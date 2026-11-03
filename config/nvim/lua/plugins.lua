vim.pack.add {
   { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
   { src = "https://github.com/stevearc/oil.nvim" },
   { src = "https://github.com/stevearc/conform.nvim" },
   { src = "https://github.com/nvim-mini/mini.nvim" },
   { src = "https://github.com/neovim/nvim-lspconfig" },
   { src = "https://github.com/lewis6991/gitsigns.nvim" },
   { src = "https://github.com/vague-theme/vague.nvim" },
}

require("mini.ai").setup()
require("mini.move").setup()
require("mini.align").setup()
require("mini.surround").setup()
require("mini.splitjoin").setup()

require("gitsigns").setup()

require("conform").setup {
   format_on_save = true,
   formatters_by_ft = {
      lua = { "stylua" },
      c = { "clang-format" },
   },
}

local oil = require("oil")
oil.setup {
   default_file_explorer = true,
   skip_confirm_for_simple_edits = true,
   float = { border = "single", max_width = 0.8, max_height = 0.8 },
   preview_win = { win_options = { number = true } },
}

vim.keymap.set("n", "<leader>-", oil.open)

vim.keymap.set("n", "<leader>_", function()
   oil.open(vim.fn.getcwd())
end)

vim.cmd.colorscheme("vague")
