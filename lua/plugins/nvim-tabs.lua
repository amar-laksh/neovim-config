local tabs_status_ok, tabs = pcall(require, 'barbar')
if not tabs_status_ok then
    return
end

tabs.setup()
