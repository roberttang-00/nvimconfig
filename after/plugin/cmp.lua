local has_cmp, cmp = pcall(require, 'cmp')
local has_luasnip, luasnip = pcall(require, 'luasnip')
local has_copilot, copilot_cmp = pcall(require, 'copilot_cmp.comparators')
local has_co, copilot = pcall(require, 'copilot')
local lspkind = require("lspkind")

local symbols = {
	Boolean = "",
	Character = "",
	Class = "",
	Color = "",
	Constant = "",
	Constructor = "",
	Enum = "",
	EnumMember = "",
	Event = "ﳅ",
	Field = "",
	File = "",
	Folder = "ﱮ",
	Function = "ﬦ",
	Interface = "",
	Keyword = "",
	Method = "",
	Module = "",
	Number = "",
	Operator = "Ψ",
	Parameter = "",
	Property = "ﰠ",
	Reference = "",
	Snippet = "",
	String = "",
	Struct = "ﯟ",
	Text = "",
	TypeParameter = "",
	Unit = "",
	Value = "",
	Variable = "ﳛ",
	Copilot = ""
}

if not has_cmp then
  print("no cmp")
end
if not has_luasnip then
  print("no luasnip")
end
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
vim.opt.completeopt = "menu,menuone,noselect"
vim.g.cmp_active = true
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'copilot',  group_index = 2 },
    { name = 'nvim_lsp', group_index = 2 },
    { name = 'buffer', keyword_length = 3 },
    -- { name = 'luasnip'},
    { name = 'path', group_index = 2 },
    { name = 'nvim_lua' },
  },
  sorting = {
    --keep priority weight at 2 for much closer matches to appear above copilot
    --set to 1 to make copilot always appear on top
    priority_weight = 1,
    comparators = {
      -- order matters here
      cmp.config.compare.exact,
      has_copilot and copilot_cmp.prioritize or nil,
      has_copilot and copilot_cmp.score or nil,
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
      -- personal settings:
      -- cmp.config.compare.recently_used,
      -- cmp.config.compare.offset,
      -- cmp.config.compare.score,
      -- cmp.config.compare.sort_text,
      -- cmp.config.compare.length,
      -- cmp.config.compare.order,
    },
  },
  preselect = cmp.PreselectMode.None,
  formatting = {
    fields = {"kind", "abbr", "menu"},
    format = function(entry, vim_item)
      vim_item.menu_hl_group = "CmpItemKind" .. vim_item.kind
      vim_item.menu = vim_item.kind
      vim_item.abbr = vim_item.abbr:sub(1, 50)
      vim_item.kind = '[' .. symbols[vim_item.kind] .. ']'
      return vim_item
    end
  },
  style = {
    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
  },
  window = {
    completion = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      scrollbar = "║",
      winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:CmpSelection,Search:None',
      autocomplete = {
        require("cmp.types").cmp.TriggerEvent.InsertEnter,
        require("cmp.types").cmp.TriggerEvent.TextChanged,
      },
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      scrollbar = "║",
    },
  },
})

local highlights = {
  -- type highlights
  CmpItemKindText = { fg = "LightGrey" },
  CmpItemKindFunction = { fg = "#C586C0" },
  CmpItemKindClass = { fg = "Orange" },
  CmpItemKindKeyword = { fg = "#f90c71" },
  CmpItemKindSnippet = { fg = "#565c64" },
  CmpItemKindConstructor = { fg = "#ae43f0" },
  CmpItemKindVariable = { fg = "#9CDCFE", bg = "NONE" },
  CmpItemKindInterface = { fg = "#f90c71", bg = "NONE" },
  CmpItemKindFolder = { fg = "#2986cc" },
  CmpItemKindReference = { fg = "#922b21" },
  CmpItemKindMethod = { fg = "#C586C0" },
  CmpItemKindCopilot = { fg = "#6CC644" },
  -- CmpItemMenu = { fg = "#C586C0", bg = "#C586C0" },
  CmpItemAbbr = { fg = "#565c64", bg = "NONE" },
  CmpItemAbbrMatch = { fg = "#569CD6", bg = "NONE" },
  CmpItemAbbrMatchFuzzy = { fg = "#569CD6", bg = "NONE" },
  CmpMenuBorder = { fg="#263341" },
  CmpMenu = { bg="#10171f" },
  CmpSelection = { bg="#263341" },
}

for group, hl in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, hl)
end
