-- Logs
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.log", "*.log.*", "/var/log/*", "syslog.*" },
  callback = function()
    vim.opt.syntax = "messages"
  end,
})

-- .env.local
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".env", ".env.*", ".env.local" },
  callback = function()
    vim.opt.syntax = "sh"
  end,
})

-- .venv
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".venv", "**/.venv/**", "pyvenv.cfg" },
  callback = function()
    vim.opt.syntax = "conf"
  end,
})


-- TSV files → csv filetype with tab delimiter (for csv.vim)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tsv", "*.tab" },
  callback = function()
    vim.bo.filetype = "csv"
    vim.b.csv_delimiter = "\t"
  end,
})

-- Hugo projects
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.html",
  callback = function()
    if vim.fn.search("{{") ~= 0 then
      vim.bo.filetype = "gohtmltmpl"
    end
  end,
})

vim.filetype.add({
  -- Neovim only knows the bare name "Brewfile". The two names this machine
  -- actually uses -- the live ~/.Brewfile and the chezmoi source dot_Brewfile
  -- -- get no filetype without these entries.
  filename = {
    [".Brewfile"] = "ruby",
    ["dot_Brewfile"] = "ruby",
  },
  pattern = {
    [".*/layouts/.*%.html"] = "gohtmltmpl",
    [".*/themes/.*/layouts/.*%.html"] = "gohtmltmpl",
  },
})
