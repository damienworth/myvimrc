require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- common
    use 'bronson/vim-trailing-whitespace' -- highlight trailing spaces
    use 'tpope/vim-abolish'
    use 'tpope/vim-fugitive' -- Git commands

    -- general dev
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp' -- autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- snippets plugin
    require('lspconfig').clangd.setup {
        root_dir = require('lspconfig').util.root_pattern("compile_commands.json", "comfile_flags.txt", ".git"),
        filetypes = { "c", "cpp", "objc", "objcpp" }
    }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    require('nvim-treesitter.install').compilers = { "cl", "clang", "gcc", "cpp", "g++" }
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "bash", "c", "cpp", "css", "html", "javascript", "json", "ledger", "lua", "markdown", "python", "rst", "ruby", "rust", "toml", "yaml"
        },
        sync_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        refactor = {
            highlight_definitions = {
                enable = true
            }
        }
    }

    -- search
    use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'BurntSushi/ripgrep'}} }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    require('telescope').setup {
        extensions = {
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
                case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                                                -- the dafault case_mode is "smart_case"
            }
        }
    }
    -- to get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function
    require('telescope').load_extension('fzf')

    use 'preservim/nerdcommenter'
    use 'tpope/vim-eunuch' -- wrapper UNIX commands
    use 'tpope/vim-vinegar' -- file browser

    -- debugging
    use { 'mfussenegger/nvim-dap' }
    use { 'theHamsta/nvim-dap-virtual-text' }
    require('nvim-dap-virtual-text').setup {}

    local dap = require('dap')
    dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode-13', -- adjust as needed
        name = 'lldb',
        env = {
            LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
        }
    }

    -- cpp
    dap.configurations.cpp = {
        {
            name = "Launch",       -- a user readable name for the configuration
            type = "lldb",         -- references the Adapter to use
            request = "launch",    -- either `attach` or `launch`, indicates if the
                                   -- debug-adapter in turn should launch a debugee or if
                                   -- it can attach to a debugee.
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            runInTerminal = false,
            stopOnEntry = false,
            debuggerRoot = '${workspaceFolder}',
            args = {},
            postRunCommands = { 'process handle -p true -s false -n false SIGWINCH' }
        }
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- python
    local pyright = require('lspconfig').pyright
    pyright.setup{}

    -- remapping
    use 'folke/which-key.nvim'
    --use {
        --'folke/which-key.nvim',
        --config = function()
            --require('which-key').setup {
                ---- all defaults
            --}
		--end
    --}

    -- colorscheme
    use 'chriskempson/vim-tomorrow-theme'
end)

-- add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        -- on_attach = my_custom_on_attach
        capabilities = capabilities,
    }
end

-- luasnip setup
local luasnip = require'luasnip'

-- nvim-cmp setup
local cmp = require'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
	end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }
}
