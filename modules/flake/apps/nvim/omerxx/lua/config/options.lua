vim.opt.wrap = true
vim.g.codeium_os = "Darwin"
vim.g.codeium_arch = "arm64"
vim.opt.foldmethod = "manual"



-- Opções para performanceestilo Helix
vim.opt.lazyredraw = true -- Não redesenha a tela enquanto executa macros/movimentos encadeados
vim.opt.updatetime = 200  -- Tempo de resposta mais rápido para eventos
vim.opt.timeoutlen = 300  -- Resposta mais rápida para atalhos
