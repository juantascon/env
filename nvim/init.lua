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
-- vim.opt.listchars = { space = '·', tab = '➜ ' }
vim.cmd("set list listchars=space:·,tab:\\➜\\ ")

disabled_builtin = {
  "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
  "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
  "getscript", "getscriptPlugin", "vimball", "vimballPlugin", "2html_plugin",
  "logipat", "matchit", "matchparen", "rrhelper"
}
for _, plugin in pairs(disabled_builtin) do
  vim.g["loaded_" .. plugin] = 1
end


vim.cmd('inoremap <expr> <Tab> pumvisible() ? "\\<C-n>" : "\\<Tab>"')
vim.cmd('inoremap <expr> <S-Tab> pumvisible() ? "\\<C-p>" : "\\<S-Tab>"')

local function map(m, k, a)
  vim.api.nvim_set_keymap(m, k, a, { noremap = true, silent = true })
end

map('n', 'H', '^')
map('n', 'L', 'g_')
map('n', '<C-m>', '%')
map('n', '<C-s>', ':w<CR>')
map('i', '<C-s>', '<esc>:w<CR>')


vim.cmd 'packadd paq-nvim'
local paq_nvim = require('paq-nvim')
local paq = paq_nvim.paq
paq {'savq/paq-nvim', opt=true}


paq 'RRethy/nvim-base16'
require'base16-colorscheme'.setup('seti')


paq 'nvim-lua/popup.nvim'
paq 'nvim-telescope/telescope-media-files.nvim'
paq 'nvim-telescope/telescope.nvim'
local telescope = require("telescope")
telescope.setup()


paq 'b3nj5m1n/kommentary'
local kommentary_config = require("kommentary.config")
kommentary_config.configure_language("default", {
  prefer_single_line_comments = true,
})
kommentary_config.configure_language("elixir", {
  single_line_comment_string = "#"
})


paq 'editorconfig/editorconfig-vim'


paq 'nvim-treesitter/nvim-treesitter'
paq 'p00f/nvim-ts-rainbow'
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


paq 'kyazdani42/nvim-web-devicons'
paq 'akinsho/nvim-bufferline.lua'
require'bufferline'.setup()
map('n', '<C-w>', ':bd<CR>')
map('n', '<C-k>', ':BufferLineCyclePrev<CR>')
map('n', '<C-j>', ':BufferLineCycleNext<CR>')
map('n', '<C-down>', ':BufferLineMovePrev<CR>')
map('n', '<C-up>', ':BufferLineMoveNext<CR>')
for i = 1, 5 do
  map('n', '<C-t>' .. i, ':lua require("bufferline").go_to_buffer(' .. i .. ')<CR>')
end


paq 'mbbill/undotree'


paq 'kyazdani42/nvim-web-devicons'
paq 'famiu/feline.nvim'
require'feline'.setup()


paq 'simrat39/symbols-outline.nvim'
map('n', '<C-o>', ':SymbolsOutline<CR>')


paq 'rmagatti/auto-session'
require'auto-session'.setup()
paq 'vim-lua/plenary.nvim'
paq 'rmagatti/session-lens'
telescope.load_extension("session-lens")
require"telescope._extensions.session-lens".setup { shorten_path = false }


paq 'vim-lua/plenary.nvim'
paq 'lewis6991/gitsigns.nvim'
require'gitsigns'.setup {
  signs = {
    add = {hl = "DiffAdded"},
    change = {hl = "SignColumn"},
    delete = {hl = "DiffRemoved"}
  }
}


paq 'karb94/neoscroll.nvim'
require'neoscroll'.setup()


paq {'ms-jpq/coq_nvim', branch = 'coq'}
vim.schedule(function() vim.cmd('COQnow -s') end)

-- paq 'hrsh7th/nvim-compe'
-- require('compe').setup {
--   enabled = true,
--   autocomplete = true,
--   debug = false,
--   min_length = 1,
--   preselect = 'disable',
--   throttle_time = 80,
--   source_timeout = 200,
--   incomplete_delay = 400,
--   max_abbr_width = 100,
--   max_kind_width = 100,
--   max_menu_width = 100,
--   documentation = true,
--   source = {
--     path = true,
--     buffer = true,
--     calc = true,
--     nvim_lsp = true,
--     nvim_lua = true,
--     spell = true,
--     treesitter = true
--   }
-- }


paq 'ethanholz/nvim-lastplace'
require('nvim-lastplace').setup()


paq 'kosayoda/nvim-lightbulb'
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]
paq 'ray-x/lsp_signature.nvim'
local on_attach = function(_, _)
  require('lsp_signature').on_attach()
end


paq 'kyazdani42/nvim-web-devicons'
paq 'folke/trouble.nvim'
require("trouble").setup()


paq 'kabouzeid/nvim-lspinstall'
paq 'neovim/nvim-lspconfig'
local lspconfig = require('lspconfig')
lspconfig.gopls.setup{on_attach = on_attach}
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


paq 'folke/which-key.nvim'
require("which-key").setup()
require("which-key").register({
  ["<leader><leader>"] = { function() require("telescope.builtin").buffers({show_all_buffers = true}) end, 'buffers' },
  ["<leader>p"] = { function() require("telescope.builtin").find_files{hidden = true, previewer = false} end, 'find_files' },
  ["<leader>g"] = { function() require("telescope.builtin").live_grep{hidden = true} end, 'live_grep' },
  ["<leader>f"] = { function() require("telescope.builtin").file_browser{hidden = true, previewer = false} end, 'file_browser' },
  ["<leader>r"] = { ':SearchSession<CR>', 'sessions' },
  ["<leader>l"] = { ':noh<CR>', 'clear_highlight' },
  ["<leader>c"] = { "<Plug>kommentary_line_default", "toggle_comments" },
  ["<leader>t"] = { ":TroubleToggle<CR>", "toggle_trouble" },
  ["<leader>u"] = { ":UndotreeToggle<CR>"},

  ["<leader>qs"] = { ":wq<CR>", "quit save" },
  ["<leader>qq"] = { ":q<CR>", "quit" },
  ["<leader>qf"] = { ":q!<CR>", "quit force" },

  ["<leader>a"] = { function() require("telescope.builtin").lsp_code_actions() end, 'lsp_actions' },
  ["<leader><tab>"] = { function() vim.lsp.buf.formatting() end, "lsp_formatting" },
  ["<leader>d"] = { function() vim.lsp.buf.definition() end, "lsp_definition" },
  ["<leader>k"] = { function() vim.lsp.buf.hover() end, "lsp_hover" },
  ["<leader>s"] = { function() vim.lsp.buf.signature_help() end, "lsp_signature" },

})
require("which-key").register({
  ["<leader>c"] = { "<Plug>kommentary_visual_default", "toggle_comments" }
}, {mode = "v"})


paq_nvim.install()
paq_nvim.update()
paq_nvim.clean()

