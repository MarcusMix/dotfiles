return {
        "tiagovla/tokyodark.nvim",
        opts = {},
        config = function(_, opts)
            require("tokyodark").setup(opts)
            vim.cmd([[colorscheme tokyodark]])
        end,
}
 
