local async = require('blink.cmp.lib.async')

local help = {}

--- Processes a help file and returns a list of tags asynchronously
--- @param file string
--- @return blink.cmp.Task
--- TODO: rewrite using async lib, shared as a library in lib/fs.lua
local function read_tags_from_file(file)
  return async.task.new(function(resolve)
    vim.uv.fs_open(file, 'r', 438, function(err, fd)
      if err or fd == nil then return resolve({}) end

      -- Read file content
      vim.uv.fs_fstat(fd, function(stat_err, stat)
        if stat_err or stat == nil then
          vim.uv.fs_close(fd)
          return resolve({})
        end

        vim.uv.fs_read(fd, stat.size, 0, function(read_err, data)
          vim.uv.fs_close(fd)

          if read_err or data == nil then return resolve({}) end

          -- Process the file content
          local tags = {}
          for line in data:gmatch('[^\r\n]+') do
            local tag = line:match('^([^\t]+)')
            if tag then table.insert(tags, tag) end
          end

          resolve(tags)
        end)
      end)
    end)
  end)
end

--- @param arg string
function help.get_completions(arg)
  local help_files = vim.api.nvim_get_runtime_file('doc/tags', true)
  -- TODO: remove after adding support for fuzzy matching on custom range
  local arg_parts = vim.split(arg, '.', { plain = true })
  local arg_prefix = table.concat(arg_parts, '.', 1, #arg_parts - 1)

  return async.task
    .await_all(vim.tbl_map(read_tags_from_file, help_files))
    :map(function(tags_arrs) return require('blink.cmp.lib.utils').flatten(tags_arrs) end)
    :map(function(tags)
      return vim.tbl_filter(function(tag) return vim.startswith(tag, arg_prefix) end, tags)
    end)
end

return help
