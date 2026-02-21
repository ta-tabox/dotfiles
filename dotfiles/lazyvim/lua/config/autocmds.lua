-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Autocmdsに関する設定
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Remove whitespace on save (except for markdown files)
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Markdownファイルの場合はスキップ
    if vim.bo.filetype ~= "markdown" then
      vim.cmd([[:%s/\s\+$//e]])
    end
  end,
})

autocmd("FileType", {
  group = augroup("turn_off_auto_commenting", {}),
  pattern = "*",
  command = [[setlocal fo-=cro]],
})

-- Restore cursor location when file is opened
autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- Insert -> Nomalの際にIMEを英字にする
-- luaに書き直すのが難しすぎたので、luaにvimスクリプトを解釈させる方法で実装
-- Nomalモードの切り替えにラグが発生するので使用しない。
-- vim.cmd([[
--     let g:imeoff = 'osascript -e "tell application \"System Events\" to key code 102"'
--     augroup MyIMEGroup
--         autocmd!
--         autocmd InsertLeave * :call system(g:imeoff)
--     augroup END
-- ]])

-- Disable autoformat for all files
autocmd({ "FileType" }, {
  pattern = { "*" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Reload buffers when files are changed outside of Neovim (e.g. Codex edits)
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = { "*" },
  command = "checktime",
})
