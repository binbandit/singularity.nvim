-- singularity.nvim — lualine theme
--
-- Pulls straight from the active Singularity OLED v2 palette.

-- Prefer the palette of the currently-applied variant (set by load()), falling
-- back to a side-effect-free computation if the scheme has not been applied yet.
local mod = require("singularity")
local singularity = mod.colors or mod.get_palette()

local colors = {
  bg = singularity.bg_elevated,
  inactive_bg = singularity.bg_void,
  fg = singularity.light,
  muted = singularity.dust,
  black = singularity.oled,
  normal = singularity.photon,
  insert = singularity.quasar_green,
  visual = singularity.flare,
  replace = singularity.redshift,
  command = singularity.ion,
}

return {
  normal = {
    a = { fg = colors.black, bg = colors.normal },
    b = { fg = colors.fg, bg = colors.bg },
    c = { fg = colors.fg, bg = colors.bg },
    z = { fg = colors.fg, bg = colors.bg },
  },
  insert = {
    a = { fg = colors.black, bg = colors.insert },
    b = { fg = colors.fg, bg = colors.bg },
    z = { fg = colors.insert, bg = colors.bg },
  },
  visual = {
    a = { fg = colors.black, bg = colors.visual },
    b = { fg = colors.fg, bg = colors.bg },
    y = { fg = colors.fg, bg = colors.bg },
    z = { fg = colors.visual, bg = colors.bg },
  },
  replace = {
    a = { fg = colors.black, bg = colors.replace },
    b = { fg = colors.fg, bg = colors.bg },
  },
  command = {
    a = { fg = colors.black, bg = colors.command },
  },
  inactive = {
    a = { fg = colors.muted, bg = colors.inactive_bg },
    b = { fg = colors.muted, bg = colors.inactive_bg },
    c = { fg = colors.muted, bg = colors.inactive_bg },
    z = { fg = colors.muted, bg = colors.inactive_bg },
  },
}
