-- singularity.nvim — a black-hole OLED Neovim colorscheme.
--
-- True OLED black, accretion-disk orange/yellow, warm paper foregrounds, and
-- sparse gravitational-lensing cool accents.
--
-- Requiring this module has NO side effects. colors/singularity.lua calls
-- require("singularity").load() to apply it; .setup{} configures it and
-- .get_palette() returns the active colours (used by the lualine theme).

local M = {}

-- Optional configuration. The colorscheme works fully without calling setup().
M.config = {
  variant = "dark",        -- legacy aliases exist, but the palette is OLED-only
  italics = true,          -- italic comments / emphasis (#40)
  transparent = false,     -- clear editor + gutter + float backgrounds (#103, #41)
  dim_inactive = false,    -- dimmer background for inactive (NormalNC) windows (#37)
  colored_headings = true, -- per-level markdown heading colours (#80)
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Historical variant names are accepted as aliases, but Singularity is now an
-- OLED-only theme.
local function resolve_variant(_override)
  return "dark"
end

local function build_palette(_variant)
  return {
    oled = "#000000",
    light = "#FFF6E3",
    parchment = "#F2E1BE",
    paper = "#D8C7A3",
    mist = "#BDAE92",
    dust = "#A99B83",
    cinder = "#8E8374",
    smoke = "#6D665E",

    bg_void = "#030201",
    bg_mantle = "#070503",
    bg_surface = "#0D0905",
    bg_elevated = "#16100A",
    bg_overlay = "#21170D",
    bg_selection_soft = "#2F1D0B",
    bg_selection = "#4A2E12",

    flare = "#FF7A1A",
    ember = "#FF9D3D",
    corona = "#FFB86B",
    gold = "#FFC857",
    photon = "#FFD98A",
    horizon = "#FFF0B8",

    ion = "#8BDDE6",
    gravity_blue = "#9EC7FF",
    quasar_green = "#BFE879",
    nova = "#F6A3FF",
    redshift = "#FF746A",

    border_subtle = "#3A230E",
    border_visible = "#8A5A1C",
    border_focus = "#FF7A1A",

    error_bg = "#2A0F0B",
    warning_bg = "#2B1E08",
    info_bg = "#0A2024",
    hint_bg = "#17220D",
    conflict_bg = "#281226",

    ansi_black = "#000000",
    ansi_red = "#FF746A",
    ansi_green = "#BFE879",
    ansi_yellow = "#FFD98A",
    ansi_blue = "#9EC7FF",
    ansi_magenta = "#F6A3FF",
    ansi_cyan = "#8BDDE6",
    ansi_white = "#D8C7A3",
    ansi_bright_black = "#8E8374",
    ansi_bright_red = "#FF9A91",
    ansi_bright_green = "#D2F49A",
    ansi_bright_yellow = "#FFF0B8",
    ansi_bright_blue = "#BDD7FF",
    ansi_bright_magenta = "#FFC0FF",
    ansi_bright_cyan = "#B9F1F5",
    ansi_bright_white = "#FFF6E3",

    base00 = "#000000", -- OLED / editor background
    base01 = "#030201", -- void / cursor line and large UI surfaces
    base02 = "#0D0905", -- surface / subtle widgets
    base03 = "#A99B83", -- dust / comments and subdued text
    base04 = "#D8C7A3", -- paper / default foreground
    base05 = "#F2E1BE", -- parchment / strong foreground
    base06 = "#FFF6E3", -- light / maximum emphasis
    base07 = "#8BDDE6", -- ion / cyan types and info
    base08 = "#FFC857", -- gold / functions and matches
    base09 = "#FF7A1A", -- flare / keywords and active accents
    base10 = "#FF746A", -- redshift / errors and deletions
    base11 = "#9EC7FF", -- gravity blue / links and debug
    base12 = "#FF9D3D", -- ember / properties and warm secondary syntax
    base13 = "#BFE879", -- quasar green / success and additions
    base14 = "#F6A3FF", -- nova / decorators, macros, rare syntax
    base15 = "#FFF0B8", -- horizon / constants and high-energy values
    yellow = "#FFD98A",
    blend = "#16100A",
    none = "NONE",
  }
end

-- Active palette for a variant (defaults to the configured/auto one). No side effects.
function M.get_palette(variant)
  return build_palette(resolve_variant(variant))
end

-- Apply the colorscheme. Invoked by the colors/ entries and on :colorscheme.
-- `override` is accepted for legacy colorscheme entrypoints; all variants use
-- the OLED v2 palette.
function M.load(override)
  local variant = resolve_variant(override)
  if vim.g.colors_name then
    vim.cmd.hi("clear")
  end
  vim.g.colors_name = "singularity"
  vim.o.termguicolors = true
  vim.o.background = "dark"

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

  vim.g["terminal_color_0"] = c.ansi_black or c.base01
  vim.g["terminal_color_1"] = c.ansi_red or c.base10
  vim.g["terminal_color_2"] = c.ansi_green or c.base13
  vim.g["terminal_color_3"] = c.ansi_yellow or c.yellow
  vim.g["terminal_color_4"] = c.ansi_blue or c.base09
  vim.g["terminal_color_5"] = c.ansi_magenta or c.base14
  vim.g["terminal_color_6"] = c.ansi_cyan or c.base07
  vim.g["terminal_color_7"] = c.ansi_white or c.base04
  vim.g["terminal_color_8"] = c.ansi_bright_black or c.base03
  vim.g["terminal_color_9"] = c.ansi_bright_red or c.base10
  vim.g["terminal_color_10"] = c.ansi_bright_green or c.base13
  vim.g["terminal_color_11"] = c.ansi_bright_yellow or c.base15
  vim.g["terminal_color_12"] = c.ansi_bright_blue or c.base11
  vim.g["terminal_color_13"] = c.ansi_bright_magenta or c.base14
  vim.g["terminal_color_14"] = c.ansi_bright_cyan or c.base07
  vim.g["terminal_color_15"] = c.ansi_bright_white or c.base06
  hl("ColorColumn", {fg = c.none, bg = c.bg_void or c.base01})
  hl("Cursor", {fg = c.oled or c.base00, bg = c.light or c.base06})
  hl("CursorLine", {fg = c.none, bg = c.bg_void or c.base01})
  hl("CursorColumn", {fg = c.none, bg = c.bg_void or c.base01})
  hl("CursorLineNr", {fg = c.photon or c.base08, bg = c.none, bold = true})
  hl("QuickFixLine", {fg = c.none, bg = c.bg_selection_soft or c.base02})
  hl("Error", {fg = c.redshift or c.base10, bg = c.error_bg or c.base01})
  hl("LineNr", {fg = c.cinder or c.base03, bg = c.base00})
  hl("NonText", {fg = c.border_subtle or c.base02, bg = c.none})
  hl("Normal", {fg = c.paper or c.base04, bg = c.base00})
  hl("MsgArea", {fg = c.paper or c.base04, bg = c.base00})
  hl("MsgSeparator", {fg = c.border_subtle or c.base01, bg = c.base00})
  hl("Pmenu", {fg = c.paper or c.base04, bg = c.bg_elevated or c.base01})
  hl("PmenuSbar", {fg = c.paper or c.base04, bg = c.bg_elevated or c.base01})
  hl("PmenuSel", {fg = c.light or c.base06, bg = c.bg_selection or c.base02})
  hl("PmenuThumb", {fg = c.border_visible or c.base08, bg = c.border_visible or c.base02})
  hl("PmenuKind", {fg = c.mist or c.base03, bg = c.bg_elevated or c.base01})
  hl("PmenuKindSel", {fg = c.photon or c.base08, bg = c.bg_selection or c.base02})
  hl("PmenuExtra", {fg = c.mist or c.base03, bg = c.bg_elevated or c.base01})
  hl("PmenuExtraSel", {fg = c.light or c.base06, bg = c.bg_selection or c.base02})
  hl("PmenuMatch", {fg = c.photon or c.base08, bg = c.bg_elevated or c.base01, bold = true})
  hl("PmenuMatchSel", {fg = c.horizon or c.base15, bg = c.bg_selection or c.base02, bold = true})
  hl("SpecialKey", {fg = c.border_subtle or c.base03, bg = c.none})
  hl("Whitespace", {fg = c.border_subtle or c.base02, bg = c.none})
  hl("Visual", {fg = c.light or c.base06, bg = c.bg_selection or c.base02})
  hl("VisualNOS", {fg = c.light or c.base06, bg = c.bg_selection or c.base02})
  hl("TooLong", {fg = c.none, bg = c.bg_selection_soft or c.base02})
  hl("Debug", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("Macro", {fg = c.nova or c.base14, bg = c.none})
  hl("MatchParen", {fg = c.none, bg = c.bg_selection_soft or c.base02, underline = true})
  hl("Bold", {fg = c.none, bg = c.none, bold = true})
  hl("Italic", {fg = c.none, bg = c.none, italic = true})
  hl("Underlined", {fg = c.none, bg = c.none, underline = true})
  hl("DiagnosticWarn", {fg = c.gold or c.base14, bg = c.none})
  hl("DiagnosticError", {fg = c.redshift or c.base10, bg = c.none})
  hl("DiagnosticInfo", {fg = c.ion or c.base09, bg = c.none})
  hl("DiagnosticHint", {fg = c.quasar_green or c.base13, bg = c.none})
  hl("DiagnosticUnderlineWarn", {sp = c.gold or c.base14, bg = c.none, undercurl = true})
  hl("DiagnosticUnderlineError", {sp = c.redshift or c.base10, bg = c.none, undercurl = true})
  hl("DiagnosticUnderlineInfo", {sp = c.ion or c.base07, bg = c.none, undercurl = true})
  hl("DiagnosticUnderlineHint", {sp = c.quasar_green or c.base13, bg = c.none, undercurl = true})
  hl("DiagnosticVirtualTextWarn", {fg = c.gold or c.base14, bg = c.warning_bg or c.none})
  hl("DiagnosticVirtualTextError", {fg = c.redshift or c.base10, bg = c.error_bg or c.none})
  hl("DiagnosticVirtualTextInfo", {fg = c.ion or c.base07, bg = c.info_bg or c.none})
  hl("DiagnosticVirtualTextHint", {fg = c.quasar_green or c.base13, bg = c.hint_bg or c.none})
  hl("DiagnosticVirtualLinesWarn", {fg = c.gold or c.base08, bg = c.warning_bg or c.none})
  hl("DiagnosticVirtualLinesError", {fg = c.redshift or c.base10, bg = c.error_bg or c.none})
  hl("DiagnosticVirtualLinesInfo", {fg = c.ion or c.base07, bg = c.info_bg or c.none})
  hl("DiagnosticVirtualLinesHint", {fg = c.quasar_green or c.base13, bg = c.hint_bg or c.none})
  hl("DiagnosticSignWarn", {fg = c.gold or c.base08, bg = c.none})
  hl("DiagnosticSignError", {fg = c.redshift or c.base10, bg = c.none})
  hl("DiagnosticSignInfo", {fg = c.ion or c.base07, bg = c.none})
  hl("DiagnosticSignHint", {fg = c.quasar_green or c.base13, bg = c.none})
  hl("DiagnosticFloatingWarn", {fg = c.gold or c.base08, bg = c.bg_elevated or c.blend})
  hl("DiagnosticFloatingError", {fg = c.redshift or c.base10, bg = c.bg_elevated or c.blend})
  hl("DiagnosticFloatingInfo", {fg = c.ion or c.base07, bg = c.bg_elevated or c.blend})
  hl("DiagnosticFloatingHint", {fg = c.quasar_green or c.base13, bg = c.bg_elevated or c.blend})
  hl("DiagnosticOk", {fg = c.quasar_green or c.base13, bg = c.none})
  hl("DiagnosticSignOk", {fg = c.quasar_green or c.base13, bg = c.none})
  hl("DiagnosticFloatingOk", {fg = c.quasar_green or c.base13, bg = c.bg_elevated or c.blend})
  hl("DiagnosticVirtualTextOk", {fg = c.quasar_green or c.base13, bg = c.hint_bg or c.none})
  hl("HealthError", {fg = c.redshift or c.base10, bg = c.none})
  hl("HealthWarning", {fg = c.gold or c.base08, bg = c.none})
  hl("HealthSuccess", {fg = c.quasar_green or c.base13, bg = c.none})
  hl("@comment", {link = "Comment"})
  hl("@text.literal.commodity", {fg = c.base13, bg = c.none})
  hl("@number", {fg = c.base09, bg = c.none})
  hl("@number.date", {fg = c.base08, bg = c.none})
  hl("@number.date.effective", {fg = c.base13, bg = c.none})
  hl("@number.interval", {fg = c.base09, bg = c.none})
  hl("@number.status", {fg = c.base12, bg = c.none})
  hl("@number.quantity", {fg = c.base11, bg = c.none})
  hl("@number.quantity.negative", {fg = c.base10, bg = c.none})
  hl("LspCodeLens", {fg = c.dust or c.base03, bg = c.none})
  hl("LspReferenceText", {fg = c.none, bg = c.bg_selection_soft or c.base02})
  hl("LspReferenceRead", {fg = c.none, bg = c.bg_selection_soft or c.base02})
  hl("LspReferenceWrite", {fg = c.none, bg = c.bg_selection_soft or c.base02})
  hl("LspSignatureActiveParameter", {fg = c.photon or c.base08, bg = c.none})
  hl("@lsp.type.class", {link = "Structure"})
  hl("@lsp.type.decorator", {link = "Decorator"})
  hl("@lsp.type.decorator.markdown", {link = "Structure"})
  hl("@lsp.type.function", {link = "@function"})
  hl("@lsp.type.macro", {link = "Macro"})
  hl("@lsp.type.method", {link = "@method"})
  hl("@lsp.type.struct", {link = "Structure"})
  hl("@lsp.type.type", {link = "Type"})
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
  hl("@lsp.type.interface", {link = "@interface"})
  hl("@lsp.type.typeParameter", {link = "@type.parameter"})
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
  hl("Folded", {fg = c.mist or c.base04, bg = c.bg_surface or c.base01})
  hl("FoldColumn", {fg = c.cinder or c.base03, bg = c.base00})
  hl("SignColumn", {fg = c.cinder or c.base03, bg = c.base00})
  hl("Directory", {fg = c.gold or c.base08, bg = c.none})
  hl("EndOfBuffer", {fg = c.bg_void or c.base01, bg = c.none})
  hl("ErrorMsg", {fg = c.redshift or c.base10, bg = c.none})
  hl("ModeMsg", {fg = c.paper or c.base04, bg = c.none})
  hl("MoreMsg", {fg = c.photon or c.base08, bg = c.none})
  hl("Question", {fg = c.paper or c.base04, bg = c.none})
  hl("Substitute", {fg = c.oled or c.base00, bg = c.flare or c.base09})
  hl("WarningMsg", {fg = c.gold or c.base14, bg = c.none})
  hl("WildMenu", {fg = c.light or c.base06, bg = c.bg_selection or c.base01})
  hl("helpHyperTextJump", {fg = c.gravity_blue or c.base11, bg = c.none, underline = true})
  hl("helpSpecial", {fg = c.photon or c.base08, bg = c.none})
  hl("helpHeadline", {fg = c.gold or c.base08, bg = c.none})
  hl("helpHeader", {fg = c.horizon or c.base15, bg = c.none})
  hl("DiffAdded", {fg = c.quasar_green or c.base13, bg = c.none})
  hl("DiffChanged", {fg = c.gold or c.base08, bg = c.none})
  hl("DiffRemoved", {fg = c.redshift or c.base10, bg = c.none})
  hl("DiffAdd", {bg = c.hint_bg or "#17220D", fg = c.none})
  hl("DiffChange", {bg = c.warning_bg or "#2B1E08", fg = c.none})
  hl("DiffText", {bg = c.bg_selection or "#4A2E12", fg = c.none})
  hl("DiffDelete", {bg = c.error_bg or "#2A0F0B", fg = c.none})
  hl("diffAdded", {fg = c.quasar_green or c.base13, bg = c.none})
  hl("diffChanged", {fg = c.gold or c.base08, bg = c.none})
  hl("diffRemoved", {fg = c.redshift or c.base10, bg = c.none})
  hl("diffDeleted", {fg = c.redshift or c.base10, bg = c.none})
  hl("diffLine", {fg = c.photon or c.base08, bg = c.bg_elevated or c.base02})
  hl("diffFile", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("diffNewFile", {fg = c.quasar_green or c.base13, bg = c.none})
  hl("diffOldFile", {fg = c.redshift or c.base10, bg = c.none})
  hl("IncSearch", {fg = c.oled or c.base00, bg = c.photon or c.base08, bold = true})
  hl("Search", {fg = c.oled or c.base00, bg = c.photon or c.base08})
  hl("TabLine", {fg = c.dust or c.base03, bg = c.bg_mantle or c.base01})
  hl("TabLineFill", {fg = c.border_subtle or c.base01, bg = c.bg_mantle or c.base01})
  hl("TabLineSel", {fg = c.light or c.base06, bg = c.oled or c.base00, underline = true, sp = c.border_focus or c.base09})
  hl("Title", {fg = c.gold or c.base08, bg = c.none, bold = true})
  hl("VertSplit", {fg = c.border_subtle or c.base01, bg = c.base00})
  hl("WinSeparator", {fg = c.border_subtle or c.base01, bg = c.base00})
  hl("WinBar", {fg = c.parchment or c.base05, bg = c.bg_void or c.base01})
  hl("WinBarNC", {fg = c.dust or c.base03, bg = c.bg_void or c.base01})
  hl("Boolean", {fg = c.horizon or c.base15, bg = c.none})
  hl("Character", {fg = c.corona or c.base14, bg = c.none})
  hl("Comment", {fg = c.dust or c.base03, bg = c.none, italic = true})
  hl("Conceal", {fg = c.none, bg = c.none})
  hl("Conditional", {fg = c.flare or c.base09, bg = c.none})
  hl("Constant", {fg = c.horizon or c.base15, bg = c.none})
  hl("Decorator", {fg = c.nova or c.base14, bg = c.none})
  hl("Define", {fg = c.flare or c.base09, bg = c.none})
  hl("Delimiter", {fg = c.cinder or c.base03, bg = c.none})
  hl("Delimeter", {link = "Delimiter"})
  hl("Exception", {fg = c.flare or c.base09, bg = c.none})
  hl("Float", {link = "Number"})
  hl("Function", {fg = c.gold or c.base08, bg = c.none})
  hl("Identifier", {fg = c.paper or c.base04, bg = c.none})
  hl("Include", {fg = c.mist or c.base03, bg = c.none})
  hl("Keyword", {fg = c.flare or c.base09, bg = c.none})
  hl("Label", {fg = c.flare or c.base09, bg = c.none})
  hl("Number", {fg = c.horizon or c.base15, bg = c.none})
  hl("Operator", {fg = c.mist or c.base03, bg = c.none})
  hl("PreProc", {fg = c.flare or c.base09, bg = c.none})
  hl("Repeat", {fg = c.flare or c.base09, bg = c.none})
  hl("Special", {fg = c.nova or c.base14, bg = c.none})
  hl("SpecialChar", {fg = c.nova or c.base14, bg = c.none})
  hl("SpecialComment", {fg = c.mist or c.base03, bg = c.none, italic = true})
  hl("Statement", {fg = c.flare or c.base09, bg = c.none})
  hl("StorageClass", {fg = c.flare or c.base09, bg = c.none})
  hl("String", {fg = c.corona or c.base14, bg = c.none})
  hl("Structure", {fg = c.ion or c.base07, bg = c.none})
  hl("Tag", {fg = c.ion or c.base07, bg = c.none})
  hl("Todo", {fg = c.oled or c.base00, bg = c.photon or c.base13, bold = true})
  hl("Type", {fg = c.ion or c.base07, bg = c.none})
  hl("Typedef", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("markdownBlockquote", {fg = c.dust or c.base03, bg = c.none})
  hl("markdownBold", {fg = c.light or c.base06, bg = c.none, bold = true})
  hl("markdownItalic", {fg = c.paper or c.base04, bg = c.none, italic = true})
  hl("markdownBoldItalic", {fg = c.light or c.base06, bg = c.none, bold = true, italic = true})
  hl("markdownRule", {link = "Comment"})
  hl("markdownH1", {fg = c.gold or c.base08, bg = c.none, bold = true})
  hl("markdownH2", {link = "markdownH1"})
  hl("markdownH3", {link = "markdownH1"})
  hl("markdownH4", {link = "markdownH1"})
  hl("markdownH5", {link = "markdownH1"})
  hl("markdownH6", {link = "markdownH1"})
  hl("markdownHeadingDelimiter", {link = "markdownH1"})
  hl("markdownHeadingRule", {link = "markdownH1"})
  hl("markdownUrl", {fg = c.gravity_blue or c.base11, bg = c.none, underline = true})
  hl("markdownCode", {fg = c.corona or c.base12, bg = c.bg_elevated or c.base01})
  hl("markdownCodeBlock", {link = "markdownCode"})
  hl("markdownCodeDelimiter", {link = "markdownCode"})
  hl("markdownListMarker", {fg = c.gold or c.base08, bg = c.none})
  hl("markdownOrderedListMarker", {fg = c.gold or c.base08, bg = c.none})
  hl("@markup", {link = "@none"})
  hl("@markup.environment", {link = "Macro"})
  hl("@markup.environment.name", {link = "Type"})
  hl("@markup.emphasis", {fg = c.paper or c.base04, italic = true})
  hl("@markup.italic", {fg = c.paper or c.base04, italic = true})
  hl("@markup.strikethrough", {strikethrough = true})
  hl("@markup.strong", {fg = c.light or c.base06, bold = true})
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
  hl("@markup.link.description", {fg = c.gravity_blue or c.base11, underline = true, italic = true})
  hl("@markup.list", {link = "markdownListMarker"})
  hl("@markup.list.bullet", {link = "markdownListMarker"})
  hl("@markup.list.checked", {link = "markdownListMarker"})
  hl("@markup.list.markdown", {link = "markdownListMarker"})
  hl("@markup.list.ordered", {link = "markdownOrderedListMarker"})
  hl("@markup.list.unchecked", {link = "markdownListMarker"})
  hl("@markup.math", {link = "Special"})
  hl("@markup.raw", {link = "String"})
  hl("@markup.raw.markdown_inline", {link = "markdownCode"})
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
  hl("@error", {fg = c.redshift or c.base10, bg = c.none})
  hl("@operator", {link = "Operator"})
  hl("@punctuation.delimiter", {fg = c.cinder or c.base03, bg = c.none})
  hl("@punctuation.bracket", {fg = c.mist or c.base03, bg = c.none})
  hl("@punctuation.special", {fg = c.nova or c.base14, bg = c.none})
  hl("@string", {link = "String"})
  hl("@string.documentation", {fg = c.mist or c.base03, bg = c.none, italic = true})
  hl("@string.regex", {fg = c.gold or c.base08, bg = c.none})
  hl("@string.regexp", {link = "@string.regex"})
  hl("@string.escape", {fg = c.nova or c.base14, bg = c.none})
  hl("@string.special", {fg = c.nova or c.base14, bg = c.none})
  hl("@string.special.symbol", {fg = c.horizon or c.base15, bg = c.none})
  hl("@string.special.url", {fg = c.gravity_blue or c.base11, bg = c.none, underline = true})
  hl("@character", {link = "Character"})
  hl("@boolean", {link = "Boolean"})
  hl("@number", {link = "Number"})
  hl("@float", {link = "Float"})
  hl("@function", {fg = c.gold or c.base08, bg = c.none})
  hl("@function.builtin", {fg = c.gold or c.base08, bg = c.none})
  hl("@function.macro", {fg = c.nova or c.base14, bg = c.none})
  hl("@method", {fg = c.photon or c.base08, bg = c.none})
  hl("@constructor", {fg = c.horizon or c.base15, bg = c.none, bold = true})
  hl("@parameter", {fg = c.mist or c.base03, bg = c.none})
  hl("@keyword", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.function", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.operator", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.coroutine", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.conditional", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.repeat", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.return", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.exception", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.import", {fg = c.mist or c.base03, bg = c.none})
  hl("@keyword.modifier", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.directive", {fg = c.flare or c.base09, bg = c.none})
  hl("@keyword.directive.define", {fg = c.flare or c.base09, bg = c.none})
  hl("@conditional", {fg = c.flare or c.base09, bg = c.none})
  hl("@repeat", {fg = c.flare or c.base09, bg = c.none})
  hl("@label", {fg = c.flare or c.base09, bg = c.none})
  hl("@include", {fg = c.mist or c.base03, bg = c.none})
  hl("@exception", {fg = c.flare or c.base09, bg = c.none})
  hl("@type", {link = "Type"})
  hl("@type.builtin", {link = "Type"})
  hl("@type.definition", {fg = c.ion or c.base07, bg = c.none})
  hl("@type.parameter", {fg = c.ion or c.base07, bg = c.none})
  hl("@type.qualifier", {fg = c.flare or c.base09, bg = c.none})
  hl("@interface", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("@module", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("@module.builtin", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("@namespace", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("@attribute", {fg = c.nova or c.base14, bg = c.none})
  hl("@field", {fg = c.ember or c.base12, bg = c.none})
  hl("@property", {fg = c.ember or c.base12, bg = c.none})
  hl("@variable", {fg = c.paper or c.base04, bg = c.none})
  hl("@variable.builtin", {fg = c.parchment or c.base05, bg = c.none})
  hl("@variable.parameter", {fg = c.mist or c.base03, bg = c.none})
  hl("@variable.parameter.builtin", {fg = c.mist or c.base03, bg = c.none})
  hl("@variable.member", {fg = c.ember or c.base12, bg = c.none})
  hl("@constant", {fg = c.horizon or c.base15, bg = c.none})
  hl("@constant.builtin", {fg = c.horizon or c.base15, bg = c.none})
  hl("@constant.macro", {fg = c.nova or c.base14, bg = c.none})
  hl("@symbol", {fg = c.horizon or c.base15, bg = c.none, bold = true})
  hl("@text", {fg = c.paper or c.base04, bg = c.none})
  hl("@text.strong", {fg = c.none, bg = c.none})
  hl("@text.emphasis", {fg = c.paper or c.base04, bg = c.none, italic = true})
  hl("@text.underline", {fg = c.gravity_blue or c.base11, bg = c.none, underline = true})
  hl("@text.strike", {fg = c.dust or c.base03, bg = c.none, strikethrough = true})
  hl("@text.title", {fg = c.gold or c.base08, bg = c.none, bold = true})
  hl("@text.literal", {fg = c.corona or c.base14, bg = c.none})
  hl("@text.uri", {fg = c.gravity_blue or c.base11, bg = c.none, underline = true})
  hl("@tag", {fg = c.ion or c.base07, bg = c.none})
  hl("@tag.attribute", {fg = c.ember or c.base12, bg = c.none})
  hl("@tag.delimiter", {fg = c.cinder or c.base03, bg = c.none})
  hl("@tag.builtin.tsx", {link = "@tag.tsx"})
  hl("@reference", {fg = c.paper or c.base04, bg = c.none})
  hl("NvimInternalError", {fg = c.oled or c.base00, bg = c.redshift or c.base10})
  hl("NormalFloat", {fg = c.paper or c.base04, bg = c.bg_elevated or c.blend})
  hl("FloatBorder", {fg = c.border_visible or c.base08, bg = c.bg_elevated or c.blend})
  hl("FloatTitle", {fg = c.photon or c.base08, bg = c.bg_elevated or c.blend, bold = true})
  hl("FloatFooter", {fg = c.mist or c.base03, bg = c.bg_elevated or c.blend})
  hl("FloatShadow", {fg = c.none, bg = c.bg_overlay or c.base02})
  hl("FloatShadowThrough", {fg = c.none, bg = c.bg_surface or c.base02})
  hl("NormalNC", {fg = c.paper or c.base04, bg = c.base00})
  hl("TermCursor", {fg = c.oled or c.base00, bg = c.light or c.base06})
  hl("TermCursorNC", {fg = c.oled or c.base00, bg = c.light or c.base06})
  hl("StatusLine", {fg = c.light or c.base06, bg = c.bg_elevated or c.base00})
  hl("StatusLineNC", {fg = c.dust or c.base03, bg = c.bg_void or c.base01})
  hl("StatusReplace", {fg = c.oled or c.base00, bg = c.redshift or c.base10})
  hl("StatusInsert", {fg = c.oled or c.base00, bg = c.quasar_green or c.base13})
  hl("StatusVisual", {fg = c.oled or c.base00, bg = c.flare or c.base09})
  hl("StatusTerminal", {fg = c.oled or c.base00, bg = c.corona or c.base12})
  hl("StatusNormal", {fg = c.oled or c.base00, bg = c.photon or c.base15})
  hl("StatusCommand", {fg = c.oled or c.base00, bg = c.ion or c.base07})
  hl("StatusLineDiagnosticWarn", {fg = c.gold or c.base08, bg = c.bg_elevated or c.base00, bold = true})
  hl("StatusLineDiagnosticError", {fg = c.redshift or c.base10, bg = c.bg_elevated or c.base00, bold = true})
  hl("TelescopeBorder", {fg = c.border_visible or c.base08, bg = c.bg_elevated or c.blend})
  hl("TelescopePromptBorder", {fg = c.border_visible or c.base08, bg = c.bg_elevated or c.base02})
  hl("TelescopePromptNormal", {fg = c.paper or c.base04, bg = c.bg_elevated or c.base02})
  hl("TelescopePromptPrefix", {fg = c.photon or c.base08, bg = c.bg_elevated or c.base02})
  hl("TelescopeNormal", {fg = c.paper or c.base04, bg = c.bg_elevated or c.blend})
  hl("TelescopePreviewTitle", {fg = c.oled or c.base00, bg = c.ember or c.base12})
  hl("TelescopePromptTitle", {fg = c.oled or c.base00, bg = c.gravity_blue or c.base11})
  hl("TelescopeResultsTitle", {fg = c.bg_elevated or c.blend, bg = c.bg_elevated or c.blend})
  hl("TelescopeSelection", {fg = c.light or c.base06, bg = c.bg_selection or c.base02})
  hl("TelescopePreviewLine", {fg = c.none, bg = c.bg_selection_soft or c.base01})
  hl("TelescopeMatching", {fg = c.photon or c.base08, bg = c.none, bold = true})
  hl("NotifyERRORBorder", {fg = c.redshift or c.base10, bg = c.none})
  hl("NotifyWARNBorder", {fg = c.gold or c.base08, bg = c.none})
  hl("NotifyINFOBorder", {fg = c.ion or c.base07, bg = c.none})
  hl("NotifyDEBUGBorder", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("NotifyTRACEBorder", {fg = c.nova or c.base14, bg = c.none})
  hl("NotifyERRORIcon", {fg = c.redshift or c.base10, bg = c.none})
  hl("NotifyWARNIcon", {fg = c.gold or c.base08, bg = c.none})
  hl("NotifyINFOIcon", {fg = c.ion or c.base07, bg = c.none})
  hl("NotifyDEBUGIcon", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("NotifyTRACEIcon", {fg = c.nova or c.base14, bg = c.none})
  hl("NotifyERRORTitle", {fg = c.redshift or c.base10, bg = c.none})
  hl("NotifyWARNTitle", {fg = c.gold or c.base08, bg = c.none})
  hl("NotifyINFOTitle", {fg = c.ion or c.base07, bg = c.none})
  hl("NotifyDEBUGTitle", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("NotifyTRACETitle", {fg = c.nova or c.base14, bg = c.none})
  hl("CmpItemAbbr", {fg = c.paper or c.base04, bg = c.none})
  hl("CmpItemAbbrMatch", {fg = c.photon or c.base08, bg = c.none, bold = true})
  hl("CmpItemAbbrMatchFuzzy", {fg = c.photon or c.base08, bg = c.none, bold = true})
  hl("CmpItemMenu", {fg = c.mist or c.base03, bg = c.none, italic = true})
  hl("CmpItemKindInterface", {fg = c.gravity_blue or c.base11})
  hl("CmpItemKindColor", {fg = c.corona or c.base12})
  hl("CmpItemKindTypeParameter", {fg = c.ion or c.base07})
  hl("CmpItemKindText", {fg = c.mist or c.base03})
  hl("CmpItemKindEnum", {fg = c.photon or c.base08})
  hl("CmpItemKindKeyword", {fg = c.flare or c.base09})
  hl("CmpItemKindConstant", {fg = c.horizon or c.base15})
  hl("CmpItemKindConstructor", {fg = c.horizon or c.base15})
  hl("CmpItemKindReference", {fg = c.mist or c.base03})
  hl("CmpItemKindFunction", {fg = c.gold or c.base08})
  hl("CmpItemKindStruct", {fg = c.ion or c.base07})
  hl("CmpItemKindClass", {fg = c.ion or c.base07})
  hl("CmpItemKindModule", {fg = c.gravity_blue or c.base11})
  hl("CmpItemKindOperator", {fg = c.mist or c.base03})
  hl("CmpItemKindField", {fg = c.ember or c.base12})
  hl("CmpItemKindProperty", {fg = c.ember or c.base12})
  hl("CmpItemKindEvent", {fg = c.nova or c.base14})
  hl("CmpItemKindUnit", {fg = c.horizon or c.base15})
  hl("CmpItemKindSnippet", {fg = c.nova or c.base14})
  hl("CmpItemKindFolder", {fg = c.gold or c.base08})
  hl("CmpItemKindVariable", {fg = c.paper or c.base04})
  hl("CmpItemKindFile", {fg = c.paper or c.base04})
  hl("CmpItemKindMethod", {fg = c.photon or c.base08})
  hl("CmpItemKindValue", {fg = c.horizon or c.base15})
  hl("CmpItemKindEnumMember", {fg = c.horizon or c.base15})
  hl("CmpItemKindTypeParameter", {fg = c.ion or c.base07})
  hl("NvimTreeImageFile", {fg = c.corona or c.base12, bg = c.none})
  hl("NvimTreeFolderIcon", {fg = c.gold or c.base08, bg = c.none})
  hl("NvimTreeWinSeparator", {fg = c.border_subtle or c.base01, bg = c.bg_void or c.base00})
  hl("NvimTreeFolderName", {fg = c.gold or c.base08, bg = c.none})
  hl("NvimTreeIndentMarker", {fg = c.border_subtle or c.base02, bg = c.none})
  hl("NvimTreeEmptyFolderName", {fg = c.mist or c.base03, bg = c.none})
  hl("NvimTreeOpenedFolderName", {fg = c.photon or c.base08, bg = c.none})
  hl("NvimTreeNormal", {fg = c.mist or c.base04, bg = c.bg_void or c.base00})
  hl("NeogitBranch", {fg = c.flare or c.base09, bg = c.none})
  hl("NeogitRemote", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("NeogitHunkHeader", {fg = c.paper or c.base04, bg = c.bg_surface or c.base02})
  hl("NeogitHunkHeaderHighlight", {fg = c.light or c.base06, bg = c.bg_selection_soft or c.base03})
  hl("GitSignsCurrentLineBlame", {link = "Comment"})
  hl("GitSignsAdd", {link = "DiffAdded"})
  hl("GitSignsAddNr", {link = "DiffAdded"})
  hl("GitSignsAddLn", {bg = c.hint_bg or c.base02})
  hl("GitSignsChange", {link = "DiffChanged"})
  hl("GitSignsChangeNr", {link = "DiffChanged"})
  hl("GitSignsChangeLn", {bg = c.warning_bg or c.base02})
  hl("GitSignsDelete", {link = "DiffRemoved"})
  hl("GitSignsDeleteNr", {link = "DiffRemoved"})
  hl("GitSignsDeleteLn", {bg = c.error_bg or c.base02})
  hl("GitSignsTopdelete", {link = "DiffRemoved"})
  hl("GitSignsChangedelete", {fg = c.gold or c.base08, bg = c.none})
  hl("GitSignsUntracked", {link = "DiffAdded"})
  hl("HydraRed", {fg = c.redshift or c.base10, bg = c.none})
  hl("HydraBlue", {fg = c.gravity_blue or c.base11, bg = c.none})
  hl("HydraAmaranth", {fg = c.nova or c.base14, bg = c.none})
  hl("HydraTeal", {fg = c.ion or c.base07, bg = c.none})
  hl("HydraHint", {fg = c.none, bg = c.bg_elevated or c.blend})
  hl("alpha1", {fg = c.base03, bg = c.none})
  hl("alpha2", {fg = c.base04, bg = c.none})
  hl("alpha3", {fg = c.base03, bg = c.none})
  hl("CodeBlock", {fg = c.none, bg = c.bg_elevated or c.base01})
  hl("BufferLineDiagnostic", {fg = c.redshift or c.base10, bg = c.none, bold = true})
  hl("BufferLineDiagnosticVisible", {fg = c.redshift or c.base10, bg = c.none, bold = true})
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
  hl("FlashLabel", {fg = c.light or c.base06, bg = c.flare or c.base09, bold = true})

  -- ── Issue fixes ───────────────────────────────────────
  hl("Folded", { fg = c.mist or c.base04, bg = c.bg_surface or c.base01 }) -- #86 fg was base02 (too dark)
  hl("@text.underline", { underline = true })          -- #101 underline, not accent text
  hl("CurSearch", { link = "IncSearch" })              -- #91 current search match
  hl("Added", { link = "DiffAdded" })                  -- #101 builtin diff base groups
  hl("Changed", { link = "DiffChanged" })
  hl("Removed", { link = "DiffRemoved" })
  hl("@diff.plus", { link = "DiffAdded" })             -- #101 treesitter diff captures
  hl("@diff.minus", { link = "DiffRemoved" })
  hl("@diff.delta", { link = "DiffChanged" })

  -- Per-level markdown headings (#80). Set colored_headings = false to disable.
  if cfg.colored_headings then
    local levels = {
      c.gold or c.base08,
      c.photon or c.base08,
      c.flare or c.base09,
      c.ion or c.base07,
      c.nova or c.base14,
      c.quasar_green or c.base13,
    }
    for i, colour in ipairs(levels) do
      hl("markdownH" .. i, { fg = colour, bold = true })
      hl("@markup.heading." .. i .. ".markdown", { link = "markdownH" .. i })
    end
  end

  -- ── mini.nvim — https://github.com/nvim-mini/mini.nvim ──────────────────
  -- Group names validated against upstream mini.hues; links keep them in sync
  -- with the OLED palette, transparency and config automatically.
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
  hl("MiniFilesTitleFocused", { fg = c.photon or c.base08, bold = true })
  -- mini.icons (base16 has no yellow; uses c.yellow)
  hl("MiniIconsAzure", { fg = c.gravity_blue or c.base11 })
  hl("MiniIconsBlue", { fg = c.gravity_blue or c.base11 })
  hl("MiniIconsCyan", { fg = c.ion or c.base07 })
  hl("MiniIconsGreen", { fg = c.quasar_green or c.base13 })
  hl("MiniIconsGrey", { fg = c.dust or c.base03 })
  hl("MiniIconsOrange", { fg = c.ember or c.base12 })
  hl("MiniIconsPurple", { fg = c.nova or c.base14 })
  hl("MiniIconsRed", { fg = c.redshift or c.base10 })
  hl("MiniIconsYellow", { fg = c.photon or c.yellow })
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
  hl("MiniIndentscopeSymbol", { fg = c.border_subtle or c.base02 })
  hl("MiniIndentscopeSymbolOff", { link = "MiniIndentscopeSymbol" })
  -- mini.map
  hl("MiniMapNormal", { link = "NormalFloat" })
  hl("MiniMapSymbolCount", { fg = c.base05 })
  hl("MiniMapSymbolLine", { fg = c.base11 })
  hl("MiniMapSymbolView", { fg = c.border_subtle or c.base02 })
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
  hl("MiniTrailspace", { bg = c.redshift or c.base10 })
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
  -- Everything links to the theme's semantic groups so it tracks the OLED palette,
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
  hl("NavicText", { fg = c.paper or c.base04 })
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
  hl("BlinkCmpKindCopilot", { fg = c.quasar_green or c.base13 })
  hl("NoiceCompletionItemKindDefault", { fg = c.parchment or c.base05 })

  -- which-key.nvim (v3)
  hl("WhichKey", { fg = c.gold or c.base08 })
  hl("WhichKeyGroup", { fg = c.ember or c.base12 })
  hl("WhichKeyDesc", { fg = c.paper or c.base04 })
  hl("WhichKeySeparator", { link = "Comment" })
  hl("WhichKeyValue", { fg = c.parchment or c.base05 })
  hl("WhichKeyNormal", { link = "NormalFloat" })
  hl("WhichKeyBorder", { link = "FloatBorder" })
  hl("WhichKeyTitle", { link = "Title" })
  hl("WhichKeyIcon", { fg = c.gravity_blue or c.base11 })
  for _, col in ipairs({ "Azure", "Blue", "Cyan", "Green", "Grey", "Orange", "Purple", "Red", "Yellow" }) do
    hl("WhichKeyIcon" .. col, { link = "MiniIcons" .. col })
  end

  -- neo-tree.nvim
  hl("NeoTreeNormal", { fg = c.mist or c.base03, bg = c.bg_void or c.base01 })
  hl("NeoTreeNormalNC", { fg = c.dust or c.base03, bg = c.bg_void or c.base01 })
  hl("NeoTreeDirectoryName", { link = "Directory" })
  hl("NeoTreeDirectoryIcon", { link = "Directory" })
  hl("NeoTreeRootName", { fg = c.parchment or c.base05, bold = true })
  hl("NeoTreeFileNameOpened", { fg = c.light or c.base06 })
  hl("NeoTreeSymbolicLinkTarget", { fg = c.gravity_blue or c.base11 })
  hl("NeoTreeIndentMarker", { fg = c.border_subtle or c.base02 })
  hl("NeoTreeExpander", { fg = c.mist or c.base03 })
  hl("NeoTreeModified", { fg = c.gold or c.base08 })
  hl("NeoTreeGitAdded", { link = "DiffAdded" })
  hl("NeoTreeGitConflict", { fg = c.nova or c.base14 })
  hl("NeoTreeGitDeleted", { link = "DiffRemoved" })
  hl("NeoTreeGitIgnored", { link = "Comment" })
  hl("NeoTreeGitModified", { link = "DiffChanged" })
  hl("NeoTreeGitUnstaged", { fg = c.gold or c.base08 })
  hl("NeoTreeGitUntracked", { fg = c.quasar_green or c.base13 })
  hl("NeoTreeGitStaged", { link = "DiffAdded" })
  hl("NeoTreeFloatBorder", { link = "FloatBorder" })
  hl("NeoTreeFloatTitle", { link = "Title" })
  hl("NeoTreeTitleBar", { fg = c.oled or c.base00, bg = c.flare or c.base09 })
  hl("NeoTreeDimText", { link = "Comment" })
  hl("NeoTreeFilterTerm", { fg = c.photon or c.base08 })
  hl("NeoTreeTabActive", { fg = c.light or c.base06, bg = c.oled or c.base00, bold = true })
  hl("NeoTreeTabInactive", { link = "Comment" })
  hl("NeoTreeTabSeparatorActive", { fg = c.border_focus or c.base09 })
  hl("NeoTreeTabSeparatorInactive", { link = "WinSeparator" })
  hl("NeoTreeVertSplit", { link = "WinSeparator" })
  hl("NeoTreeWinSeparator", { link = "WinSeparator" })
  hl("NeoTreeStatusLineNC", { link = "StatusLineNC" })

  -- noice.nvim
  hl("NoiceCmdline", { link = "NormalFloat" })
  hl("NoiceCmdlineIcon", { fg = c.ember or c.base12 })
  hl("NoiceCmdlineIconSearch", { fg = c.photon or c.base08 })
  hl("NoiceCmdlinePopup", { link = "NormalFloat" })
  hl("NoiceCmdlinePopupBorder", { link = "FloatBorder" })
  hl("NoiceCmdlinePopupBorderSearch", { fg = c.border_focus or c.base09 })
  hl("NoiceCmdlinePopupTitle", { link = "Title" })
  hl("NoiceCmdlinePrompt", { fg = c.photon or c.base08 })
  hl("NoiceConfirm", { link = "NormalFloat" })
  hl("NoiceConfirmBorder", { link = "FloatBorder" })
  hl("NoicePopup", { link = "NormalFloat" })
  hl("NoicePopupBorder", { link = "FloatBorder" })
  hl("NoicePopupmenu", { link = "Pmenu" })
  hl("NoicePopupmenuBorder", { link = "FloatBorder" })
  hl("NoicePopupmenuMatch", { fg = c.photon or c.base08, bold = true })
  hl("NoicePopupmenuSelected", { link = "PmenuSel" })
  hl("NoiceMini", { fg = c.parchment or c.base05 })
  hl("NoiceScrollbar", { link = "PmenuSbar" })
  hl("NoiceScrollbarThumb", { link = "PmenuThumb" })
  hl("NoiceSplit", { link = "NormalFloat" })
  hl("NoiceSplitBorder", { link = "FloatBorder" })
  hl("NoiceVirtualText", { fg = c.nova or c.base14 })
  hl("NoiceCursor", { link = "Cursor" })
  hl("NoiceFormatProgressDone", { fg = c.oled or c.base00, bg = c.quasar_green or c.base13 })
  hl("NoiceFormatProgressTodo", { fg = c.dust or c.base03, bg = c.bg_surface or c.base02 })
  hl("NoiceLspProgressClient", { fg = c.gravity_blue or c.base11 })
  hl("NoiceLspProgressSpinner", { fg = c.ember or c.base12 })
  hl("NoiceLspProgressTitle", { fg = c.paper or c.base04 })
  hl("NoiceFormatLevelDebug", { link = "Comment" })
  hl("NoiceFormatLevelTrace", { link = "Comment" })
  hl("NoiceFormatLevelOff", { link = "Comment" })
  hl("NoiceFormatLevelInfo", { link = "DiagnosticInfo" })
  hl("NoiceFormatLevelWarn", { link = "DiagnosticWarn" })
  hl("NoiceFormatLevelError", { link = "DiagnosticError" })

  -- lazy.nvim
  hl("LazyNormal", { link = "NormalFloat" })
  hl("LazyH1", { fg = c.oled or c.base00, bg = c.redshift or c.base10, bold = true })
  hl("LazyH2", { link = "Title" })
  hl("LazyButton", { fg = c.paper or c.base04, bg = c.bg_surface or c.base01 })
  hl("LazyButtonActive", { fg = c.oled or c.base00, bg = c.flare or c.base09 })
  hl("LazyComment", { link = "Comment" })
  hl("LazyDimmed", { link = "Comment" })
  hl("LazyProp", { fg = c.parchment or c.base05 })
  hl("LazyValue", { fg = c.nova or c.base14 })
  hl("LazyDir", { link = "Directory" })
  hl("LazyUrl", { fg = c.gravity_blue or c.base11, underline = true })
  hl("LazyCommit", { fg = c.quasar_green or c.base13 })
  hl("LazyCommitIssue", { fg = c.horizon or c.base15 })
  hl("LazyCommitType", { fg = c.gravity_blue or c.base11 })
  hl("LazyCommitScope", { fg = c.ember or c.base12 })
  hl("LazyProgressDone", { fg = c.flare or c.base09 })
  hl("LazyProgressTodo", { fg = c.border_subtle or c.base02 })
  hl("LazySpecial", { fg = c.gold or c.base08 })
  hl("LazyLocal", { fg = c.quasar_green or c.base13 })
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
  hl("MasonHeader", { fg = c.oled or c.base00, bg = c.flare or c.base09, bold = true })
  hl("MasonHeaderSecondary", { fg = c.oled or c.base00, bg = c.ember or c.base12, bold = true })
  hl("MasonHeading", { fg = c.paper or c.base04, bold = true })
  hl("MasonHighlight", { fg = c.gold or c.base08 })
  hl("MasonHighlightBlock", { fg = c.oled or c.base00, bg = c.gold or c.base08 })
  hl("MasonHighlightBlockBold", { fg = c.oled or c.base00, bg = c.gold or c.base08, bold = true })
  hl("MasonHighlightSecondary", { fg = c.horizon or c.base15 })
  hl("MasonHighlightBlockSecondary", { fg = c.oled or c.base00, bg = c.horizon or c.base15 })
  hl("MasonHighlightBlockBoldSecondary", { fg = c.oled or c.base00, bg = c.horizon or c.base15, bold = true })
  hl("MasonMuted", { link = "Comment" })
  hl("MasonMutedBlock", { fg = c.paper or c.base04, bg = c.bg_surface or c.base01 })
  hl("MasonMutedBlockBold", { fg = c.paper or c.base04, bg = c.bg_surface or c.base01, bold = true })
  hl("MasonError", { link = "DiagnosticError" })

  -- trouble.nvim (v3)
  hl("TroubleNormal", { link = "NormalFloat" })
  hl("TroubleNormalNC", { link = "NormalFloat" })
  hl("TroubleText", { fg = c.paper or c.base04 })
  hl("TroublePreview", { link = "Visual" })
  hl("TroubleFilename", { fg = c.horizon or c.base15 })
  hl("TroubleBasename", { fg = c.horizon or c.base15 })
  hl("TroubleDirectory", { link = "Directory" })
  hl("TroubleIconDirectory", { link = "Directory" })
  hl("TroubleSource", { link = "Comment" })
  hl("TroubleCode", { link = "Comment" })
  hl("TroublePos", { fg = c.parchment or c.base05 })
  hl("TroubleCount", { fg = c.oled or c.base00, bg = c.ember or c.base12 })
  hl("TroubleStatusline", { link = "StatusLine" })
  for _, g in ipairs({ "TroubleIndent", "TroubleIndentFoldClosed", "TroubleIndentFoldOpen",
    "TroubleIndentTop", "TroubleIndentMiddle", "TroubleIndentLast", "TroubleIndentWs" }) do
    hl(g, { fg = c.border_subtle or c.base02 })
  end

  -- blink.cmp
  hl("BlinkCmpMenu", { link = "Pmenu" })
  hl("BlinkCmpMenuBorder", { link = "FloatBorder" })
  hl("BlinkCmpMenuSelection", { link = "PmenuSel" })
  hl("BlinkCmpScrollBarGutter", { link = "PmenuSbar" })
  hl("BlinkCmpScrollBarThumb", { link = "PmenuThumb" })
  hl("BlinkCmpLabel", { fg = c.paper or c.base04 })
  hl("BlinkCmpLabelDeprecated", { fg = c.cinder or c.base03, strikethrough = true })
  hl("BlinkCmpLabelMatch", { fg = c.photon or c.base08, bold = true })
  hl("BlinkCmpLabelDescription", { link = "Comment" })
  hl("BlinkCmpLabelDetail", { link = "Comment" })
  hl("BlinkCmpKind", { fg = c.ember or c.base12 })
  hl("BlinkCmpDoc", { link = "NormalFloat" })
  hl("BlinkCmpDocBorder", { link = "FloatBorder" })
  hl("BlinkCmpSignatureHelpBorder", { link = "FloatBorder" })

  -- fzf-lua
  hl("FzfLuaNormal", { link = "NormalFloat" })
  hl("FzfLuaBorder", { link = "FloatBorder" })
  hl("FzfLuaTitle", { link = "Title" })
  hl("FzfLuaHeaderBind", { fg = c.ember or c.base12 })
  hl("FzfLuaHeaderText", { fg = c.flare or c.base09 })
  hl("FzfLuaDirPart", { link = "Comment" })
  hl("FzfLuaFzfMatch", { fg = c.photon or c.base08, bold = true })
  hl("FzfLuaFzfPrompt", { fg = c.photon or c.base08 })
  hl("FzfLuaPathColNr", { fg = c.gravity_blue or c.base11 })
  hl("FzfLuaPathLineNr", { fg = c.quasar_green or c.base13 })
  hl("FzfLuaBufName", { fg = c.nova or c.base14 })
  hl("FzfLuaBufNr", { fg = c.horizon or c.base15 })
  hl("FzfLuaBufFlagCur", { fg = c.flare or c.base09 })
  hl("FzfLuaBufFlagAlt", { fg = c.gravity_blue or c.base11 })
  hl("FzfLuaTabTitle", { link = "Title" })
  hl("FzfLuaTabMarker", { fg = c.ember or c.base12 })
  hl("FzfLuaLiveSym", { fg = c.photon or c.base08 })

  -- diffview.nvim
  hl("DiffviewNormal", { link = "Normal" })
  hl("DiffviewDim1", { link = "Comment" })
  hl("DiffviewPrimary", { fg = c.flare or c.base09 })
  hl("DiffviewSecondary", { fg = c.ember or c.base12 })
  hl("DiffviewWinSeparator", { link = "WinSeparator" })
  hl("DiffviewFilePanelTitle", { fg = c.flare or c.base09, bold = true })
  hl("DiffviewFilePanelCounter", { fg = c.ember or c.base12, bold = true })
  hl("DiffviewFilePanelRootPath", { link = "Comment" })
  hl("DiffviewFilePanelFileName", { link = "Normal" })
  hl("DiffviewFilePanelSelected", { fg = c.light or c.base06, bg = c.bg_selection or c.base02 })
  hl("DiffviewFilePanelPath", { link = "Comment" })
  hl("DiffviewFilePanelInsertions", { link = "DiffAdded" })
  hl("DiffviewFilePanelDeletions", { link = "DiffRemoved" })
  hl("DiffviewFilePanelConflicts", { fg = c.nova or c.base14 })
  hl("DiffviewFolderName", { link = "Directory" })
  hl("DiffviewFolderSign", { link = "Directory" })
  hl("DiffviewHash", { link = "Comment" })
  hl("DiffviewReference", { fg = c.gravity_blue or c.base11 })
  hl("DiffviewReflogSelector", { fg = c.horizon or c.base15 })
  hl("DiffviewStatusAdded", { link = "DiffAdded" })
  hl("DiffviewStatusUntracked", { fg = c.quasar_green or c.base13 })
  hl("DiffviewStatusModified", { link = "DiffChanged" })
  hl("DiffviewStatusRenamed", { link = "DiffChanged" })
  hl("DiffviewStatusCopied", { link = "DiffChanged" })
  hl("DiffviewStatusTypeChange", { link = "DiffChanged" })
  hl("DiffviewStatusUnmerged", { fg = c.nova or c.base14 })
  hl("DiffviewStatusUnknown", { link = "Comment" })
  hl("DiffviewStatusDeleted", { link = "DiffRemoved" })
  hl("DiffviewStatusBroken", { fg = c.redshift or c.base10 })
  hl("DiffviewStatusIgnored", { link = "Comment" })

  -- indent-blankline.nvim (ibl v3)
  hl("IblIndent", { fg = c.border_subtle or c.base02 })
  hl("IblWhitespace", { fg = c.border_subtle or c.base02 })
  hl("IblScope", { fg = c.border_visible or c.base08 })

  -- rainbow-delimiters.nvim
  hl("RainbowDelimiterRed", { fg = c.corona or c.base12 })
  hl("RainbowDelimiterYellow", { fg = c.gold or c.base08 })
  hl("RainbowDelimiterBlue", { fg = c.ion or c.base07 })
  hl("RainbowDelimiterOrange", { fg = c.nova or c.base14 })
  hl("RainbowDelimiterGreen", { fg = c.quasar_green or c.base13 })
  hl("RainbowDelimiterViolet", { fg = c.horizon or c.base15 })
  hl("RainbowDelimiterCyan", { fg = c.photon or c.yellow })

  -- nvim-treesitter-context
  hl("TreesitterContext", { bg = c.bg_void or c.base01 })
  hl("TreesitterContextLineNumber", { fg = c.photon or c.base08, bg = c.bg_void or c.base01 })
  hl("TreesitterContextBottom", { underline = true, sp = c.border_subtle or c.base02 })

  -- vim-illuminate
  hl("IlluminatedWordText", { link = "LspReferenceText" })
  hl("IlluminatedWordRead", { link = "LspReferenceRead" })
  hl("IlluminatedWordWrite", { link = "LspReferenceWrite" })

  -- leap.nvim
  hl("LeapMatch", { fg = c.oled or c.base00, bg = c.photon or c.base08, bold = true })
  hl("LeapLabel", { fg = c.flare or c.base09, bold = true })
  hl("LeapBackdrop", { link = "Comment" })

  -- render-markdown.nvim
  for i = 1, 6 do
    hl("RenderMarkdownH" .. i, { link = "markdownH" .. i })
    hl("RenderMarkdownH" .. i .. "Bg", { bg = c.bg_surface or c.base01 })
  end
  hl("RenderMarkdownCode", { bg = c.bg_elevated or c.base01 })
  hl("RenderMarkdownCodeInline", { fg = c.corona or c.base12, bg = c.bg_elevated or c.base01 })
  hl("RenderMarkdownBullet", { fg = c.gold or c.base08 })
  hl("RenderMarkdownTableHead", { fg = c.ember or c.base12 })
  hl("RenderMarkdownTableRow", { fg = c.paper or c.base04 })
  hl("RenderMarkdownSuccess", { fg = c.quasar_green or c.base13 })
  hl("RenderMarkdownInfo", { link = "DiagnosticInfo" })
  hl("RenderMarkdownHint", { link = "DiagnosticHint" })
  hl("RenderMarkdownWarn", { link = "DiagnosticWarn" })
  hl("RenderMarkdownError", { link = "DiagnosticError" })

  -- nvim-dap
  hl("DapBreakpoint", { fg = c.redshift or c.base10 })
  hl("DapBreakpointCondition", { fg = c.ember or c.base12 })
  hl("DapBreakpointRejected", { link = "Comment" })
  hl("DapLogPoint", { fg = c.gravity_blue or c.base11 })
  hl("DapStopped", { fg = c.quasar_green or c.base13 })

  -- nvim-dap-ui
  hl("DapUINormal", { link = "NormalFloat" })
  hl("DapUIVariable", { fg = c.paper or c.base04 })
  hl("DapUIScope", { fg = c.gold or c.base08 })
  hl("DapUIType", { fg = c.ion or c.base07 })
  hl("DapUIValue", { fg = c.paper or c.base04 })
  hl("DapUIModifiedValue", { fg = c.ember or c.base12, bold = true })
  hl("DapUIDecoration", { fg = c.gold or c.base08 })
  hl("DapUIThread", { fg = c.quasar_green or c.base13 })
  hl("DapUIStoppedThread", { fg = c.gold or c.base08 })
  hl("DapUISource", { fg = c.gravity_blue or c.base11 })
  hl("DapUILineNumber", { fg = c.photon or c.base08 })
  hl("DapUIFloatNormal", { link = "NormalFloat" })
  hl("DapUIFloatBorder", { link = "FloatBorder" })
  hl("DapUIWatchesEmpty", { fg = c.redshift or c.base10 })
  hl("DapUIWatchesValue", { fg = c.quasar_green or c.base13 })
  hl("DapUIWatchesError", { link = "DiagnosticError" })
  hl("DapUIBreakpointsPath", { fg = c.gold or c.base08 })
  hl("DapUIBreakpointsInfo", { fg = c.quasar_green or c.base13 })
  hl("DapUIBreakpointsCurrentLine", { fg = c.quasar_green or c.base13, bold = true })
  hl("DapUIBreakpointsLine", { fg = c.gold or c.base08 })
  hl("DapUIBreakpointsDisabledLine", { link = "Comment" })
  hl("DapUICurrentFrameName", { fg = c.quasar_green or c.base13, bold = true })
  hl("DapUIStepOver", { fg = c.gravity_blue or c.base11 })
  hl("DapUIStepInto", { fg = c.gravity_blue or c.base11 })
  hl("DapUIStepBack", { fg = c.gravity_blue or c.base11 })
  hl("DapUIStepOut", { fg = c.gravity_blue or c.base11 })
  hl("DapUIStop", { fg = c.redshift or c.base10 })
  hl("DapUIPlayPause", { fg = c.quasar_green or c.base13 })
  hl("DapUIRestart", { fg = c.quasar_green or c.base13 })
  hl("DapUIUnavailable", { link = "Comment" })
  hl("DapUIWinSelect", { fg = c.ember or c.base12 })
  hl("DapUIEndofBuffer", { link = "EndOfBuffer" })

  -- oil.nvim
  hl("OilDir", { link = "Directory" })
  hl("OilDirIcon", { link = "Directory" })
  hl("OilFile", { link = "Normal" })
  hl("OilLink", { fg = c.gravity_blue or c.base11 })
  hl("OilLinkTarget", { fg = c.nova or c.base14 })
  hl("OilOrphanLink", { fg = c.redshift or c.base10 })
  hl("OilOrphanLinkTarget", { fg = c.redshift or c.base10 })
  hl("OilSocket", { fg = c.nova or c.base14 })
  hl("OilCreate", { link = "DiffAdded" })
  hl("OilDelete", { link = "DiffRemoved" })
  hl("OilMove", { link = "DiffChanged" })
  hl("OilCopy", { link = "DiffChanged" })
  hl("OilChange", { link = "DiffChanged" })
  hl("OilRestore", { link = "DiffAdded" })
  hl("OilPurge", { fg = c.redshift or c.base10 })
  hl("OilTrash", { fg = c.redshift or c.base10 })
  hl("OilTrashSourcePath", { link = "Comment" })
  for _, g in ipairs({ "OilHidden", "OilDirHidden", "OilFileHidden", "OilSocketHidden",
    "OilLinkHidden", "OilEmpty" }) do
    hl(g, { link = "Comment" })
  end

  -- fidget.nvim
  hl("FidgetTask", { link = "Comment" })
  hl("FidgetTitle", { fg = c.ember or c.base12 })

  -- lspsaga.nvim
  hl("SagaNormal", { link = "NormalFloat" })
  hl("SagaBorder", { link = "FloatBorder" })
  hl("SagaTitle", { link = "Title" })
  hl("SagaText", { fg = c.paper or c.base04 })
  hl("SagaCount", { fg = c.ember or c.base12 })
  hl("SagaBeacon", { bg = c.ember or c.base12 })
  hl("SagaVirtLine", { fg = c.border_subtle or c.base02 })
  hl("SagaSpinner", { fg = c.ember or c.base12 })
  hl("SagaSpinnerTitle", { fg = c.gravity_blue or c.base11 })
  hl("SagaSelect", { fg = c.flare or c.base09 })
  hl("SagaSearch", { fg = c.photon or c.base08, bold = true })
  hl("SagaFinderFname", { fg = c.horizon or c.base15 })
  hl("SagaDetail", { link = "Comment" })
  hl("SagaFileName", { fg = c.horizon or c.base15 })
  hl("SagaFolderName", { link = "Directory" })
  hl("SagaInCurrent", { fg = c.flare or c.base09 })
  hl("RenameNormal", { link = "NormalFloat" })
  hl("RenameMatch", { fg = c.photon or c.base08, bold = true })

  -- dropbar.nvim
  hl("DropBarMenuHoverEntry", { bg = c.bg_selection_soft or c.base01 })
  hl("DropBarMenuHoverIcon", { fg = c.ember or c.base12 })
  hl("DropBarMenuHoverSymbol", { fg = c.photon or c.base08, bold = true })
  hl("DropBarIconUISeparator", { link = "Comment" })

  -- Dim inactive windows (#37).
  if cfg.dim_inactive then
    hl("NormalNC", { fg = c.paper or c.base04, bg = c.bg_void or c.base01 })
  end

  -- Transparency (#103, #41): clear large editor surfaces only. Floats, pickers,
  -- completion menus, hovers and command palettes stay backed by darkness.
  if cfg.transparent then
    local groups = {
      "Normal", "NormalNC", "SignColumn", "FoldColumn", "MsgArea",
      "LineNr", "CursorLineNr", "EndOfBuffer", "WinSeparator", "VertSplit",
      "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeWinSeparator",
      "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeWinSeparator",
    }
    for _, g in ipairs(groups) do
      local current = vim.api.nvim_get_hl(0, { name = g })
      current.bg = nil
      current.ctermbg = nil
      vim.api.nvim_set_hl(0, g, current)
    end
    hl("Normal", { fg = c.parchment or c.base05, bg = c.none })
    hl("NormalNC", { fg = c.parchment or c.base05, bg = c.none })
    hl("MsgArea", { fg = c.parchment or c.base05, bg = c.none })
    hl("Comment", { fg = c.mist or c.base03, bg = c.none, italic = true })
    hl("SpecialComment", { fg = c.mist or c.base03, bg = c.none, italic = true })
    hl("LineNr", { fg = c.dust or c.base03, bg = c.none })
    hl("SignColumn", { fg = c.dust or c.base03, bg = c.none })
    hl("FoldColumn", { fg = c.dust or c.base03, bg = c.none })
    hl("CursorLineNr", { fg = c.photon or c.base08, bg = c.none, bold = true })
    hl("Delimiter", { fg = c.mist or c.base03, bg = c.none })
    hl("@punctuation.delimiter", { fg = c.mist or c.base03, bg = c.none })
    hl("@punctuation.bracket", { fg = c.mist or c.base03, bg = c.none })
    hl("@punctuation.special", { fg = c.nova or c.base14, bg = c.none })
    hl("NvimTreeNormal", { fg = c.paper or c.base04, bg = c.none })
    hl("NvimTreeNormalNC", { fg = c.dust or c.base03, bg = c.none })
    hl("NeoTreeNormal", { fg = c.paper or c.base04, bg = c.none })
    hl("NeoTreeNormalNC", { fg = c.dust or c.base03, bg = c.none })
    hl("StatusLineNC", { fg = c.dust or c.base03, bg = c.none })
  end

  return c
end

return M
