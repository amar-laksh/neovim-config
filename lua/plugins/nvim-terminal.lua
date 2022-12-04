local fterm_status_ok, fterm = pcall(require, 'FTerm')
if not fterm_status_ok then
    return
end

fterm.setup({
    border     = 'single',
    dimensions = {
        height = 0.4,
        width = 0.4,
    },
})
