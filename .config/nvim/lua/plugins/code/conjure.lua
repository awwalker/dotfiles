local noremap = { noremap = true }

local M = {
  "Olical/conjure",
  ft = { "clojure", "python", "edn" },
  keys = {
    {"<leader>di", "<cmd> ConjureCljDebugInit<CR>", mode="n", noremap },
    {"<leader>c",  "<cmd> ConjureCljDebugInput continue<CR>", mode="n", noremap },
    {"<leader>si", "<cmd> ConjureCljDebugInput in<CR>", mode="n", noremap },
    {"<leader>so", "<cmd> ConjureCljDebugInput out<CR>", mode="n", noremap },
    {"<leader>l", "<cmd> ConjureCljDebugInput local<CR>", mode="n", noremap },
    {"<leader>n", "<cmd> ConjureCljDebugInput next<CR>", mode="n", noremap },
    {"<leader>de", "<cmd> ConjureCljDebugInput eval<CR>", mode="n", noremap },
  },
  config = function()
    vim.g["conjure#eval#gsubs"] = { ["comment"] = { "^%(comment[%s%c]", "(do " } }
    -- autocmd BufNewFile conjure-log-* lua vim.diagnostic.disable(0)
    vim.api.nvim_create_autocmd("BufNewFile", {
      group = vim.api.nvim_create_augroup("ConjureLog", { clear = true }),
      pattern = "conjure-log-*",
      callback = function(params)
        vim.diagnostic.disable(0)
      end,
    })
    -- autocmd User ConjureEval if expand("%:t") =~ "^conjure-log-" | exec "normal G" | endif
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("ConjureEval", { clear = true }),
      pattern = "ConjureEval",
      callback = function(params)
        if string.match(vim.api.nvim_buf_get_name(0), "conjure%-log%-") then
          vim.api.nvim_exec([[normal G]], true)
        end
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("ConjureSmartQ", { clear = true }),
      pattern = "conjure-log-*",
      command = "nmap <buffer> q gq",
    })
  end
}

return M
