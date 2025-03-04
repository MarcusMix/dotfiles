return {
    "navarasu/onedark.nvim",
    opts = {},
    config = function(_)
        require("onedark").setup({
            style = 'darker'
        })
        vim.cmd([[colorscheme onedark]])
    end,
}

