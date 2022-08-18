vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])


-- Changes theme background based on time (24 hour)
local currentHour = tonumber(os.date("%H"))
if currentHour <= 21 and currentHour >= 5 then
    vim.o.background = "light"
else
    vim.o.background = "dark"
end
