require "nvchad.autocmds"

-- Dynamic terminal padding
local autocmd = vim.api.nvim_create_autocmd

-- Show Nvdash when all buffers are closed
autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

--clang formatter along with cursor pos
autocmd("BufWritePre", {
  pattern = "*.cpp",

  callback = function()
    -- Save cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local view = vim.fn.winsaveview()

    -- Format the file
    vim.cmd "silent! %!clang-format"

    -- Restore cursor position and view
    vim.fn.winrestview(view)
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos "."
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",
})

-- Return to last edit position
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if line > 1 and line <= vim.fn.line "$" then
      vim.cmd 'normal! g`"'
    end
  end,
})

-- Highlight yanked text
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})

-- start only one clangd
autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "clangd" then
      -- Count clangd instances
      local clangd_clients = {}
      for _, c in pairs(vim.lsp.get_clients()) do
        if c.name == "clangd" then
          table.insert(clangd_clients, c)
        end
      end

      -- If multiple instances, keep the one with custom args
      if #clangd_clients > 1 then
        for _, c in pairs(clangd_clients) do
          local has_custom_args = #c.config.cmd > 1
          if not has_custom_args and c.id ~= client.id then
            vim.lsp.stop_client(c.id)
            print "Stopped duplicate default clangd"
          end
        end
      end
    end
  end,
})

vim.filetype.add {
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
}

-- Hyprlang LSP
autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    -- print(string.format("starting hyprls for %s", vim.inspect(event))) -- Removed print statement
    vim.lsp.start {
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    }
  end,
})

-- Highlight on hover
autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local bufnr = args.buf
    -- Set up keybinds for LSP for this buffer
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
    -- Add more LSP keybinds as needed
  end,
})

-- Auto-format on save in python(isort)
-- autocmd("BufWritePre", {
--   pattern = "*.py",
--   callback = function()
--     vim.lsp.buf.format { async = false }
--   end,
-- })
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function(args)
    require("conform").format { bufnr = args.buf, async = false }
  end,
})
