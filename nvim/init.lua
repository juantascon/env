local disabled_builtin = {"netrw", "netrwSettings", "netrwFileHandlers", "gzip", "zip", "tar", "shada_autoload", "msgpack_autoload"}
for _, plugin in pairs(disabled_builtin) do
  vim.g["loaded_" .. plugin] = 1
end

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


vim.g.mapleader = " "
vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h17"
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.writebackup = false
vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.showtabline = 0
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.cursorline = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 250
vim.opt.undofile = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 1
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.list = true
vim.opt.listchars:append("space:·")
vim.opt.listchars:append("tab:➜ ")

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


require("lazy").setup {
  "gpanders/editorconfig.nvim",
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
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
    dependencies = {"nvim-lua/plenary.nvim"},
    lazy = false,
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
      { "<C-k>", "<cmd>bprevious<cr>"},
      { "<C-j>", "<cmd>bnext<cr>"},
      { "<C-S-k>", "<cmd>BufferLineMovePrev<cr>"},
      { "<C-S-j>", "<cmd>BufferLineMoveNext<cr>"},
      { "<C-1>", "<cmd>BufferLineGoToBuffer 1<cr>"},
      { "<C-2>", "<cmd>BufferLineGoToBuffer 2<cr>"},
      { "<C-3>", "<cmd>BufferLineGoToBuffer 3<cr>"},
      { "<C-4>", "<cmd>BufferLineGoToBuffer 4<cr>"},
      { "<C-5>", "<cmd>BufferLineGoToBuffer 5<cr>"},

      { "<leader>w", "<cmd>bdelete<cr>"},
      { "<leader>k", "<cmd>bprevious<cr>"},
      { "<leader>j", "<cmd>bnext<cr>"},
      { "<leader>S-k", "<cmd>BufferLineMovePrev<cr>"},
      { "<leader>S-j", "<cmd>BufferLineMoveNext<cr>"},
      { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>"},
      { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>"},
      { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>"},
      { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>"},
      { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>"},
    },
    opts = {},
  },
  {
    "ojroques/nvim-hardline",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    lazy = false,
    keys = {
      {"hg", "<cmd>Gitsigns preview_hunk<cr>", desc = "git_preview" },
      {"hn", "<cmd>Gitsigns next_hunk<cr>", desc = "git_next" },
      {"hp", "<cmd>Gitsigns prev_hunk<cr>", desc = "git_prev" },
    },
    opts = {numhl = true, signcolumn = false },
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    opts = {},
  },
  {
    "gen740/SmoothCursor.nvim",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    lazy = false,
    opts = {},
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    lazy = false,
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
      lsp.preset("recommended")
      lsp.nvim_workspace()
      lsp.ensure_installed({"pylsp", "sumneko_lua", "bashls", "jsonls"})
      lsp.configure("pylsp", {settings = {pylsp = {plugins = {pycodestyle = {maxLineLength = 120}}}}})
      lsp.setup()

      local cmp = require("cmp")
      cmp.setup.cmdline(":", {sources = {{name = "cmdline"}}})
      cmp.setup.cmdline("/", {sources = {{name = "buffer"}}})
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    keys = {
      {"<leader>p", function() require("telescope.builtin").find_files() end, desc = "find_files" },
      {"<leader>F", function() require("telescope.builtin").live_grep() end, desc = "live_grep" },
      {"<leader>h", function() require("telescope.builtin").git_status() end, desc = "git_status" },
      {"<leader>l", function() require("telescope.builtin").quickfix() end, desc = "quickfix" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {horizontal = {prompt_position = "top"}},
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
              ["<cr>"] = function(bufnr)
                local picker = require("telescope.actions.state").get_current_picker(bufnr)
                if #picker:get_multi_selection() > 0 then
                  require("telescope.actions").send_selected_to_qflist(bufnr)
                  require("telescope.builtin").quickfix()
                else
                  require("telescope.actions").select_default(bufnr)
                end
              end,
            },
          },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}
