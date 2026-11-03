vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>c", vim.cmd.make)
vim.keymap.set("n", "<leader>C", ":set makeprg=" .. vim.opt_local.makeprg:get())

-- Toggle autocomplete
vim.api.nvim_create_user_command("ToggleAutocomplete", function()
   vim.o.autocomplete = not vim.o.autocomplete
end, {})

function Apply_diagnostics()
   vim.diagnostic.config {
      update_in_insert = false,
      severity_sort = true,
      jump = { float = true },
      float = { source = "if_many" },
      underline = { severity = { min = vim.diagnostic.severity.WARN } },
      virtual_text = _G.DiagState.virtual_text,
      virtual_lines = _G.DiagState.virtual_lines,
   }
end
Apply_diagnostics()

vim.keymap.set("n", "<leader>w", function()
   DiagState.virtual_text = not DiagState.virtual_text
   Apply_diagnostics()
end, { desc = "Toggle virtual text" })

vim.keymap.set("n", "<leader>W", function()
   DiagState.virtual_lines = not DiagState.virtual_lines
   Apply_diagnostics()
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
local terminal = {
   buf = nil,
   win = nil,
}

local function createTerminalWindow(sizeFactor)
   local height = math.ceil(vim.o.lines / sizeFactor)
   local width = math.ceil(vim.o.columns / sizeFactor)
   local row = math.ceil((vim.o.lines - height) / 2)
   local col = math.ceil((vim.o.columns - width) / 2)

   return vim.api.nvim_open_win(terminal.buf, false, {
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
      vim.api.nvim_win_close(terminal.win, true)
   end, { buffer = buf })

   return buf
end

vim.keymap.set("n", "<leader>t", function()
   if terminal.buf == nil or vim.api.nvim_buf_is_valid(terminal.buf) == false then
      terminal.buf = createTerminalBuffer()
   end

   if not terminal.win or not vim.api.nvim_win_is_valid(terminal.win) then terminal.win = createTerminalWindow(1.4) end

   vim.api.nvim_set_current_win(terminal.win)
   vim.api.nvim_buf_call(terminal.buf, vim.cmd.startinsert)
end)

-- find
vim.keymap.set("n", "<leader><leader>", ":find ")

-- qf
vim.keymap.set("n", "<leader>q", function()
   for _, win in ipairs(vim.fn.getwininfo()) do
      if win.quickfix == 1 then
         vim.cmd.cclose()
         return
      end
   end
   vim.cmd.copen()
end)

vim.api.nvim_create_autocmd("LspAttach", {
   group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
   callback = function(args)
      local bufnr = args.buf

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
   end,
})
