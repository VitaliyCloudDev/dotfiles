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
vim.opt.cursorline  = true
vim.opt.wrap        = false
vim.opt.clipboard   = "unnamed"
vim.opt.swapfile    = false
vim.opt.hidden      = true
vim.opt.backspace   = "indent,eol,start"
vim.opt.mouse       = "a"
vim.opt.scrolloff   = 8

-- Дополнительно полезное
vim.opt.number         = true   -- номера строк
vim.opt.relativenumber = true   -- относительные номера (удобно для движений)
vim.opt.signcolumn     = "yes"  -- колонка слева для диагностики/git (не прыгает)
vim.opt.termguicolors  = true   -- 24-bit цвета


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

  -- Автодополнение
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- источник: LSP
      "hrsh7th/cmp-buffer",     -- источник: слова из буфера
      "L3MON4D3/LuaSnip",       -- сниппеты (нужны nvim-cmp)
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
          ["<Tab>"]   = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"]    = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(), -- вызвать вручную
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
      })
    end,
  },

  -- Тема — VS Code Dark+
  {
    "Mofiqul/vscode.nvim",
    priority = 1000, -- грузить первым
    config = function()
      require("vscode").setup({ style = "light" })
      require("vscode").load()
    end,
  },

  -- Файловый менеджер
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true, -- схлопывать пустые папки
        },
        filters = {
          dotfiles = false, -- показывать скрытые файлы
        },
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

})


-- =============================================================================
-- Горячие клавиши
-- =============================================================================

local map = vim.keymap.set

-- Файловый менеджер (как в VS Code)
map("n", "<C-b>", ":NvimTreeToggle<CR>",  { silent = true, desc = "Файловое дерево" })
map("n", "<C-S-e>", ":NvimTreeFocus<CR>", { silent = true, desc = "Фокус на дереве" })

-- Поиск файлов (как Ctrl+P в VS Code)
map("n", "<C-p>", ":Telescope find_files<CR>",  { silent = true, desc = "Найти файл" })
-- Поиск по содержимому
map("n", "<C-f>", ":Telescope live_grep<CR>",   { silent = true, desc = "Поиск в проекте" })

-- Навигация между окнами
map("n", "<C-h>", "<C-w>h", { desc = "Окно влево" })
map("n", "<C-l>", "<C-w>l", { desc = "Окно вправо" })
map("n", "<C-j>", "<C-w>j", { desc = "Окно вниз" })
map("n", "<C-k>", "<C-w>k", { desc = "Окно вверх" })

-- Снять подсветку поиска
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Сохранить как в VS Code
map("n", "<C-s>", ":w<CR>",  { silent = true, desc = "Сохранить" })
map("i", "<C-s>", "<Esc>:w<CR>a", { silent = true, desc = "Сохранить из insert mode" })
-- LSP PYTHON
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyrightconfig.json", "pyproject.toml", "requirements.txt", ".git" },
})
vim.lsp.enable("pyright")
-- LSP GOLANG
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go" },
  root_markers = { "go.mod", "go.work", ".git" },
})
vim.lsp.enable({ "pyright", "gopls" })
-- Cursor Show Tip
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
vim.opt.updatetime = 500  -- миллисекунды, по умолчанию 4000