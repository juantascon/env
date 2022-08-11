local disabled_builtin = {"netrw", "netrwSettings", "netrwFileHandlers", "gzip", "zip", "tar", "shada_autoload", "msgpack_autoload"}
for _, plugin in pairs(disabled_builtin) do
  vim.g["loaded_" .. plugin] = 1
end

local dep_path = vim.fn.stdpath("data") .. "/site/pack/deps/opt/dep"
if vim.fn.empty(vim.fn.glob(dep_path)) > 0 then
  vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/chiyadev/dep", dep_path })
end
vim.cmd("packadd dep")


vim.g.mapleader = " "
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
vim.keymap.set("n", "cw", "ciw")
vim.keymap.set("n", "yw", "yiw")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")


require "dep" {
  sync = "always",
  "chiyadev/dep",
  "gpanders/editorconfig.nvim",
  {
    "rlane/pounce.nvim",
    function()
      require"pounce".setup { accept_keys = "12345" }
      vim.keymap.set({"n", "v"}, "s", "<cmd>Pounce<cr>")
    end,
  },
  {
    "marko-cerovac/material.nvim",
    function()
      vim.g.material_style = "darker"
      vim.cmd("colorscheme material")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    function()
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
    deps = {"p00f/nvim-ts-rainbow", "RRethy/nvim-treesitter-textsubjects"},
  },
  {
    "ethanholz/nvim-lastplace",
    function()
      require("nvim-lastplace").setup()
    end,
  },
  {
    "shatur/neovim-session-manager",
    function()
      require("session_manager").setup{
        autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
        autosave_only_in_session = true,
      }
    end,
    requires = {"nvim-lua/plenary.nvim"},
  },
  {
    "numToStr/Comment.nvim",
    function()
      require("Comment").setup()
    end,
  },
  {
    "akinsho/bufferline.nvim",
    function()
      require"bufferline".setup({})
      vim.keymap.set({"n", "t"}, "<C-w>", "<cmd>bdelete<cr>")
      vim.keymap.set({"n", "t"}, "<C-k>", "<cmd>bprevious<cr>")
      vim.keymap.set({"n", "t"}, "<C-j>", "<cmd>bnext<cr>")
      vim.keymap.set({"n", "t"}, "<C-S-k>", "<cmd>BufferLineMovePrev<cr>")
      vim.keymap.set({"n", "t"}, "<C-S-j>", "<cmd>BufferLineMoveNext<cr>")
      for i = 1, 5 do
        vim.keymap.set({"n", "t"}, "<C-" .. i .. ">", "<cmd>BufferLineGoToBuffer " .. i .. "<cr>")
      end
    end,
    requires = "kyazdani42/nvim-web-devicons",
  },
  {
    "ojroques/nvim-hardline",
    function()
      require("hardline").setup()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    function()
      require("gitsigns").setup {
        signs = {
          add = { hl = "GitGutterAdd", text = "+" },
          change = { hl = "GitGutterChange", text = "~" },
          delete = { hl = "GitGutterDelete", text = "_" },
          topdelete = { hl = "GitGutterDelete", text = "‾" },
          changedelete = { hl = "GitGutterChange", text = "~" },
        },
      }
    end,
    requires = {"nvim-lua/plenary.nvim"},
  },
  {
    "declancm/cinnamon.nvim",
    function()
      require"cinnamon".setup()
    end,
  },
  {
    "folke/which-key.nvim",
    function()
      local whichkey = require("which-key")
      whichkey.setup()
      whichkey.register({
        ["<leader>p"] = { function() require("fzf-lua").files() end, "find_files" },
        ["<leader>F"] = { function() require("fzf-lua").live_grep_resume() end, "live_grep" },
        ["<leader>r"] = { "<cmd>SessionManager load_session<cr>", "sessions" },
        ["<leader>f"] = { ":%s///gc<Left><Left><Left><Left>", "find&replace" },
        ["<leader>l"] = { "<cmd>nohlsearch<cr>", "clear" },
        ["<leader>n"] = { "<cmd>cnext<cr>", "quickfix_next" },
        ["<leader>N"] = { "<cmd>cprev<cr>", "quickfix_prev" },
        ["<leader>gg"] = { "<cmd>Gitsigns preview_hunk<cr>", "git_preview" },
        ["<leader>gn"] = { "<cmd>Gitsigns next_hunk<cr>", "git_next" },
        ["<leader>gp"] = { "<cmd>Gitsigns prev_hunk<cr>", "git_prev" },
        ["<leader>xx"] = { "<cmd>TroubleToggle<cr>", "trouble_toggle" },
        ["<leader>xd"] = { "<cmd>Trouble workspace_diagnostics<cr>", "workspace_diagnostics" },
        ["<leader>xq"] = { "<cmd>Trouble quickfix<cr>", "quickfix" },
        ["<leader>xr"] = { "<cmd>Trouble lsp_references<cr>", "lsp_references" },
        ["<leader>xn"] = { function() require("trouble").next({skip_groups = true, jump = true}) end, "trouble_next" },
        ["<leader>xN"] = { function() require("trouble").previous({skip_groups = true, jump = true}) end, "trouble_prev" },

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
    function()
      require"fzf-lua".setup({
        files = {
          fd_opts = "--color=never --type f --no-ignore --hidden --follow --exclude .git"
        }
      })
      require"fzf-lua".register_ui_select()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    function()
      local cmp = require"cmp"
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
    requires = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-buffer", "hrsh7th/cmp-cmdline", "hrsh7th/cmp-nvim-lsp-signature-help"},
  },
  {
    "neovim/nvim-lspconfig",
    function()
      require("mason").setup({})
      require("mason-lspconfig").setup()
      local lspconfig = require("lspconfig")
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
    requires = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"},
  },
  {
    "whynothugo/lsp_lines.nvim",
    function()
      require("lsp_lines").setup()
      vim.diagnostic.config({virtual_text = false,})
    end,
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  },
  {
    "folke/trouble.nvim",
    function()
      require("trouble").setup {}
    end,
    requires = { "kyazdani42/nvim-web-devicons"},
  },
  {
    "j-hui/fidget.nvim",
    function()
      require("fidget").setup {}
    end,
  },
}
