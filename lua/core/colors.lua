vim.cmd([[colorscheme gruvbox]])

require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = true,
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "soft", -- can be "hard", "soft" or empty string
    overrides = {},
})

-- Changes theme background based on time (24 hour)
local currentHour = tonumber(os.date("%H"))
if currentHour < 18 and currentHour >= 5 then
    vim.o.background = "light"
else
    vim.o.background = "dark"
end
