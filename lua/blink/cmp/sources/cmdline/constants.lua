-- spellchecker:off
return {
  ex_search_commands = {
    substitute = true,
    global = true,
    vglobal = true,
    vimgrep = true,
    vimgrepadd = true,
    grep = true,
    grepadd = true,
    lvimgrep = true,
    lvimgrepadd = true,
  },
  modifiers = {
    p = 'full path',
    h = 'directory (head)',
    t = 'filename (tail)',
    r = 'basename (root, no ext)',
    e = 'extension',
    s = 'substitute first occurrence',
    gs = 'substitute all occurrences',
    S = 'escape for shell',
    ['~'] = 'relative to home directory',
    ['.'] = 'relative to current directory',
  },
  completion_types = {
    buffer = { 'buffer', 'diff_buffer' },
    path = { 'dir', 'dir_in_path', 'file', 'file_in_path', 'runtime' },
  },
}
-- spellchecker:on
