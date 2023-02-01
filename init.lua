-- nvim config
vim.o.relativenumber = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- variables
local Plug = vim.fn["plug#"]

-- begin plugins
vim.call("plug#begin")

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'airblade/vim-rooter'

vim.call("plug#end")

-- vim options
local option = vim.o
option.noswapfile = true
option.tabstop = 4
option.shiftwidth = 4
option.expandtab = true

-- keymaps
vim.g.mapleader = " "

local keyset = vim.keymap.set
keyset('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')
keyset('n', '<leader>c', '<cmd>q<cr>')
keyset('n', '<leader>w', '<cmd>w<cr>')
keyset('n', '<leader>q', '<cmd>wq<cr>')

-- neovim tree config
require("nvim-tree").setup({
    view = {
    relativenumber = true
    },
    sync_root_with_cwd = true,
    -- respect_buf_cwd = true,
    -- update_focused_file = {
    --     enable = true,
    --     update_root = true
    -- }
})

-- cmp config
local cmp = require("cmp")
cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-j>'] = cmp.mapping.scroll_docs(-4),
      ['<C-k>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    },{
      { name = 'buffer' },
      }
    )})
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['tsserver'].setup {
capabilities = capabilities
}

-- mason config
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- mason-lspconfig config
require("mason-lspconfig").setup({
    automatic_installation = true
})
