return {
    {
        'dracula/vim',
        name = 'dracula',
        lazy = false, -- 必ず起動時に読み込まれる
        priority = 1000, -- 最優先
        config = function()
            -- load the colorscheme
            vim.cmd([[ colorscheme dracula ]])
        end
    }
}
