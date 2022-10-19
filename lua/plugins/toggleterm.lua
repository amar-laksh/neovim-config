local toggleterm_status_ok, toggleterm = pcall(require, 'toggleterm')
if not toggleterm_status_ok then
    return
end

toggleterm.setup({
    open_mapping = [[<esc>c]],
    direction = 'vertical',
    size = function(term)
        if term.direction == 'vertical' then
            return vim.o.columns * 0.4
        end
    end
})
