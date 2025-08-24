return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  { "folke/which-key.nvim", enabled = false }, -- disable a default nvchad plugin

  -- this opts will extend the default opts
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "hyprlang" } },
    -- opts = { ensure_installed = {"html", "css", "bash"} },
  },

  -- If your opts uses a function call ex: require*, then make opts spec a function
  -- Then modify the opts arg
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, conf)
      conf.defaults.mappings.i = {
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<Esc>"] = require("telescope.actions").close,
      }

      -- or
      -- table.insert(conf.defaults.mappings.i, your table)
      return conf
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        hijack_cursor = true,
        disable_netrw = true,
        view = {
          cursorline = false,
          side = "left",
          -- number = true,
        },
        renderer = {
          hidden_display = "simple",
          highlight_git = "none",
        },
        git = {
          enable = false,
        },
      }
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    -- -@type ibl.config
    opts = {},
  },
  -- {
  --   "CRAG666/code_runner.nvim",
  --   config = true,
  --   lazy = false,
  -- },
  -- {
  --   "CRAG666/betterTerm.nvim",
  --   lazy = false,
  --   opts = {
  --     position = "vertical",
  --     size = 85,
  --     -- position = 'bot',
  --     -- size = 25,
  --     jump_tab_mapping = "<A-$tab>",
  --   },
  -- },
  {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
    },
    config = function(_, opts)
      require("luasnip").config.set_config(opts)

      -- Load VSCode-style snippets (from friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Load your own Lua snippets
      require("luasnip.loaders.from_lua").lazy_load {
        paths = "~/.config/nvim/lua/snippets",
      }
    end,
  },
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
  {
    "karb94/neoscroll.nvim",
    opts = {
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        "<C-u>",
        "<C-d>",
        "<C-b>",
        "<C-f>",
        "<C-y>",
        "<C-e>",
        "zt",
        "zz",
        "zb",
      },
      hide_cursor = true, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      duration_multiplier = 1.0, -- Global duration multiplier
      easing = "linear", -- Default easing function
      pre_hook = nil, -- Function to run before the scrolling animation starts
      post_hook = nil, -- Function to run after the scrolling animation ends
      performance_mode = false, -- Disable "Performance Mode" on all buffers.
      ignored_events = { -- Events ignored while scrolling
        "WinScrolled",
        "CursorMoved",
      },
    },
    lazy = false,
  },
}
