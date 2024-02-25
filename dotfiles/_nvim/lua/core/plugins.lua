-- https://github.com/echasnovski/mini.nvim/tree/main

-- miniプラグインのセットアップ
require('mini.bracketed').setup()
require('mini.comment').setup({
    custom_commentstring = '#',
})
require('mini.completion').setup()
require('mini.cursorword').setup()
require('mini.files').setup()
require('mini.fuzzy').setup()
-- require('mini.jump').setup({
--   mappings = {
--     repeat_jump = ':',
--   }
-- })
require('mini.jump2d').setup()
require('mini.pairs').setup()
require('mini.starter').setup()
require('mini.statusline').setup()
require('mini.surround').setup()
require('mini.bufremove').setup()
require('mini.tabline').setup()
