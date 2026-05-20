-- singularity.nvim — colour utilities
--
-- A pure-Lua HSLuv implementation plus a few perceptually-uniform blending
-- helpers. HSLuv keeps lightness perceptually even across hues, which is what
-- lets the grey ramp (base01–base05) blend cleanly between the background and
-- foreground anchors.
--
-- Ported from the original Fennel source of oxocarbon.nvim and de-mangled into
-- readable Lua. The maths is unchanged — `math.atan2` is kept deliberately for
-- LuaJIT/Neovim compatibility (it was removed in PUC-Lua 5.3+).

local hex_chars = "0123456789abcdef"

local epsilon = 0.0088564516
local kappa = 903.2962962
local ref_y = 1
local ref_u = 0.19783000664283
local ref_v = 0.46831999493879

-- Linear-RGB <-> XYZ conversion matrices (sRGB / D65).
local m = {
  { 3.2409699419045, -1.5373831775701, -0.498610760293 },
  { -0.96924363628087, 1.8759675015077, 0.041555057407175 },
  { 0.055630079696993, -0.20397695888897, 1.0569715142429 },
}

local m_inv = {
  { 0.41239079926595, 0.35758433938387, 0.18048078840183 },
  { 0.21263900587151, 0.71516867876775, 0.072192315360733 },
  { 0.019330818715591, 0.11919477979462, 0.95053215224966 },
}

-- Lines bounding the sRGB gamut at a given lightness, in the L*u*v* plane.
local function get_bounds(l)
  local result = {}
  local sub1 = ((l + 16) ^ 3) / 1560896
  local sub2 = (sub1 > epsilon) and sub1 or (l / kappa)

  for i = 1, 3 do
    local m1, m2, m3 = m[i][1], m[i][2], m[i][3]
    for t = 0, 1 do
      local top1 = (284517 * m1 - 94839 * m3) * sub2
      local top2 = (838422 * m3 + 769860 * m2 + 731718 * m1) * l * sub2 - 769860 * t * l
      local bottom = (632260 * m3 - 126452 * m2) * sub2 + 126452 * t
      table.insert(result, { slope = top1 / bottom, intercept = top2 / bottom })
    end
  end

  return result
end

local function length_of_ray_until_intersect(theta, line)
  return line.intercept / (math.sin(theta) - line.slope * math.cos(theta))
end

local function max_safe_chroma_for_lh(l, h)
  local hrad = h / 360 * math.pi * 2
  local bounds = get_bounds(l)
  local min = math.huge

  for i = 1, 6 do
    local distance = length_of_ray_until_intersect(hrad, bounds[i])
    if distance >= 0 then
      min = math.min(min, distance)
    end
  end

  return min
end

local function y_to_l(y)
  if y <= epsilon then
    return y / ref_y * kappa
  else
    return 116 * (y / ref_y) ^ 0.33333333333333 - 16
  end
end

local function l_to_y(l)
  if l <= 8 then
    return ref_y * l / kappa
  else
    return ref_y * ((l + 16) / 116) ^ 3
  end
end

local function from_linear(c)
  if c <= 0.0031308 then
    return 12.92 * c
  else
    return 1.055 * c ^ 0.41666666666667 - 0.055
  end
end

local function to_linear(c)
  if c > 0.04045 then
    return ((c + 0.055) / 1.055) ^ 2.4
  else
    return c / 12.92
  end
end

local function dot_product(a, b)
  local sum = 0
  for i = 1, 3 do
    sum = sum + a[i] * b[i]
  end
  return sum
end

local function luv_to_lch(tuple)
  local l, u, v = tuple[1], tuple[2], tuple[3]
  local c = math.sqrt(u * u + v * v)
  local h

  if c < 0.00000001 then
    h = 0
  else
    h = math.atan2(v, u) * 180 / 3.1415926535898
    if h < 0 then
      h = 360 + h
    end
  end

  return { l, c, h }
end

local function lch_to_luv(tuple)
  local l, c = tuple[1], tuple[2]
  local hrad = tuple[3] / 360 * 2 * math.pi
  return { l, math.cos(hrad) * c, math.sin(hrad) * c }
end

