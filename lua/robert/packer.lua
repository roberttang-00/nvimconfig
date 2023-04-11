-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use { 'tomasr/molokai' }
  use({
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  })

	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use('ThePrimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')

  use({
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{"christianchiarulli/nvim-cmp"},         -- Required
			{'hrsh7th/cmp-nvim-lsp'},     -- Required
			{'hrsh7th/cmp-buffer'},       -- Optional
			{'hrsh7th/cmp-path'},         -- Optional
			{'saadparwaiz1/cmp_luasnip'}, -- Optional
			{'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      {'rafamadriz/friendly-snippets'}, -- Optional
    }
  })
  -- use { "zbirenbaum/copilot.lua", config = function() require("copilot").setup() end }
  -- use { 'zbirenbaum/copilot-cmp', after = { "copilot.lua" }, config = function () require("copilot_cmp").setup({ formatters = {label = require("copilot_cmp.format").format_label_text, insert_text = require("copilot_cmp.format").format_insert_text, preview = require("copilot_cmp.format").deindent,},})end}
  use("folke/zen-mode.nvim")
  use("lervag/vimtex")
  use("onsails/lspkind.nvim")
  use {'nyoom-engineering/oxocarbon.nvim'}
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end}
end)

