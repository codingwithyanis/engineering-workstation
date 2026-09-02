-- A focused Neovim setup for editing, navigation, LSP, and completion.

vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.showmode = false
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes'
vim.opt.winborder = 'rounded'

vim.diagnostic.config {
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '●',
      [vim.diagnostic.severity.WARN] = '●',
      [vim.diagnostic.severity.INFO] = '●',
      [vim.diagnostic.severity.HINT] = '●',
    },
  },
}

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  { src = gh 'rebelot/kanagawa.nvim', name = 'kanagawa' },
  { src = gh 'nvim-lualine/lualine.nvim' },
  { src = gh 'folke/snacks.nvim' },
  { src = gh 'neovim/nvim-lspconfig' },
  { src = gh 'nvim-treesitter/nvim-treesitter' },
  { src = gh 'rachartier/tiny-inline-diagnostic.nvim' },
  { src = gh 'windwp/nvim-autopairs' },
  { src = gh 'saghen/blink.lib' },
  { src = gh 'saghen/blink.cmp' },
  { src = 'https://codeberg.org/andyg/leap.nvim' },
}

require('kanagawa').setup { theme = 'wave' }
vim.cmd.colorscheme 'kanagawa-wave'

require('lualine').setup {}
require('nvim-autopairs').setup {}

require('snacks').setup {
  picker = { enabled = true },
  explorer = { enabled = true },
  lazygit = { enabled = true },
}

require('tiny-inline-diagnostic').setup {
  options = {
    multilines = { enabled = true },
  },
  preset = 'ghost',
}

-- Install and enable syntax highlighting for the languages configured below.
require('nvim-treesitter').install {
  'html',
  'javascript',
  'java',
  'lua',
  'php',
  'tsx',
  'typescript',
}
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'java', 'javascript', 'lua', 'php', 'typescript', 'typescriptreact' },
  callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})

local cmp = require 'blink.cmp'
cmp.setup {
  keymap = {
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
    ['<Esc>'] = { 'cancel', 'fallback' },
  },
  completion = {
    accept = {
      auto_brackets = { enabled = true },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'lua' },
}

-- Reuse language servers already installed by Mason without loading Mason itself.
local mason_bin = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'bin')
if vim.uv.fs_stat(mason_bin) then vim.env.PATH = mason_bin .. ':' .. vim.env.PATH end

vim.lsp.enable {
  'jdtls',
  'intelephense',
  'ts_ls',
  'lua_ls',
  'html',
}

vim.keymap.set('n', '<leader>ff', Snacks.picker.files)
vim.keymap.set('n', '<leader>fg', Snacks.picker.grep)
vim.keymap.set('n', '<leader>fb', Snacks.picker.buffers)
vim.keymap.set('n', '<leader>fd', Snacks.picker.diagnostics)
vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>fs', Snacks.picker.lsp_symbols)
vim.keymap.set('n', '<leader>fe', function() Snacks.explorer() end)
vim.keymap.set('n', '<leader>fS', Snacks.picker.lsp_workspace_symbols)
vim.keymap.set('n', 'gd', Snacks.picker.lsp_definitions)
vim.keymap.set('n', 'gr', Snacks.picker.lsp_references)
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = 'Leap jump in current window' })
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)', { desc = 'Leap jump from another window' })
vim.keymap.set('n', '<leader>lg', function() Snacks.lazygit() end)

-- vim: ts=2 sts=2 sw=2 et
