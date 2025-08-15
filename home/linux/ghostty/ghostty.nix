# This is the configuration file for Ghostty.
#
# This template file has been automatically created at the following
# path since Ghostty couldn't find any existing config files on your system:
#
#   /Users/kelevra/Library/Application Support/com.mitchellh.ghostty/config
#
# The template does not set any default options, since Ghostty ships
# with sensible defaults for all options. Users should only need to set
# options that they want to change from the default.
#
# Run `ghostty +show-config --default --docs` to view a list ofghost
# all available config options and their default values.
#
# Additionally, each config option is also explained in detail
# on Ghostty's website, at https://ghostty.org/docs/config.

# Config syntax crash course
# ==========================
# # The config file consists of simple key-value pairs,
# # separated by equals signs.
font-family = GohuFont 14 Nerd Font
window-padding-x = 1
theme = GruvboxDarkHard
background-opacity = 0.8
background-blur = true
keybind = unconsumed:alt+one=goto_tab:1
keybind = unconsumed:alt+two=goto_tab:2
keybind = unconsumed:alt+three=goto_tab:3
keybind = unconsumed:alt+four=goto_tab:4
keybind = unconsumed:alt+five=goto_tab:5
keybind = unconsumed:alt+six=goto_tab:6
keybind = unconsumed:alt+seven=goto_tab:7
keybind = unconsumed:alt+eight=goto_tab:8
keybind = unconsumed:alt+nine=last_tab

# theme = rose-pine
#
# # Spacing around the equals sign does not matter.
# # All of these are identical:
# key=value
# key= value
# key =value
# key = value
#
# # Any line beginning with a # is a comment. It's not possible to put
# # a comment after a config option, since it would be interpreted as a
# # part of the value. For example, this will have a value of "#123abc":
# background = #123abc
#
# # Empty values are used to reset config keys to default.
# key =
#
# # Some config options have unique syntaxes for their value,
# # which is explained in the docs for that config option.
# # Just for example:
# resize-overlay-duration = 4s 200ms

