local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Sair do modo de inserção" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Salvar arquivo" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Sair" })

-- ZK / Notas
map("n", "<leader>zn", "<cmd>ZkNew { title = vim.fn.input('Título: ') }<cr>", { desc = "Criar nova nota ZK" })
map("n", "<leader>zf", "<cmd>ZkNotes { sort = { 'modified' } }<cr>", { desc = "Buscar notas ZK (Telescope)" })
map("n", "<leader>zt", "<cmd>ZkTags<cr>", { desc = "Buscar tags ZK (Telescope)" })
map("n", "<leader>zb", "<cmd>ZkBacklinks<cr>", { desc = "Buscar backlinks ZK" })
map("n", "<leader>zl", "<cmd>ZkLinks<cr>", { desc = "Buscar links de saída" })
