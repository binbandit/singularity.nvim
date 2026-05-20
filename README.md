# singularity.nvim

A dark, light, and paper Neovim colorscheme built around **ember** — a deep,
burnt-orange accent. It's a pure-Lua descendant of
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

The **paper** theme is a warm, low-glare third variant — ember on aged-cream
stock (`#f4ecd8`) with a sepia grey ramp and accents darkened to stay AA-legible
on cream.

In the dark theme the grey ramp (`base01`–`base05`) is blended perceptually in
HSLuv space between the background and foreground anchors, so contrast stays even
across the scale.

## Features

- **Pure Lua** — no Fennel toolchain or build step. Clone and go.
- Dark and light variants, switched via `background`.
- LSP, Treesitter and semantic-token highlighting.
- Fast: plain `nvim_set_hl` calls, no runtime cost beyond the palette blend.
- Uses `termguicolors`; the 16 terminal colours are set too.
- Optional `setup()`: italics, transparency, dim-inactive windows, colourful headings.
- Requiring the module has no side effects — it applies only via `:colorscheme`.

### Plugin support

Explicit highlights are shipped for the core (Diagnostics, LSP semantic tokens,
nvim-treesitter) plus a wide range of plugins:

- **Completion**: nvim-cmp, blink.cmp
- **Pickers**: Telescope, fzf-lua
- **File explorers**: neo-tree, oil.nvim, NvimTree
- **Git**: Gitsigns, Neogit, diffview.nvim
- **UI / menus**: noice.nvim, which-key, lazy.nvim, mason.nvim, nvim-notify,
  fidget.nvim, bufferline, alpha, dropbar
- **Editing / motion**: indent-blankline, rainbow-delimiters, treesitter-context,
  vim-illuminate, leap.nvim, Flash, Hydra
- **LSP UI**: trouble.nvim, nvim-navic, lspsaga
- **Debug**: nvim-dap, nvim-dap-ui
- **Markup**: render-markdown, Vimwiki, markdown/asciidoc
- **The full [mini.nvim](https://github.com/nvim-mini/mini.nvim) suite** (24 modules)

A matching [lualine](https://github.com/nvim-lualine/lualine.nvim) theme is
bundled. Everything links to the theme's semantic groups, so plugins that key
off standard highlights (todo-comments, gitsigns, etc.) and most others "just
work".

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

### Variants

Three variants ship: **dark**, **light** and **paper** (warm cream). Select one
with a dedicated colorscheme name:

```lua
vim.cmd.colorscheme("singularity-dark")  -- or singularity-light / singularity-paper
```

Plain `:colorscheme singularity` follows the `variant` option (default `"auto"`,
which tracks `background`). Selecting a variant sets `background` to match.

## Configuration

`setup()` is optional — the colorscheme works with no configuration. Call it
before `:colorscheme` to override the defaults:

```lua
require("singularity").setup({
  variant = "auto",        -- "auto" (follow background) | "dark" | "light" | "paper"
  italics = true,          -- italic comments and emphasis
  transparent = false,     -- clear editor, gutter and float backgrounds
  dim_inactive = false,    -- give inactive windows a dimmer background
  colored_headings = true, -- per-level markdown heading colours
})

vim.opt.background = "dark"
vim.cmd.colorscheme("singularity")
```

With lazy.nvim, pass `opts` and apply the scheme in `config`:

```lua
{
  "binbandit/singularity.nvim",
  lazy = false,
  priority = 1000,
  opts = { transparent = true },
  config = function(_, opts)
    require("singularity").setup(opts)
    vim.cmd.colorscheme("singularity")
  end,
}
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

## Differences from oxocarbon

singularity began as a pure-Lua port of oxocarbon, then diverged:

- **Ember accent** instead of magenta, in both themes.
- **Legible light theme** — a tonal counterpart with WCAG-AA contrast on white
  (oxocarbon's light variant rendered comments near-black and several accents
  below AA).
- **No side effects on `require`** — applies only via `:colorscheme`/`load()`,
  so lazy-loading and the lualine theme no longer trigger it.
- **`setup()` configuration** — italics, transparency, dim-inactive, headings.
- **Fixes** drawn from oxocarbon's issue tracker: readable folded text, per-level
  markdown headings, cmp kind colours on the text rather than blocks, a defined
  `CurSearch`, subtler light-mode LSP references, and the missing diff/diagnostic
  groups (`Added`/`Changed`/`Removed`, `@diff.*`).
- **Comprehensive mini.nvim support** — 24 modules / ~130 highlight groups,
  validated against upstream `mini.hues`. The original repo has only a partial,
  unmerged PR.
- **~20 more popular plugins themed** — noice, which-key, neo-tree, blink.cmp,
  trouble, lazy, mason, diffview, fzf-lua, nvim-dap(-ui), render-markdown, navic,
  oil, leap, rainbow-delimiters and more (~440 groups), with names validated
  against current upstream sources.

## Credits

singularity.nvim is a Lua port and ember restyle of
[oxocarbon.nvim](https://github.com/nyoom-engineering/oxocarbon.nvim) by Nyoom
Engineering / Riccardo Mazzarini. The colour-space maths is unchanged from the
original Fennel implementation.

## License

[MIT](LICENSE). The original oxocarbon copyright is retained.
