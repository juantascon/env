local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

local autocmd = vim.api.nvim_create_autocmd
local aug = vim.api.nvim_create_augroup("group", {clear = true})
autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {callback = function() vim.opt.relativenumber = true end, group = aug})
autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {callback = function() vim.opt.relativenumber = false end, group = aug})
autocmd("BufReadPost", {callback = function() if vim.fn.line "'\"" > 1 and vim.fn.line "'\"" <= vim.fn.line "$" then vim.cmd 'normal! g`"' end end, group = aug})
autocmd("BufWritePost", {pattern = "*.py", command = "LspZeroFormat", group = aug})

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h17"
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.writebackup = false
vim.opt.showtabline = 0
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes:2"
vim.opt.number = true
vim.opt.laststatus = 3
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.lazyredraw = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 250
vim.opt.mat = 2
vim.opt.undofile = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 1
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.list = true
vim.opt.listchars:append("space:·")
vim.opt.listchars:append("tab:➜ ")
vim.opt.pumheight = 10
vim.opt.wildmode = "longest:full,full"

vim.keymap.set({"i", "c"}, "<S-Insert>", "<MiddleMouse>")
vim.keymap.set({"n", "v"}, "<Home>", "^")
vim.keymap.set("i", "<Home>", "<Esc>^i")
vim.keymap.set("n", "cn", "*``cgn")
vim.keymap.set("x", "cn", [["y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"]], { expr = true })
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "dw", "diw")
vim.keymap.set("n", "yw", "yiw")
vim.keymap.set("n", "cw", [["_ciw]])
vim.keymap.set("n", "yf", [[:let @+ = expand("%")<cr>]], {desc = "Yank filename"})
vim.keymap.set({"n", "x"}, "gy", [["+y]], {desc = "Yank to system clipboard"})
vim.keymap.set("n", "gp", [["+p]], {desc = "Paste from system clipboard"})
vim.keymap.set("x", "gp", [["+P]], {desc = "Paste from system clipboard"})
vim.keymap.set("n", "gf", "gF")
vim.keymap.set({"n", "x"}, "gw", "*N")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr><cmd>cclose<cr>")
vim.keymap.set({"n", "i"}, "<C-s>", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>s", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>f", ":%s///gc<Left><Left><Left><Left>", {silent = false, desc = "find & replace"})
vim.keymap.set("v", "<Leader>f", [[y:%s/<C-R>"//gc<Left><Left><Left>]], {silent = false, desc = "find & replace selection"})
vim.keymap.set("n", "<leader>q", "<cmd>qa<cr>")

require("lazy").setup ({
  "gpanders/editorconfig.nvim",
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require"nvim-treesitter.configs".setup {
        highlight = {enable = true},
        indent = {enable = true},
        ensure_installed = "all",
      }
    end,
  },
  {
    "shatur/neovim-session-manager",
    lazy = false,
    dependencies = {"nvim-lua/plenary.nvim"},
    keys = {
      { "<leader>r", "<cmd>SessionManager load_session<cr>", desc = "sessions" },
    },
    config = function()
      require("session_manager").setup {
        autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
        autosave_only_in_session = true,
      }
    end,
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    keys = {
      { "<C-w>", "<cmd>bdelete<cr>"},
      { "<C-k>", "<cmd>BufferLineCyclePrev<cr>"},
      { "<C-j>", "<cmd>BufferLineCycleNext<cr>"},
      { "<C-S-k>", "<cmd>BufferLineMovePrev<cr>"},
      { "<C-S-j>", "<cmd>BufferLineMoveNext<cr>"},
      { "<C-1>", "<cmd>BufferLineGoToBuffer 1<cr>"},
      { "<C-2>", "<cmd>BufferLineGoToBuffer 2<cr>"},
      { "<C-3>", "<cmd>BufferLineGoToBuffer 3<cr>"},
      { "<C-4>", "<cmd>BufferLineGoToBuffer 4<cr>"},
      { "<C-5>", "<cmd>BufferLineGoToBuffer 5<cr>"},

      { "<leader>w", "<cmd>bdelete<cr>"},
      { "<leader>k", "<cmd>BufferLineCyclePrev<cr>"},
      { "<leader>j", "<cmd>BufferLineCycleNext<cr>"},
      { "<leader>S-k", "<cmd>BufferLineMovePrev<cr>"},
      { "<leader>S-j", "<cmd>BufferLineMoveNext<cr>"},
      { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>"},
      { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>"},
      { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>"},
      { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>"},
      { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>"},
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        separator_style = "slant",
      }
    },
  },
  {
    "ojroques/nvim-hardline",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    dependencies = {"nvim-lua/plenary.nvim"},
    keys = {
      {"hh", "<cmd>Gitsigns preview_hunk<cr>", desc = "git_preview" },
      {"hn", "<cmd>Gitsigns next_hunk<cr>", desc = "git_next" },
      {"hN", "<cmd>Gitsigns prev_hunk<cr>", desc = "git_prev" },
    },
    opts = {},
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    opts = {
      mappings = "yh"
    },
  },
  {
    "gen740/SmoothCursor.nvim",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    opts = {},
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    priority = 1000,
    dependencies = {
      {"neovim/nvim-lspconfig"},
      {"williamboman/mason.nvim"},
      {"williamboman/mason-lspconfig.nvim"},
      {"hrsh7th/nvim-cmp"},
      {"hrsh7th/cmp-nvim-lsp"},
      {"hrsh7th/cmp-buffer"},
      {"hrsh7th/cmp-nvim-lua"},
      {"hrsh7th/cmp-cmdline"},
      {"hrsh7th/cmp-nvim-lsp-signature-help"},
      {"saadparwaiz1/cmp_luasnip"},
      {"rafamadriz/friendly-snippets"},
      {"L3MON4D3/LuaSnip"},
    },
    config = function()
      local lsp = require("lsp-zero")
      local cmp = require("cmp")
      lsp.preset({
        name = "recommended",
        set_lsp_keymaps = {omit = {"<F2>", "<C-k>"}, preserve_mappings=false},
        suggest_lsp_servers = false,
      })
      lsp.setup_nvim_cmp({
        preselect = cmp.PreselectMode.None,
        completion = {completeopt = "menu,menuone,noinsert,noselect"},
      })
      lsp.nvim_workspace()
      lsp.ensure_installed({"pylsp", "lua_ls", "bashls", "jsonls"})
      -- :PylspInstall pyls-black pyls-isort
      lsp.configure("pylsp", {settings = {pylsp = {plugins = {pycodestyle = {maxLineLength = 120}}}}})
      lsp.setup()

      cmp.setup.cmdline(":", {sources = {{name = "cmdline"}}})
      cmp.setup.cmdline("/", {sources = {{name = "buffer"}}})

    end,
  },
  {
    "ibhagwan/fzf-lua",
    lazy = false,
    keys = {
      {"<leader>p", function() require("fzf-lua").files() end, desc = "find_files" },
      {"<leader>F", function() require("fzf-lua").live_grep_resume() end, desc = "live_grep" },
      {"<leader>h", function() require("fzf-lua").git_status() end, desc = "git_status" },
      {"<leader>l", function() require("fzf-lua").quickfix() end, desc = "quickfix" },
    },
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        files = {
          fd_opts = "--color=never --type f --no-ignore --hidden --follow --exclude .git --exclude __pycache__ --exclude node_modules"
        },
        grep = {
          rg_opts = "--sort=path --column --line-number --no-heading --color=always --smart-case --max-columns=512",
        },
      })
      fzf.register_ui_select()
    end,
  },
},
{
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {"netrw", "netrwSettings", "netrwFileHandlers", "gzip", "zip", "tar", "shada_autoload", "tutor", "tohtml", "msgpack_autoload"}
    },
  },
})
