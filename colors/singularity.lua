-- Colorscheme entry point: `:colorscheme singularity`.
-- Uncache the module so the palette is recomputed on every (re)apply.
package.loaded["singularity"] = nil

require("singularity")
