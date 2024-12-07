-- nvim config
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.nvim_tree_respect_buf_cwd = 1

-- Sync registers with system clipboard
vim.opt.clipboard:append{"unnamedplus"}

-- no swapfile
vim.opt.swapfile = false

-- variables
local Plug = vim.fn["plug#"]

-- begin plugins
vim.call("plug#begin")

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'ahmedkhalf/project.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jay-babu/mason-null-ls.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'Mofiqul/dracula.nvim'
Plug 'cloudhead/neovim-fuzzy'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'williamboman/mason.nvim'
Plug 'windwp/nvim-ts-autotag'
Plug 'ray-x/cmp-treesitter'
Plug 'williamboman/mason-lspconfig.nvim'
Plug "airblade/vim-rooter"
Plug "rafamadriz/friendly-snippets"
Plug 'ellisonleao/glow.nvim'
Plug 'jamestthompson3/nvim-remote-containers'
Plug 'folke/lazydev.nvim'
Plug('folke/trouble.nvim', {dependencies = "nvim-tree/nvim-web-devicons"})

vim.call("plug#end")

-- colorscheme
vim.cmd('colorscheme dracula')

-- vim options
local option = vim.o
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
keyset('n', '<leader>f', '<cmd>FuzzyOpen<cr>')
keyset('n', '<leader>g', '<cmd>FuzzyGrep<cr>')
keyset('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<cr>')
keyset('n', '<leader>p', '<cmd>lua vim.lsp.buf.format()<cr>')
keyset('n', '<leader>m', '<cmd>Glow<cr>')
keyset('n', '<leader>t', '<cmd>lua vim.lsp.buf.hover()<cr>')
keyset('i', '<C-j>', '')
keyset('i', '<C-k>', '')
keyset("n", "<leader>D", "<cmd>TroubleToggle<cr>",
       {silent = true, noremap = true})

-- neovim tree config
require("nvim-tree").setup({
    view = {relativenumber = true},
    sync_root_with_cwd = true
})

-- neovim glow config
require('glow').setup()

-- lazydev config
require('lazydev').setup({
    enabled = true,
    debug = false,
    runtime = vim.env.VIMRUNTIME --[[@as string]] ,
    library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        {path = "${3rd}/luv/library", words = {"vim%.uv"}}
    },
    integrations = {
        -- Fixes lspconfig's workspace management for LuaLS
        -- Only create a new workspace if the buffer is not part
        -- of an existing workspace or one of its libraries
        lspconfig = true,
        -- add the cmp source for completion of:
        -- `require "modname"`
        -- `---@module "modname"`
        cmp = true,
        -- same, but for Coq
        coq = false
    }
})

-- lsp servers
local servers = {
    "typescript", "javascript", "c", "cpp", "fish", "gitignore", "html",
    "julia", "lua", "tsx", "sql"
}

-- rooter_patterns
vim.g.rooter_patterns = {'.git', 'Makefile', '*.sln', 'build/env.sh', ".env"}

-- luasnip config
require("luasnip.loaders.from_vscode").lazy_load()

-- cmp config
local cmp = require("cmp")
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.scroll_docs(-4),
        ['<C-k>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({select = true})
    }),
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    sources = cmp.config.sources({{name = 'nvim_lsp'}}, {{name = 'buffer'}},
                                 {{name = 'luasnip'}})
})

-- language server
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local nvim_lsp = require('lspconfig')

nvim_lsp['ts_ls'].setup {capabilities = capabilities}
nvim_lsp['html'].setup {capabilities = capabilities}
nvim_lsp['cssls'].setup {capabilities = capabilities}
nvim_lsp['cssmodules_ls'].setup {capabilities = capabilities}
nvim_lsp['pyright'].setup {capabilities = capabilities}
nvim_lsp['tailwindcss'].setup {capabilities = capabilities}
nvim_lsp['lua_ls'].setup {capabilities = capabilities}
nvim_lsp['sqlls'].setup {capabilities = capabilities}
nvim_lsp['prismals'].setup {capabilities = capabilities}
nvim_lsp['lua_ls'].setup {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. '/.luarc.json') or
                vim.loop.fs_stat(path .. '/.luarc.jsonc') then return end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config
                                                             .settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {Lua = {}}
}
-- diagnostic
vim.diagnostic.config({virtual_text = false})

-- manson setup
require("mason").setup({PATH = "append"})

-- mason-lspconfig setup
require("mason-lspconfig").setup({automatic_installation = true})

-- mason-null-ls setup
require("mason-null-ls").setup({automatic_installation = true})

-- treesitter setup
require'nvim-treesitter.configs'.setup {
    ensure_installed = servers,
    sync_install = false,
    auto_install = false,
    autotag = {enable = true},
    highlight = {enable = true}
}

-- null_ls config
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.formatting.json_tool,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.prettier
            .with({extra_args = {"--tab-width", 2}}),
        null_ls.builtins.formatting.black,
        null_ls.builtins.diagnostics.dotenv_linter,
        null_ls.builtins.diagnostics.eslint, null_ls.builtins.diagnostics.fish
    }
})
