local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h17"
vim.opt.showtabline = 0
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes:2"
vim.opt.laststatus = 3
vim.opt.cmdheight = 1
vim.opt.updatetime = 250
vim.opt.timeoutlen = 250
vim.opt.mat = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 1
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.list = true
vim.opt.listchars:append("space:·")
vim.opt.listchars:append("tab:➜ ")
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt = "context:0,closeoff,foldcolumn:0,internal"

local autocmd = vim.api.nvim_create_autocmd
autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {callback = function() vim.opt.relativenumber = true end})
autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {callback = function() vim.opt.relativenumber = false end})
local format = function() vim.lsp.buf.format({filter = function(client) return client.name ~= "elixirls" end }) end
autocmd("BufWritePost", {pattern = {"*.ex", "*.exs"}, callback = format})
vim.keymap.set({"i", "c"}, "<S-Insert>", "<MiddleMouse>")
vim.keymap.set({"n", "v"}, "<Home>", "^")
vim.keymap.set("i", "<Home>", "<Esc>^i")
vim.keymap.set("x", "c", [["y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"]], {expr = true, silent = true})
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set({"n", "x"}, "r", [["_d]])
vim.keymap.set("n", "rr", [["_dd]])
vim.keymap.set("v", "p", [["_dP]])
vim.keymap.set("n", "vw", "viw")
vim.keymap.set("n", "rw", [["_diw]])
vim.keymap.set("n", "dw", "diw")
vim.keymap.set("n", "yw", "yiw")
vim.keymap.set("n", "yf", [[:let @+ = expand("%")<cr>]], {desc = "yank_filename"})
vim.keymap.set("n", "gf", "gF", {desc = "goto_filename"})
vim.keymap.set({"n", "x"}, "gw", "*N")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr><cmd>cclose<cr><cmd>only<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>qa<cr>")
vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>")
vim.keymap.set("", "<Space>", "<Nop>", {noremap = true, silent = true})
vim.keymap.set("n", "<Leader><Leader>h", "<cmd>terminal gitui<cr>", {silent = true, desc = "gitui"})

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
      require("nvim-treesitter.configs").setup {
        highlight = {enable = true},
        indent = {enable = true},
        auto_install = true,
      }
    end,
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.basics").setup({extra_ui = true})
      require("mini.misc").setup({})
      MiniMisc.setup_restore_cursor()
      require("mini.bracketed").setup({})
      require("mini.indentscope").setup({})
      require("mini.comment").setup({})
      require("mini.completion").setup({
          delay = { completion = 0, info = 0, signature = 0 },
      })
      require("mini.statusline").setup()
      require("mini.sessions").setup({autoread = false, autowrite = true, force = {read = true}})
      local session = function() return ({vim.fn.getcwd():gsub("/", "__")})[1] end
      vim.api.nvim_create_user_command("SessionWrite", function() MiniSessions.write(session()) end, {})
      vim.api.nvim_create_user_command("SessionRead", function() MiniSessions.read(session()) end, {})
      if vim.fn.argc() == 0 then return vim.cmd.SessionRead() end

      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          { mode = 'i', keys = '<C-x>' },
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
          { mode = "n", keys = "h" },
          { mode = "x", keys = "h" },
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
        },
        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    keys = {
      {"<C-t>", "<cmd>enew<cr>"},
      {"<C-w>", "<cmd>bdelete<cr>"},
      {"<C-k>", "<cmd>BufferLineCyclePrev<cr>"},
      {"<C-j>", "<cmd>BufferLineCycleNext<cr>"},
      {"<C-S-k>", "<cmd>BufferLineMovePrev<cr>"},
      {"<C-S-j>", "<cmd>BufferLineMoveNext<cr>"},
      {"<C-1>", "<cmd>BufferLineGoToBuffer 1<cr>"},
      {"<C-2>", "<cmd>BufferLineGoToBuffer 2<cr>"},
      {"<C-3>", "<cmd>BufferLineGoToBuffer 3<cr>"},
      {"<C-4>", "<cmd>BufferLineGoToBuffer 4<cr>"},
      {"<C-5>", "<cmd>BufferLineGoToBuffer 5<cr>"},

      {"<leader>t", "<cmd>enew<cr>"},
      {"<leader>w", "<cmd>bdelete<cr>"},
      {"<leader>k", "<cmd>BufferLineCyclePrev<cr>"},
      {"<leader>j", "<cmd>BufferLineCycleNext<cr>"},
      {"<leader>S-k", "<cmd>BufferLineMovePrev<cr>"},
      {"<leader>S-j", "<cmd>BufferLineMoveNext<cr>"},
      {"<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>"},
      {"<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>"},
      {"<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>"},
      {"<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>"},
      {"<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>"},
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        separator_style = "slant",
      }
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({})
      vim.keymap.set("n", "hh", gitsigns.toggle_deleted, {desc = "gitsigns_togle_deleted"})
      vim.keymap.set("n", "hs", gitsigns.stage_hunk, {desc = "gitsigns_stage_hunk"})
      vim.keymap.set("v", "hs", function() gitsigns.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, {desc = "gitsigns_stage_hunk"})
      vim.keymap.set("n", "hS", gitsigns.stage_buffer, {desc = "gitsigns_stage_buffer"})
      vim.keymap.set("n", "hR", gitsigns.reset_buffer_index, {desc = "gitsigns_reset_buffer_index"})
      vim.keymap.set("n", "hu", gitsigns.undo_stage_hunk, {desc = "gitsigns_undo_stage_hunk"})
      vim.keymap.set("n", "hb", function() gitsigns.blame_line{full=true} end, {desc = "gitsigns_blame_line"})
      vim.keymap.set("n", "hB", gitsigns.toggle_current_line_blame, {desc = "gitsigns_togle_blame_line"})
      vim.keymap.set("n", "hd", gitsigns.diffthis, {desc = "gitsigns_diffthis"})
      vim.keymap.set("n", "hD", function() gitsigns.diffthis("~") end, {desc = "gitsigns_diffthis~"})
      vim.keymap.set("n", "hn", gitsigns.preview_hunk, {desc = "gitsigns_preview_hunk"})
    end,
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
    "neovim/nvim-lspconfig",
    priority = 1000,
    lazy = false,
    dependencies = {
      {"williamboman/mason.nvim"},
      {"folke/neodev.nvim"},
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
      require("mason").setup({})
      require("neodev").setup({
        override = function(root_dir, library)
          library.enabled = true
          library.plugins = true
        end,
      })

      local mix_credo = {
        lintCommand = "mix credo suggest --format=flycheck --read-from-stdin ${INPUT}",
        lintStdin = true,
        lintFormats = { "%f:%l:%c: %t: %m", "%f:%l: %t: %m" },
        lintCategoryMap = { R = "N", D = "I", F = "E", W = "W" },
      }
      local mix_format = {formatCommand = "mix format -", formatStdin = true}
      local languages = {
        elixir = { mix_format, mix_credo }
      }

      local efmls_config = {
        filetypes = vim.tbl_keys(languages),
        settings = {
          rootMarkers = { ".git/" },
          languages = languages,
        },
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
        },
      }

      local lspconfig = require("lspconfig")
      lspconfig.efm.setup(efmls_config)
      lspconfig.lua_ls.setup({})
      lspconfig.elixirls.setup({cmd = { "elixir-ls" }})
      lspconfig.erlangls.setup({})
      lspconfig.jsonls.setup({})
    end,
  },
  {
    "ibhagwan/fzf-lua",
    lazy = false,
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        keymap = {
          fzf = {
            ["ctrl-a"] = "select-all+accept",
          },
        },
        git = {
          status = {
            actions = {
              ["right"] = "",
              ["left"] = "",
              ["ctrl-x"] = "",
            },
          },
        },
        files = {
          fd_opts = "--color=never --type f --no-ignore --hidden --follow --exclude .git --exclude deps --exclude _build --exclude .elixir_ls --exclude node_modules"
        },
        grep = {
          rg_opts = "--sort=path --column --line-number --no-heading --color=always --smart-case --max-columns=512",
        },
      })

      fzf.register_ui_select()

      vim.keymap.set("n", "<Leader>p", fzf.files, {desc = "fzf_find_files"})
      vim.keymap.set("n", "<Leader>g", fzf.live_grep_resume, {desc = "fzf_live_grep"})
      vim.keymap.set("n", "<Leader>b", fzf.blines, {desc = "fzf_buffer_lines"})
      vim.keymap.set("n", "<Leader>h", fzf.git_status, {desc = "fzf_git_status"})
      vim.keymap.set("n", "<Leader>l", fzf.quickfix, {desc = "fzf_quickfix"})
      vim.keymap.set("n", "<Leader>d", fzf.lsp_workspace_diagnostics, {desc = "fzf_diagnostics"})
    end,
  },
},
{
  -- checker = {enabled = true},
  performance = {
    rtp = {
      disabled_plugins = {"netrw", "netrwSettings", "netrwFileHandlers", "gzip", "zip", "tar", "shada_autoload", "tutor", "tohtml", "msgpack_autoload"}
    },
  },
})
