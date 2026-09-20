local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Tema
    { "folke/tokyonight.nvim", priority = 1000, opts = { style = "night", transparent = true } },

    -- Telescope (Fuzzy Finder)
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      -- Telescope (Fuzzy Finder)
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar arquivos" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar texto (grep)" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Listar buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Buscar ajuda" },
      },
    },

    -- Autocompletar nativo + fontes do LSP
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          }),
          sources = cmp.config.sources({
            { name = "nvim-lsp" },
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end,
    },
    -- Integração ZK + Telescope
    {
      "mickael-menu/zk-nvim",
      config = function()
        require("zk").setup({
          picker = "telescope",
        })
      end,
    },
    -- LSP Config com capacidades do autocompletar
    {
      "neovim/nvim-lspconfig",
      dependencies = { "hrsh7th/cmp-nvim-lsp" },
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Servidores genéricos
        local default_servers = { "pyright", "gopls", "zk" }
        for _, server in ipairs(default_servers) do
          vim.lsp.config(server, { capabilities = capabilities })
          vim.lsp.enable(server)
        end
        -- Configuração específica do Nil (Nix LSP)
        vim.lsp.config("nil_ls", {
          capabilities = capabilities,
          settings = {
            ["nil"] = {
              nix = {
                flake = {
                  autoArchive = true,
                  autoEvalInputs = false,
                },
              },
            },
          },
        })
        vim.lsp.enable("nil_ls")
      end,
    },
  },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
