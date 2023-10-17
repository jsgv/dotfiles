if not pcall(require, 'git-worktree') then
  return
end

local telescope_git_worktree = require('telescope').extensions.git_worktree

require('git-worktree').setup()

vim.keymap.set('n', '<Leader>gwt',  function () telescope_git_worktree.git_worktrees() end)
vim.keymap.set('n', '<Leader>gwn',  function () telescope_git_worktree.create_git_worktree() end)

