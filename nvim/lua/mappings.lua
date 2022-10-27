vim.api.nvim_set_keymap("n", "<F3>", "<cmd>set hlsearch!<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<cmd>lua require'telescope.builtin'.spell_suggest()<cr>", { noremap = true, silent = true })

local wk = require('which-key')

wk.register({
    ["<C-p>"] = {
        "<cmd>lua require'telescope.builtin'.find_files()<cr>", "Find Files"
    },
    ["<F3>"] = { "<cmd>set hlsearch!<cr>" },
    ["<F5>"] = { "<cmd>lua require'dap'.continue()<cr>" },
    ["<F10>"] = { "<cmd>lua require'dap'.step_over()<cr>" },
    ["<F11>"] = { "<cmd>lua require'dap'.step_into()<cr>" },
    ["<F12>"] = { "<cmd>lua require'dap'.step_out()<cr>" }
})

wk.register({
    ["<leader>"] = {
        -- navigation
        f = {
            name = "+Find", -- optional group name
            g = { "<cmd>lua require'telescope.builtin'.live_grep()<cr>", "Live (G)rep" }, -- create a binding with label
            b = { "<cmd>lua require'telescope.builtin'.buffers()<cr>", "Buffers" },
            h = { "<cmd>lua require'telescope.builtin'.help_tags()<cr>", "Help Tags" },
            s = { "<cmd>lua require'telescope.builtin'.grep_string()<cr>", "Grep String" },
            w = { "<cmd>lua require'telescope.builtin'.grep_string({ word_match = '-w' })<cr>", "Grep Exact" },
        },
        -- lsp
        g = {
            name = "+LSP",
            i = { ":LspInfo<cr>", "Connected Language Servers" },
            k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
            K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Commands" },
            d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go To Definition" },
            D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go To Declaration" },
            r = { "<cmd>lua vim.lsp.buf.references()<cr>", "See References" },
            R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
            a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
            e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Show Line Diagnostics" },
            n = { "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "Go To Next Diagnostics" },
            p = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "Go To Previous Diagnostics" },
        },
        -- debugging
        d = {
            name = "Debugging",
            c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
            v = { "<cmd>lua require('dap').step_over()<cr>", "Step Over" },
            i = { "<cmd>lua require('dap').step_into()<cr>", "Step Into" },
            o = { "<cmd>lua require('dap').step_out()<cr>", "Step Out" },
            h = { "<cmd>lua require('dap.ui.widgets').hover()<cr>", "Hover" },
            r = { "<cmd>lua require('dap').repl.toggle()<cr>", "Repl (toggle)" },
            b = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Create" },
            B = {
                "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
                "Breakpoint Condition"
            },
            m = {
                "<cmd>lua require('dap').set_breakpoint({ nil, nil, vim.fn.input('Log point message: ') })<cr>",
                "Log Point Message"
            },
            s = {
                "<cmd>lua require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes).toggle()<cr>",
                "Scopes"
            },
            f = {
                "<cmd>lua require('dap.ui.widgets').sidebar(require('dap.ui.widgets').frames).toggle()<cr>",
                "Frames"
            },
            x = { "<cmd>lua require('dap').terminate()<cr><cmd>lua require('dap').close()<cr>", "Terminate" },
        }
    },
})

