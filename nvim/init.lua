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
local usercmd = vim.api.nvim_create_user_command
autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {callback = function() vim.opt.relativenumber = true end})
autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {callback = function() vim.opt.relativenumber = false end})
usercmd("Format", function() vim.lsp.buf.format({filter = function(client) return client.name ~= "elixirls" end }) end, {})
autocmd("BufWritePost", {pattern = {"*.ex", "*.exs"}, callback = vim.cmd.Format})

vim.keymap.set({"i", "c"}, "<S-Insert>", "<MiddleMouse>")
vim.keymap.set({"n", "x"}, "<Home>", "^")
vim.keymap.set("i", "<Home>", "<Esc>^i")
vim.keymap.set("x", "c", [["y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"]], {expr = true, silent = true})
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")
vim.keymap.set({"n", "x"}, "r", [["_d]])
vim.keymap.set("n", "rr", [["_dd]])
vim.keymap.set("x", "p", [["_dP]])
vim.keymap.set("o", "w", "iw")
vim.keymap.set("n", "yf", [[:let @+ = expand("%")<cr>]], {desc = "yank_filename"})
vim.keymap.set("n", "gf", "gF", {desc = "goto_filename"})
vim.keymap.set("n", "<Esc>", "<cmd>silent nohlsearch<cr><cmd>silent cclose<cr><cmd>silent only<cr>")
vim.keymap.set("", "<Space>", "<Nop>")
vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>")
vim.keymap.set("n", "<Leader><Leader>h", "<cmd>terminal gitui<cr>", {silent = true, desc = "gitui"})
vim.keymap.set("n", "yh", [[<cmd>let @+=system("git browser-url " . expand("%") . " " . line("."))<cr>]], {silent = true, desc = "yank_giturl"})

require("lazy").setup ({
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("kanagawa")
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
      require("mini.statusline").setup({})

      require("mini.files").setup({
        options = {
          use_as_default_explorer = true,
        },
        mappings = {
          close = "<Esc>",
          go_in_plus = "<Right>",
          go_out_plus = "<Left>",
        },
      })
      vim.keymap.set("n", "<Leader>f", MiniFiles.open, {desc = "minifiles_open_cwd"})
      vim.keymap.set("n", "<leader>F", function() MiniFiles.open(vim.api.nvim_buf_get_name(0), true) end, {desc = "minifiles_open_bufdir"})

      require("mini.completion").setup({
          delay = { completion = 0, info = 0, signature = 0 },
      })

      require("mini.sessions").setup({autoread = false, autowrite = true, force = {read = true}})
      local session = function() return ({vim.fn.getcwd():gsub("/", "__")})[1] end
      usercmd("SessionWrite", function() MiniSessions.write(session()) end, {})
      usercmd("SessionRead", function() MiniSessions.read(session()) end, {})
      if vim.fn.argc() == 0 then vim.cmd.SessionRead() end

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
    "neovim/nvim-lspconfig",
    priority = 1000,
    config = function()
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

      local library = {vim.fn.expand("$VIMRUNTIME/lua")}
      for _, plugin in ipairs(require("lazy").plugins()) do
        table.insert(library, plugin.dir .. "/lua")
      end
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {globals = {"vim"}, disable = {"missing-fields"}},
            runtime = {path = { "?.lua", "?/init.lua" }, pathStrict = true, version = "LuaJIT"},
            workspace = {library = library, checkThirdParty = false},
            telemetry = {enable = false},
          }
        }
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {desc = "hover"})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {desc = "lsp_definition"})
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {desc = "lsp_declaration"})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {desc = "lsp_implementation"})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {desc = "lsp_references"})
      vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, {desc = "lsp_signature_help"})
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, {desc = "diagnostic_open_float"})
    end,
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup({
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "thick",
        },
      })
      vim.keymap.set("n", "<C-t>", vim.cmd.enew)
      vim.keymap.set("n", "<C-w>", vim.cmd.bdelete)
      vim.keymap.set("n", "<C-j>", function() bufferline.cycle(1) end)
      vim.keymap.set("n", "<C-k>", function() bufferline.cycle(-1) end)
      vim.keymap.set("n", "<C-S-j>", function() bufferline.move(1) end)
      vim.keymap.set("n", "<C-S-k>", function() bufferline.move(-1) end)
      for i=1, 5 do
        vim.keymap.set("n", "<C-"..i..">", function() bufferline.go_to(i) end)
      end
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({})
      vim.keymap.set("n", "hh", gitsigns.toggle_deleted, {desc = "gitsigns_togle_deleted"})
      vim.keymap.set("n", "hs", gitsigns.stage_hunk, {desc = "gitsigns_stage_hunk"})
      vim.keymap.set("x", "hs", function() gitsigns.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, {desc = "gitsigns_stage_hunk"})
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
    "ibhagwan/fzf-lua",
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
