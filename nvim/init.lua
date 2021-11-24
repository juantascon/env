disabled_builtin = {
  "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
  "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
  "getscript", "getscriptPlugin", "vimball", "vimballPlugin", "2html_plugin",
  "logipat", "matchit", "matchparen", "rrhelper"
}
for _, plugin in pairs(disabled_builtin) do
  vim.g["loaded_" .. plugin] = 1
end


local install_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require "paq" {
  'savq/paq-nvim';
  'nvim-lua/plenary.nvim';
  'kyazdani42/nvim-web-devicons';
  'nvim-lua/popup.nvim';
  'RRethy/nvim-base16';
  'nvim-treesitter/nvim-treesitter';
  'nvim-telescope/telescope-media-files.nvim';
  'nvim-telescope/telescope.nvim';
  'rmagatti/auto-session';
  'rmagatti/session-lens';
  'b3nj5m1n/kommentary';
  'editorconfig/editorconfig-vim';
  'p00f/nvim-ts-rainbow';
  'akinsho/nvim-bufferline.lua';
  'mbbill/undotree';
  'famiu/feline.nvim';
  'simrat39/symbols-outline.nvim';
  'lewis6991/gitsigns.nvim';
  'karb94/neoscroll.nvim';
  -- {'ms-jpq/coq_nvim', branch = 'coq'};
  'hrsh7th/nvim-compe';
  'ethanholz/nvim-lastplace';
  'kosayoda/nvim-lightbulb';
  'ray-x/lsp_signature.nvim';
  'folke/trouble.nvim';
  'kabouzeid/nvim-lspinstall';
  'neovim/nvim-lspconfig';
  'folke/which-key.nvim';
}
vim.schedule(function() vim.cmd('PaqInstall') end)
vim.schedule(function() vim.cmd('PaqUpdate') end)
vim.schedule(function() vim.cmd('PaqClean') end)


vim.g.mapleader = ' '
vim.opt.timeoutlen = 250
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.writebackup = false
vim.opt.completeopt = {"menuone", "noselect", "noinsert"}
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

vim.cmd('inoremap <expr> <Tab> pumvisible() ? "\\<C-n>" : "\\<Tab>"')
vim.cmd('inoremap <expr> <S-Tab> pumvisible() ? "\\<C-p>" : "\\<S-Tab>"')
map('n', 'H', '^')
map('n', 'L', 'g_')
map('n', '<C-m>', '%')
map('n', '<C-s>', ':w<CR>')
map('i', '<C-s>', '<esc>:w<CR>')
map('n', '<C-o>', ':SymbolsOutline<CR>')
map({'i','n'}, '<S-Insert>', '<MiddleMouse>')


require'base16-colorscheme'.setup('seti')

local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
telescope.setup()

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
map('n', '<C-w>', ':bd<CR>')
map('n', '<C-k>', ':BufferLineCyclePrev<CR>')
map('n', '<C-j>', ':BufferLineCycleNext<CR>')
map('n', '<C-down>', ':BufferLineMovePrev<CR>')
map('n', '<C-up>', ':BufferLineMoveNext<CR>')
for i = 1, 5 do
  map('n', '<C-t>' .. i, ':BufferLineGoToBuffer ' .. i .. '<CR>')
end

require'feline'.setup()

require'gitsigns'.setup {
  signs = {
    add = {hl = "DiffAdded"},
    change = {hl = "SignColumn"},
    delete = {hl = "DiffRemoved"}
  }
}

require'neoscroll'.setup()

require('compe').setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'disable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    spell = true,
    treesitter = true
  }
}

require('nvim-lastplace').setup()

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]

require("trouble").setup()

local on_attach = function(_, _)
  require('lsp_signature').on_attach()
end
local lspconfig = require('lspconfig')
lspconfig.gopls.setup{on_attach = on_attach}
lspconfig.clangd.setup{
  cmd = {require("lspinstall.util").install_path('cpp') .. '/clangd/bin/clangd', '--background-index'},
  on_attach = on_attach,
}
lspconfig.elixirls.setup({
  cmd = {require("lspinstall.util").install_path('elixir') .. '/elixir-ls/language_server.sh'},
  on_attach = on_attach,
  settings = {
    elixirLS = {
      dialyzerEnabled = false,
      fetchDeps = false
    }
  }
})

local whichkey = require("which-key")
whichkey.setup()
whichkey.register({
  ["<leader>p"] = { function() telescope_builtin.find_files{hidden = true, previewer = false} end, 'find_files' },
  ["<leader>g"] = { function() telescope_builtin.live_grep{hidden = true} end, 'live_grep' },
  ["<leader>f"] = { function() telescope_builtin.file_browser{hidden = true, previewer = false} end, 'file_browser' },
  ["<leader>r"] = { ':SearchSession<CR>', 'sessions' },
  ["<leader>l"] = { ':noh<CR>', 'clear' },
  ["<leader>c"] = { "<Plug>kommentary_line_default", "comment" },
  ["<leader>u"] = { ":UndotreeToggle<CR>", "undotree" },
  ["<leader>F"] = { ":%s///gc<Left><Left><Left><Left>", "find&replace" },
  -- ["<leader>F"] = { ":%s/<C-r><C-w>//gc<Left><Left><Left>", "find&replace" },
-- "sy:%s/<C-r>s//gc<Left>

  ["<leader>qs"] = { ":wq<CR>", "quit save" },
  ["<leader>qq"] = { ":q<CR>", "quit" },
  ["<leader>qf"] = { ":q!<CR>", "quit force" },
  ["<leader>s"] = { ":w<CR>", "save" },

  ["<leader>t"] = { ":TroubleToggle<CR>", "toggle_trouble" },
  ["<leader>a"] = { function() telescope_builtin.lsp_code_actions() end, 'lsp_actions' },
  ["<leader><tab>"] = { function() vim.lsp.buf.formatting() end, "lsp_formatting" },
  ["<leader>d"] = { function() vim.lsp.buf.definition() end, "lsp_definition" },
  ["<leader>k"] = { function() vim.lsp.buf.hover() end, "lsp_hover" },
  ["<leader>h"] = { function() vim.lsp.buf.signature_help() end, "lsp_signature" },

})
whichkey.register({
  ["<leader>c"] = { "<Plug>kommentary_visual_default", "comment" }
}, {mode = "v"})
