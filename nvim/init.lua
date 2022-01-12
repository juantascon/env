local disabled_builtin = {"netrw", "netrwSettings", "netrwFileHandlers", "gzip", "zip", "tar", "shada_autoload", "msgpack_autoload"}
for _, plugin in pairs(disabled_builtin) do
  vim.g["loaded_" .. plugin] = 1
end

local dep_path = vim.fn.stdpath("data") .. "/site/pack/deps/opt/dep"
if vim.fn.empty(vim.fn.glob(dep_path)) > 0 then
  vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/chiyadev/dep", dep_path })
end
vim.cmd("packadd dep")


vim.g.mapleader = ' '
vim.opt.timeoutlen = 250
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.writebackup = false
vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.showtabline = 0
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.scrolloff = 999
vim.opt.list = true
vim.opt.listchars:append("space:·")
vim.opt.listchars:append("tab:➜ ")

vim.keymap.set({'n', 'v'}, '<Home>', '^')
vim.keymap.set('i', '<Home>', '<Esc>^i')
vim.keymap.set({'n', 'i'}, '<C-s>', '<cmd>w<cr>')
vim.keymap.set({'i', 'c'}, '<S-Insert>', '<MiddleMouse>')
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set('n', 'dw', 'diw')
vim.keymap.set('n', 'cw', 'ciw')
vim.keymap.set('n', 'yw', 'yiw')


