local pretty_print = require("cc.pretty").pretty_print
local dim = require ".lib.dim"
local D = dim.create:new("out.dim")
D:add("/test/")
D:save()
local Dd = dim.file:new("/out.dim")
Dd:save("/testOut",2)
pretty_print(Dd)