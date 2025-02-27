return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "html", "eslint", "pyright", "jdtls"}

            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.html.setup({})
            lspconfig.eslint.setup({})
            lspconfig.pyright.setup({})
            lspconfig.jdtls.setup({})
            lspconfig.lua_ls.setup({})
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        end
    }
}



