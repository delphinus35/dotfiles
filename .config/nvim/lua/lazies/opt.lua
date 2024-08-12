---@diagnostic disable: missing-fields
local fn, uv, api = require("core.utils").globals()
local utils = require "core.utils"
local lazy_require = require "lazy_require"
local palette = require "core.utils.palette"

local function dwm(method)
  return function()
    require("dwm")[method]()
  end
end

---@type LazySpec[]
return {
  { "lifepillar/vim-solarized8" },

  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "ToggleTermAll", "TermExec" },
    keys = {
      { "<A-c>", "<Cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "ToggleTerm" },
    },
    init = function()
      palette "toggleterm" {
        nord = function(colors)
          api.set_hl(0, "WinBorderTop", { fg = colors.border })
          api.set_hl(0, "WinBorderLeft", { fg = colors.border })
          api.set_hl(0, "WinBorderRight", { fg = colors.border })
          api.set_hl(0, "WinBorderBottom", { fg = colors.border })
        end,
        sweetie = function(colors)
          api.set_hl(0, "WinBorderTop", { fg = colors.blue })
          api.set_hl(0, "WinBorderLeft", { fg = colors.blue })
          api.set_hl(0, "WinBorderRight", { fg = colors.blue })
          api.set_hl(0, "WinBorderBottom", { fg = colors.blue })
        end,
      }
      vim.api.nvim_create_user_command("Serpl", function(info)
        local path = #info.fargs > 0 and table.concat(info.fargs) or vim.uv.cwd()
        vim.cmd.TermExec { args = { "direction=float", "dir=" .. vim.fn.escape(path, [[ \]]), 'cmd="serpl"' } }
      end, { nargs = "*", desc = "Run serpl" })
    end,
    opts = {
      open_mapping = false,
      direction = "float",
      autochdir = true,
      float_opts = {
        border = {
          --{ "⡤", "WinBorderTop" },
          { "⡠", "WinBorderTop" },
          { "⠤", "WinBorderTop" },
          --{ "⢤", "WinBorderTop" },
          { "⢄", "WinBorderTop" },
          { "⢸", "WinBorderRight" },
          --{ "⠚", "WinBorderBottom" },
          { "⠊", "WinBorderBottom" },
          { "⠒", "WinBorderBottom" },
          --{ "⠓", "WinBorderBottom" },
          { "⠑", "WinBorderBottom" },
          { "⡇", "WinBorderLeft" },
        },
      },
      winbar = { enabled = true },
    },
  },

  { "cocopon/colorswatch.vim", cmd = { "ColorSwatchGenerate" } },
  { "cocopon/inspecthi.vim", cmd = { "Inspecthi", "InspecthiShowInspector", "InspecthiHideInspector" } },

  {
    "dhruvasagar/vim-table-mode",
    cmd = { "TableModeToggle" },
    init = function()
      vim.g.table_mode_map_prefix = "`t"
      vim.g.table_mode_corner = "|"
    end,
  },

  { "dstein64/vim-startuptime", cmd = { "StartupTime" } },
  { "fuenor/JpFormat.vim", cmd = { "JpFormatAll", "JpJoinAll" } },
  { "lambdalisue/suda.vim", cmd = { "SudaRead", "SudaWrite" } },

  {
    "iberianpig/tig-explorer.vim",
    dependencies = { "rbgrouleff/bclose.vim" },
    -- TODO: cmd does not work?
    keys = {
      { "<Leader>tT", [[<Cmd>TigOpenCurrentFile<CR>]] },
      { "<Leader>tt", [[<Cmd>TigOpenProjectRootDir<CR>]] },
      { "<Leader>tg", [[<Cmd>TigGrep<CR>]] },
      { "<Leader>tr", [[<Cmd>TigGrepResume<CR>]] },
      { "<Leader>tG", [[y<Cmd>TigGrep<Space><C-R>"<CR>]], mode = { "v" } },
      { "<Leader>tc", [[<Cmd><C-u>:TigGrep<Space><C-R><C-W><CR>]] },
      { "<Leader>tb", [[<Cmd>TigBlame<CR>]] },
    },
    cmd = {
      "Tig",
      "TigOpenCurrentFile",
      "TigOpenProjectRootDir",
      "TigGrep",
      "TigBlame",
      "TigGrepResume",
      "TigStatus",
      "TigOpenFileWithCommit",
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && yarn",
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_open_to_the_world = 1
    end,
  },

  {
    "npxbr/glow.nvim",
    cmd = { "Glow", "GlowInstall" },
    init = function()
      vim.g.glow_use_pager = true
    end,
  },

  { "powerman/vim-plugin-AnsiEsc", cmd = { "AnsiEsc" } },

  {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    keys = { { "<A-O>", ":Octo " } },
    init = function()
      api.create_autocmd("FileType", {
        desc = "Set up octo.nvim mappings",
        pattern = "octo",
        callback = function()
          vim.keymap.set("n", "<CR>", function()
            require("octo.navigation").go_to_issue()
          end, { buffer = true, desc = "octo.navigation.go_to_issue" })
          vim.keymap.set("n", "K", function()
            require("octo").on_cursor_hold()
          end, { buffer = true, desc = "octo.on_cursor_hold" })
        end,
      })
      api.create_autocmd({ "BufEnter", "BufReadPost" }, {
        desc = "Chdir every time you enter in Octo buffers",
        pattern = "octo://*",
        callback = function()
          local dir = require("core.utils.octo"):buf_repo_dir()
          if dir then
            api.set_current_dir(dir)
          end
        end,
      })
      vim.keymap.set("n", "<Plug>(octo-toggle-enterprise)", function()
        require("core.utils.octo"):toggle()
      end, { desc = "Octo toggle .com ⇔ Enterprise" })
    end,
    config = function()
      vim.treesitter.language.register("markdown", "octo")
      require("core.utils.octo"):setup()
    end,
  },

  {
    "rhysd/ghpr-blame.vim",
    cmd = { "GHPRBlame" },
    init = function()
      vim.g.ghpr_github_auth_token = {
        ["github.com"] = vim.env.HOMEBREW_GITHUB_API_TOKEN,
        [vim.env.GITHUB_ENTERPRISE_HOST] = vim.env.GITHUB_ENTERPRISE_API_TOKEN_GHPRBLAME,
      }
      vim.g.ghpr_github_api_url = {
        [vim.env.GITHUB_ENTERPRISE_HOST] = vim.env.GITHUB_ENTERPRISE_API_PATH,
      }
    end,
  },

  {
    "rhysd/git-messenger.vim",
    cmd = { "GitMessenger" },
    keys = { { "<A-b>", [[<Cmd>GitMessenger<CR>]] } },
    init = function()
      vim.g.git_messenger_no_default_mappings = true
    end,
  },

  {
    "tyru/capture.vim",
    dependencies = { { "thinca/vim-prettyprint", cmd = { "PP", "PrettyPrint" } } },
    cmd = { "Capture" },
  },

  {
    "tpope/vim-eunuch",
    cmd = {
      "Cfind",
      "Chmod",
      "Clocate",
      "Copy",
      "Delete",
      "Duplicate",
      "Lfind",
      "Llocate",
      "Mkdir",
      "Move",
      "Remove",
      "Rename",
      "SudoEdit",
      "SudoWrite",
      "Unlink",
      "W",
      "Wall",
    },
  },

  {
    "vifm/vifm.vim",
    cmd = { "EditVifm", "VsplitVifm", "SplitVifm", "DiffVifm", "TabVifm" },
    ft = { "vifm" },
  },

  {
    "vim-scripts/autodate.vim",
    cmd = { "Autodate", "AutodateOFF", "AutodateON" },
    init = function()
      vim.g.autodate_format = "%FT%T%z"
      local group = api.create_augroup("Autodate", {})
      api.create_autocmd({ "BufRead", "BufNewFile" }, {
        desc = "Set up autodate.vim",
        group = group,
        once = true,
        callback = function()
          api.create_autocmd(
            { "BufUnload", "FileWritePre", "BufWritePre" },
            { desc = "Run autodate.vim", group = group, command = "Autodate" }
          )
        end,
      })
    end,
  },

  {
    "LumaKernel/nvim-visual-eof.lua",
    event = { "BufRead", "BufNewFile" },
    init = function()
      palette "visual_eof" {
        nord = function(colors)
          api.set_hl(0, "VisualEOL", { fg = colors.green })
          api.set_hl(0, "VisualNoEOL", { fg = colors.red })
        end,
        sweetie = function(colors)
          api.set_hl(0, "VisualEOL", { fg = colors.green })
          api.set_hl(0, "VisualNoEOL", { fg = colors.red })
        end,
      }
    end,
    opts = {
      text_EOL = " ",
      text_NOEOL = " ",
      ft_ng = {
        "FTerm",
        "denite",
        "denite-filter",
        "fugitive.*",
        "git.*",
        "packer",
      },
      buf_filter = function(bufnr)
        return api.buf_get_option(bufnr, "buftype") == ""
      end,
    },
  },
  --
  -- {
  --   "delphinus/auto-cursorline.nvim",
  --   event = { "BufRead", "CursorMoved", "CursorMovedI", "WinEnter", "WinLeave" },
  --   init = function()
  --     api.create_autocmd("FileType", {
  --       pattern = "TelescopePrompt",
  --       callback = function()
  --         require("auto-cursorline").disable { buffer = true }
  --         vim.wo.cursorline = false
  --       end,
  --     })
  --   end,
  --   config = true,
  -- },

  {
    "delphinus/dwm.nvim",
    event = { "VimEnter" },
    keys = {
      { "<C-j>", "<C-w>w" },
      { "<C-k>", "<C-w>W" },
      { "<A-CR>", dwm "focus" },
      { "<C-@>", dwm "focus" },
      { "<C-Space>", dwm "focus" },
      { "<C-l>", dwm "grow" },
      { "<C-h>", dwm "shrink" },
      { "<C-n>", dwm "new" },
      { "<C-q>", dwm "rotateLeft" },
      { "<C-s>", dwm "rotate" },
      { "<C-c>", dwm "close" },
    },
    cond = function()
      -- HACK: Do not load when it is loading committia.vim
      local file = vim.fs.basename(api.buf_get_name(0))
      return vim.iter({ "COMMIT_EDITMSG", "MERGE_MSG" }):all(function(name)
        return file ~= name
      end)
    end,
    opts = {
      key_maps = false,
      master_pane_count = 1,
      master_pane_width = "60%",
    },
  },

  {
    "delphinus/emcl.nvim",
    event = { "CmdlineEnter" },
    config = true,
  },

  {
    "folke/noice.nvim",
    event = { "BufRead", "BufNewFile", "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
    init = function()
      palette "noice" {
        nord = function(colors)
          api.set_hl(0, "NoiceLspProgressSpinner", { fg = colors.white })
          api.set_hl(0, "NoiceLspProgressTitle", { fg = colors.orange })
          api.set_hl(0, "NoiceLspProgressClient", { fg = colors.yellow })
        end,
      }
      vim.api.nvim_create_user_command("NoiceRedirect", function(cmd)
        require("noice").redirect(cmd.args)
      end, { desc = "Redirect any command with Noice", nargs = "+", complete = "command" })
    end,
    opts = {
      cmdline = {
        format = {
          cmdline = { icon = "" },
          search_down = { icon = "" },
          search_up = { icon = "" },
          filter = { icon = "" },
        },
      },
      popupmenu = {
        backend = "cmp",
      },
      lsp = {
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      format = {
        spinner = {
          name = "dots12",
          --name = "sand",
        },
      },
    },
  },

  {
    enabled = not vim.env.LIGHT,
    "haringsrob/nvim_context_vt",
    event = { "BufNewFile", "BufRead", "FocusLost", "CursorHold" },
    wants = { "nvim-treesitter" },
    init = function()
      palette "context_vt" {
        nord = function(colors)
          api.set_hl(0, "ContextVt", { fg = colors.context })
        end,
        sweetie = function(colors)
          api.set_hl(0, "ContextVt", { fg = colors.dark_grey })
        end,
      }
    end,
    opts = {
      prefix = "",
      highlight = "ContextVt",
    },
  },

  {
    "itchyny/vim-cursorword",
    event = { "FocusLost", "CursorHold" },
    init = function()
      api.create_autocmd("ColorScheme", {
        desc = "Set up highlight for vim-cursorword",
        group = api.create_augroup("cursorword-colors", {}),
        callback = function()
          api.set_hl(0, "CursorWord", { undercurl = true })
        end,
      })
    end,
  },

  {
    "itchyny/vim-parenmatch",
    event = { "FocusLost", "CursorHold" },
    init = function()
      vim.g.loaded_matchparen = 1
    end,
    config = function()
      fn["parenmatch#highlight"]()
    end,
  },

  {
    "lewis6991/foldsigns.nvim",
    event = { "FocusLost", "CursorHold" },
    config = true,
  },

  {
    "lewis6991/gitsigns.nvim",
    cmd = { "Gitsigns" },
    event = { "FocusLost", "CursorHold" },
    keys = {
      {
        "gL",
        lazy_require("gitsigns").setloclist(),
        desc = "gitsigns.setloclist",
      },
      {
        "gQ",
        lazy_require("gitsigns").setqflist "all",
        desc = 'gitsigns.setqflist "all"',
      },
    },
    init = function()
      palette "gitsigns" {
        nord = function(colors)
          api.set_hl(0, "GitSignsAdd", { fg = colors.green })
          api.set_hl(0, "GitSignsChange", { fg = colors.yellow })
          api.set_hl(0, "GitSignsDelete", { fg = colors.red })
          api.set_hl(0, "GitSignsCurrentLineBlame", { fg = colors.brighter_black })
          api.set_hl(0, "GitSignsAddInline", { bg = colors.bg_green })
          api.set_hl(0, "GitSignsChangeInline", { bg = colors.bg_yellow })
          api.set_hl(0, "GitSignsDeleteInline", { bg = colors.bg_red })
          api.set_hl(0, "GitSignsUntracked", { fg = colors.magenta })
        end,
      }
    end,
    config = function()
      local gitsigns = require "gitsigns"
      local function gs(method)
        return function()
          gitsigns[method]()
        end
      end

      gitsigns.setup {
        signs = {
          add = {},
          change = {},
          delete = { text = "✗" },
          topdelete = { text = "↑" },
          changedelete = { text = "•" },
          untracked = { text = "⢸" },
        },
        numhl = true,
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 10,
        },
        word_diff = true,
        on_attach = function(bufnr)
          local km = vim.keymap
          km.set("n", "]c", gs "next_hunk", { buffer = bufnr, desc = "gitsigns.next_hunk" })
          km.set("n", "[c", gs "prev_hunk", { buffer = bufnr, desc = "gitsigns.prev_hunk" })
        end,
      }
    end,
  },

  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    opts = { chunk = { chars = { right_arrow = "→" } }, blank = { chars = { "∙" } } },
  },

  {
    enabled = not vim.env.LIGHT,
    --"lukas-reineke/virt-column.nvim",
    "delphinus/virt-column.nvim",
    branch = "feature/buf-filter",
    init = function()
      palette "virt_column" {
        nord = function(colors)
          api.set_hl(0, "ColorColumn", {})
          api.set_hl(0, "VirtColumn", { fg = colors.brighter_black })
        end,
        sweetie = function(colors)
          api.set_hl(0, "ColorColumn", {})
          api.set_hl(0, "VirtColumn", { fg = colors.dark_grey })
        end,
      }

      local require_virt_column = (function()
        local init = false
        return function()
          local vt = require "virt-column"
          if not init then
            vt.config.char = "⡂"
            vt.namespace = api.create_namespace "virt-column"
            init = true
          end
          return vt
        end
      end)()

      api.create_user_command("VirtColumnRefresh", function(args)
        require_virt_column()
        require("virt-column.commands").refresh(args.bang)
      end, { bang = true, desc = "Refresh virt-column" })

      local group = api.create_augroup("VirtColumnAutogroup", {})
      api.create_autocmd(
        { "FileChangedShellPost", "TextChanged", "TextChangedI", "CompleteChanged", "BufWinEnter" },
        { group = group, command = "VirtColumnRefresh" }
      )
      api.create_autocmd("SessionLoadPost", { group = group, command = "VirtColumnRefresh!" })
      api.create_autocmd("TermEnter", {
        desc = "Clear virt-column",
        group = group,
        callback = function()
          require_virt_column().clear_buf(0)
        end,
      })

      local t = assert(uv.new_timer())
      t:start(5000, 5000, function()
        require_virt_column()
        vim.schedule(function()
          require("virt-column.commands").refresh()
        end)
      end)
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "delphinus/eaw.nvim" },
    },
    init = function()
      -- HACK: dashboard-nvim will change laststatus
      -- vim.opt.laststatus = 3
      vim.opt.showtabline = 0
    end,
    config = function()
      require("core.utils.lualine"):config()
    end,
  },

  {
    "tpope/vim-fugitive",
    keys = {
      { "git", [[<Cmd>Git<CR>]] },
      { "g<Space>", [[:Git ]] },
      { "d<", [[<Cmd>diffget //2<CR>]] },
      { "d>", [[<Cmd>diffget //3<CR>]] },
      { "gs", [[<Cmd>Gstatus<CR>]] },
    },
    event = { "BufRead", "FocusLost", "CursorHold" },
  },

  { "dix75/jira.vim", ft = { "confluencewiki" } },
  { "Glench/Vim-Jinja2-Syntax", ft = { "jinja" } },
  { "Vimjas/vim-python-pep8-indent", ft = { "python" } },
  { "aklt/plantuml-syntax", ft = { "plantuml" } },
  { "aliou/bats.vim", ft = { "bats" } },
  -- {'dag/vim-fish' ft = {'fish'}},
  { "blankname/vim-fish", ft = { "fish" } },
  { "c9s/perlomni.vim", ft = { "perl" } },
  { "delphinus/qfheight.nvim", ft = { "qf" }, config = true },
  { "delphinus/vim-data-section-simple", ft = { "perl" } },
  { "delphinus/vim-firestore", ft = { "firestore" } },
  { "hail2u/vim-css3-syntax", ft = { "css" } },
  { "isobit/vim-caddyfile", ft = { "caddyfile" } },
  { "junegunn/vader.vim", ft = { "vader" } },
  { "kchmck/vim-coffee-script", ft = { "coffee" } },

  { enabled = not vim.env.LIGHT, "kevinhwang91/nvim-bqf", ft = { "qf" } },

  { "leafo/moonscript-vim", ft = { "moonscript" } },
  { "moznion/vim-cpanfile", ft = { "cpanfile" } },

  {
    "motemen/vim-syntax-hatena",
    ft = { "hatena" },
    config = function()
      vim.g.hatena_syntax_html = true
    end,
  },

  { "motemen/xslate-vim", ft = { "xslate" } },
  { "msanders/cocoa.vim", ft = { "objc" } },
  { "mustache/vim-mustache-handlebars", ft = { "mustache", "handlebars", "html.mustache", "html.handlebars" } },
  { "nikvdp/ejs-syntax", ft = { "ejs" } },
  { "pboettch/vim-cmake-syntax", ft = { "cmake" } },

  {
    "pearofducks/ansible-vim",
    ft = { "ansible", "yaml.ansible" },
    config = function()
      vim.g.ansible_name_highlight = "b"
      vim.g.ansible_extra_keywords_highlight = 1
    end,
  },

  { "rhysd/vim-textobj-ruby", dependencies = { "kana/vim-textobj-user" }, ft = { "ruby" } },

  { "delphinus/vim-rails", branch = "feature/recognize-ridgepole", ft = { "ruby" } },

  {
    "vim-perl/vim-perl",
    ft = { "perl", "perl6" },
    init = function()
      vim.g.perl_include_pod = 1
      vim.g.perl_string_as_statement = 1
      vim.g.perl_sync_dist = 1000
      vim.g.perl_fold = 1
      vim.g.perl_nofold_packages = 1
      vim.g.perl_fold_anonymous_subs = 1
      vim.g.perl_sub_signatures = 1
    end,
  },

  { "vim-scripts/a.vim", ft = { "c", "cpp" } },
  { "vim-scripts/applescript.vim", ft = { "applescript" } },
  { "vim-scripts/fontforge_script.vim", ft = { "fontforge_script" } },
  { "vim-scripts/nginx.vim", ft = { "nginx" } },
  { "vim-skk/skkdict.vim", ft = { "skkdict" } },

  {
    "arecarn/vim-fold-cycle",
    keys = {
      { "<A-l>", [[<Plug>(fold-cycle-open)]] },
      { "<A-¬>", [[<Plug>(fold-cycle-open)]] },
      { "<A-h>", [[<Plug>(fold-cycle-open)]] },
      { "<A-˙>", [[<Plug>(fold-cycle-open)]] },
    },
    init = function()
      vim.g.fold_cycle_default_mapping = 0
    end,
  },

  {
    "chikatoike/concealedyank.vim",
    keys = { { "Y", "<Plug>(operator-concealedyank)", mode = { "x" } } },
  },

  { "delphinus/vim-tmux-copy", keys = { "<A-[>", "<A-“>" } },

  {
    "inkarkat/vim-LineJuggler",
    dependencies = {
      { "inkarkat/vim-ingo-library" },
      { "tpope/vim-repeat" },
      { "vim-scripts/visualrepeat" },
    },
    keys = {
      { "[E", mode = { "n", "v" } },
      { "]E", mode = { "n", "v" } },
      { "[e", mode = { "n", "v" } },
      { "]e", mode = { "n", "v" } },
      { "[f", mode = { "n", "v" } },
      { "]f", mode = { "n", "v" } },
      { "[<Space>", mode = { "n", "v" } },
      { "]<Space>", mode = { "n", "v" } },
      { "[D", "<Plug>(LineJugglerDupOverUp)", mode = { "n", "x" } },
      { "]D", "<Plug>(LineJugglerDupOverDown)", mode = { "n", "x" } },
      { "[<C-d>", "<Plug>(LineJugglerDupRangeUp)", mode = { "n", "x" } },
      { "]<C-d>", "<Plug>(LineJugglerDupRangeDown)", mode = { "n", "x" } },
    },
  },

  {
    "junegunn/vim-easy-align",
    keys = { { "<CR>", "<Plug>(EasyAlign)", mode = { "v" } } },
    init = function()
      vim.g.easy_align_delimiters = {
        [">"] = { pattern = [[>>\|=>\|>]] },
        ["/"] = { pattern = [[//\+\|/\*\|\*/]], ignore_groups = { "String" } },
        ["#"] = {
          pattern = [[#\+]],
          ignore_groups = { "String" },
          delimiter_align = "l",
        },
        ["]"] = {
          pattern = [=[[[\]]]=],
          left_margin = 0,
          right_margin = 0,
          stick_to_left = 0,
        },
        [")"] = {
          pattern = "[()]",
          left_margin = 0,
          right_margin = 0,
          stick_to_left = 0,
        },
        ["d"] = {
          pattern = [[ \(\S\+\s*[;=]\)\@=]],
          left_margin = 0,
          right_margin = 0,
        },
      }
    end,
  },

  {
    "kylechui/nvim-surround",
    keys = { "ys", "ds", "cs", "S" },
    config = true,
  },

  {
    "ruifm/gitlinker.nvim",
    keys = { { "<Space>gc", mode = { "n", "v" } } },
    dependencies = { "plenary.nvim" },
    opts = function(_)
      return {
        opts = {
          add_current_line_on_normal_mode = false,
          action_callback = function(url)
            local actions = require "gitlinker.actions"
            actions.copy_to_clipboard(url)
            actions.open_in_browser(url)
          end,
        },
        callbacks = {
          [vim.g.gh_e_host or ""] = function(url_data)
            return require("gitlinker.hosts").get_github_type_url(url_data)
          end,
        },
        mappings = "<Space>gc",
      }
    end,
  },

  {
    "t9md/vim-quickhl",
    keys = {
      { "<Space>qm", [[<Plug>(quickhl-manual-this)]], mode = { "n", "x" }, remap = true },
      { "<Space>qt", [[<Plug>(quickhl-manual-toggle)]], mode = { "n", "x" }, remap = true },
      { "<Space>qM", [[<Plug>(quickhl-manual-reset)]], mode = { "n", "x" }, remap = true },
    },
  },

  {
    "tyru/columnskip.vim",
    keys = {
      { "[j", [[<Plug>(columnskip:nonblank:next)]], mode = { "n", "x", "o" } },
      { "[k", [[<Plug>(columnskip:nonblank:prev)]], mode = { "n", "x", "o" } },
      { "]j", [[<Plug>(columnskip:first-nonblank:next)]], mode = { "n", "x", "o" } },
      { "]k", [[<Plug>(columnskip:first-nonblank:prev)]], mode = { "n", "x", "o" } },
    },
  },

  {
    "hrsh7th/vim-searchx",
    fn = { "searchx#*" },
    init = function()
      local km = vim.keymap
      local searchx = function(name)
        return function(opt)
          return function()
            require("lazy").load { plugins = { "vim-searchx" } }
            local f = fn["searchx#" .. name]
            return opt and f(opt) or f()
          end
        end
      end

      -- Overwrite / and ?.
      km.set({ "n", "x" }, "?", searchx "start" { dir = 0, desc = "Start vim-searchx to the top" })
      km.set({ "n", "x" }, "/", searchx "start" { dir = 1, desc = "Start vim-searchx to the bottom" })
      km.set("c", "<A-;>", searchx "select"(), { desc = "searchx#select" })

      -- Move to next/prev match.
      km.set({ "n", "x" }, "N", searchx "prev"(), { desc = "searchx#prev" })
      km.set({ "n", "x" }, "n", searchx "next"(), { desc = "searchx#next" })
      km.set({ "c", "n", "x" }, "<A-Z>", searchx "prev"(), { desc = "searchx#prev" })
      km.set({ "c", "n", "x" }, "<A-X>", searchx "next"(), { desc = "searchx#next" })

      -- Clear highlights
      km.set("n", "<Esc><Esc>", searchx "clear"(), { desc = "searchx#clear" })

      palette "searchx" {
        nord = function(_)
          api.set_hl(0, "SearchxMarker", { link = "DiffChange" })
          api.set_hl(0, "SearchxMarkerCurrent", { link = "WarningMsg" })
        end,
      }
    end,
    config = function()
      vim.g.searchx = {
        -- Auto jump if the recent input matches to any marker.
        auto_accept = true,
        -- The scrolloff value for moving to next/prev.
        scrolloff = vim.opt.scrolloff:get(),
        -- To enable scrolling animation.
        scrolltime = 0,
        -- Marker characters.
        markers = vim.split("HJKLASDFGYUIOPQWERTNMZXCVB", ""),
        -- To enable auto nohlsearch after cursor is moved
        nohlsearch = { jump = true },
        convert = function(input)
          -- If the input does not contain iskeyword characters, it deals with
          -- the input as "very magic".
          if not vim.regex([[\k]]):match_str(input) then
            return [[\V]] .. input
          elseif input:match "^%." then
            return input:sub(2)
          end
          -- If the input contains spaces, it tries fuzzy matching.
          local converted = vim.iter(vim.split(input, " ")):map(fn["kensaku#query"]):totable()
          return table.concat(converted, [[.\{-}]])
        end,
      }
    end,
  },

  { "delphinus/characterize.nvim", config = true },

  {
    "mrjones2014/op.nvim",
    build = "make install",
    cmd = {
      "OpAnalyzeBuffer",
      "OpCreate",
      "OpEdit",
      "OpInsert",
      "OpNote",
      "OpOpen",
      "OpSidebar",
      "OpSignin",
      "OpSignout",
      "OpView",
      "OpWhoami",
    },
    dependencies = { { "stevearc/dressing.nvim" } },
    opts = {
      signin_on_start = true,
    },
  },

  {
    "yuki-yano/fuzzy-motion.vim",
    keys = { { "s", "<Cmd>FuzzyMotion<CR>", mode = { "n", "x" } } },
    init = function()
      vim.g.fuzzy_motion_labels = vim.split("HJKLASDFGYUIOPQWERTNMZXCVB", "")
      vim.g.fuzzy_motion_matchers = "kensaku,fzf"

      palette "fuzzy_motion" {
        nord = function(colors)
          api.set_hl(0, "FuzzyMotionShade", { fg = colors.gray })
          api.set_hl(0, "FuzzyMotionChar", { fg = colors.red })
          api.set_hl(0, "FuzzyMotionSubChar", { fg = colors.yellow })
          api.set_hl(0, "FuzzyMotionMatch", { fg = colors.cyan })
        end,
        sweetie = function(colors)
          api.set_hl(0, "FuzzyMotionShade", { fg = colors.dark_grey })
          api.set_hl(0, "FuzzyMotionChar", { fg = colors.red })
          api.set_hl(0, "FuzzyMotionSubChar", { fg = colors.yellow })
          api.set_hl(0, "FuzzyMotionMatch", { fg = colors.cyan })
        end,
      }
    end,
    config = function()
      require("denops-lazy").load "fuzzy-motion.vim"
    end,
  },

  { "tzachar/highlight-undo.nvim", keys = { "u", "<C-r>" }, opts = {} },

  {
    "rickhowe/wrapwidth",
    cmd = { "Wrapwidth" },
    init = function()
      local group = vim.api.nvim_create_augroup("Wrapwidth", {})
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        callback = function()
          local config = vim.api.nvim_win_get_config(0)
          local is_floatwin = config.relative ~= ""
          if not is_floatwin then
            vim.cmd.Wrapwidth(-2)
          end
        end,
      })
      -- NOTE: set Wrapwidth if the file contains Wrapwidth xx in upper lines.
      api.create_autocmd("BufReadPost", {
        group = group,
        callback = function()
          local lines = api.buf_get_lines(0, 0, 2, false)
          if lines then
            for _, line in ipairs(lines) do
              local width = line:match [[Wrapwidth ([0-9]+)]]
              if width then
                vim.schedule(function()
                  vim.notify(("setting Wrapwidth due to head lines: %d"):format(width), vim.log.levels.DEBUG)
                  vim.cmd.Wrapwidth(width)
                end)
                break
              end
            end
          end
        end,
      })
      vim.g.wrapwidth_hl = "SignColumn"
    end,
  },

  {
    "tris203/hawtkeys.nvim",
    cmd = { "Hawtkeys", "HawtkeysAll", "HawtkeysDupes" },
    dependencies = { "plenary.nvim" },
    opts = {
      leader = [[\]],
    },
    init = function()
      -- Disable cmp in hawtkeys buffer
      vim.api.nvim_create_autocmd({ "InsertEnter" }, {
        group = vim.api.nvim_create_augroup("hawtkeys-cmp", {}),
        callback = function(args)
          if args.buf == require("hawtkeys.ui").SearchBuf then
            require("cmp").setup.buffer { enabled = false }
          end
        end,
      })
    end,
  },

  { "rbong/vim-flog", dependencies = { "tpope/vim-fugitive" }, cmd = { "Flog", "Flogsplit", "Floggit" } },

  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown",
    ft = { "markdown" },
    init = function()
      palette "sweetie" {
        nord = function(colors)
          api.set_hl(0, "@markup.heading.1.markdown", { fg = "#88C0D0", bold = true })
          api.set_hl(0, "@markup.heading.2.markdown", { fg = "#A3BE8C", bold = true })
          api.set_hl(0, "@markup.heading.3.markdown", { fg = "#EBCB8B", bold = true })
          api.set_hl(0, "@markup.heading.4.markdown", { fg = "#D08770", bold = true })
          api.set_hl(0, "@markup.heading.5.markdown", { fg = "#B48EAD", bold = true })
          api.set_hl(0, "@markup.heading.6.markdown", { fg = "#ECEFF4", bold = true })
        end,
        sweetie = function(colors)
          if colors.is_dark then
            api.set_hl(0, "@markup.heading.1.markdown", { fg = colors.blue, bg = "#303948", bold = true })
            api.set_hl(0, "@markup.heading.2.markdown", { fg = colors.green, bg = "#2b3324", bold = true })
            api.set_hl(0, "@markup.heading.3.markdown", { fg = colors.yellow, bg = "#3e3924", bold = true })
            api.set_hl(0, "@markup.heading.4.markdown", { fg = colors.orange, bg = "#3e332a", bold = true })
            api.set_hl(0, "@markup.heading.5.markdown", { fg = colors.magenta, bg = "#37223e", bold = true })
            api.set_hl(0, "@markup.heading.6.markdown", { fg = colors.violet, bg = "#261C39", bold = true })
          else
            api.set_hl(0, "@markup.heading.1.markdown", { fg = "#194064", bg = "#bee0ff", bold = true })
            api.set_hl(0, "@markup.heading.2.markdown", { fg = "#255517", bg = "#d1ffc3", bold = true })
            api.set_hl(0, "@markup.heading.3.markdown", { fg = "#695c18", bg = "#fff3b9", bold = true })
            api.set_hl(0, "@markup.heading.4.markdown", { fg = "#834e20", bg = "#e2d5c9", bold = true })
            api.set_hl(0, "@markup.heading.5.markdown", { fg = "#751c5e", bg = "#e2cbdc", bold = true })
            api.set_hl(0, "@markup.heading.6.markdown", { fg = "#54307c", bg = "#c4a9e2", bold = true })
          end
        end,
      }
    end,
    config = function()
      ---@type UserConfig
      require("render-markdown").setup {
        heading = {
          -- icons = { "⓵", "⓶", "⓷", "⓸", "⓹", "⓺" },
          icons = { "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳" },
          -- icons = { "󰎦", "󰎩", "󰎬", "󰎮", "󰎰", "󰎵" },
          -- icons = { "󰎥", "󰎨", "󰎫", "󰎲", "󰎯", "󰎴" },
          signs = { "󰫎" },
          backgrounds = {
            "@markup.heading.1.markdown",
            "@markup.heading.2.markdown",
            "@markup.heading.3.markdown",
            "@markup.heading.4.markdown",
            "@markup.heading.5.markdown",
            "@markup.heading.6.markdown",
          },
          foregrounds = {
            "@markup.heading.1.markdown",
            "@markup.heading.2.markdown",
            "@markup.heading.3.markdown",
            "@markup.heading.4.markdown",
            "@markup.heading.5.markdown",
            "@markup.heading.6.markdown",
          },
        },
        code = { highlight = "CursorLine" },
        bullet = { icons = { "", "", "", "" } },
        checkbox = { unchecked = { icon = "" }, checked = { icon = "" } },
        conceal = { rendered = 2 },
      }
    end,
  },

  {
    "4513ECHO/nvim-keycastr",
    init = function()
      local enabled = false
      local config_set = false
      vim.keymap.set("n", "<Leader>kk", function()
        vim.notify(("%s keycastr"):format(enabled and "Disabling" or "Enabling"))
        local keycastr = require "keycastr"
        if not config_set then
          keycastr.config.set { win_config = { border = "rounded" }, position = "NE" }
          config_set = true
        end
        keycastr[enabled and "disable" or "enable"]()
        enabled = not enabled
      end)
    end,
  },

  {
    "Wansmer/treesj",
    keys = { "<Space>m", "<Space>j", "<Space>s" },
    cmd = { "TSJToggle", "TSJJoin", "TSJSplit" },
    opts = {},
  },

  {
    "obaland/vfiler.vim",
    dependencies = { "obaland/vfiler-column-devicons" },
    keys = {
      {
        "<Space>ff",
        function()
          require("vfiler").start(vim.fn.expand "%:h")
        end,
      },
      {
        "<Space>fF",
        "<Cmd>VFiler<CR>",
      },
    },
    cmd = { "VFiler" },
    config = function()
      local action = require "vfiler/action"
      local config = require "vfiler/config"
      config.setup {
        options = {
          columns = "indent,devicons,name,mode,size,time",
          auto_cd = true,
        },
        mappings = {
          ["<A-Space>"] = function(...)
            action.toggle_select(...)
            action.move_cursor_up(...)
          end,
          R = action.jump_to_root,
          L = action.open_tree_recursive,
        },
      }
      config.unmap [[\]] -- unmap jump_to_root
      -- NOTE: see default mappings below
      -- ~/.local/share/nvim/lazy/vfiler.vim/lua/vfiler/config.lua
    end,
  },

  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("tiny-devicons-auto-colors").setup { colors = palette.list }
    end,
  },

  { "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },

  {
    "NStefan002/screenkey.nvim",
    branch = "dev",
    cmd = { "Screenkey" },
    opts = {
      win_opts = { row = 8, border = "rounded" },
      keys = {
        ["<ESC>"] = "⎋",
        ["<BS>"] = "󰌥",
        ["<DEL>"] = "⌦",
        ["CTRL"] = "⌃",
        ["ALT"] = "⌥",
        ["SUPER"] = "⌘",
      },
    },
  },

  {
    "svampkorg/moody.nvim",
    event = { "ModeChanged" },
    init = function()
      palette "moody" {
        sweetie = function(colors)
          vim.api.nvim_set_hl(0, "NormalMoody", { fg = colors.blue })
          vim.api.nvim_set_hl(0, "InsertMoody", { fg = colors.orange })
          vim.api.nvim_set_hl(0, "VisualMoody", { fg = colors.magenta })
          vim.api.nvim_set_hl(0, "CommandMoody", { fg = colors.green })
          vim.api.nvim_set_hl(0, "ReplaceMoody", { fg = colors.red })
          vim.api.nvim_set_hl(0, "SelectMoody", { fg = colors.violet })
          vim.api.nvim_set_hl(0, "TerminalMoody", { fg = colors.cyan })
          vim.api.nvim_set_hl(0, "TerminalNormalMoody", { fg = colors.cyan })
        end,
      }
    end,
    opts = { disabled_filetypes = { "TelescopePrompt" } },
  },

  {
    "jedrzejboczar/possession.nvim",
    dependencies = { "plenary.nvim" },
    init = function()
      -- Neovimを再起動するコマンドを作ったら結構よかった
      -- https://zenn.dev/nazo6/articles/neovim-restart-command
      -- If quit with `:Q`, Neovim launches with the last session at the next time.
      vim.api.nvim_create_user_command("Quit", function()
        require("possession.session").save("restart", { no_confirm = true })
        vim.cmd.qa { bang = true, mods = { emsg_silent = true } }
      end, {})
      vim.api.nvim_create_autocmd("VimEnter", {
        nested = true,
        callback = function()
          local config = require "possession.config"
          local session = require "possession.session"
          if session.exists "restart" then
            local saved = vim.iter(config):fold({}, function(a, k, v)
              if k ~= "setup" then
                a[k] = v
              end
              return a
            end)
            local new_config = vim.deepcopy(saved)
            new_config.silent = true
            config.setup(new_config)
            session.load "restart"
            session.delete("restart", { no_confirm = true })
            config.setup(saved)
          end
        end,
      })
      -- NOTE: https://github.com/jedrzejboczar/possession.nvim/issues/19
      vim.opt.sessionoptions:remove "folds"
    end,
    opts = {
      commands = { save = "SSave", load = "SLoad", delete = "SDelete", list = "SList" },
      -- NOTE: This is needed for terminal buffers
      plugins = { delete_hidden_buffers = { force = true } },
    },
  },

  { "Kicamon/markdown-table-mode.nvim", ft = { "markdown" }, opts = {} },

  {
    "folke/zen-mode.nvim",
    keys = { { "<A-z>", "<Cmd>ZenMode<CR>" } },
    cmd = { "ZenMode" },
    ---@type ZenOptions
    opts = {
      window = { width = 81 },
      plugins = {
        tmux = { enabled = true },
        wezterm = { enabled = true },
      },
      on_open = function()
        require("incline").disable()
        vim.opt_local.wrap = true
        vim.o.cmdheight = 1
        vim.o.laststatus = 0
      end,
      on_close = function()
        require("incline").enable()
        vim.opt_local.wrap = false
        vim.o.cmdheight = 0
        vim.o.laststatus = 3
      end,
    },
  },

  {
    "stevearc/quicker.nvim",
    ft = { "qf" },
    keys = {
      {
        "<leader>q",
        function()
          require("quicker").toggle()
        end,
        mode = "n",
        desc = "Toggle quickfix",
      },
      {
        "<leader>l",
        function()
          require("quicker").toggle { loclist = true }
        end,
        mode = "n",
        desc = "Toggle loclist",
      },
    },
    opts = {
      keys = {
        {
          ">",
          function()
            require("quicker").expand { before = 2, after = 2, add_to_existing = true }
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    },
  },

  {
    "mawkler/demicolon.nvim",
    keys = { "[d", "]d", "f", "F", "t", "T", ";", "," },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("demicolon").setup {
        diagnostic = { float = { border = { "⡠", "⠤", "⢄", "⢸", "⠊", "⠒", "⠑", "⡇" } } },
        keymaps = {
          horizontal_motions = true,
          diagnostic_motions = false,
          repeat_motions = true,
        },
      }
      local jump = require "demicolon.jump"
      vim.keymap.set({ "n", "x", "o" }, "]d", jump.diagnostic_jump_repeatably { count = 1 })
      vim.keymap.set({ "n", "x", "o" }, "[d", jump.diagnostic_jump_repeatably { count = -1 })
    end,
  },

  { "folke/persistence.nvim", event = { "BufReadPre" }, opts = {} },

  {
    "nvimdev/dashboard-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VimEnter" },
    opts = {
      theme = "hyper",
      config = {
        week_header = { enable = true },
        shortcut = {
          {
            desc = " Load the last session ",
            group = "DiffAdd",
            key = "l",
            action = function()
              require("persistence").load { last = true }
            end,
          },
          {
            desc = " Open Obsidian Quick Note ",
            group = "DiffChange",
            key = "o",
            action = "ObsidianQuickNote",
          },
        },
        project = {
          label = "Recent Projects:",
          action = function(path)
            vim.uv.chdir(path)
            require("telescope").extensions.frecency.frecency { workspace = "CWD" }
          end,
        },
        mru = { label = "Most Recent Files:", limit = 5 },
      },
    },
  },
}
