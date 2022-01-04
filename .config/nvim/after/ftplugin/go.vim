setlocal tabstop=4
setlocal shiftwidth=4

nmap <silent> <leader>dt :lua require('dap-go').debug_test()<CR>
