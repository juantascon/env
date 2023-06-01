local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

local autocmd = vim.api.nvim_create_autocmd
autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {callback = function() vim.opt.relativenumber = true end})
autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {callback = function() vim.opt.relativenumber = false end})
autocmd("BufReadPost", {callback = function() if vim.fn.line "'\"" > 1 and vim.fn.line "'\"" <= vim.fn.line "$" then vim.cmd 'normal! g`"' end end})
autocmd("BufWritePost", {pattern = "*.py", callback = function() vim.lsp.buf.format() end})

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
vim.opt.pumblend = 10
vim.opt.winblend = 10
vim.opt.wildmode = "longest:full,full"
vim.opt.smartcase = true

vim.keymap.set({"i", "c"}, "<S-Insert>", "<MiddleMouse>")
vim.keymap.set({"n", "v"}, "<Home>", "^")
vim.keymap.set("i", "<Home>", "<Esc>^i")
vim.keymap.set("n", "c", "*``cgn")
vim.keymap.set("x", "c", [["y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"]], { expr = true })
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set({"n", "x"}, "r", [["_d]])
vim.keymap.set("n", "rr", [["_dd]])
vim.keymap.set("v", "p", [["_dP]])
vim.keymap.set("n", "vw", "viw")
vim.keymap.set("n", "rw", [["_diw]])
vim.keymap.set("n", "dw", "diw")
vim.keymap.set("n", "yw", "yiw")
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
vim.keymap.set("n", "<C-[>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<C-]>", "<cmd>cprev<cr>")
vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("", "<C-z>", "<Nop>", { noremap = true, silent = true })

require("lazy").setup ({
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
        auto_install = true,
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
    "echasnovski/mini.indentscope",
    opts = {},
  },
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    keys = {
      { "<C-t>", "<cmd>enew<cr>"},
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

      { "<leader>t", "<cmd>enew<cr>"},
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
    config = function()
      require("gitlinker").setup({
        mappings = "yh",
        callbacks = {["gitlab.lan.athonet.com"] = require("gitlinker.hosts").get_gitlab_type_url},
      })
    end
  },
  {
    "gen740/SmoothCursor.nvim",
    opts = {},
  },
  {
    "folke/noice.nvim",
    dependencies = {
      {"MunifTanjim/nui.nvim"},
      -- {"rcarriga/nvim-notify"},
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    priority = 1000,
    lazy = false,
    dependencies = {
      {"williamboman/mason.nvim"},
      {"williamboman/mason-lspconfig.nvim"},
      {"folke/neodev.nvim"},
      {"hrsh7th/nvim-cmp"},
      {"hrsh7th/cmp-nvim-lsp"},
      {"hrsh7th/cmp-buffer"},
      {"hrsh7th/cmp-nvim-lua"},
      {"hrsh7th/cmp-nvim-lsp-signature-help"},
      {"saadparwaiz1/cmp_luasnip"},
      {"rafamadriz/friendly-snippets"},
      {"L3MON4D3/LuaSnip"},
    },
    keys = {
      {"K", function() vim.lsp.buf.hover() end},
      {"gd", function() vim.lsp.buf.definition() end},
      {"gD", function() vim.lsp.buf.declaration() end},
      {"gi", function() vim.lsp.buf.implementation() end},
      {"gr", function() vim.lsp.buf.references() end},
      {"gs", function() vim.lsp.buf.signature_help() end},
      {"gl", function() vim.diagnostic.open_float() end},
    },
    config = function()
      require("neodev").setup({
        override = function(root_dir, library)
          library.enabled = true
          library.plugins = true
        end,
      })

      require("mason").setup({})
      require("mason-lspconfig").setup()

      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        preselect = cmp.PreselectMode.None,
        completion = {completeopt = "menu,menuone,noinsert,noselect"},
        mapping = {
          ["<cr>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace}),
          ["<down>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
          ["<up>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
          ["<c-u>"] = cmp.mapping.scroll_docs(-4),
          ["<c-d>"] = cmp.mapping.scroll_docs(4),
        },
        sources = {
          {name = "nvim_lsp"},
          {name = "nvim_lsp_signature_help"},
          {name = "luasnip"},
          {name = "nvim_lua"},
          {name = "buffer", keyword_length = 4},
        },
      })

      local lspconfig = require("lspconfig")
      local defaults = lspconfig.util.default_config
      defaults.capabilities = vim.tbl_deep_extend("force", defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
      lspconfig.lua_ls.setup({})
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.mix,
        },
      }
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
        keymap = {
          fzf = {
            ["ctrl-a"] = "select-all+accept",
          }
        },
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
  -- checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {"netrw", "netrwSettings", "netrwFileHandlers", "gzip", "zip", "tar", "shada_autoload", "tutor", "tohtml", "msgpack_autoload"}
    },
  },
})
