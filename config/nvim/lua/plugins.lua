vim.pack.add {
   { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
   { src = "https://github.com/stevearc/oil.nvim" },
   { src = "https://github.com/stevearc/conform.nvim" },
   { src = "https://github.com/nvim-mini/mini.nvim" },
   { src = "https://github.com/neovim/nvim-lspconfig" },
   { src = "https://github.com/lewis6991/gitsigns.nvim" },
   { src = "https://github.com/vague-theme/vague.nvim" },
   { src = "https://github.com/folke/snacks.nvim" },
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

-- Snacks Pickers
---@diagnostic disable: undefined-global
vim.keymap.set("n", "<leader><space>", Snacks.picker.smart)
vim.keymap.set("n", "<leader>ff", Snacks.picker.files)
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep)
vim.keymap.set("x", "<leader>fg", Snacks.picker.grep_word)
vim.keymap.set("n", "<leader>b", Snacks.picker.buffers)
vim.keymap.set("n", "<leader>u", Snacks.picker.undo)
vim.keymap.set("n", "<leader>fh", Snacks.picker.help)
vim.keymap.set("n", "<leader>d", Snacks.picker.diagnostics)
vim.keymap.set("n", "<leader>m", Snacks.picker.marks)
vim.keymap.set("n", "<leader>r\"", Snacks.picker.registers)
---@diagnostic enable: undefined-global

vim.cmd.colorscheme("vague")
