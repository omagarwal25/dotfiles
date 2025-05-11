local function copilot_action(action)
  local copilot = require "copilot.suggestion"
  return function()
    if copilot.is_visible() then
      copilot[action]()
      return true -- doesn't run the next command
    end
  end
end

return {
  "zbirenbaum/copilot.lua",
  specs = {
    { import = "astrocommunity.completion.copilot-lua" },
    {
      "Saghen/blink.cmp",
      optional = true,
      opts = function(_, opts)
        if not opts.keymap then opts.keymap = {} end

        opts.keymap["<C-X>"] = { copilot_action "next" }
        opts.keymap["<C-Z>"] = { copilot_action "prev" }
        -- opts.keymap["<C-Right>"] = { copilot_action "accept_word" }
        opts.keymap["<C-L>"] = { copilot_action "accept" }
        -- opts.keymap["<C-Down>"] = { copilot_action "accept_line" }
        -- opts.keymap["<C-J>"] = { copilot_action "accept_line", "select_next", "fallback" }
      end,
    },
  },
}
