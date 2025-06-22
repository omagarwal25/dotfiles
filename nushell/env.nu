# pnpm
$env.PNPM_HOME = "/Users/oma/Library/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend $env.PNPM_HOME )
# pnpm end
