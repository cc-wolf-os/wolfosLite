local button = require(".sys.lib.ui.button")
local input = require(".sys.lib.ui.input")
local uiManager = require(".sys.lib.ui.uiManager")
local events = require(".sys.lib.events")

_ENV.wm.setProcessTitle(_ENV.wm.id, "Run")

local w, h = term.getSize()

local manager = events:new()
local focusableManager = uiManager:new()
local path = ""

local okay = button:new{
  x = w - 4, 
  y = h - 1, 
  text = "OK", 
  callback = function()
    _ENV.wm.addProcess(path, { isCentered = true }, true)
    _ENV.wm.killProcess(_ENV.wm.id)
  end, 
  disabled = true,
}

local cancel = button:new{
  x = w - 14, 
  y = h - 1, 
  text = "Cancel", 
  callback = function()
    _ENV.wm.killProcess(_ENV.wm.id)
  end,
}

local path = input:new{
  x = 2, 
  y = 4, 
  w = w - 4, 
  onChange = function(content) 
    if #content == 0 then
      okay:setDisabled(true)
    else
      okay:setDisabled(false)
    end
    path = content
  end, 
  onComplete = function(content, type)
    path = content
    if type == "return" then
      _ENV.wm.addProcess(content, { isCentered = true }, true)
      _ENV.wm.killProcess(_ENV.wm.id)
    end
  end,
}

path:setFocused(true)

local function render()
  w, h = term.getSize()
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.black)
  term.clear()

  term.setCursorPos(2, 2)
  term.write("Enter a path to run")

  path:render()
  okay:render()
  cancel:render()
end

focusableManager:addButton(okay)
focusableManager:addButton(cancel)
focusableManager:addInput(path)

focusableManager:inject(manager)
render()

while true do
  local e = {os.pullEvent()}
  focusableManager:check(e)
end