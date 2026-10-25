vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Toggle autocomplete
vim.keymap.set("n", "<leader>c", function()
   vim.o.autocomplete = not vim.o.autocomplete
end)

-- Toggle diagnostics display
local function reconf_diags()
   vim.diagnostic.config {
      virtual_text = _G.diagnostics.virtual_text,
      virtual_lines = _G.diagnostics.virtual_lines,
   }
end

vim.keymap.set("n", "<leader>d", function()
   _G.diagnostics.virtual_text = not _G.diagnostics.virtual_text
   reconf_diags()
end, { desc = "Toggle virtual text" })

vim.keymap.set("n", "<leader>D", function()
   _G.diagnostics.virtual_lines = not _G.diagnostics.virtual_lines
   reconf_diags()
end, { desc = "Toggle virtual lines" })

-- let me press enter without accepting autocomplete sheiz
vim.keymap.set("i", "<CR>", function()
   if vim.fn.pumvisible() ~= 0 then
      return "<C-e><CR>"
   else
      return "<CR>"
   end
end, { expr = true, silent = true })

vim.keymap.set("t", "<S-Esc>", vim.cmd.stopinsert)

-- Terminal!!!
_G.terminal = {
   buf = nil,
   win = nil,
}

local function createTerminalWindow(sizeFactor)
   local height = math.ceil(vim.o.lines / sizeFactor)
   local width = math.ceil(vim.o.columns / sizeFactor)
   local row = math.ceil((vim.o.lines - height) / 2)
   local col = math.ceil((vim.o.columns - width) / 2)

   return vim.api.nvim_open_win(_G.terminal.buf, false, {
      relative = "editor",
      height = height,
      width = width,
      row = row,
      col = col,
      title = "Term",
      title_pos = "center",
      border = "rounded",
   })
end

local function createTerminalBuffer()
   local buf = vim.api.nvim_create_buf(false, true)

   vim.api.nvim_buf_call(buf, vim.cmd.terminal)
   vim.bo[buf].buflisted = false

   vim.keymap.set("n", "<Esc>", function()
      vim.api.nvim_win_close(_G.terminal.win, true)
   end, { buffer = buf })

   return buf
end

vim.keymap.set("n", "<leader>t", function()
   if _G.terminal.buf == nil or vim.api.nvim_buf_is_valid(_G.terminal.buf) == false then
      _G.terminal.buf = createTerminalBuffer()
   end

   if not _G.terminal.win or not vim.api.nvim_win_is_valid(_G.terminal.win) then
      _G.terminal.win = createTerminalWindow(1.4)
   end

   vim.api.nvim_set_current_win(_G.terminal.win)
   vim.api.nvim_buf_call(_G.terminal.buf, vim.cmd.startinsert)
end)

-- find
vim.keymap.set("n", "<leader><leader>", ":find ")

-- qf
local copen = false
vim.keymap.set("n", "<leader>q", function()
   if copen then
      vim.cmd.cclose()
   else
      vim.cmd.copen()
   end
end)

vim.api.nvim_create_autocmd("LspAttach", {
   group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
   callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
   end,
})
