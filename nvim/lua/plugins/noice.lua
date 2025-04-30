---@type LazySpec
return {
  "folke/noice.nvim",

  opts = function(_, opts)
    local utils = require "astrocore"

    return utils.extend_tbl(opts, {
      presets = {
        inc_rename = false,
        command_palette = false,
      },
    })
  end,
}
