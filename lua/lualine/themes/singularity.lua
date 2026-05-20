-- singularity.nvim — lualine theme
--
-- Pulls straight from the active singularity palette, so it tracks the
-- background (dark/light) and the ember accents automatically.

-- Prefer the palette of the currently-applied variant (set by load()), falling
-- back to a side-effect-free computation if the scheme has not been applied yet.
local mod = require("singularity")
local singularity = mod.colors or mod.get_palette()

local colors = {
  color0 = singularity.base02,
  color1 = singularity.base10, -- ember-bright (replace mode)
  color2 = singularity.base08,
  color3 = singularity.base00,
  color6 = singularity.base04,
  color7 = singularity.base09,
  color8 = singularity.base14,
  color9 = singularity.base12, -- ember-hot (insert mode)
  color10 = singularity.base13,
}

return {
  normal = {
    a = { fg = colors.color0, bg = colors.color7 },
    b = { fg = colors.color6, bg = colors.color3 },
    c = { fg = colors.color6, bg = colors.color3 },
    z = { fg = colors.color6, bg = colors.color3 },
  },
  insert = {
    a = { fg = colors.color0, bg = colors.color9 },
    b = { fg = colors.color6, bg = colors.color3 },
    z = { fg = colors.color9, bg = colors.color3 },
  },
  visual = {
    a = { fg = colors.color0, bg = colors.color8 },
    b = { fg = colors.color6, bg = colors.color3 },
    y = { fg = colors.color6, bg = colors.color3 },
    z = { fg = colors.color9, bg = colors.color3 },
  },
  replace = {
    a = { fg = colors.color0, bg = colors.color1 },
    b = { fg = colors.color2, bg = colors.color3 },
  },
  command = {
    a = { fg = colors.color0, bg = colors.color10 },
  },
  inactive = {
    a = { fg = colors.color0, bg = colors.color7 },
    b = { fg = colors.color6, bg = colors.color3 },
    z = { fg = colors.color0, bg = colors.color3 },
  },
}
