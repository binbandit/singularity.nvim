-- singularity.nvim — an ember-toned Neovim colorscheme.
--
-- A pure-Lua descendant of oxocarbon.nvim (IBM Carbon inspired), restyled so the
-- signature accent is ember rather than magenta:
--   dark:  ember-bright #dd5500 / ember-hot #ee6611
--   light: ember-deep   #b34400 / ember     #c65300  (tuned for WCAG-AA on white)
--
-- Requiring this module has NO side effects. colors/singularity.lua calls
-- require("singularity").load() to apply it; .setup{} configures it and
-- .get_palette() returns the active colours (used by the lualine theme).

local colorutils = require("singularity.colorutils")
local blend_hex = colorutils.blend_hex

local M = {}

-- Optional configuration. The colorscheme works fully without calling setup().
M.config = {
  italics = true,          -- italic comments / emphasis (#40)
  transparent = false,     -- clear editor + gutter + float backgrounds (#103, #41)
  dim_inactive = false,    -- dimmer background for inactive (NormalNC) windows (#37)
  colored_headings = true, -- per-level markdown heading colours (#80)
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

local function build_palette(bg)
  local base00 = "#161616"
  local base06 = "#ffffff"
  local base09 = "#78a9ff"

  -- Dark palette. base10 / base12 are the ember accents.
  local dark = {
    base00 = base00,
    base01 = blend_hex(base00, base06, 0.085),
    base02 = blend_hex(base00, base06, 0.18),
    base03 = blend_hex(base00, base06, 0.3),
    base04 = blend_hex(base00, base06, 0.82),
    base05 = blend_hex(base00, base06, 0.95),
    base06 = base06,
    base07 = "#08bdba",
    base08 = "#3ddbd9",
    base09 = base09,
    base10 = "#dd5500", -- ember-bright
    base11 = "#33b1ff",
    base12 = "#ee6611", -- ember-hot
    base13 = "#42be65",
    base14 = "#be95ff",
    base15 = "#82cfff",
    blend = "#131313",
    none = "NONE",
  }

  -- Light palette: a legible tonal counterpart (see README). Ember in the same
  -- roles via deeper shades; cool blue/teal syntax; Material blue-grey ramp.
  local light = {
    base00 = base06,
    base01 = "#eceff1",
    base02 = "#cfd8dc",
    base03 = "#78828a",
    base04 = "#37474f",
    base05 = "#546e7a",
    base06 = "#263238",
    base07 = "#0e7c7b",
    base08 = "#0a8385",
    base09 = "#1a66d6",
    base10 = "#b34400", -- ember-deep
    base11 = "#0f52c4",
    base12 = "#c65300", -- ember
    base13 = "#2a8049",
    base14 = "#7b3fd4",
    base15 = "#0e7693",
    blend = "#f4f6f8",
    none = "NONE",
  }

  return (bg == "dark") and dark or light
end

-- Active palette for a background (defaults to current). No side effects.
function M.get_palette(bg)
  return build_palette(bg or vim.o.background)
end

-- Apply the colorscheme. Invoked by colors/singularity.lua and on :colorscheme.
function M.load()
  if vim.g.colors_name then
    vim.cmd.hi("clear")
  end
  vim.g.colors_name = "singularity"
  vim.o.termguicolors = true

  local cfg = M.config
  local c = build_palette(vim.o.background)
  M.colors = c

  -- Highlight setter that honours the `italics` option.
  local function hl(group, spec)
    if spec.italic and not cfg.italics then
      spec.italic = nil
    end
    vim.api.nvim_set_hl(0, group, spec)
  end

  vim.g["terminal_color_0"] = c.base01
  vim.g["terminal_color_1"] = c.base11
  vim.g["terminal_color_2"] = c.base14
  vim.g["terminal_color_3"] = c.base13
  vim.g["terminal_color_4"] = c.base09
  vim.g["terminal_color_5"] = c.base15
  vim.g["terminal_color_6"] = c.base08
  vim.g["terminal_color_7"] = c.base05
  vim.g["terminal_color_8"] = c.base03
  vim.g["terminal_color_9"] = c.base11
  vim.g["terminal_color_10"] = c.base14
  vim.g["terminal_color_11"] = c.base13
  vim.g["terminal_color_12"] = c.base09
  vim.g["terminal_color_13"] = c.base15
  vim.g["terminal_color_14"] = c.base07
  vim.g["terminal_color_15"] = c.base06
  hl("ColorColumn", {fg = c.none, bg = c.base01})
  hl("Cursor", {fg = c.base00, bg = c.base04})
  hl("CursorLine", {fg = c.none, bg = c.base01})
  hl("CursorColumn", {fg = c.none, bg = c.base01})
  hl("CursorLineNr", {fg = c.base04, bg = c.none})
  hl("QuickFixLine", {fg = c.none, bg = c.base01})
  hl("Error", {fg = c.base10, bg = c.base01})
  hl("LineNr", {fg = c.base03, bg = c.base00})
  hl("NonText", {fg = c.base02, bg = c.none})
  hl("Normal", {fg = c.base04, bg = c.base00})
  hl("Pmenu", {fg = c.base04, bg = c.base01})
  hl("PmenuSbar", {fg = c.base04, bg = c.base01})
  hl("PmenuSel", {fg = c.base08, bg = c.base02})
  hl("PmenuThumb", {fg = c.base08, bg = c.base02})
  hl("SpecialKey", {fg = c.base03, bg = c.none})
  hl("Visual", {fg = c.none, bg = c.base02})
  hl("VisualNOS", {fg = c.none, bg = c.base02})
  hl("TooLong", {fg = c.none, bg = c.base02})
  hl("Debug", {fg = c.base13, bg = c.none})
  hl("Macro", {fg = c.base07, bg = c.none})
  hl("MatchParen", {fg = c.none, bg = c.base02, underline = true})
  hl("Bold", {fg = c.none, bg = c.none, bold = true})
  hl("Italic", {fg = c.none, bg = c.none, italic = true})
  hl("Underlined", {fg = c.none, bg = c.none, underline = true})
  hl("DiagnosticWarn", {fg = c.base14, bg = c.none})
  hl("DiagnosticError", {fg = c.base10, bg = c.none})
  hl("DiagnosticInfo", {fg = c.base09, bg = c.none})
  hl("DiagnosticHint", {fg = c.base04, bg = c.none})
  hl("DiagnosticUnderlineWarn", {fg = c.base14, bg = c.none, undercurl = true})
  hl("DiagnosticUnderlineError", {fg = c.base10, bg = c.none, undercurl = true})
  hl("DiagnosticUnderlineInfo", {fg = c.base04, bg = c.none, undercurl = true})
  hl("DiagnosticUnderlineHint", {fg = c.base04, bg = c.none, undercurl = true})
  hl("HealthError", {fg = c.base10, bg = c.none})
  hl("HealthWarning", {fg = c.base14, bg = c.none})
  hl("HealthSuccess", {fg = c.base13, bg = c.none})
  hl("@comment", {link = "Comment"})
  hl("@text.literal.commodity", {fg = c.base13, bg = c.none})
  hl("@number", {fg = c.base09, bg = c.none})
  hl("@number.date", {fg = c.base08, bg = c.none})
  hl("@number.date.effective", {fg = c.base13, bg = c.none})
  hl("@number.interval", {fg = c.base09, bg = c.none})
  hl("@number.status", {fg = c.base12, bg = c.none})
  hl("@number.quantity", {fg = c.base11, bg = c.none})
  hl("@number.quantity.negative", {fg = c.base10, bg = c.none})
  hl("LspCodeLens", {fg = c.none, bg = c.base03})
  hl("LspReferenceText", {fg = c.none, bg = c.base03})
  hl("LspReferenceRead", {fg = c.none, bg = c.base03})
  hl("LspReferenceWrite", {fg = c.none, bg = c.base03})
  hl("LspSignatureActiveParameter", {fg = c.base08, bg = c.none})
  hl("@lsp.type.class", {link = "Structure"})
  hl("@lsp.type.decorator", {link = "Decorator"})
  hl("@lsp.type.decorator.markdown", {link = "Structure"})
  hl("@lsp.type.function", {link = "@function"})
  hl("@lsp.type.macro", {link = "Macro"})
  hl("@lsp.type.method", {link = "@function"})
  hl("@lsp.type.struct", {link = "Structure"})
  hl("@lsp.type.type", {link = "Type"})
  hl("@lsp.type.typeParameter", {link = "Typedef"})
  hl("@lsp.type.selfParameter", {link = "@variable.builtin"})
  hl("@lsp.type.builtinConstant", {link = "@constant.builtin"})
  hl("@lsp.type.magicFunction", {link = "@function.builtin"})
  hl("@lsp.type.boolean", {link = "@boolean"})
  hl("@lsp.type.builtinType", {link = "@type.builtin"})
  hl("@lsp.type.comment", {link = "@comment"})
  hl("@lsp.type.enum", {link = "@type"})
  hl("@lsp.type.enumMember", {link = "@constant"})
  hl("@lsp.type.escapeSequence", {link = "@string.escape"})
  hl("@lsp.type.formatSpecifier", {link = "@punctuation.special"})
  hl("@lsp.type.keyword", {link = "@keyword"})
  hl("@lsp.type.namespace", {link = "@namespace"})
  hl("@lsp.type.number", {link = "@number"})
  hl("@lsp.type.operator", {link = "@operator"})
  hl("@lsp.type.parameter", {link = "@parameter"})
  hl("@lsp.type.property", {link = "@property"})
  hl("@lsp.type.selfKeyword", {link = "@variable.builtin"})
  hl("@lsp.type.string.rust", {link = "@string"})
  hl("@lsp.type.typeAlias", {link = "@type.definition"})
  hl("@lsp.type.unresolvedReference", {link = "Error"})
  hl("@lsp.type.variable", {link = "@variable"})
  hl("@lsp.mod.readonly", {link = "@constant"})
  hl("@lsp.mod.typeHint", {link = "Type"})
  hl("@lsp.mod.builtin", {link = "Special"})
  hl("@lsp.typemod.class.defaultLibrary", {link = "@type.builtin"})
  hl("@lsp.typemod.enum.defaultLibrary", {link = "@type.builtin"})
  hl("@lsp.typemod.enumMember.defaultLibrary", {link = "@constant.builtin"})
  hl("@lsp.typemod.function.defaultLibrary", {link = "@function.builtin"})
  hl("@lsp.typemod.keyword.async", {link = "@keyword.coroutine"})
  hl("@lsp.typemod.macro.defaultLibrary", {link = "@function.builtin"})
  hl("@lsp.typemod.method.defaultLibrary", {link = "@function.builtin"})
  hl("@lsp.typemod.operator.injected", {link = "@operator"})
  hl("@lsp.typemod.string.injected", {link = "@string"})
  hl("@lsp.typemod.operator.controlFlow", {link = "@exception"})
  hl("@lsp.typemod.keyword.documentation", {link = "Special"})
  hl("@lsp.typemod.variable.global", {link = "@constant"})
  hl("@lsp.typemod.variable.static", {link = "@constant"})
  hl("@lsp.typemod.variable.defaultLibrary", {link = "Special"})
  hl("@lsp.typemod.function.builtin", {link = "@function.builtin"})
  hl("@lsp.typemod.function.readonly", {link = "@method"})
  hl("@lsp.typemod.variable.defaultLibrary", {link = "@variable.builtin"})
  hl("@lsp.typemod.variable.injected", {link = "@variable"})
  hl("Folded", {fg = c.base02, bg = c.base01})
  hl("FoldColumn", {fg = c.base01, bg = c.base00})
  hl("SignColumn", {fg = c.base01, bg = c.base00})
  hl("Directory", {fg = c.base08, bg = c.none})
  hl("EndOfBuffer", {fg = c.base01, bg = c.none})
  hl("ErrorMsg", {fg = c.base10, bg = c.none})
  hl("ModeMsg", {fg = c.base04, bg = c.none})
  hl("MoreMsg", {fg = c.base08, bg = c.none})
  hl("Question", {fg = c.base04, bg = c.none})
  hl("Substitute", {fg = c.base01, bg = c.base08})
  hl("WarningMsg", {fg = c.base14, bg = c.none})
  hl("WildMenu", {fg = c.base08, bg = c.base01})
  hl("helpHyperTextJump", {fg = c.base08, bg = c.none})
  hl("helpSpecial", {fg = c.base09, bg = c.none})
  hl("helpHeadline", {fg = c.base10, bg = c.none})
  hl("helpHeader", {fg = c.base15, bg = c.none})
  hl("DiffAdded", {fg = c.base07, bg = c.none})
  hl("DiffChanged", {fg = c.base09, bg = c.none})
  hl("DiffRemoved", {fg = c.base10, bg = c.none})
  hl("DiffAdd", {bg = "#122f2f", fg = c.none})
  hl("DiffChange", {bg = "#222a39", fg = c.none})
  hl("DiffText", {bg = "#2f3f5c", fg = c.none})
  hl("DiffDelete", {bg = "#361c28", fg = c.none})
  hl("IncSearch", {fg = c.base06, bg = c.base10})
  hl("Search", {fg = c.base01, bg = c.base08})
  hl("TabLine", {link = "StatusLineNC"})
  hl("TabLineFill", {link = "TabLine"})
  hl("TabLineSel", {link = "StatusLine"})
  hl("Title", {fg = c.base04, bg = c.none})
  hl("VertSplit", {fg = c.base01, bg = c.base00})
  hl("WinSeparator", {fg = c.base01, bg = c.base00})
  hl("Boolean", {fg = c.base09, bg = c.none})
  hl("Character", {fg = c.base14, bg = c.none})
  hl("Comment", {fg = c.base03, bg = c.none, italic = true})
  hl("Conceal", {fg = c.none, bg = c.none})
  hl("Conditional", {fg = c.base09, bg = c.none})
  hl("Constant", {fg = c.base04, bg = c.none})
  hl("Decorator", {fg = c.base12, bg = c.none})
  hl("Define", {fg = c.base09, bg = c.none})
  hl("Delimeter", {fg = c.base06, bg = c.none})
  hl("Exception", {fg = c.base09, bg = c.none})
  hl("Float", {link = "Number"})
  hl("Function", {fg = c.base08, bg = c.none})
  hl("Identifier", {fg = c.base04, bg = c.none})
  hl("Include", {fg = c.base09, bg = c.none})
  hl("Keyword", {fg = c.base09, bg = c.none})
  hl("Label", {fg = c.base09, bg = c.none})
  hl("Number", {fg = c.base15, bg = c.none})
  hl("Operator", {fg = c.base09, bg = c.none})
  hl("PreProc", {fg = c.base09, bg = c.none})
  hl("Repeat", {fg = c.base09, bg = c.none})
  hl("Special", {fg = c.base04, bg = c.none})
  hl("SpecialChar", {fg = c.base04, bg = c.none})
  hl("SpecialComment", {fg = c.base08, bg = c.none})
  hl("Statement", {fg = c.base09, bg = c.none})
  hl("StorageClass", {fg = c.base09, bg = c.none})
  hl("String", {fg = c.base14, bg = c.none})
  hl("Structure", {fg = c.base09, bg = c.none})
  hl("Tag", {fg = c.base04, bg = c.none})
  hl("Todo", {fg = c.base13, bg = c.none})
  hl("Type", {fg = c.base09, bg = c.none})
  hl("Typedef", {fg = c.base09, bg = c.none})
  hl("markdownBlockquote", {fg = c.base08, bg = c.none})
  hl("markdownBold", {link = "Bold"})
  hl("markdownItalic", {link = "Italic"})
  hl("markdownBoldItalic", {fg = c.none, bg = c.none, bold = true, italic = true})
  hl("markdownRule", {link = "Comment"})
  hl("markdownH1", {fg = c.base10, bg = c.none})
  hl("markdownH2", {link = "markdownH1"})
  hl("markdownH3", {link = "markdownH1"})
  hl("markdownH4", {link = "markdownH1"})
  hl("markdownH5", {link = "markdownH1"})
  hl("markdownH6", {link = "markdownH1"})
  hl("markdownHeadingDelimiter", {link = "markdownH1"})
  hl("markdownHeadingRule", {link = "markdownH1"})
  hl("markdownUrl", {fg = c.base14, bg = c.none, underline = true})
  hl("markdownCode", {link = "String"})
  hl("markdownCodeBlock", {link = "markdownCode"})
  hl("markdownCodeDelimiter", {link = "markdownCode"})
  hl("markdownUrl", {link = "String"})
  hl("markdownListMarker", {fg = c.base08, bg = c.none})
  hl("markdownOrderedListMarker", {fg = c.base08, bg = c.none})
  hl("@markup", {link = "@none"})
  hl("@markup.environment", {link = "Macro"})
  hl("@markup.environment.name", {link = "Type"})
  hl("@markup.emphasis", {italic = true})
  hl("@markup.italic", {italic = true})
  hl("@markup.strikethrough", {strikethrough = true})
  hl("@markup.strong", {bold = true})
  hl("@markup.underline", {underline = true})
  hl("@markup.heading", {link = "Title"})
  hl("@markup.heading.marker", {link = "markdownHeadingDelimiter"})
  hl("@markup.heading.1.markdown", {link = "markdownH1"})
  hl("@markup.heading.2.markdown", {link = "markdownH1"})
  hl("@markup.heading.3.markdown", {link = "markdownH1"})
  hl("@markup.heading.4.markdown", {link = "markdownH1"})
  hl("@markup.heading.5.markdown", {link = "markdownH1"})
  hl("@markup.heading.6.markdown", {link = "markdownH1"})
  hl("@markup.heading.7.markdown", {link = "markdownH1"})
  hl("@markup.heading.8.markdown", {link = "markdownH1"})
  hl("@markup.link", {link = "markdownUrl"})
  hl("@markup.link.label", {underline = true})
  hl("@markup.link.label.symbol", {link = "markdownItalic"})
  hl("@markup.link.label.markdown_inline", {link = "markdownItalic"})
  hl("@markup.link.title", {link = "Title"})
  hl("@markup.link.url", {link = "markdownUrl"})
  hl("@markup.link.destination", {link = "markdownUrl"})
  hl("@markup.link.description", {fg = c.blend, underline = true, italic = true})
  hl("@markup.list", {link = "markdownListMarker"})
  hl("@markup.list.bullet", {link = "markdownListMarker"})
  hl("@markup.list.checked", {link = "markdownListMarker"})
  hl("@markup.list.markdown", {link = "markdownListMarker"})
  hl("@markup.list.ordered", {link = "markdownOrderedListMarker"})
  hl("@markup.list.unchecked", {link = "markdownListMarker"})
  hl("@markup.math", {link = "Special"})
  hl("@markup.raw", {link = "String"})
  hl("@markup.raw.markdown_inline", {link = "String"})
  hl("@markup.quote", {link = "markdownBlockquote"})
  hl("@markup.literal", {link = "markdownCode"})
  hl("@markup.code.block", {link = "markdownCodeBlock"})
  hl("@markup.rule", {link = "Comment"})
  hl("asciidocAttributeEntry", {fg = c.base15, bg = c.none})
  hl("asciidocAttributeList", {link = "asciidocAttributeEntry"})
  hl("asciidocAttributeRef", {link = "asciidocAttributeEntry"})
  hl("asciidocHLabel", {link = "markdownH1"})
  hl("asciidocOneLineTitle", {link = "markdownH1"})
  hl("asciidocQuotedMonospaced", {link = "markdownBlockquote"})
  hl("asciidocURL", {link = "markdownUrl"})
  hl("@comment", {link = "Comment"})
  hl("@error", {fg = c.base11, bg = c.none})
  hl("@operator", {link = "Operator"})
  hl("@punctuation.delimiter", {fg = c.base08, bg = c.none})
  hl("@punctuation.bracket", {fg = c.base08, bg = c.none})
  hl("@punctuation.special", {fg = c.base08, bg = c.none})
  hl("@string", {link = "String"})
  hl("@string.regex", {fg = c.base07, bg = c.none})
  hl("@string.escape", {fg = c.base15, bg = c.none})
  hl("@character", {link = "Character"})
  hl("@boolean", {link = "Boolean"})
  hl("@number", {link = "Number"})
  hl("@float", {link = "Float"})
  hl("@function", {fg = c.base12, bg = c.none, bold = true})
  hl("@function.builtin", {fg = c.base12, bg = c.none})
  hl("@function.macro", {fg = c.base07, bg = c.none})
  hl("@method", {fg = c.base07, bg = c.none})
  hl("@constructor", {fg = c.base09, bg = c.none})
  hl("@parameter", {fg = c.base04, bg = c.none})
  hl("@keyword", {fg = c.base09, bg = c.none})
  hl("@keyword.function", {fg = c.base08, bg = c.none})
  hl("@keyword.operator", {fg = c.base08, bg = c.none})
  hl("@conditional", {fg = c.base09, bg = c.none})
  hl("@repeat", {fg = c.base09, bg = c.none})
  hl("@label", {fg = c.base15, bg = c.none})
  hl("@include", {fg = c.base09, bg = c.none})
  hl("@exception", {fg = c.base15, bg = c.none})
  hl("@type", {link = "Type"})
  hl("@type.builtin", {link = "Type"})
  hl("@attribute", {fg = c.base15, bg = c.none})
  hl("@field", {fg = c.base04, bg = c.none})
  hl("@property", {fg = c.base10, bg = c.none})
  hl("@variable", {fg = c.base04, bg = c.none})
  hl("@variable.builtin", {fg = c.base04, bg = c.none})
  hl("@constant", {fg = c.base14, bg = c.none})
  hl("@constant.builtin", {fg = c.base07, bg = c.none})
  hl("@constant.macro", {fg = c.base07, bg = c.none})
  hl("@namespace", {fg = c.base07, bg = c.none})
  hl("@symbol", {fg = c.base15, bg = c.none, bold = true})
  hl("@text", {fg = c.base04, bg = c.none})
  hl("@text.strong", {fg = c.none, bg = c.none})
  hl("@text.emphasis", {fg = c.base10, bg = c.none, bold = true})
  hl("@text.underline", {fg = c.base10, bg = c.none, underline = true})
  hl("@text.strike", {fg = c.base10, bg = c.none, strikethrough = true})
  hl("@text.title", {fg = c.base10, bg = c.none})
  hl("@text.literal", {fg = c.base04, bg = c.none})
  hl("@text.uri", {fg = c.base14, bg = c.none, underline = true})
  hl("@tag", {fg = c.base09, bg = c.none})
  hl("@tag.attribute", {fg = c.base15, bg = c.none})
  hl("@tag.delimiter", {fg = c.base15, bg = c.none})
  hl("@tag.builtin.tsx", {link = "@tag.tsx"})
  hl("@reference", {fg = c.base04, bg = c.none})
  hl("NvimInternalError", {fg = c.base00, bg = c.base08})
  hl("NormalFloat", {fg = c.base05, bg = c.blend})
  hl("FloatBorder", {fg = c.blend, bg = c.blend})
  hl("NormalNC", {fg = c.base04, bg = c.base00})
  hl("TermCursor", {fg = c.base00, bg = c.base04})
  hl("TermCursorNC", {fg = c.base00, bg = c.base04})
  hl("StatusLine", {fg = c.base04, bg = c.base00})
  hl("StatusLineNC", {fg = c.base04, bg = c.base01})
  hl("StatusReplace", {fg = c.base00, bg = c.base08})
  hl("StatusInsert", {fg = c.base00, bg = c.base12})
  hl("StatusVisual", {fg = c.base00, bg = c.base14})
  hl("StatusTerminal", {fg = c.base00, bg = c.base11})
  hl("StatusNormal", {fg = c.base00, bg = c.base15})
  hl("StatusCommand", {fg = c.base00, bg = c.base13})
  hl("StatusLineDiagnosticWarn", {fg = c.base14, bg = c.base00, bold = true})
  hl("StatusLineDiagnosticError", {fg = c.base10, bg = c.base00, bold = true})
  hl("TelescopeBorder", {fg = c.blend, bg = c.blend})
  hl("TelescopePromptBorder", {fg = c.base02, bg = c.base02})
  hl("TelescopePromptNormal", {fg = c.base05, bg = c.base02})
  hl("TelescopePromptPrefix", {fg = c.base08, bg = c.base02})
  hl("TelescopeNormal", {fg = c.none, bg = c.blend})
  hl("TelescopePreviewTitle", {fg = c.base02, bg = c.base12})
  hl("TelescopePromptTitle", {fg = c.base02, bg = c.base11})
  hl("TelescopeResultsTitle", {fg = c.blend, bg = c.blend})
  hl("TelescopeSelection", {fg = c.none, bg = c.base02})
  hl("TelescopePreviewLine", {fg = c.none, bg = c.base01})
  hl("TelescopeMatching", {fg = c.base08, bg = c.none, bold = true, italic = true})
  hl("NotifyERRORBorder", {fg = c.base08, bg = c.none})
  hl("NotifyWARNBorder", {fg = c.base14, bg = c.none})
  hl("NotifyINFOBorder", {fg = c.base05, bg = c.none})
  hl("NotifyDEBUGBorder", {fg = c.base13, bg = c.none})
  hl("NotifyTRACEBorder", {fg = c.base13, bg = c.none})
  hl("NotifyERRORIcon", {fg = c.base08, bg = c.none})
  hl("NotifyWARNIcon", {fg = c.base14, bg = c.none})
  hl("NotifyINFOIcon", {fg = c.base05, bg = c.none})
  hl("NotifyDEBUGIcon", {fg = c.base13, bg = c.none})
  hl("NotifyTRACEIcon", {fg = c.base13, bg = c.none})
  hl("NotifyERRORTitle", {fg = c.base08, bg = c.none})
  hl("NotifyWARNTitle", {fg = c.base14, bg = c.none})
  hl("NotifyINFOTitle", {fg = c.base05, bg = c.none})
  hl("NotifyDEBUGTitle", {fg = c.base13, bg = c.none})
  hl("NotifyTRACETitle", {fg = c.base13, bg = c.none})
  hl("CmpItemAbbr", {fg = "#adadad", bg = c.none})
  hl("CmpItemAbbrMatch", {fg = c.base05, bg = c.none, bold = true})
  hl("CmpItemAbbrMatchFuzzy", {fg = c.base04, bg = c.none, bold = true})
  hl("CmpItemMenu", {fg = c.base04, bg = c.none, italic = true})
  hl("CmpItemKindInterface", {fg = c.base08})
  hl("CmpItemKindColor", {fg = c.base08})
  hl("CmpItemKindTypeParameter", {fg = c.base08})
  hl("CmpItemKindText", {fg = c.base09})
  hl("CmpItemKindEnum", {fg = c.base09})
  hl("CmpItemKindKeyword", {fg = c.base09})
  hl("CmpItemKindConstant", {fg = c.base10})
  hl("CmpItemKindConstructor", {fg = c.base10})
  hl("CmpItemKindReference", {fg = c.base10})
  hl("CmpItemKindFunction", {fg = c.base11})
  hl("CmpItemKindStruct", {fg = c.base11})
  hl("CmpItemKindClass", {fg = c.base11})
  hl("CmpItemKindModule", {fg = c.base11})
  hl("CmpItemKindOperator", {fg = c.base11})
  hl("CmpItemKindField", {fg = c.base12})
  hl("CmpItemKindProperty", {fg = c.base12})
  hl("CmpItemKindEvent", {fg = c.base12})
  hl("CmpItemKindUnit", {fg = c.base13})
  hl("CmpItemKindSnippet", {fg = c.base13})
  hl("CmpItemKindFolder", {fg = c.base13})
  hl("CmpItemKindVariable", {fg = c.base14})
  hl("CmpItemKindFile", {fg = c.base14})
  hl("CmpItemKindMethod", {fg = c.base15})
  hl("CmpItemKindValue", {fg = c.base15})
  hl("CmpItemKindEnumMember", {fg = c.base15})
  hl("NvimTreeImageFile", {fg = c.base12, bg = c.none})
  hl("NvimTreeFolderIcon", {fg = c.base12, bg = c.none})
  hl("NvimTreeWinSeparator", {fg = c.base00, bg = c.base00})
  hl("NvimTreeFolderName", {fg = c.base09, bg = c.none})
  hl("NvimTreeIndentMarker", {fg = c.base02, bg = c.none})
  hl("NvimTreeEmptyFolderName", {fg = c.base15, bg = c.none})
  hl("NvimTreeOpenedFolderName", {fg = c.base15, bg = c.none})
  hl("NvimTreeNormal", {fg = c.base04, bg = c.base00})
  hl("NeogitBranch", {fg = c.base10, bg = c.none})
  hl("NeogitRemote", {fg = c.base09, bg = c.none})
  hl("NeogitHunkHeader", {fg = c.base04, bg = c.base02})
  hl("NeogitHunkHeaderHighlight", {fg = c.base04, bg = c.base03})
  hl("GitSignsCurrentLineBlame", {link = "Comment"})
  hl("HydraRed", {fg = c.base12, bg = c.none})
  hl("HydraBlue", {fg = c.base09, bg = c.none})
  hl("HydraAmaranth", {fg = c.base10, bg = c.none})
  hl("HydraTeal", {fg = c.base08, bg = c.none})
  hl("HydraHint", {fg = c.none, bg = c.blend})
  hl("alpha1", {fg = c.base03, bg = c.none})
  hl("alpha2", {fg = c.base04, bg = c.none})
  hl("alpha3", {fg = c.base03, bg = c.none})
  hl("CodeBlock", {fg = c.none, bg = c.base01})
  hl("BufferLineDiagnostic", {fg = c.base10, bg = c.none, bold = true})
  hl("BufferLineDiagnosticVisible", {fg = c.base10, bg = c.none, bold = true})
  hl("htmlH1", {link = "markdownH1"})
  hl("mkdRule", {link = "markdownRule"})
  hl("mkdListItem", {link = "markdownListMarker"})
  hl("mkdListItemCheckbox", {link = "markdownListMarker"})
  hl("VimwikiHeader1", {link = "markdownH1"})
  hl("VimwikiHeader2", {link = "markdownH1"})
  hl("VimwikiHeader3", {link = "markdownH1"})
  hl("VimwikiHeader4", {link = "markdownH1"})
  hl("VimwikiHeader5", {link = "markdownH1"})
  hl("VimwikiHeader6", {link = "markdownH1"})
  hl("VimwikiHeaderChar", {link = "markdownH1"})
  hl("VimwikiList", {link = "markdownListMarker"})
  hl("VimwikiLink", {link = "markdownUrl"})
  hl("VimwikiCode", {link = "markdownCode"})
  hl("FlashLabel", {fg = c.base05, bg = c.base00, bold = true})

  -- ── Issue fixes ───────────────────────────────────────
  hl("Folded", { fg = c.base04, bg = c.base01 })       -- #86 fg was base02 (too dark)
  hl("@text.underline", { underline = true })          -- #101 underline, not ember text
  hl("CurSearch", { link = "IncSearch" })              -- #91 current search match
  hl("Added", { link = "DiffAdded" })                  -- #101 builtin diff base groups
  hl("Changed", { link = "DiffChanged" })
  hl("Removed", { link = "DiffRemoved" })
  hl("@diff.plus", { link = "DiffAdded" })             -- #101 treesitter diff captures
  hl("@diff.minus", { link = "DiffRemoved" })
  hl("@diff.delta", { link = "DiffChanged" })

  -- Per-level markdown headings (#80). Set colored_headings = false to disable.
  if cfg.colored_headings then
    local levels = { c.base10, c.base11, c.base08, c.base13, c.base14, c.base15 }
    for i, colour in ipairs(levels) do
      hl("markdownH" .. i, { fg = colour, bold = true })
      hl("@markup.heading." .. i .. ".markdown", { link = "markdownH" .. i })
    end
  end

  -- Light-mode fixups (#59 LSP references, IncSearch fg). Dark is unaffected.
  if vim.o.background == "light" then
    hl("IncSearch", { fg = c.base00, bg = c.base10 })
    hl("LspReferenceText", { bg = c.base02 })
    hl("LspReferenceRead", { bg = c.base02 })
    hl("LspReferenceWrite", { bg = c.base02 })
  end

  -- Dim inactive windows (#37).
  if cfg.dim_inactive then
    local dim = (vim.o.background == "dark") and c.blend or c.base01
    hl("NormalNC", { fg = c.base04, bg = dim })
  end

  -- Transparency (#103, #41): clear editor, gutter and float backgrounds.
  if cfg.transparent then
    local groups = {
      "Normal", "NormalNC", "NormalFloat", "FloatBorder", "SignColumn", "FoldColumn",
      "LineNr", "CursorLineNr", "EndOfBuffer", "WinSeparator", "VertSplit",
      "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeWinSeparator",
      "TelescopeNormal", "TelescopeBorder",
    }
    for _, g in ipairs(groups) do
      local current = vim.api.nvim_get_hl(0, { name = g })
      current.bg = nil
      current.ctermbg = nil
      vim.api.nvim_set_hl(0, g, current)
    end
  end

  return c
end

return M
