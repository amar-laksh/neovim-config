local dressing_status_ok, dressing = pcall(require, 'dressing')
if not dressing_status_ok then
    return
end


dressing.setup({})
