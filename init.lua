-- =============================================================================
-- init.lua
-- ~/.config/nvim/init.lua
-- =============================================================================

-- =============================================================================
-- Базовые настройки (из .vimrc)
-- =============================================================================

vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true
vim.opt.autoindent  = true
vim.opt.hlsearch    = true
vim.opt.incsearch   = true
vim.opt.cursorline  = false
vim.opt.wrap        = false
vim.opt.clipboard   = "unnamed"
vim.opt.swapfile    = false
vim.opt.hidden      = true
vim.opt.backspace   = "indent,eol,start"
vim.opt.mouse       = "a"
vim.opt.scrolloff   = 8
vim.opt.shell       = "/bin/bash"
vim.opt.updatetime  = 500  -- для CursorHold, по умолчанию 4000

-- Дополнительно полезное
vim.opt.number         = true   -- номера строк
vim.opt.relativenumber = true   -- относительные номера (удобно для движений)
vim.opt.signcolumn     = "yes"  -- колонка слева для диагностики/git (не прыгает)
vim.opt.termguicolors  = true   -- 24-bit цвета
vim.opt.colorcolumn = "80"

vim.g.mapleader = " "           -- leader = пробел


-- =============================================================================
-- Bootstrap lazy.nvim
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- =============================================================================
-- Плагины
-- =============================================================================

require("lazy").setup({

  -- Тема — VS Code Dark+
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({ style = "light" })
      require("vscode").load()
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2d2e" })
    end,
  },

  -- Mason — менеджер установки LSP серверов
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "pyright" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  -- Автодополнение
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
      })
    end,
  },

  -- Файловый менеджер
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end,
  },

  -- Строка статуса
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "vscode" },
      })
    end,
  },

  -- Нечёткий поиск файлов (как Ctrl+P в VS Code)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
    end,
  },

  -- Автозакрытие скобок и кавычек
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Git: показывает изменения в signcolumn
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Комментирование: gcc для строки, gc для выделения
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Форматирование кода при сохранении
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python     = { "black" },
          go         = { "gofmt" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          json       = { "prettier" },
          yaml       = { "prettier" },
          lua        = { "stylua" },
        },
        -- форматировать автоматически при сохранении
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,  -- если форматтер не найден — использовать LSP
        },
      })
    end,
  },

  -- Подсветка отступов
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope  = { enabled = true },
      })
    end,
  },

  -- Подсказки по хоткеям
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
      -- Группы для leader-клавиш
      require("which-key").add({
        { "<leader>e", desc = "Показать ошибку" },
        { "<leader>f", group = "Файл" },
      })
    end,
  },

  -- Breadcrumbs — текущий класс/функция вверху окна
  {
    "utilyre/barbecue.nvim",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("barbecue").setup({
        theme = "vscode",
      })
    end,
  },

})


-- =============================================================================
-- Горячие клавиши
-- =============================================================================

local map = vim.keymap.set

-- Файловый менеджер (как в VS Code)
map("n", "<C-b>",   ":NvimTreeToggle<CR>", { silent = true, desc = "Файловое дерево" })
map("n", "<C-S-e>", ":NvimTreeFocus<CR>",  { silent = true, desc = "Фокус на дереве" })

-- Поиск файлов (как Ctrl+P в VS Code)
map("n", "<C-p>", ":Telescope find_files<CR>", { silent = true, desc = "Найти файл" })
map("n", "<C-f>", ":Telescope live_grep<CR>",  { silent = true, desc = "Поиск в проекте" })

-- Навигация между окнами
map("n", "<C-h>", "<C-w>h", { desc = "Окно влево" })
map("n", "<C-l>", "<C-w>l", { desc = "Окно вправо" })
map("n", "<C-j>", "<C-w>j", { desc = "Окно вниз" })
map("n", "<C-k>", "<C-w>k", { desc = "Окно вверх" })

-- Снять подсветку поиска
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Сохранить как в VS Code
map("n", "<C-s>", ":w<CR>",       { silent = true, desc = "Сохранить" })
map("i", "<C-s>", "<Esc>:w<CR>a", { silent = true, desc = "Сохранить из insert mode" })

-- Терминал
map("n", "<C-t>", ":terminal<CR>", { silent = true, desc = "Терминал" })

-- LSP диагностика
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Показать ошибку" })
map("n", "[d",        vim.diagnostic.goto_prev,  { desc = "Предыдущая ошибка" })
map("n", "]d",        vim.diagnostic.goto_next,  { desc = "Следующая ошибка" })

-- Форматировать вручную
map("n", "<leader>ff", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Форматировать файл" })


-- =============================================================================
-- Автокоманды
-- =============================================================================

-- Показывать диагностику при остановке курсора
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end,
})
