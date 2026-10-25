_G.diagnostics = {
   virtual_text = true,
   virtual_lines = false,
}

vim.lsp.enable {
   "lua_ls",
   "pyright",
   "rust_analyzer",
   "gopls",
   "clangd",
   "gdscript",
   "nil_ls",
   "org",
}

vim.diagnostic.config {
   update_in_insert = false,
   severity_sort = true,
   jump = { float = true },
   float = { source = "if_many" },
   underline = { severity = { min = vim.diagnostic.severity.WARN } },
   virtual_text = _G.diagnostics.virtual_text,
   virtual_lines = vim.g.virtual_lines,
}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.netrw_banner = 0

vim.o.title = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.confirm = true
vim.o.cmdheight = 0
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.grepprg = "rg --vimgrep"
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.scrolloff = 10
vim.o.sidescrolloff = 8
vim.o.swapfile = false
vim.o.undofile = true
vim.opt.complete:append("o")
vim.opt.completeopt = { "menuone", "noinsert", "popup", "fuzzy" }
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.wrap = false
vim.o.list = true
vim.opt.listchars = {
   trail = "·",
   nbsp = "␣",
   tab = "» ",
   extends = "⟩",
   precedes = "⟨",
}
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.showmode = false
vim.o.shiftwidth = 0
vim.o.pumblend = 30
vim.o.pummaxwidth = 80
vim.o.pumheight = 10
vim.o.signcolumn = "yes"
vim.o.formatoptions = "jqln"
vim.o.smartindent = true
vim.o.autocomplete = true
vim.o.lazyredraw = true

vim.opt.shortmess:append { W = true, I = true, c = true }
vim.opt.path:append { "**" }

local AG_misc = vim.api.nvim_create_augroup("misc", {})
local AG_FiletypeOpts = vim.api.nvim_create_augroup("FiletypeOpts", {})

vim.api.nvim_create_autocmd("TextYankPost", {
   group = AG_misc,
   callback = function()
      (vim.hl or vim.highlight).on_yank()
   end,
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = "markdown",
   group = AG_FiletypeOpts,
   callback = function()
      vim.o.wrap = true
      vim.o.linebreak = true
      vim.o.spell = true
      vim.keymap.set("n", "j", "gj")
      vim.keymap.set("n", "k", "gk")
   end,
})

vim.keymap.set("n", "<leader>|", vim.cmd.split)
vim.keymap.set("n", "<leader>\\", vim.cmd.vsplit)
