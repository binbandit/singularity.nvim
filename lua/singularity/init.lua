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
  variant = "auto",        -- "auto" follows &background; or "dark" | "light" | "paper"
  italics = true,          -- italic comments / emphasis (#40)
  transparent = false,     -- clear editor + gutter + float backgrounds (#103, #41)
  dim_inactive = false,    -- dimmer background for inactive (NormalNC) windows (#37)
  colored_headings = true, -- per-level markdown heading colours (#80)
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Resolve which palette to use: an explicit override wins, else config.variant,
-- else follow &background. "auto" maps to dark/light from &background.
local function resolve_variant(override)
  local v = override or M.config.variant or "auto"
  if v == "auto" then
    return (vim.o.background == "light") and "light" or "dark"
  end
  return v
end

local function build_palette(variant)
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
    yellow = "#d2a106", -- icons / hipatterns accent (base16 has no yellow slot)
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
    yellow = "#8a6700", -- icons / hipatterns accent (legible amber on white)
    blend = "#f4f6f8",
    none = "NONE",
  }

  -- Paper palette: a warm, low-glare light variant on aged-cream stock. Same
  -- ember signature; sepia grey ramp; accents darkened to stay WCAG-AA on cream.
  local paper = {
    base00 = "#f4ecd8",
    base01 = "#ebe2c9",
    base02 = "#dcd1b4",
    base03 = "#897e62",
    base04 = "#433c2b",
    base05 = "#655c45",
    base06 = "#2a2516",
    base07 = "#0c6f64",
    base08 = "#0a6f69",
    base09 = "#1f51a8",
    base10 = "#a83e00", -- ember-deep
    base11 = "#1a44a6",
    base12 = "#ab4400", -- ember
    base13 = "#3c6e1e",
    base14 = "#6a3ab8",
    base15 = "#0c6a80",
    yellow = "#7a5c00",
    blend = "#efe6d0",
    none = "NONE",
  }

  if variant == "paper" then return paper end
  if variant == "light" then return light end
  return dark
end

-- Active palette for a variant (defaults to the configured/auto one). No side effects.
function M.get_palette(variant)
  return build_palette(resolve_variant(variant))
end

-- Apply the colorscheme. Invoked by the colors/ entries and on :colorscheme.
-- `override` forces a variant ("dark"/"light"/"paper"); nil uses config/auto.
function M.load(override)
  local variant = resolve_variant(override)
  if vim.g.colors_name then
    vim.cmd.hi("clear")
  end
  vim.g.colors_name = "singularity"
  vim.o.termguicolors = true
  -- paper and light are light-background variants; keep &background in sync.
  vim.o.background = (variant == "dark") and "dark" or "light"

  local cfg = M.config
  local c = build_palette(variant)
  M.colors = c
  M.variant = variant

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

  -- ── mini.nvim — https://github.com/nvim-mini/mini.nvim ──────────────────
  -- Group names validated against upstream mini.hues; links keep them in sync
  -- with dark/light, transparency and config automatically.
  -- mini.statusline
  hl("MiniStatuslineModeNormal", { link = "StatusNormal" })
  hl("MiniStatuslineModeInsert", { link = "StatusInsert" })
  hl("MiniStatuslineModeVisual", { link = "StatusVisual" })
  hl("MiniStatuslineModeReplace", { link = "StatusReplace" })
  hl("MiniStatuslineModeCommand", { link = "StatusCommand" })
  hl("MiniStatuslineModeOther", { link = "StatusTerminal" })
  hl("MiniStatuslineDevinfo", { link = "StatusLine" })
  hl("MiniStatuslineFileinfo", { link = "StatusLine" })
  hl("MiniStatuslineFilename", { link = "StatusLineNC" })
  hl("MiniStatuslineInactive", { link = "StatusLineNC" })
  -- mini.tabline
  hl("MiniTablineCurrent", { link = "TabLineSel" })
  hl("MiniTablineVisible", { link = "TabLine" })
  hl("MiniTablineHidden", { link = "TabLine" })
  hl("MiniTablineModifiedCurrent", { link = "TabLineSel" })
  hl("MiniTablineModifiedVisible", { link = "TabLine" })
  hl("MiniTablineModifiedHidden", { link = "TabLine" })
  hl("MiniTablineFill", { link = "TabLineFill" })
  hl("MiniTablineTabpagesection", { link = "TabLineSel" })
  hl("MiniTablineTrunc", { link = "TabLine" })
  -- mini.pick
  hl("MiniPickBorder", { link = "TelescopeBorder" })
  hl("MiniPickBorderBusy", { link = "TelescopeBorder" })
  hl("MiniPickBorderText", { link = "TelescopePromptTitle" })
  hl("MiniPickCursor", { link = "Cursor" })
  hl("MiniPickIconDirectory", { link = "Directory" })
  hl("MiniPickIconFile", { link = "Normal" })
  hl("MiniPickHeader", { link = "Title" })
  hl("MiniPickMatchCurrent", { link = "TelescopeSelection" })
  hl("MiniPickMatchMarked", { link = "Todo" })
  hl("MiniPickMatchRanges", { link = "TelescopeMatching" })
  hl("MiniPickNormal", { link = "TelescopeNormal" })
  hl("MiniPickPreviewLine", { link = "TelescopePreviewLine" })
  hl("MiniPickPreviewRegion", { link = "Visual" })
  hl("MiniPickPrompt", { link = "TelescopePromptNormal" })
  hl("MiniPickPromptCaret", { link = "TelescopePromptNormal" })
  hl("MiniPickPromptPrefix", { link = "TelescopePromptPrefix" })
  -- mini.files
  hl("MiniFilesNormal", { link = "NormalFloat" })
  hl("MiniFilesBorder", { link = "FloatBorder" })
  hl("MiniFilesBorderModified", { link = "DiagnosticWarn" })
  hl("MiniFilesCursorLine", { link = "CursorLine" })
  hl("MiniFilesDirectory", { link = "Directory" })
  hl("MiniFilesFile", { link = "Normal" })
  hl("MiniFilesTitle", { link = "Title" })
  hl("MiniFilesTitleFocused", { fg = c.base10, bold = true })
  -- mini.icons (base16 has no yellow; uses c.yellow)
  hl("MiniIconsAzure", { fg = c.base11 })
  hl("MiniIconsBlue", { fg = c.base09 })
  hl("MiniIconsCyan", { fg = c.base07 })
  hl("MiniIconsGreen", { fg = c.base13 })
  hl("MiniIconsGrey", { fg = c.base05 })
  hl("MiniIconsOrange", { fg = c.base12 })
  hl("MiniIconsPurple", { fg = c.base14 })
  hl("MiniIconsRed", { fg = c.base10 })
  hl("MiniIconsYellow", { fg = c.yellow })
  -- mini.diff
  hl("MiniDiffSignAdd", { link = "DiffAdded" })
  hl("MiniDiffSignChange", { link = "DiffChanged" })
  hl("MiniDiffSignDelete", { link = "DiffRemoved" })
  hl("MiniDiffOverAdd", { link = "DiffAdd" })
  hl("MiniDiffOverChange", { link = "DiffChange" })
  hl("MiniDiffOverChangeBuf", { link = "DiffText" })
  hl("MiniDiffOverContext", { link = "Comment" })
  hl("MiniDiffOverContextBuf", { link = "Comment" })
  hl("MiniDiffOverDelete", { link = "DiffDelete" })
  -- mini.deps
  hl("MiniDepsChangeAdded", { link = "DiffAdded" })
  hl("MiniDepsChangeRemoved", { link = "DiffRemoved" })
  hl("MiniDepsHint", { link = "DiagnosticHint" })
  hl("MiniDepsInfo", { link = "DiagnosticInfo" })
  hl("MiniDepsMsgBreaking", { link = "DiagnosticWarn" })
  hl("MiniDepsPlaceholder", { link = "Comment" })
  hl("MiniDepsTitle", { link = "Title" })
  hl("MiniDepsTitleError", { link = "Error" })
  hl("MiniDepsTitleSame", { link = "Comment" })
  hl("MiniDepsTitleUpdate", { link = "DiffAdded" })
  -- mini.hipatterns
  hl("MiniHipatternsFixme", { fg = c.base00, bg = c.base10, bold = true })
  hl("MiniHipatternsHack", { fg = c.base00, bg = c.yellow, bold = true })
  hl("MiniHipatternsTodo", { fg = c.base00, bg = c.base11, bold = true })
  hl("MiniHipatternsNote", { fg = c.base00, bg = c.base13, bold = true })
  -- mini.clue
  hl("MiniClueBorder", { link = "FloatBorder" })
  hl("MiniClueTitle", { link = "Title" })
  hl("MiniClueDescGroup", { fg = c.base15 })
  hl("MiniClueDescSingle", { link = "NormalFloat" })
  hl("MiniClueNextKey", { fg = c.base08, bold = true })
  hl("MiniClueNextKeyWithPostkeys", { fg = c.base12, bold = true })
  hl("MiniClueSeparator", { link = "WinSeparator" })
  -- mini.starter
  hl("MiniStarterHeader", { fg = c.base10 })
  hl("MiniStarterFooter", { link = "Comment" })
  hl("MiniStarterInactive", { link = "Comment" })
  hl("MiniStarterItem", { link = "Normal" })
  hl("MiniStarterItemBullet", { fg = c.base08 })
  hl("MiniStarterItemPrefix", { fg = c.base12 })
  hl("MiniStarterSection", { fg = c.base11, bold = true })
  hl("MiniStarterQuery", { fg = c.base13, bold = true })
  hl("MiniStarterCurrent", { link = "CursorLine" })
  -- mini.notify
  hl("MiniNotifyNormal", { link = "NormalFloat" })
  hl("MiniNotifyBorder", { link = "FloatBorder" })
  hl("MiniNotifyTitle", { link = "Title" })
  hl("MiniNotifyLspProgress", { link = "Comment" })
  -- mini.jump / mini.jump2d
  hl("MiniJump", { link = "IncSearch" })
  hl("MiniJump2dSpot", { fg = c.base10, bold = true })
  hl("MiniJump2dSpotUnique", { fg = c.base12, bold = true })
  hl("MiniJump2dSpotAhead", { fg = c.base08 })
  hl("MiniJump2dDim", { link = "Comment" })
  -- mini.cursorword
  hl("MiniCursorword", { underline = true })
  hl("MiniCursorwordCurrent", { link = "MiniCursorword" })
  -- mini.indentscope
  hl("MiniIndentscopeSymbol", { fg = c.base03 })
  hl("MiniIndentscopeSymbolOff", { link = "MiniIndentscopeSymbol" })
  -- mini.map
  hl("MiniMapNormal", { link = "NormalFloat" })
  hl("MiniMapSymbolCount", { fg = c.base05 })
  hl("MiniMapSymbolLine", { fg = c.base11 })
  hl("MiniMapSymbolView", { fg = c.base03 })
  -- mini.snippets
  hl("MiniSnippetsCurrent", { sp = c.base08, underline = true })
  hl("MiniSnippetsCurrentReplace", { sp = c.base10, underline = true })
  hl("MiniSnippetsVisited", { sp = c.base13, underline = true })
  hl("MiniSnippetsUnvisited", { sp = c.base03, underline = true })
  hl("MiniSnippetsFinal", { sp = c.base14, underline = true })
  -- mini.test
  hl("MiniTestPass", { fg = c.base13 })
  hl("MiniTestFail", { fg = c.base10 })
  hl("MiniTestEmphasis", { bold = true })
  -- mini.completion
  hl("MiniCompletionActiveParameter", { link = "LspSignatureActiveParameter" })
  hl("MiniCompletionDeprecated", { fg = c.base03, strikethrough = true })
  hl("MiniCompletionInfoBorderOutdated", { link = "DiagnosticWarn" })
  -- mini.operators / mini.surround / mini.trailspace / mini.animate
  hl("MiniOperatorsExchangeFrom", { link = "Visual" })
  hl("MiniSurround", { link = "IncSearch" })
  hl("MiniTrailspace", { bg = c.base10 })
  hl("MiniAnimateCursor", { link = "Cursor" })
  hl("MiniAnimateNormalFloat", { link = "NormalFloat" })
  -- mini.cmdline (peek window)
  hl("MiniCmdlinePeekNormal", { link = "NormalFloat" })
  hl("MiniCmdlinePeekBorder", { link = "FloatBorder" })
  hl("MiniCmdlinePeekTitle", { link = "Title" })
  hl("MiniCmdlinePeekLineNr", { link = "LineNr" })
  hl("MiniCmdlinePeekSign", { link = "SignColumn" })
  hl("MiniCmdlinePeekSep", { link = "WinSeparator" })

  -- ── Popular third-party plugins ─────────────────────────────────────────
  -- Group names validated against upstream sources (plugin repos / catppuccin).
  -- Everything links to the theme's semantic groups so it tracks dark/light,
  -- transparency and config automatically.

  -- LSP-kind icons -> treesitter captures (nvim-navic, trouble symbols)
  local kind_link = {
    File = "Directory", Module = "@namespace", Namespace = "@namespace", Package = "@namespace",
    Class = "@type", Method = "@function", Property = "@property", Field = "@field",
    Constructor = "@constructor", Enum = "@type", Interface = "@type", Function = "@function",
    Variable = "@variable", Constant = "@constant", String = "@string", Number = "@number",
    Boolean = "@boolean", Array = "@punctuation.bracket", Object = "@type", Key = "@field",
    Null = "@constant.builtin", EnumMember = "@constant", Struct = "@type", Event = "@type",
    Operator = "@operator", TypeParameter = "@type",
  }
  for kind, target in pairs(kind_link) do
    hl("NavicIcons" .. kind, { link = target })
    hl("TroubleIcon" .. kind, { link = target })
  end
  hl("NavicText", { fg = c.base04 })
  hl("NavicSeparator", { link = "Comment" })

  -- completion kinds (CmpItemKind* defined above); mirror for blink.cmp / noice
  local cmp_kinds = {
    "Text", "Method", "Function", "Constructor", "Field", "Variable", "Class", "Interface",
    "Module", "Property", "Unit", "Value", "Enum", "Keyword", "Snippet", "Color", "File",
    "Reference", "Folder", "EnumMember", "Constant", "Struct", "Event", "Operator", "TypeParameter",
  }
  for _, kind in ipairs(cmp_kinds) do
    hl("BlinkCmpKind" .. kind, { link = "CmpItemKind" .. kind })
    hl("NoiceCompletionItemKind" .. kind, { link = "CmpItemKind" .. kind })
  end
  hl("BlinkCmpKindCopilot", { fg = c.base08 })
  hl("NoiceCompletionItemKindDefault", { fg = c.base05 })

  -- which-key.nvim (v3)
  hl("WhichKey", { fg = c.base08 })
  hl("WhichKeyGroup", { fg = c.base12 })
  hl("WhichKeyDesc", { fg = c.base04 })
  hl("WhichKeySeparator", { link = "Comment" })
  hl("WhichKeyValue", { fg = c.base05 })
  hl("WhichKeyNormal", { link = "NormalFloat" })
  hl("WhichKeyBorder", { link = "FloatBorder" })
  hl("WhichKeyTitle", { link = "Title" })
  hl("WhichKeyIcon", { fg = c.base11 })
  for _, col in ipairs({ "Azure", "Blue", "Cyan", "Green", "Grey", "Orange", "Purple", "Red", "Yellow" }) do
    hl("WhichKeyIcon" .. col, { link = "MiniIcons" .. col })
  end

  -- neo-tree.nvim
  hl("NeoTreeNormal", { link = "Normal" })
  hl("NeoTreeNormalNC", { link = "NormalNC" })
  hl("NeoTreeDirectoryName", { link = "Directory" })
  hl("NeoTreeDirectoryIcon", { link = "Directory" })
  hl("NeoTreeRootName", { fg = c.base10, bold = true })
  hl("NeoTreeFileNameOpened", { fg = c.base15 })
  hl("NeoTreeSymbolicLinkTarget", { fg = c.base14 })
  hl("NeoTreeIndentMarker", { fg = c.base02 })
  hl("NeoTreeExpander", { fg = c.base04 })
  hl("NeoTreeModified", { fg = c.base12 })
  hl("NeoTreeGitAdded", { link = "DiffAdded" })
  hl("NeoTreeGitConflict", { fg = c.base10 })
  hl("NeoTreeGitDeleted", { link = "DiffRemoved" })
  hl("NeoTreeGitIgnored", { link = "Comment" })
  hl("NeoTreeGitModified", { link = "DiffChanged" })
  hl("NeoTreeGitUnstaged", { fg = c.base12 })
  hl("NeoTreeGitUntracked", { fg = c.base14 })
  hl("NeoTreeGitStaged", { link = "DiffAdded" })
  hl("NeoTreeFloatBorder", { link = "FloatBorder" })
  hl("NeoTreeFloatTitle", { link = "Title" })
  hl("NeoTreeTitleBar", { fg = c.base00, bg = c.base10 })
  hl("NeoTreeDimText", { link = "Comment" })
  hl("NeoTreeFilterTerm", { fg = c.base08 })
  hl("NeoTreeTabActive", { fg = c.base10, bold = true })
  hl("NeoTreeTabInactive", { link = "Comment" })
  hl("NeoTreeTabSeparatorActive", { fg = c.base10 })
  hl("NeoTreeTabSeparatorInactive", { link = "WinSeparator" })
  hl("NeoTreeVertSplit", { link = "WinSeparator" })
  hl("NeoTreeWinSeparator", { link = "WinSeparator" })
  hl("NeoTreeStatusLineNC", { link = "StatusLineNC" })

  -- noice.nvim
  hl("NoiceCmdline", { link = "NormalFloat" })
  hl("NoiceCmdlineIcon", { fg = c.base12 })
  hl("NoiceCmdlineIconSearch", { fg = c.base15 })
  hl("NoiceCmdlinePopup", { link = "NormalFloat" })
  hl("NoiceCmdlinePopupBorder", { link = "FloatBorder" })
  hl("NoiceCmdlinePopupBorderSearch", { fg = c.base15 })
  hl("NoiceCmdlinePopupTitle", { link = "Title" })
  hl("NoiceCmdlinePrompt", { fg = c.base12 })
  hl("NoiceConfirm", { link = "NormalFloat" })
  hl("NoiceConfirmBorder", { link = "FloatBorder" })
  hl("NoicePopup", { link = "NormalFloat" })
  hl("NoicePopupBorder", { link = "FloatBorder" })
  hl("NoicePopupmenu", { link = "Pmenu" })
  hl("NoicePopupmenuBorder", { link = "FloatBorder" })
  hl("NoicePopupmenuMatch", { fg = c.base08, bold = true })
  hl("NoicePopupmenuSelected", { link = "PmenuSel" })
  hl("NoiceMini", { fg = c.base05 })
  hl("NoiceScrollbar", { link = "PmenuSbar" })
  hl("NoiceScrollbarThumb", { link = "PmenuThumb" })
  hl("NoiceSplit", { link = "NormalFloat" })
  hl("NoiceSplitBorder", { link = "FloatBorder" })
  hl("NoiceVirtualText", { fg = c.base14 })
  hl("NoiceCursor", { link = "Cursor" })
  hl("NoiceFormatProgressDone", { fg = c.base00, bg = c.base13 })
  hl("NoiceFormatProgressTodo", { fg = c.base00, bg = c.base02 })
  hl("NoiceLspProgressClient", { fg = c.base11 })
  hl("NoiceLspProgressSpinner", { fg = c.base12 })
  hl("NoiceLspProgressTitle", { fg = c.base04 })
  hl("NoiceFormatLevelDebug", { link = "Comment" })
  hl("NoiceFormatLevelTrace", { link = "Comment" })
  hl("NoiceFormatLevelOff", { link = "Comment" })
  hl("NoiceFormatLevelInfo", { link = "DiagnosticInfo" })
  hl("NoiceFormatLevelWarn", { link = "DiagnosticWarn" })
  hl("NoiceFormatLevelError", { link = "DiagnosticError" })

  -- lazy.nvim
  hl("LazyNormal", { link = "NormalFloat" })
  hl("LazyH1", { fg = c.base00, bg = c.base10, bold = true })
  hl("LazyH2", { link = "Title" })
  hl("LazyButton", { fg = c.base04, bg = c.base01 })
  hl("LazyButtonActive", { fg = c.base00, bg = c.base10 })
  hl("LazyComment", { link = "Comment" })
  hl("LazyDimmed", { link = "Comment" })
  hl("LazyProp", { fg = c.base05 })
  hl("LazyValue", { fg = c.base14 })
  hl("LazyDir", { link = "Directory" })
  hl("LazyUrl", { fg = c.base14, underline = true })
  hl("LazyCommit", { fg = c.base13 })
  hl("LazyCommitIssue", { fg = c.base15 })
  hl("LazyCommitType", { fg = c.base11 })
  hl("LazyCommitScope", { fg = c.base12 })
  hl("LazyProgressDone", { fg = c.base10 })
  hl("LazyProgressTodo", { fg = c.base02 })
  hl("LazySpecial", { fg = c.base08 })
  hl("LazyLocal", { fg = c.base13 })
  hl("LazyNoCond", { link = "DiagnosticWarn" })
  hl("LazyError", { link = "DiagnosticError" })
  hl("LazyWarning", { link = "DiagnosticWarn" })
  hl("LazyInfo", { link = "DiagnosticInfo" })
  hl("LazyReasonStart", { fg = c.base13 })
  hl("LazyReasonRuntime", { fg = c.base15 })
  hl("LazyReasonPlugin", { fg = c.base04 })
  hl("LazyReasonEvent", { fg = c.base14 })
  hl("LazyReasonKeys", { fg = c.base09 })
  hl("LazyReasonSource", { fg = c.base08 })
  hl("LazyReasonFt", { fg = c.base11 })
  hl("LazyReasonCmd", { fg = c.base07 })
  hl("LazyReasonImport", { fg = c.base05 })
  hl("LazyReasonRequire", { fg = c.base05 })

  -- mason.nvim
  hl("MasonHeader", { fg = c.base00, bg = c.base10, bold = true })
  hl("MasonHeaderSecondary", { fg = c.base00, bg = c.base12, bold = true })
  hl("MasonHeading", { fg = c.base04, bold = true })
  hl("MasonHighlight", { fg = c.base08 })
  hl("MasonHighlightBlock", { fg = c.base00, bg = c.base08 })
  hl("MasonHighlightBlockBold", { fg = c.base00, bg = c.base08, bold = true })
  hl("MasonHighlightSecondary", { fg = c.base15 })
  hl("MasonHighlightBlockSecondary", { fg = c.base00, bg = c.base15 })
  hl("MasonHighlightBlockBoldSecondary", { fg = c.base00, bg = c.base15, bold = true })
  hl("MasonMuted", { link = "Comment" })
  hl("MasonMutedBlock", { fg = c.base04, bg = c.base01 })
  hl("MasonMutedBlockBold", { fg = c.base04, bg = c.base01, bold = true })
  hl("MasonError", { link = "DiagnosticError" })

  -- trouble.nvim (v3)
  hl("TroubleNormal", { link = "NormalFloat" })
  hl("TroubleNormalNC", { link = "NormalFloat" })
  hl("TroubleText", { fg = c.base04 })
  hl("TroublePreview", { link = "Visual" })
  hl("TroubleFilename", { fg = c.base15 })
  hl("TroubleBasename", { fg = c.base15 })
  hl("TroubleDirectory", { link = "Directory" })
  hl("TroubleIconDirectory", { link = "Directory" })
  hl("TroubleSource", { link = "Comment" })
  hl("TroubleCode", { link = "Comment" })
  hl("TroublePos", { fg = c.base05 })
  hl("TroubleCount", { fg = c.base00, bg = c.base12 })
  hl("TroubleStatusline", { link = "StatusLine" })
  for _, g in ipairs({ "TroubleIndent", "TroubleIndentFoldClosed", "TroubleIndentFoldOpen",
    "TroubleIndentTop", "TroubleIndentMiddle", "TroubleIndentLast", "TroubleIndentWs" }) do
    hl(g, { fg = c.base02 })
  end

  -- blink.cmp
  hl("BlinkCmpMenu", { link = "Pmenu" })
  hl("BlinkCmpMenuBorder", { link = "FloatBorder" })
  hl("BlinkCmpMenuSelection", { link = "PmenuSel" })
  hl("BlinkCmpScrollBarGutter", { link = "PmenuSbar" })
  hl("BlinkCmpScrollBarThumb", { link = "PmenuThumb" })
  hl("BlinkCmpLabel", { fg = c.base04 })
  hl("BlinkCmpLabelDeprecated", { fg = c.base03, strikethrough = true })
  hl("BlinkCmpLabelMatch", { fg = c.base08, bold = true })
  hl("BlinkCmpLabelDescription", { link = "Comment" })
  hl("BlinkCmpLabelDetail", { link = "Comment" })
  hl("BlinkCmpKind", { fg = c.base12 })
  hl("BlinkCmpDoc", { link = "NormalFloat" })
  hl("BlinkCmpDocBorder", { link = "FloatBorder" })
  hl("BlinkCmpSignatureHelpBorder", { link = "FloatBorder" })

  -- fzf-lua
  hl("FzfLuaNormal", { link = "NormalFloat" })
  hl("FzfLuaBorder", { link = "FloatBorder" })
  hl("FzfLuaTitle", { link = "Title" })
  hl("FzfLuaHeaderBind", { fg = c.base12 })
  hl("FzfLuaHeaderText", { fg = c.base10 })
  hl("FzfLuaDirPart", { link = "Comment" })
  hl("FzfLuaFzfMatch", { fg = c.base08, bold = true })
  hl("FzfLuaFzfPrompt", { fg = c.base12 })
  hl("FzfLuaPathColNr", { fg = c.base11 })
  hl("FzfLuaPathLineNr", { fg = c.base13 })
  hl("FzfLuaBufName", { fg = c.base14 })
  hl("FzfLuaBufNr", { fg = c.base15 })
  hl("FzfLuaBufFlagCur", { fg = c.base10 })
  hl("FzfLuaBufFlagAlt", { fg = c.base11 })
  hl("FzfLuaTabTitle", { link = "Title" })
  hl("FzfLuaTabMarker", { fg = c.base12 })
  hl("FzfLuaLiveSym", { fg = c.base08 })

  -- diffview.nvim
  hl("DiffviewNormal", { link = "Normal" })
  hl("DiffviewDim1", { link = "Comment" })
  hl("DiffviewPrimary", { fg = c.base10 })
  hl("DiffviewSecondary", { fg = c.base12 })
  hl("DiffviewWinSeparator", { link = "WinSeparator" })
  hl("DiffviewFilePanelTitle", { fg = c.base10, bold = true })
  hl("DiffviewFilePanelCounter", { fg = c.base12, bold = true })
  hl("DiffviewFilePanelRootPath", { link = "Comment" })
  hl("DiffviewFilePanelFileName", { link = "Normal" })
  hl("DiffviewFilePanelSelected", { fg = c.base10 })
  hl("DiffviewFilePanelPath", { link = "Comment" })
  hl("DiffviewFilePanelInsertions", { link = "DiffAdded" })
  hl("DiffviewFilePanelDeletions", { link = "DiffRemoved" })
  hl("DiffviewFilePanelConflicts", { fg = c.base10 })
  hl("DiffviewFolderName", { link = "Directory" })
  hl("DiffviewFolderSign", { link = "Directory" })
  hl("DiffviewHash", { link = "Comment" })
  hl("DiffviewReference", { fg = c.base14 })
  hl("DiffviewReflogSelector", { fg = c.base15 })
  hl("DiffviewStatusAdded", { link = "DiffAdded" })
  hl("DiffviewStatusUntracked", { fg = c.base14 })
  hl("DiffviewStatusModified", { link = "DiffChanged" })
  hl("DiffviewStatusRenamed", { link = "DiffChanged" })
  hl("DiffviewStatusCopied", { link = "DiffChanged" })
  hl("DiffviewStatusTypeChange", { link = "DiffChanged" })
  hl("DiffviewStatusUnmerged", { fg = c.base10 })
  hl("DiffviewStatusUnknown", { link = "Comment" })
  hl("DiffviewStatusDeleted", { link = "DiffRemoved" })
  hl("DiffviewStatusBroken", { fg = c.base10 })
  hl("DiffviewStatusIgnored", { link = "Comment" })

  -- indent-blankline.nvim (ibl v3)
  hl("IblIndent", { fg = c.base02 })
  hl("IblWhitespace", { fg = c.base02 })
  hl("IblScope", { fg = c.base11 })

  -- rainbow-delimiters.nvim
  hl("RainbowDelimiterRed", { fg = c.base10 })
  hl("RainbowDelimiterYellow", { fg = c.yellow })
  hl("RainbowDelimiterBlue", { fg = c.base09 })
  hl("RainbowDelimiterOrange", { fg = c.base12 })
  hl("RainbowDelimiterGreen", { fg = c.base13 })
  hl("RainbowDelimiterViolet", { fg = c.base14 })
  hl("RainbowDelimiterCyan", { fg = c.base07 })

  -- nvim-treesitter-context
  hl("TreesitterContext", { bg = c.base01 })
  hl("TreesitterContextLineNumber", { fg = c.base10, bg = c.base01 })
  hl("TreesitterContextBottom", { underline = true, sp = c.base02 })

  -- vim-illuminate
  hl("IlluminatedWordText", { link = "LspReferenceText" })
  hl("IlluminatedWordRead", { link = "LspReferenceRead" })
  hl("IlluminatedWordWrite", { link = "LspReferenceWrite" })

  -- leap.nvim
  hl("LeapMatch", { fg = c.base00, bg = c.base12, bold = true })
  hl("LeapLabel", { fg = c.base10, bold = true })
  hl("LeapBackdrop", { link = "Comment" })

  -- render-markdown.nvim
  for i = 1, 6 do
    hl("RenderMarkdownH" .. i, { link = "markdownH" .. i })
    hl("RenderMarkdownH" .. i .. "Bg", { bg = c.base01 })
  end
  hl("RenderMarkdownCode", { bg = c.base01 })
  hl("RenderMarkdownCodeInline", { fg = c.base14, bg = c.base01 })
  hl("RenderMarkdownBullet", { fg = c.base08 })
  hl("RenderMarkdownTableHead", { fg = c.base12 })
  hl("RenderMarkdownTableRow", { fg = c.base04 })
  hl("RenderMarkdownSuccess", { fg = c.base13 })
  hl("RenderMarkdownInfo", { link = "DiagnosticInfo" })
  hl("RenderMarkdownHint", { link = "DiagnosticHint" })
  hl("RenderMarkdownWarn", { link = "DiagnosticWarn" })
  hl("RenderMarkdownError", { link = "DiagnosticError" })

  -- nvim-dap
  hl("DapBreakpoint", { fg = c.base10 })
  hl("DapBreakpointCondition", { fg = c.base12 })
  hl("DapBreakpointRejected", { link = "Comment" })
  hl("DapLogPoint", { fg = c.base11 })
  hl("DapStopped", { fg = c.base13 })

  -- nvim-dap-ui
  hl("DapUINormal", { link = "NormalFloat" })
  hl("DapUIVariable", { fg = c.base04 })
  hl("DapUIScope", { fg = c.base08 })
  hl("DapUIType", { fg = c.base09 })
  hl("DapUIValue", { fg = c.base04 })
  hl("DapUIModifiedValue", { fg = c.base12, bold = true })
  hl("DapUIDecoration", { fg = c.base08 })
  hl("DapUIThread", { fg = c.base13 })
  hl("DapUIStoppedThread", { fg = c.base08 })
  hl("DapUISource", { fg = c.base14 })
  hl("DapUILineNumber", { fg = c.base08 })
  hl("DapUIFloatNormal", { link = "NormalFloat" })
  hl("DapUIFloatBorder", { link = "FloatBorder" })
  hl("DapUIWatchesEmpty", { fg = c.base10 })
  hl("DapUIWatchesValue", { fg = c.base13 })
  hl("DapUIWatchesError", { link = "DiagnosticError" })
  hl("DapUIBreakpointsPath", { fg = c.base08 })
  hl("DapUIBreakpointsInfo", { fg = c.base13 })
  hl("DapUIBreakpointsCurrentLine", { fg = c.base13, bold = true })
  hl("DapUIBreakpointsLine", { fg = c.base08 })
  hl("DapUIBreakpointsDisabledLine", { link = "Comment" })
  hl("DapUICurrentFrameName", { fg = c.base13, bold = true })
  hl("DapUIStepOver", { fg = c.base11 })
  hl("DapUIStepInto", { fg = c.base11 })
  hl("DapUIStepBack", { fg = c.base11 })
  hl("DapUIStepOut", { fg = c.base11 })
  hl("DapUIStop", { fg = c.base10 })
  hl("DapUIPlayPause", { fg = c.base13 })
  hl("DapUIRestart", { fg = c.base13 })
  hl("DapUIUnavailable", { link = "Comment" })
  hl("DapUIWinSelect", { fg = c.base12 })
  hl("DapUIEndofBuffer", { link = "EndOfBuffer" })

  -- oil.nvim
  hl("OilDir", { link = "Directory" })
  hl("OilDirIcon", { link = "Directory" })
  hl("OilFile", { link = "Normal" })
  hl("OilLink", { fg = c.base15 })
  hl("OilLinkTarget", { fg = c.base14 })
  hl("OilOrphanLink", { fg = c.base10 })
  hl("OilOrphanLinkTarget", { fg = c.base10 })
  hl("OilSocket", { fg = c.base14 })
  hl("OilCreate", { link = "DiffAdded" })
  hl("OilDelete", { link = "DiffRemoved" })
  hl("OilMove", { link = "DiffChanged" })
  hl("OilCopy", { link = "DiffChanged" })
  hl("OilChange", { link = "DiffChanged" })
  hl("OilRestore", { link = "DiffAdded" })
  hl("OilPurge", { fg = c.base10 })
  hl("OilTrash", { fg = c.base10 })
  hl("OilTrashSourcePath", { link = "Comment" })
  for _, g in ipairs({ "OilHidden", "OilDirHidden", "OilFileHidden", "OilSocketHidden",
    "OilLinkHidden", "OilEmpty" }) do
    hl(g, { link = "Comment" })
  end

  -- fidget.nvim
  hl("FidgetTask", { link = "Comment" })
  hl("FidgetTitle", { fg = c.base12 })

  -- lspsaga.nvim
  hl("SagaNormal", { link = "NormalFloat" })
  hl("SagaBorder", { link = "FloatBorder" })
  hl("SagaTitle", { link = "Title" })
  hl("SagaText", { fg = c.base04 })
  hl("SagaCount", { fg = c.base12 })
  hl("SagaBeacon", { bg = c.base12 })
  hl("SagaVirtLine", { fg = c.base02 })
  hl("SagaSpinner", { fg = c.base12 })
  hl("SagaSpinnerTitle", { fg = c.base11 })
  hl("SagaSelect", { fg = c.base10 })
  hl("SagaSearch", { fg = c.base08, bold = true })
  hl("SagaFinderFname", { fg = c.base15 })
  hl("SagaDetail", { link = "Comment" })
  hl("SagaFileName", { fg = c.base15 })
  hl("SagaFolderName", { link = "Directory" })
  hl("SagaInCurrent", { fg = c.base10 })
  hl("RenameNormal", { link = "NormalFloat" })
  hl("RenameMatch", { fg = c.base08, bold = true })

  -- dropbar.nvim
  hl("DropBarMenuHoverEntry", { bg = c.base01 })
  hl("DropBarMenuHoverIcon", { fg = c.base12 })
  hl("DropBarMenuHoverSymbol", { fg = c.base08, bold = true })
  hl("DropBarIconUISeparator", { link = "Comment" })

  -- Light/paper fixups (#59 LSP references, IncSearch fg). Dark is unaffected.
  if variant ~= "dark" then
    hl("IncSearch", { fg = c.base00, bg = c.base10 })
    hl("LspReferenceText", { bg = c.base02 })
    hl("LspReferenceRead", { bg = c.base02 })
    hl("LspReferenceWrite", { bg = c.base02 })
  end

  -- Dim inactive windows (#37).
  if cfg.dim_inactive then
    local dim = (variant == "dark") and c.blend or c.base01
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
