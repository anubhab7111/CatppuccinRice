-- require("nvchad.configs.lspconfig").defaults()
--
-- require("lspconfig").clangd.setup {
--   cmd = {
--     "clangd", -- Fixed: was "-clang-tidy"
--     "--clang-tidy=false",
--     "--header-insertion=never",
--     "--function-arg-placeholders=false",
--   },
--   on_attach = function(client, bufnr)
--     client.server_capabilities.documentFormattingProvider = false
--     client.server_capabilities.documentRangeFormattingProvider = false
--   end,
-- }
--
-- local servers = { "html", "cssls", "clangd", "basedpyright" }
-- vim.lsp.enable(servers)

-- Prevent NvChad from auto-starting default clangd
local original_setup = require("lspconfig").clangd.setup
require("lspconfig").clangd.setup = function() end

-- Load NvChad defaults (this won't start clangd now)
require("nvchad.configs.lspconfig").defaults()

-- Restore original setup function
require("lspconfig").clangd.setup = original_setup

-- Now setup clangd with your custom configuration
require("lspconfig").clangd.setup {
  cmd = {
    "clangd",
    "--clang-tidy=false",
    "--header-insertion=never",
    "--function-arg-placeholders=false",
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

-- Don't include clangd in servers list since we handle it manually
local servers = { "html", "cssls", "basedpyright", "tsserver" }
vim.lsp.enable(servers)
