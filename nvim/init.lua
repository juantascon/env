local disabled_builtin = {"netrw", "netrwSettings", "netrwFileHandlers", "gzip", "zip", "tar", "shada_autoload", "msgpack_autoload"}
for _, plugin in pairs(disabled_builtin) do
  vim.g["loaded_" .. plugin] = 1
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)


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
vim.opt.relativenumber = true
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
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")


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
        rainbow = {
          enable = true,
          extended_mode = true
        },
        textsubjects = {
          enable = true,
          keymaps = {
            ["s"] = "textsubjects-smart",
            ["o"] = "textsubjects-container-outer",
          }
        },
      }
    end,
    dependencies = {"HiPhish/nvim-ts-rainbow2", "RRethy/nvim-treesitter-textsubjects"},
  },
  {
    "ethanholz/nvim-lastplace",
    opts = {},
  },
  {
    "shatur/neovim-session-manager",
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
    keys = {
      {"<leader>gg", "<cmd>Gitsigns preview_hunk<cr>", desc = "git_preview" },
      {"<leader>gn", "<cmd>Gitsigns next_hunk<cr>", desc = "git_next" },
      {"<leader>gp", "<cmd>Gitsigns prev_hunk<cr>", desc = "git_prev" },
    },
    opts = {
      signs = {
        add = { hl = "GitGutterAdd", text = "+" },
        change = { hl = "GitGutterChange", text = "~" },
        delete = { hl = "GitGutterDelete", text = "_" },
        topdelete = { hl = "GitGutterDelete", text = "‾" },
        changedelete = { hl = "GitGutterChange", text = "~" },
      },
    },
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
        ["<leader>l"] = { "<cmd>nohlsearch<cr>", "clear" },
        ["<leader>n"] = { "<cmd>cnext<cr>", "quickfix_next" },
        ["<leader>N"] = { "<cmd>cprev<cr>", "quickfix_prev" },

        ["<leader>q"] = { "<cmd>qa<cr>", "quit" },
        ["<leader>s"] = { "<cmd>w<cr>", "save" },

        ["<leader>da"] = { function() vim.lsp.buf.code_action() end, "lsp_actions" },
        ["<leader>df"] = { function() vim.lsp.buf.formatting() end, "lsp_formatting" },
        ["<leader>dd"] = { function() vim.lsp.buf.definition() end, "lsp_definition" },
        ["<leader>dD"] = { function() vim.lsp.buf.declaration() end, "lsp_declaration" },
        ["<leader>dk"] = { function() vim.lsp.buf.hover() end, "lsp_hover" },
        ["<leader>dh"] = { function() vim.lsp.buf.signature_help() end, "lsp_signature" },
        ["<leader>di"] = { function() vim.lsp.buf.implementation() end, "lsp_implementation" },
        ["<leader>dn"] = { function() vim.lsp.buf.rename() end, "lsp_rename" },
        ["<leader>de"] = { function() vim.lsp.buf.references() end, "lsp_references" },
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    keys = {
      {"<leader>p", function() require("fzf-lua").files() end, desc = "find_files" },
      {"<leader>F", function() require("fzf-lua").live_grep_resume() end, desc = "live_grep" },
      {"<leader>t", function() require("fzf-lua").git_status() end, desc = "git_status" },
    },
    config = function()
      require"fzf-lua".setup({
        files = {
          fd_opts = "--color=never --type f --no-ignore --hidden --follow --exclude .git --exclude _build --exclude .elixir_ls --exclude __pycache__ --exclude node_modules"
        },
        grep = {
          rg_opts = "--sort=path --column --line-number --no-heading --color=always --smart-case --max-columns=512",
        },
      })
      require"fzf-lua".register_ui_select()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) return args.body; end,
        },
        mapping = {
          ["<cr>"] = cmp.mapping(cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Insert}), { "i", "c" }),
          ["<down>"] = cmp.mapping(cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), {"i", "c"}),
          ["<up>"] = cmp.mapping(cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), {"i", "c"}),
        },
        sources = {
          {name = "nvim_lsp"},
          {name = "nvim_lsp_signature_help"},
          {name = "nvim_lua"},
          {name = "buffer", keyword_length = 4},
        },
      })
      cmp.setup.cmdline(':', {
        sources = {
          { name = 'cmdline' }
        }
      })
      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' }
        }
      })
    end,
    dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-buffer", "hrsh7th/cmp-cmdline", "hrsh7th/cmp-nvim-lsp-signature-help"},
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("mason").setup({})
      require("mason-lspconfig").setup()
      local lspconfig = require("lspconfig")
      lspconfig.pylsp.setup{
        settings = {
          pylsp = {
            plugins = { pycodestyle = { maxLineLength = 120 } }
          }
        }
      }
      lspconfig.sumneko_lua.setup({
        settings = {
          Lua = {
            runtime = {version = "LuaJIT"},
            diagnostics = {globals = {"vim"}},
            workspace = {library = vim.api.nvim_get_runtime_file("", true)},
            telemetry = {enable = false},
            completion = {autoRequire = false},
          }
        }
      })
      lspconfig.elixirls.setup({
        settings = {
          elixirLS = {
            dialyzerEnabled = false,
          }
        }
      })
      lspconfig.erlangls.setup {}
      lspconfig.bashls.setup {}
      lspconfig.jsonls.setup {}
    end,
    dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"},
  },
  {
    "whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({virtual_text = false,})
    end,
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  },
}
