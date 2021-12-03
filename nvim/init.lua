local disabled_builtin = {"netrw", "netrwSettings", "netrwFileHandlers", "gzip", "zip", "tar", "shada_autoload", "msgpack_autoload"}
for _, plugin in pairs(disabled_builtin) do
  vim.g["loaded_" .. plugin] = 1
end


local install_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require "paq" {
  'savq/paq-nvim';
  'editorconfig/editorconfig-vim';
  'neovim/nvim-lspconfig';
  'folke/which-key.nvim';
  'nvim-lua/plenary.nvim';
  'kyazdani42/nvim-web-devicons';
  'nvim-lua/popup.nvim';
  -- 'RRethy/nvim-base16';
  'marko-cerovac/material.nvim';
  'nvim-treesitter/nvim-treesitter';
  'p00f/nvim-ts-rainbow';
  'nvim-telescope/telescope.nvim';
  'ethanholz/nvim-lastplace';
  'rmagatti/auto-session';
  'rmagatti/session-lens';
  'b3nj5m1n/kommentary';
  'akinsho/nvim-bufferline.lua';
  'nvim-lualine/lualine.nvim';
  'lewis6991/gitsigns.nvim';
  'karb94/neoscroll.nvim';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-nvim-lua';
  'hrsh7th/cmp-buffer';
  'hrsh7th/nvim-cmp';
  'ray-x/lsp_signature.nvim';
  'williamboman/nvim-lsp-installer';
}
vim.schedule(function() vim.cmd('PaqInstall') end)
vim.schedule(function() vim.cmd('PaqUpdate') end)
vim.schedule(function() vim.cmd('PaqClean') end)


vim.g.mapleader = ' '
vim.opt.timeoutlen = 250
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.writebackup = false
vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.showtabline = 0
vim.opt.clipboard = "unnamedplus"
vim.opt.inccommand = "nosplit"
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.cmd("set list listchars=space:·,tab:\\➜\\ ")


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
map('n', '<C-s>', ':w<cr>')
map('i', '<C-s>', '<esc>:w<cr>')
map('n', '<C-o>', ':SymbolsOutline<cr>')
map({'i', 'c'}, '<S-Insert>', '<MiddleMouse>')


-- require'base16-colorscheme'.setup('seti')
vim.g.material_style = "darker"
vim.cmd("colorscheme material")


local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
telescope.setup()

require('nvim-lastplace').setup()

require'auto-session'.setup()

local kommentary_config = require("kommentary.config")
kommentary_config.configure_language("default", {prefer_single_line_comments = true})
kommentary_config.configure_language("elixir", {single_line_comment_string = "#"})

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
  }
}

require'bufferline'.setup()
map('n', '<C-w>', ':bd<cr>')
map('n', '<C-k>', ':BufferLineCyclePrev<cr>')
map('n', '<C-j>', ':BufferLineCycleNext<cr>')
map('n', '<C-down>', ':BufferLineMovePrev<cr>')
map('n', '<C-up>', ':BufferLineMoveNext<cr>')
for i = 1, 5 do
  map('n', '<C-t>' .. i, ':BufferLineGoToBuffer ' .. i .. '<cr>')
end

require('lualine').setup {
  options = {theme = 'material-nvim'}
}

require'gitsigns'.setup {
  signs = {
    add = {hl = "DiffAdded"},
    change = {hl = "SignColumn"},
    delete = {hl = "DiffRemoved"}
  }
}

require'neoscroll'.setup()

local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args) return args.body; end,
  },
  mapping = {
    ["<down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<cr>"] = cmp.mapping.confirm({ insert = true }),
    ["<esc>"] = cmp.mapping.close(),
  },
  sources = {
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'buffer', keyword_length = 4},
  },
  -- completion = {
  --   keyword_length = 2,
  --   completeopt = "menu,noselect"
  -- },
  -- preselect = cmp.PreselectMode.None,
})


local lsp_opts = {
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = require'lsp_signature'.on_attach,
  settings = {
    elixirLS = {
      dialyzerEnabled = false,
      fetchDeps = false
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
require'nvim-lsp-installer'.on_server_ready(function(server) server:setup(lsp_opts) end)

local whichkey = require("which-key")
whichkey.setup()
whichkey.register({
  ["<leader>p"] = { function() telescope_builtin.find_files{hidden = true, previewer = false} end, 'find_files' },
  ["<leader>g"] = { function() telescope_builtin.live_grep{hidden = true} end, 'live_grep' },
  ["<leader>f"] = { function() telescope_builtin.file_browser{hidden = true, previewer = false} end, 'file_browser' },
  ["<leader>r"] = { ':SearchSession<cr>', 'sessions' },
  ["<leader>l"] = { ':noh<cr>', 'clear' },
  ["<leader>c"] = { "<Plug>kommentary_line_default", "comment" },
  ["<leader>F"] = { ":%s///gc<Left><Left><Left><Left>", "find&replace" },

  ["<leader>qs"] = { ":wq<cr>", "quit save" },
  ["<leader>qq"] = { ":q<cr>", "quit" },
  ["<leader>qf"] = { ":q!<cr>", "quit force" },
  ["<leader>s"] = { ":w<cr>", "save" },

  ["<leader>a"] = { function() telescope_builtin.lsp_code_actions() end, 'lsp_actions' },
  ["<leader><tab>"] = { function() vim.lsp.buf.formatting() end, "lsp_formatting" },
  ["<leader>d"] = { function() vim.lsp.buf.definition() end, "lsp_definition" },
  ["<leader>D"] = { function() vim.lsp.buf.declaration() end, "lsp_declaration" },
  ["<leader>k"] = { function() vim.lsp.buf.hover() end, "lsp_hover" },
  ["<leader>h"] = { function() vim.lsp.buf.signature_help() end, "lsp_signature" },

  ["<leader>i"] = { function() vim.lsp.buf.implementation() end, "lsp_implementation" },
})
whichkey.register({
  ["<leader>c"] = { "<Plug>kommentary_visual_default", "comment" }
}, {mode = "v"})
