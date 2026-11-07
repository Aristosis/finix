vim.pack.add {
   { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
   { src = "https://github.com/stevearc/oil.nvim" },
   { src = "https://github.com/stevearc/conform.nvim" },
   { src = "https://github.com/nvim-mini/mini.nvim" },
   { src = "https://github.com/neovim/nvim-lspconfig" },
   { src = "https://github.com/lewis6991/gitsigns.nvim" },
   { src = "https://github.com/vague-theme/vague.nvim" },
   { src = "https://github.com/folke/snacks.nvim" },
   { src = "https://github.com/folke/flash.nvim" },
   { src = "https://github.com/tpope/vim-fugitive" },
}

require("mini.ai").setup()
require("mini.move").setup()
require("mini.align").setup()
require("mini.snippets").setup()
require("mini.surround").setup()
require("mini.splitjoin").setup()
require("mini.icons").setup()
---@diagnostic disable-next-line: undefined-global
MiniIcons.mock_nvim_web_devicons()

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

require("snacks").setup {
   input = { enabled = true },
   picker = {
      enabled = true,
      ui_select = true,
   },
}

-- Snacks Pickers
---@diagnostic disable: undefined-global
vim.keymap.set("n", "<leader><space>", Snacks.picker.files)
vim.keymap.set("n", "<leader>g", Snacks.picker.grep)
vim.keymap.set("x", "<leader>g", Snacks.picker.grep_word)
vim.keymap.set("n", "<leader>b", Snacks.picker.buffers)
vim.keymap.set("n", "<leader>u", Snacks.picker.undo)
vim.keymap.set("n", "<leader>h", Snacks.picker.help)
vim.keymap.set("n", "<leader>d", Snacks.picker.diagnostics)
vim.keymap.set("n", "<leader>m", Snacks.picker.marks)
vim.keymap.set("n", "<leader>r", Snacks.picker.registers)
---@diagnostic enable: undefined-global

vim.api.nvim_create_autocmd("FileType", {
   pattern = "snacks_picker_input",
   callback = function()
      vim.opt_local.autocomplete = false
   end,
})

vim.keymap.set({ "n", "x", "o" }, "<CR>", function()
   require("flash").jump()
end)

vim.keymap.set({ "n", "x", "o" }, "<S-CR>", function()
   require("flash").treesitter()
end)

local mode_map = {
   ["n"] = { "NORMAL", "%#DiagnosticOk#" },
   ["i"] = { "INSERT", "%#DiagnosticInfo#" },
   ["v"] = { "VISUAL", "%#DiagnosticWarn#" },
   ["V"] = { "V-LINE", "%#DiagnosticWarn#" },
   ["\22"] = { "V-BLOCK", "%#DiagnosticWarn#" },
   ["c"] = { "COMMAND", "%#DiagnosticHint#" },
   ["R"] = { "REPLACE", "%#DiagnosticError#" },
   ["t"] = { "TERMINAL", "%#DiagnosticOk#" },
}

function _G.Statusline()
   local m = vim.api.nvim_get_mode().mode
   local mode_info = mode_map[m] or { m:upper(), "%#StatusLine#" }
   local mode_str = string.format("%s ▊ %s %%#StatusLine#", mode_info[2], mode_info[1])

   -- git
   local git_str = ""
   local gs = vim.b.gitsigns_status_dict
   if gs and gs.head and gs.head ~= "" then
      local added = (gs.added and gs.added > 0) and (" +" .. gs.added) or ""
      local changed = (gs.changed and gs.changed > 0) and (" ~" .. gs.changed) or ""
      local removed = (gs.removed and gs.removed > 0) and (" -" .. gs.removed) or ""
      git_str = string.format("  %s%s%s%s │", gs.head, added, changed, removed)
   end

   -- lsp
   local lsp_clients = vim.lsp.get_clients { bufnr = 0 }
   local lsp_names = {}
   for _, client in ipairs(lsp_clients) do
      table.insert(lsp_names, client.name)
   end
   local lsp_str = #lsp_names > 0 and ("  " .. table.concat(lsp_names, ",") .. " │") or ""

   -- file / diag
   local file = " %f %m%r"
   local diag = vim.diagnostic.status()
   local diag_str = diag ~= "" and (" │ " .. diag) or ""
   local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "plain"
   local pos = "%l:%c (%p%%) "

   return table.concat {
      mode_str,
      git_str,
      file,
      diag_str,
      "%=", -- Right-align
      lsp_str,
      " ",
      ft,
      " │ ",
      pos,
   }
end

vim.opt.statusline = "%!v:lua.Statusline()"

vim.cmd.colorscheme("vague")
