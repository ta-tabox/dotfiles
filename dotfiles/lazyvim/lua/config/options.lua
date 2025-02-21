-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

local opt = vim.opt

vim.scriptencodeint = "utf-8"

-- シェルの設定
opt.shell = "/bin/zsh"

-- newvimのメッセージを英語にする
opt.langmenu = "en_US.UTF-8"
vim.api.nvim_exec2("language message en_US.UTF-8", {})

-- helpは日本語
opt.helplang = "js"

-- 文字コードの設定
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = { "utf-8", "sjis" }

opt.timeoutlen = 300 -- mappingの待機時間
opt.ttimeoutlen = 1 -- key codesの待機時間
opt.updatetime = 200 -- キーの入力待機時間
opt.history = 200 -- command history


-- 改行
opt.wrapmargin = 0
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
-- 行に関する設定はあまりうまくいっていない
-- opt.textwidth = 80
-- opt.columns = 80
-- opt.colorcolumn = '79'

-- Skip for VSCode
-- if not vim.g.vscode then
--   opt.tabstop = 4 -- tab時の見かけのスペース数
--   opt.shiftwidth = 4 -- 自動的に挿入される量
-- end

-- Spell check
opt.spelllang = { "en", "cjk" }

-- pythonのパスを指定
vim.g.python3_host_prog = "~/.anyenv/envs/pyenv/shims/python3"