local function xyz_to_luv(tuple)
  local x, y, z = tuple[1], tuple[2], tuple[3]
  local divider = x + 15 * y + 3 * z
  local var_u = 4 * x
  local var_v = 9 * y

  if divider ~= 0 then
    var_u = var_u / divider
    var_v = var_v / divider
  else
    var_u = 0
    var_v = 0
  end

  local l = y_to_l(y)
  if l == 0 then
    return { 0, 0, 0 }
  end

  return { l, 13 * l * (var_u - ref_u), 13 * l * (var_v - ref_v) }
end

local function luv_to_xyz(tuple)
  local l, u, v = tuple[1], tuple[2], tuple[3]
  if l == 0 then
    return { 0, 0, 0 }
  end

  local var_u = u / (13 * l) + ref_u
  local var_v = v / (13 * l) + ref_v
  local y = l_to_y(l)
  local x = 0 - (9 * y * var_u) / ((var_u - 4) * var_v - var_u * var_v)

  return { x, y, (9 * y - 15 * var_v * y - var_v * x) / (3 * var_v) }
end

local function xyz_to_rgb(tuple)
  return {
    from_linear(dot_product(m[1], tuple)),
    from_linear(dot_product(m[2], tuple)),
    from_linear(dot_product(m[3], tuple)),
  }
end

local function rgb_to_xyz(tuple)
  local rgbl = { to_linear(tuple[1]), to_linear(tuple[2]), to_linear(tuple[3]) }
  return {
    dot_product(m_inv[1], rgbl),
    dot_product(m_inv[2], rgbl),
    dot_product(m_inv[3], rgbl),
  }
end

local function hex_to_rgb(hex)
  local lower = string.lower(hex)
  local rgb = {}
  for i = 0, 2 do
    local char1 = string.sub(lower, i * 2 + 2, i * 2 + 2)
    local char2 = string.sub(lower, i * 2 + 3, i * 2 + 3)
    local digit1 = string.find(hex_chars, char1) - 1
    local digit2 = string.find(hex_chars, char2) - 1
    rgb[i + 1] = (digit1 * 16 + digit2) / 255
  end
  return rgb
end

local function rgb_to_hex(tuple)
  local hex = "#"
  for i = 1, 3 do
    local c = math.floor(tuple[i] * 255 + 0.5)
    local digit2 = math.fmod(c, 16)
    local digit1 = math.floor((c - digit2) / 16)
    hex = hex .. string.sub(hex_chars, digit1 + 1, digit1 + 1)
    hex = hex .. string.sub(hex_chars, digit2 + 1, digit2 + 1)
  end
  return hex
end

local function lch_to_hsluv(tuple)
  local l, c, h = tuple[1], tuple[2], tuple[3]
  local max_chroma = max_safe_chroma_for_lh(l, h)

  if l > 99.9999999 then
    return { h, 0, 100 }
  end
  if l < 0.00000001 then
    return { h, 0, 0 }
  end

  return { h, c / max_chroma * 100, l }
end

local function hsluv_to_lch(tuple)
  local h, s, l = tuple[1], tuple[2], tuple[3]

  if l > 99.9999999 then
    return { 100, 0, h }
  end
  if l < 0.00000001 then
    return { 0, 0, h }
  end

  return { l, max_safe_chroma_for_lh(l, h) / 100 * s, h }
end

local function rgb_to_lch(tuple)
  return luv_to_lch(xyz_to_luv(rgb_to_xyz(tuple)))
end

local function lch_to_rgb(tuple)
  return xyz_to_rgb(luv_to_xyz(lch_to_luv(tuple)))
end

local function rgb_to_hsluv(tuple)
  return lch_to_hsluv(rgb_to_lch(tuple))
end

local function hsluv_to_rgb(tuple)
  return lch_to_rgb(hsluv_to_lch(tuple))
end

local function hex_to_hsluv(s)
  return rgb_to_hsluv(hex_to_rgb(s))
end

local function hsluv_to_hex(tuple)
  return rgb_to_hex(hsluv_to_rgb(tuple))
end

local function linear_tween(start, stop)
  return function(i)
    return start + i * (stop - start)
  end
end

