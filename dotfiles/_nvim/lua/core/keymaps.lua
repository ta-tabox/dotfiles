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


-- leaderとして設定するためスペースの機能を削除
keymap("", "<Space>", "<Nop>", default_opts)

-- Nomal --
-- 論理行と表示行を入れ替え
keymap("n", "k", "gk", default_opts)
keymap("n", "j", "gj", default_opts)
keymap("n", "gk", "k", default_opts)
keymap("n", "gj", "j", default_opts)

-- 移動を早くする
keymap("n", "<C-j>", "5j", default_opts)
keymap("n", "<C-k>", "5k", default_opts)
keymap("v", "<C-j>", "5j", default_opts)
keymap("v", "<C-k>", "5k", default_opts)

-- window navigation
keymap("n", "<Leader>h", "<C-w>h", default_opts)
keymap("n", "<Leader>j", "<C-w>j", default_opts)
keymap("n", "<Leader>k", "<C-w>k", default_opts)
keymap("n", "<Leader>l", "<C-w>l", default_opts)

-- yank
keymap("n", "<Leader>p", '"0p', default_opts)

-- ハイライトを消す
keymap("n", "<ESC>", "<CMD>nohlsearch<CR><ESC>", opts("No highlight search"))
keymap("n", "<Leader>q", ":nohlsearch<CR>", default_opts)

-- バッファサイズの変更
keymap("n", "<Up>", "<cmd>resize -2<CR>", opts("Resize UP"))
keymap("n", "<Down>", "<cmd>resize +2<CR>", opts("Resize Down"))
keymap("n", "<Left>", "<cmd>vertical resize -2<CR>", opts("Resize Left"))
keymap("n", "<Right>", "<cmd>vertical resize +2<CR>", opts("Resize Right"))

-- ZZ, ZQ を無効化
keymap("n", "ZZ", "<Nop>", default_opts)
keymap("n", "ZQ", "<Nop>", default_opts)


-- Insert --
keymap("i", "jk", "<Esc>", opts("Press jk faset to exit insert mode"))
keymap("i", "<C-a>", "<Esc>0i", opts("Move to the last of line"))
keymap("i", "<C-e>", "<Esc>$a", opts("Move to the first of line"))


-- Visual --
-- ビジュアルモードで < > キーによるインデント後にビジュアルモードが解除されないようにする
keymap("v", "<", "<gv", default_opts)
keymap("v", ">", ">gv", default_opts)


-- Command --
-- アクティブなファイルが含まれているディレクトリを展開
keymap("c", "<expr>", "%% getcmdtype() == ':' ? expand('%:h').'/' : '%%'", default_opts)


-- General --
-- ; :を入れ替える
keymap("n", ";", ":", default_opts)
keymap("n", ":", ";", default_opts)
keymap("v", ";", ":", default_opts)
keymap("v", ":", ";", default_opts)


-- コマンドで削除した時はヤンクしない
keymap("n", "x", '"_x', default_opts)
keymap("v", "x", '"_x', default_opts)

-- ターミナルから抜ける
keymap("t", "<ESC>", [[<C-\><C-n>]], opts("Exit the terminal"))


