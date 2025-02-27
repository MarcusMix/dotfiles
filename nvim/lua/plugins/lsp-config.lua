return {
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        config = function()
            -- Configuração do Mason
            require("mason").setup()

            -- Configuração do Mason-LSPConfig
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls" }
            })

            -- Configuração do LSP (exemplo com Lua)
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
        end
    }
}

