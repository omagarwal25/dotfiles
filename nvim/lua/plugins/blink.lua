---@type function?, function?

return {
  "Saghen/blink.cmp",
  opts = {
    completion = {
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "label", "label_description" },
            { "kind_icon", gap = 1, "kind" },
          },
        },
      },
    },
    cmdline = { completion = { ghost_text = { enabled = true } } },
  },
}
