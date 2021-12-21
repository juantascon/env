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

vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  signs = true,
  severity_sort = true,
})
vim.cmd('autocmd CursorHold * lua vim.diagnostic.open_float()')

local function map(mods, k, a)
  if type(mods) == "string" then
    mods = {mods}
  end
  for _, m in ipairs(mods) do
    vim.api.nvim_set_keymap(m, k, a, { noremap = true, silent = true })
  end
end

map('n', 'H', '^')
map('n', 'L', 'g_')
map('n', '<C-m>', '%')
map({'n', 'i'}, '<C-s>', '<cmd>w<cr>')
map({'i', 'c'}, '<S-Insert>', '<MiddleMouse>')
-- does not lose selection
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "<c-down>", "<cmd>m .+1<CR>==")
map("v", "<c-up>", "<cmd>m .-2<CR>==")
map("v", "p", '"_dP')


require "dep" {
  sync = "always",
  'chiyadev/dep',
  'editorconfig/editorconfig-vim',
  'ggandor/lightspeed.nvim',
  -- {
  --   'RRethy/nvim-base16',
  --   function()
  --     require'base16-colorscheme'.setup('seti')
  --   end,
  -- },
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
      map('n', '<C-w>', '<cmd>bdelete<cr>')
      map('n', '<C-k>', '<cmd>BufferLineCyclePrev<cr>')
      map('n', '<C-j>', '<cmd>BufferLineCycleNext<cr>')
      map('n', '<C-S-k>', '<cmd>BufferLineMovePrev<cr>')
      map('n', '<C-S-j>', '<cmd>BufferLineMoveNext<cr>')
      for i = 1, 5 do
        map('n', '<C-t>' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>')
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
      -- require'gitsigns'.setup {
      --   signs = {
      --     add = {hl = "DiffAdded"},
      --     change = {hl = "SignColumn"},
      --     delete = {hl = "DiffRemoved"}
      --   }
      -- }
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
        ["<leader>l"] = { '<cmd>noh<cr>', 'clear' },
        ["<leader>c"] = { "<Plug>kommentary_line_default", "comment" },
        ["<leader>F"] = { ":%s///gc<Left><Left><Left><Left>", "find&replace" },

        ["<leader>qs"] = { "<cmd>wq<cr>", "quit save" },
        ["<leader>qq"] = { "<cmd>q<cr>", "quit" },
        ["<leader>qf"] = { "<cmd>q!<cr>", "quit force" },
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
  -- 'nvim-lua/popup.nvim',
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
            -- case_mode = "smart_case"
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
          -- ["<down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          -- ["<up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          -- ["<cr>"] = cmp.mapping.confirm({ insert = true, replace = true, select = false }),
          -- ["<esc>"] = cmp.mapping.close(),
          -- ["<c-e>"] = cmp.mapping.close(),

          -- ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<esc>"] = cmp.mapping.close(),
          ["<cr>"] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            },
            { "i", "c" }
          ),
          -- ["<cr>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.insert, select = true }),
        },
        sources = {
          {name = 'nvim_lsp'},
          {name = 'nvim_lua'},
          {name = 'buffer', keyword_length = 4},
        },
        experimental = {
          native_menu = false,
        },
        -- preselect = cmp.PreselectMode.None,
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
