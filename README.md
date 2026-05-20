# singularity.nvim

**Singularity OLED v2** is a no-compromise black-hole Neovim colorscheme:
true OLED black, accretion-disk orange, photon-ring yellow, warm paper
foregrounds, and sparse gravitational-lensing cool accents.

The palette is designed for long sessions on black or transparent editor setups.
Default code uses aged paper instead of pure white; Light is reserved for active,
focused, selected, or otherwise high-emphasis UI.

## Palette

| Role | Token | Hex |
| --- | --- | --- |
| OLED background | `oled` | `#000000` |
| Maximum emphasis | `light` | `#FFF6E3` |
| Default foreground | `paper` | `#D8C7A3` |
| Comments | `dust` | `#A99B83` |
| Line numbers | `cinder` | `#8E8374` |
| Keywords / focus | `flare` | `#FF7A1A` |
| Properties / fields | `ember` | `#FF9D3D` |
| Strings | `corona` | `#FFB86B` |
| Functions | `gold` | `#FFC857` |
| Methods / matches | `photon` | `#FFD98A` |
| Constants / numbers | `horizon` | `#FFF0B8` |
| Types / info | `ion` | `#8BDDE6` |
| Links / namespaces | `gravity_blue` | `#9EC7FF` |
| Success / additions | `quasar_green` | `#BFE879` |
| Decorators / macros | `nova` | `#F6A3FF` |
| Errors / deletions | `redshift` | `#FF746A` |

## Features

- Pure Lua: no build step.
- OLED-only palette with legacy colorscheme aliases.
- LSP, Treesitter and semantic-token highlighting.
- Plugin highlights for completion, pickers, file explorers, Git, diagnostics,
  DAP, markdown, mini.nvim, and common UI plugins.
- Terminal ANSI colors set from the OLED v2 palette.
- Optional transparent mode that clears large editor surfaces while keeping
  floats, completion menus, hover docs, and pickers solid. Transparent mode also
  boosts muted foregrounds one step for readability.
- Matching lualine theme.

## Install

Requires Neovim `>= 0.7.0`.

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
vim.cmd.colorscheme("singularity")
```

The legacy entrypoints still exist, but all load the same OLED palette:

```lua
vim.cmd.colorscheme("singularity-dark")
vim.cmd.colorscheme("singularity-light")
vim.cmd.colorscheme("singularity-paper")
```

## Configuration

`setup()` is optional. Call it before `:colorscheme` to override defaults:

```lua
require("singularity").setup({
  italics = true,
  transparent = false,
  dim_inactive = false,
  colored_headings = true,
})

vim.cmd.colorscheme("singularity")
```

With lazy.nvim:

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

## lualine

```lua
require("lualine").setup({
  options = { theme = "singularity" },
})
```

## Customizing

All colors live in [`lua/singularity/init.lua`](lua/singularity/init.lua). The
palette exposes named OLED v2 tokens plus `base00` through `base15` aliases used
by the highlight map.

## Credits

singularity.nvim began as a Lua port and restyle of
[oxocarbon.nvim](https://github.com/nyoom-engineering/oxocarbon.nvim) by Nyoom
Engineering / Riccardo Mazzarini. The current palette is Singularity OLED v2.

## License

[MIT](LICENSE).
