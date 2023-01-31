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
local ntg = vim.api.nvim_create_augroup("numbertoggle", {clear = true})
autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {callback = function() vim.opt.relativenumber = true end, group = ntg})
autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {callback = function() vim.opt.relativenumber = false end, group = ntg})


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

vim.keymap.set({"n", "v"}, "<Home>", "^")
vim.keymap.set("i", "<Home>", "<Esc>^i")
vim.keymap.set("n", "cn", "*``cgn")
vim.keymap.set("x", "cn", [["y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"]], { expr = true })
vim.keymap.set({"n", "i"}, "<C-s>", "<cmd>w<cr>")
vim.keymap.set({"i", "c"}, "<S-Insert>", "<MiddleMouse>")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "dw", "diw")
vim.keymap.set("n", "cw", [["_ciw]])
vim.keymap.set("n", "yw", "yiw")
vim.keymap.set("n", "yf", [[:let @+ = expand("%")<cr>]])
vim.keymap.set("n", "gf", "gF")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr><cmd>cclose<cr>")


require("lazy").setup {
  "gpanders/editorconfig.nvim",
  {
    "rlane/pounce.nvim",
    keys = {
      {"s", "<cmd>Pounce<cr>"},
    },
    opts = { accept_keys = "12345" },
  },
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "darker"
      vim.cmd.colorscheme("material")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require"nvim-treesitter.configs".setup {
        highlight = {
          enable = true,
        },
        ensure_installed = "all",
        indent = {
          enable = true
        },
      }
    end,
  },
  {
    "ethanholz/nvim-lastplace",
    opts = {},
  },
  {
    "shatur/neovim-session-manager",
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
    dependencies = {"nvim-lua/plenary.nvim"},
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "akinsho/bufferline.nvim",
    opts = {},
    lazy = false,
    keys = {
      { "<C-w>", "<cmd>bdelete<cr>", mode = {"n", "t"}},
      { "<C-k>", "<cmd>bprevious<cr>", mode = {"n", "t"}},
      { "<C-j>", "<cmd>bnext<cr>", mode = {"n", "t"}},
      { "<C-S-k>", "<cmd>BufferLineMovePrev<cr>", mode = {"n", "t"}},
      { "<C-S-j>", "<cmd>BufferLineMoveNext<cr>", mode = {"n", "t"}},
      { "<C-1>", "<cmd>BufferLineGoToBuffer 1<cr>", mode = {"n", "t"}},
      { "<C-2>", "<cmd>BufferLineGoToBuffer 2<cr>", mode = {"n", "t"}},
      { "<C-3>", "<cmd>BufferLineGoToBuffer 3<cr>", mode = {"n", "t"}},
      { "<C-4>", "<cmd>BufferLineGoToBuffer 4<cr>", mode = {"n", "t"}},
      { "<C-5>", "<cmd>BufferLineGoToBuffer 5<cr>", mode = {"n", "t"}},
    },
  },
  {
    "ojroques/nvim-hardline",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    keys = {
      {"<leader>gg", "<cmd>Gitsigns preview_hunk<cr>", desc = "git_preview" },
      {"<leader>gn", "<cmd>Gitsigns next_hunk<cr>", desc = "git_next" },
      {"<leader>gp", "<cmd>Gitsigns prev_hunk<cr>", desc = "git_prev" },
    },
    opts = {numhl = true, signcolumn = false },
    dependencies = {"nvim-lua/plenary.nvim"},
  },
  {
    "ruifm/gitlinker.nvim",
    opts = {},
    dependencies = {"nvim-lua/plenary.nvim"},
  },
  {
    "gen740/SmoothCursor.nvim",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    config = function()
      local whichkey = require("which-key")
      whichkey.setup()
      whichkey.register({
        ["<leader>f"] = { ":%s///gc<Left><Left><Left><Left>", "find&replace" },
        ["<leader>n"] = { "<cmd>cnext<cr>", "quickfix_next" },
        ["<leader>N"] = { "<cmd>cprev<cr>", "quickfix_prev" },
        ["<leader>q"] = { "<cmd>qa<cr>", "quit" },
        ["<leader>s"] = { "<cmd>w<cr>", "save" },
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    keys = {
      {"<leader>p", function() require("fzf-lua").files() end, desc = "find_files" },
      {"<leader>F", function() require("fzf-lua").live_grep_resume() end, desc = "live_grep" },
      {"<leader>h", function() require("fzf-lua").git_status() end, desc = "git_status" },
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
  {
    "VonHeikemen/lsp-zero.nvim",
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
}
