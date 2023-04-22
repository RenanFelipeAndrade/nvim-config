-- nvim config
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
--
-- Sync registers with system clipboard
vim.opt.clipboard:append { "unnamedplus" }

-- variables
local Plug = vim.fn["plug#"]

-- begin plugins
vim.call("plug#begin")

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'airblade/vim-rooter'
Plug 'L3MON4D3/LuaSnip'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'Mofiqul/dracula.nvim'

vim.call("plug#end")

-- colorscheme
vim.cmd('colorscheme dracula')

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
keyset('n', '<leader>h', '<cmd>:nohlsearch<cr>')
keyset('n', 'gd', vim.lsp.buf.definition)
keyset('v', 'gd', vim.lsp.buf.definition)

-- neovim tree config
require("nvim-tree").setup({
    view = {
        relativenumber = true
    },
    sync_root_with_cwd = true,
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
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    }
    )
})

-- language server
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['tsserver'].setup {
    capabilities = capabilities
}

require('lspconfig')['pyright'].setup {
    capabilities = capabilities
}

require('lspconfig')['lua_ls'].setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
}


-- null_ls config
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.json_tool,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.prettier
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
})
