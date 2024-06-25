require "#{__dir__}/utils"

announce_section "Yarn setup"

# TODO: Robustify this. What if node isn't even installed? Include `corepack enable`. Etc...
if command?("yarn") && `yarn -v`.to_f < 2
  system("yarn check") || system!("yarn install")
else
  system!("yarn install")
end
