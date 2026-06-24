local mainMod = "SUPER"
local term = "ghostty" -- Terminal
local files = "thunar" -- File Manager

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("xdg-open \"https://\""))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(files))
hl.bind(mainMod .. " + D", hl.dsp.global("caelestia:launcher"))

hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("[float; move 15% 5%; size 70% 60%] " .. term))
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd("[float; move 15% 5%; size 35% 60%] " .. term .. " -e qalc"))
