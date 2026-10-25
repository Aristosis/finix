vim.pack.add {
   { src = "https://github.com/nvim-tree/nvim-web-devicons" },
   { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
   { src = "https://github.com/stevearc/oil.nvim" },
   { src = "https://github.com/stevearc/conform.nvim" },
   { src = "https://github.com/nvim-mini/mini.nvim" },
   { src = "https://github.com/neovim/nvim-lspconfig" },
   { src = "https://github.com/lewis6991/gitsigns.nvim" },
   { src = "https://github.com/3rd/image.nvim" },
   { src = "https://github.com/nvim-orgmode/orgmode" },
   { src = "https://github.com/vague-theme/vague.nvim" },
   { src = "https://github.com/L3MON4D3/LuaSnip" }
}

require("orgmode").setup()
require("image").setup()
require("mini.move").setup()
require("mini.align").setup()
require("mini.surround").setup()
require("mini.statusline").setup()
require("mini.ai").setup()
require("mini.splitjoin").setup()

local snippets = require("mini.snippets")
snippets.setup {
   expand = {
      -- Always insert the best-matched snippet without showing vim.ui.select
      select = function(snippets, insert)
         return insert(snippets[1])
      end,
   },
   snippets = {
      snippets.gen_loader.from_lang(),
      { prefix = "" }
   }
}

require("mini.pick").setup {
   options = {
      content_from_bottom = true,
      cache = true,
   }
}
require("mini.extra").setup()
vim.keymap.set("n", "<leader><leader>", MiniPick.builtin.files)
vim.keymap.set("n", "<leader>f", MiniPick.builtin.grep_live)
vim.keymap.set("n", "<leader>b", MiniPick.builtin.buffers)
vim.keymap.set("n", "<leader>d", MiniExtra.pickers.lsp)
vim.keymap.set("n", "<leader>m", MiniExtra.pickers.marks)

require("gitsigns").setup { signcolumn = false }

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

vim.keymap.set("n", "<leader>-", function()
   oil.open()
end)

vim.keymap.set("n", "<leader>_", function()
   oil.open(vim.fn.getcwd())
end)

require("vague").setup({transparent=true})
vim.cmd.colorscheme("vague")
