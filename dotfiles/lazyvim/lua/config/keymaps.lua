-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--[[
'' (an empty string)	mapmode-nvo	Normal, Visual, Select, Operator-pending
'n' Normal	:nmap
'v' Visual and Select
's' Select	:smap
'x' Visual	:xmap
'o' Operator-pending
'!' Insert and Command-line
'i' Insert	:imap
'l' Insert, Command-line, Lang-Arg
'c' Command-line
't' Terminal
--]]

local function opts(desc)
  return { desc = desc, noremap = true, silent = true }
end

local default_opts = { silent = true, noremap = true }

local keymap = vim.api.nvim_set_keymap

-- Nomal --
-- 移動を論理行に
keymap("n", "k", "gk", default_opts)
keymap("n", "gk", "k", default_opts)
keymap("n", "j", "gj", default_opts)
keymap("n", "gj", "j", default_opts)

-- yank
keymap("n", "<Leader>p", '"0p', default_opts)
keymap("n", "<Leader>P", '"0P', default_opts)

-- ハイライトを消す
keymap("n", "<ESC>", "<CMD>nohlsearch<CR><ESC>", opts("No highlight search"))
keymap("n", "<Leader>q", ":nohlsearch<CR>", default_opts)

-- ZZ, ZQ を無効化
keymap("n", "ZZ", "<Nop>", default_opts)
keymap("n", "ZQ", "<Nop>", default_opts)

-- Insert --
keymap("i", "jk", "<Esc>", opts("Press jk faset to exit insert mode"))
keymap("i", "<C-a>", "<Esc>0i", opts("Move to the last of line"))
keymap("i", "<C-e>", "<Esc>$a", opts("Move to the first of line"))

-- Visual --

-- Command --
-- vim.cmd([[
--     cnoremap <expr> <C-K> wildmenumode() ? '<C-P>' : '<Up>'
--     cnoremap <expr> <C-J> wildmenumode() ? '<C-N>' : '<Down>'
-- ]])

-- Terminal --
keymap("t", "<C-h>", "<Bs>", default_opts)
keymap("t", "<C-d>", "<Right><Bs>", default_opts)
keymap("t", "<C-b>", "<Left>", default_opts)
keymap("t", "<C-p>", "<Up>", default_opts)
keymap("t", "<C-f>", "<Right>", default_opts)
keymap("t", "<C-n>", "<Down>", default_opts)

-- General --
-- ; :を入れ替える
-- keymap("n", ";", ":", default_opts)
-- keymap("n", ":", ";", default_opts)
-- keymap("v", ";", ":", default_opts)
-- keymap("v", ":", ";", default_opts)

-- コマンドで削除した時はヤンクしない
keymap("n", "x", '"_x', default_opts)
keymap("v", "x", '"_x', default_opts)
