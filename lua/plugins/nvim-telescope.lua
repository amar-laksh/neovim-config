local telescope_status_ok, telescope = pcall(require, 'telescope')
if not telescope_status_ok then
    return
end


telescope.load_extension('file_browser')
telescope.load_extension('hoogle') -- Haskell hackage docs
