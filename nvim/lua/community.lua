-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.
---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  { import = "astrocommunity.colorscheme.catppuccin" },

  { import = "astrocommunity.completion.blink-cmp-emoji" },
  { import = "astrocommunity.completion.copilot-lua" },

  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  { import = "astrocommunity.bars-and-lines.lualine-nvim" },
  { import = "astrocommunity.bars-and-lines.bufferline-nvim" },

  { import = "astrocommunity.diagnostics.trouble-nvim" },

  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },

  { import = "astrocommunity.motion.flash-nvim" },

  { import = "astrocommunity.motion.mini-basics" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.split-and-window.mini-map" },

  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.git.gitgraph-nvim" },

  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.gleam" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.prisma" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.elixir-phoenix" },
  { import = "astrocommunity.pack.yaml" },

  { import = "astrocommunity.programming-language-support.kulala-nvim" },

  { import = "astrocommunity.workflow.hardtime-nvim" },
  { import = "astrocommunity.workflow.precognition-nvim" },

  { import = "astrocommunity.docker.lazydocker" },

  { import = "astrocommunity.recipes.vscode" },
}
