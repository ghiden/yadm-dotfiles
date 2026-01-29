vim.lsp.enable({
  'lua_ls',
  'zls',
  'rust_analyzer',
  'ts_ls'
})

vim.diagnostic.config({
  virtual_text = true, -- Show errors as virtual text
  update_in_insert = true, -- Update diagnostics while in insert mode
})