local function radial_tween(x, y)
  local start = math.rad(x)
  local stop = math.rad(y)
  local delta = math.atan2(math.sin(stop - start), math.cos(stop - start))
  return function(i)
    return (360 + math.deg(start + delta * i)) % 360
  end
end

local function blend_hsluv(start, stop, ratio)
  local r = ratio or 0.5
  local h = radial_tween(start[1], stop[1])
  local s = linear_tween(start[2], stop[2])
  local l = linear_tween(start[3], stop[3])
  return { h(r), s(r), l(r) }
end

local function lighten(c, n)
  return { c[1], c[2], linear_tween(c[3], 100)(n) }
end

local function darken(c, n)
  return { c[1], c[2], linear_tween(c[3], 0)(n) }
end

local function saturate(c, n)
  return { c[1], linear_tween(c[2], 100)(n), c[3] }
end

local function desaturate(c, n)
  return { c[1], linear_tween(c[2], 0)(n), c[3] }
end

local function rotate(c, n)
  return { (n + c[1]) % 360, c[2], c[3] }
end

-- Blend two hex colours in HSLuv space. `ratio` is 0 (all c1) .. 1 (all c2).
local function blend_hex(c1, c2, ratio)
  return hsluv_to_hex(blend_hsluv(hex_to_hsluv(c1), hex_to_hsluv(c2), ratio))
end

local function lighten_hex(c, n)
  return hsluv_to_hex(lighten(hex_to_hsluv(c), n))
end

local function darken_hex(c, n)
  return hsluv_to_hex(darken(hex_to_hsluv(c), n))
end

local function saturate_hex(c, n)
  return hsluv_to_hex(saturate(hex_to_hsluv(c), n))
end

local function desaturate_hex(c, n)
  return hsluv_to_hex(desaturate(hex_to_hsluv(c), n))
end

local function rotate_hex(c, n)
  return hsluv_to_hex(rotate(hex_to_hsluv(c), n))
end

-- A 51-stop gradient (0, 0.02, .. 1) between two hex colours.
local function gradient(c1, c2)
  local steps = {}
  for i = 0, 1.01, 0.02 do
    steps[#steps + 1] = i
  end
  return vim.tbl_map(function(r)
    return blend_hex(c1, c2, r)
  end, steps)
end

-- `c1`, then `n` evenly-spaced blended stops, then `c2`.
local function gradient_n(c1, c2, n)
  local result = { c1 }
  local step = 1 / (n + 1)
  for i = 1, n do
    result[#result + 1] = blend_hex(c1, c2, i * step)
  end
  result[#result + 1] = c2
  return result
end

math.randomseed(os.time())

local function random_color(red_range, green_range, blue_range)
  local r = math.random(red_range[1], red_range[2])
  local g = math.random(green_range[1], green_range[2])
  local b = math.random(blue_range[1], blue_range[2])
  return string.format("#%02x%02x%02x", r, g, b)
end

-- Generate a random base16-style palette with a perceptually even grey ramp.
local function generate_palette()
  local bg = random_color({ 0, 63 }, { 0, 63 }, { 0, 63 })
  local fg = random_color({ 240, 255 }, { 240, 255 }, { 240, 255 })
  local ramp = {
    bg,
    blend_hex(bg, fg, 0.085),
    blend_hex(bg, fg, 0.18),
    blend_hex(bg, fg, 0.3),
    blend_hex(bg, fg, 0.7),
    blend_hex(bg, fg, 0.82),
    blend_hex(bg, fg, 0.95),
    fg,
  }
  local names = {
    "base00", "base01", "base02", "base03", "base04", "base05", "base06", "base07",
    "base08", "base09", "base0A", "base0B", "base0C", "base0D", "base0E", "base0F",
  }
  local palette = {}
  for i, hex in ipairs(ramp) do
    palette[names[i]] = hex
  end
  return palette
end

return {
  blend_hex = blend_hex,
  lighten_hex = lighten_hex,
  darken_hex = darken_hex,
  saturate_hex = saturate_hex,
  desaturate_hex = desaturate_hex,
  rotate_hex = rotate_hex,
  gradient = gradient,
  gradient_n = gradient_n,
  generate_palette = generate_palette,
}
