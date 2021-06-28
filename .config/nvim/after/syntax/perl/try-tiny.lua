-- Perl highlighting for Try::Tiny keywords
-- Maintainer:   vim-perl <vim-perl@groups.google.com>
-- Installation: Put into after/syntax/perl/try-tiny.vim

-- XXX include guard
vim.api.nvim_exec([[
  syntax match perlStatementProc "\<\%(try\|catch\|finally\)\>"
]], false)

-- XXX catch instances where you forget the semicolon after the closing brace?
