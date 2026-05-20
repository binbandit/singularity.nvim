# singularity.nvim

A dark and light Neovim colorscheme built around **ember** — a deep, burnt-orange
accent. It's a pure-Lua descendant of
[oxocarbon.nvim](https://github.com/nyoom-engineering/oxocarbon.nvim) (itself
inspired by [IBM Carbon](https://carbondesignsystem.com/guidelines/color/overview/)),
restyled so the signature colour is ember rather than magenta.

The palette keeps oxocarbon's industrial greys, blues, teals, greens and purples,
but swaps its two pinks for the ember pair. In the **dark** theme the brand
colours are used directly:

| Role | Ember | Hex | Was (oxocarbon) |
| --- | --- | --- | --- |
| Primary accent — errors, headings, properties, diffs | `ember-bright` | `#dd5500` | `#ee5396` |
| Secondary accent — functions, decorators, insert mode | `ember-hot` | `#ee6611` | `#ff7eb6` |

The **light** theme is a tonal counterpart, not a separate design: ember is the
signature accent in the same roles, the syntax colours stay cool (blue/teal),
and every accent is WCAG-AA legible on white. Because the bright embers fall
below AA contrast on a light background, light mode uses deeper shades —
`#b34400` (errors/headings) and `#c65300` (functions) — and a Material blue-grey
ramp so comments recede instead of rendering near-black.

In the dark theme the grey ramp (`base01`–`base05`) is blended perceptually in
HSLuv space between the background and foreground anchors, so contrast stays even
across the scale.

## Features

- **Pure Lua** — no Fennel toolchain or build step. Clone and go.
- Dark and light variants, switched via `background`.
- LSP, Treesitter and semantic-token highlighting.
- Fast: plain `nvim_set_hl` calls, no runtime cost beyond the palette blend.
- Uses `termguicolors`; the 16 terminal colours are set too.

### Plugin support

Explicit highlights are shipped for: Diagnostics, LSP, nvim-treesitter,
Telescope, nvim-notify, nvim-cmp, NvimTree, Neogit, Gitsigns, Hydra, Flash,
bufferline, alpha, Vimwiki and markdown/asciidoc. A matching
[lualine](https://github.com/nvim-lualine/lualine.nvim) theme is bundled. Most
other plugins "just work".

## Install

Requires Neovim `>= 0.7.0` (a recent stable or nightly is recommended).

### lazy.nvim

```lua
{
  "binbandit/singularity.nvim",
  lazy = false,
  priority = 1000,
}
```

### packer.nvim

```lua
use { "binbandit/singularity.nvim" }
```

## Usage

```lua
vim.opt.background = "dark" -- or "light"
vim.cmd.colorscheme("singularity")
```

For a transparent background, clear the relevant groups after the colorscheme:

```lua
for _, group in ipairs({ "Normal", "NormalNC", "NormalFloat" }) do
  vim.api.nvim_set_hl(0, group, { bg = "none" })
end
```

### lualine

```lua
require("lualine").setup({
  options = { theme = "singularity" },
})
```

## Customising the palette

All colours live in [`lua/singularity/init.lua`](lua/singularity/init.lua) as the
`dark` and `light` tables. The HSLuv blending and other colour helpers
(`blend_hex`, `lighten_hex`, `darken_hex`, `gradient`, …) are in
[`lua/singularity/colorutils.lua`](lua/singularity/colorutils.lua).

## Credits

singularity.nvim is a Lua port and ember restyle of
[oxocarbon.nvim](https://github.com/nyoom-engineering/oxocarbon.nvim) by Nyoom
Engineering / Riccardo Mazzarini. The colour-space maths is unchanged from the
original Fennel implementation.

## License

[MIT](LICENSE). The original oxocarbon copyright is retained.