require "dep" {
  sync = "always",
  'chiyadev/dep',
  'editorconfig/editorconfig-vim',
  'ggandor/lightspeed.nvim',
  {
    'marko-cerovac/material.nvim',
    function()
      vim.g.material_style = "darker"
      vim.cmd("colorscheme material")
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    function()
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
        },
        ensure_installed = 'all',
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
            ['<cr>'] = 'textsubjects-smart',
          }
        },
      }
    end,
    deps = {'p00f/nvim-ts-rainbow', 'RRethy/nvim-treesitter-textsubjects'},
  },
  {
    'ethanholz/nvim-lastplace',
    function()
      require('nvim-lastplace').setup()
    end,
  },
  {
    'shatur/neovim-session-manager',
    function()
      require('session_manager').setup{
        autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
        autosave_only_in_session = true,
      }
    end,
    deps = {'nvim-telescope/telescope.nvim'},
    requires = {'nvim-lua/plenary.nvim'},
  },
  {
    'b3nj5m1n/kommentary',
    function()
      local kommentary_config = require("kommentary.config")
      kommentary_config.configure_language("default", {prefer_single_line_comments = true})
      kommentary_config.configure_language("elixir", {single_line_comment_string = "#"})
    end,
  },
  {
    'akinsho/bufferline.nvim',
    function()
      require'bufferline'.setup()
      vim.keymap.set('n', '<C-w>', '<cmd>bdelete<cr>')
      vim.keymap.set('n', '<C-k>', '<cmd>BufferLineCyclePrev<cr>')
      vim.keymap.set('n', '<C-j>', '<cmd>BufferLineCycleNext<cr>')
      vim.keymap.set('n', '<C-S-k>', '<cmd>BufferLineMovePrev<cr>')
      vim.keymap.set('n', '<C-S-j>', '<cmd>BufferLineMoveNext<cr>')
      for i = 1, 5 do
        vim.keymap.set('n', '<C-t>' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>')
      end
    end,
    requires = "kyazdani42/nvim-web-devicons",
  },
  {
    'nvim-lualine/lualine.nvim',
    function()
      require('lualine').setup {
        options = {theme = 'material-nvim'},
        sections = {lualine_c = {{'filename', path = 1}}},
      }
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    function()
      require('gitsigns').setup {
        signs = {
          add = { hl = 'GitGutterAdd', text = '+' },
          change = { hl = 'GitGutterChange', text = '~' },
          delete = { hl = 'GitGutterDelete', text = '_' },
          topdelete = { hl = 'GitGutterDelete', text = '‾' },
          changedelete = { hl = 'GitGutterChange', text = '~' },
        },
      }
    end,
    requires = {'nvim-lua/plenary.nvim'},
  },
  {
    'karb94/neoscroll.nvim',
    function()
      require'neoscroll'.setup()
    end,
  },
  {
    'folke/which-key.nvim',
    function()
      local whichkey = require("which-key")
      whichkey.setup()
      whichkey.register({
        ["<leader>p"] = { function() require('telescope.builtin').find_files{hidden = true, previewer = false} end, 'find_files' },
        ["<leader>g"] = { function() require('telescope.builtin').live_grep{hidden = true} end, 'live_grep' },
        ["<leader>f"] = { function() require('telescope.builtin').file_browser{hidden = true, previewer = false} end, 'file_browser' },
        ["<leader>r"] = { '<cmd>:SaveSession <cr><cmd>Telescope sessions<cr>', 'sessions' },
        ["<leader>l"] = { '<cmd>nohlsearch<cr>', 'clear' },
        ["<leader>c"] = { "<Plug>kommentary_line_default", "comment" },
        ["<leader>F"] = { ":%s///gc<Left><Left><Left><Left>", "find&replace" },

        ["<leader>q"] = { "<cmd>qa<cr>", "quit" },
        ["<leader>s"] = { "<cmd>w<cr>", "save" },

        ["<leader>a"] = { function() require('telescope.builtin').lsp_code_actions() end, 'lsp_actions' },
        ["<leader><tab>"] = { function() vim.lsp.buf.formatting() end, "lsp_formatting" },
        ["<leader>d"] = { function() vim.lsp.buf.definition() end, "lsp_definition" },
        ["<leader>D"] = { function() vim.lsp.buf.declaration() end, "lsp_declaration" },
        ["<leader>k"] = { function() vim.lsp.buf.hover() end, "lsp_hover" },
        ["<leader>h"] = { function() vim.lsp.buf.signature_help() end, "lsp_signature" },
        ["<leader>i"] = { function() vim.lsp.buf.implementation() end, "lsp_implementation" },
        -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
      })
      whichkey.register({
        ["<leader>c"] = { "<Plug>kommentary_visual_default", "comment" },
      }, {mode = "v"})

    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    function()
      local telescope = require('telescope')
      telescope.setup {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
          }
        }
      }
      telescope.load_extension('fzf')
      telescope.load_extension('sessions')
    end,
    requires = {'nvim-lua/plenary.nvim'},
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    config = function()
      os.execute("make")
    end,
    deps = {'nvim-telescope/telescope.nvim'},
  },
  {
    'hrsh7th/nvim-cmp',
    function()
      local cmp = require'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            require('snippy').expand_snippet(args.body)
          end,
        },
        mapping = {
          ["<cr>"] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            },
            { "i", "c" }
          ),
        },
        sources = {
          {name = 'nvim_lsp'},
          {name = 'nvim_lua'},
          {name = 'buffer', keyword_length = 4},
        },
      })
    end,
    deps = {'dcampos/nvim-snippy'},
    requires = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-nvim-lua', 'hrsh7th/cmp-buffer', 'dcampos/cmp-snippy'},
  },
  {
    'neovim/nvim-lspconfig',
    function()
      local opts = {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = require('lsp_signature').on_attach,
        settings = {
          elixirLS = {
            dialyzerEnabled = false,
          },
          Lua = {
            runtime = {version = 'LuaJIT'},
            diagnostics = {globals = {'vim'}},
            workspace = {library = vim.api.nvim_get_runtime_file("", true)},
            telemetry = {enable = false},
            completion = {autoRequire = false},
          }
        }
      }
      require('nvim-lsp-installer').on_server_ready(function(server) server:setup(opts) end)
    end,
    requires = {'ray-x/lsp_signature.nvim', 'williamboman/nvim-lsp-installer'},
  },
}
