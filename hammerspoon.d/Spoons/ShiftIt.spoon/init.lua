--- === HammerspoonShiftIt ===
---
--- Manages windows and positions in MacOS with key binding from ShiftIt.
---
--- Download: [https://github.com/peterkljin/hammerspoon-shiftit/raw/master/Spoons/HammerspoonShiftIt.spoon.zip](https://github.com/peterklijn/hammerspoon-shiftit/raw/master/Spoons/HammerspoonShiftIt.spoon.zip)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "HammerspoonShiftIt"
obj.version = "1.0"
obj.author = "Peter Klijn"
obj.homepage = "https://github.com/peterklijn/hammerspoon-shiftit"
obj.license = ""

obj.mash = { 'alt', 'cmd' }
obj.mapping = {
  left = { obj.mash, 'left' },
  right = { obj.mash, 'right' },

  left00_20 = { obj.mash, 'm' },
  left20_40 = { obj.mash, ',' },
  left40_100 = { obj.mash, '.' },
  left20_100 = { obj.mash, '/' },

  left00_32 = { obj.mash, 'j' },
  left32_68 = { obj.mash, 'k' },
  left68_100 = { obj.mash, 'l' },
  left32_100 = { obj.mash, ';' },

  up = { obj.mash, 'up' },
  down = { obj.mash, 'down' },
  upleft = { obj.mash, 'w' },
  upright = { obj.mash, 'r' },
  botleft = { obj.mash, 'x' },
  botright = { obj.mash, 'v' },
  maximum = { obj.mash, 'f' },
  toggleFullScreen = { obj.mash, '1' },
  toggleZoom = { obj.mash, 'z' },
  center = { obj.mash, 'd' },
  nextScreen = { obj.mash, 'n' },
  previousScreen = { obj.mash, 'p' },
  resizeOut = { obj.mash, '=' },
  resizeIn = { obj.mash, '-' }
}

local units = {
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },

  left00_20      = { x = 0.00, y = 0.00, w = 0.20, h = 1.00 },
  left20_40      = { x = 0.20, y = 0.00, w = 0.20, h = 1.00 },
  left40_100     = { x = 0.40, y = 0.00, w = 0.60, h = 1.00 },
  left20_100     = { x = 0.20, y = 0.00, w = 0.80, h = 1.00 },

  left00_32      = { x = 0.00, y = 0.00, w = 0.32, h = 1.00 },
  left32_68      = { x = 0.32, y = 0.00, w = 0.36, h = 1.00 },
  left68_100     = { x = 0.68, y = 0.00, w = 0.32, h = 1.00 },
  left32_100      = { x = 0.32, y = 0.00, w = 0.68, h = 1.00 },


  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },

  upleft50      = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
  upright50     = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
  botleft50     = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
  botright50    = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },

  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
}

function move(unit) hs.window.focusedWindow():move(unit, nil, true, 0) end

function resizeWindowInSteps(increment)
  screen = hs.window.focusedWindow():screen():frame()
  window = hs.window.focusedWindow():frame()
  wStep = math.floor(screen.w / 12)
  hStep = math.floor(screen.h / 12)
  x = window.x
  y = window.y
  w = window.w
  h = window.h
  if increment then
    xu = math.max(screen.x, x - wStep)
    w = w + (x-xu)
    x=xu
    yu = math.max(screen.y, y - hStep)
    h = h + (y - yu)
    y = yu
    w = math.min(screen.w - x + screen.x, w + wStep)
    h = math.min(screen.h - y + screen.y, h + hStep)
  else
    noChange = true
    notMinWidth = w > wStep * 3
    notMinHeight = h > hStep * 3

    snapLeft = x <= screen.x
    snapTop = y <= screen.y
    -- add one pixel in case of odd number of pixels
    snapRight = (x + w + 1) >= (screen.x + screen.w)
    snapBottom = (y + h + 1) >= (screen.y + screen.h)

    b2n = { [true]=1, [false]=0 }
    totalSnaps = b2n[snapLeft] + b2n[snapRight] + b2n[snapTop] + b2n[snapBottom]

    if notMinWidth and (totalSnaps <= 1 or not snapLeft) then
      x = x + wStep
      w = w - wStep
      noChange = false
    end
    if notMinHeight and (totalSnaps <= 1 or not snapTop) then
      y = y + hStep
      h = h - hStep
      noChange = false
    end
    if notMinWidth and (totalSnaps <= 1 or not snapRight) then
      w = w - wStep
      noChange = false
    end
    if notMinHeight and (totalSnaps <= 1 or not snapBottom) then
      h = h - hStep
      noChange = false
    end
    if noChange then
      x = notMinWidth and x + wStep or x
      y = notMinHeight and y + hStep or y
      w = notMinWidth and w - wStep * 2 or w
      h = notMinHeight and h - hStep * 2 or h
    end
  end
  hs.window.focusedWindow():move({x=x, y=y, w=w, h=h}, nil, true, 0)
end

function obj:left() move(units.left50, nil, true, 0) end
function obj:right() move(units.right50, nil, true, 0) end

function obj:left00_20() move(units.left00_20, nil, true, 0) end
function obj:left20_40() move(units.left20_40, nil, true, 0) end
function obj:left40_100() move(units.left40_100, nil, true, 0) end
function obj:left20_100() move(units.left20_100, nil, true, 0) end

function obj:left00_32() move(units.left00_32, nil, true, 0) end
function obj:left32_68() move(units.left32_68, nil, true, 0) end
function obj:left68_100() move(units.left68_100, nil, true, 0) end
function obj:left32_100() move(units.left32_100, nil, true, 0) end


function obj:up() move(units.top50, nil, true, 0) end
function obj:down() move(units.bot50, nil, true, 0) end
function obj:upleft() move(units.upleft50, nil, true, 0) end
function obj:upright() move(units.upright50, nil, true, 0) end
function obj:botleft() move(units.botleft50, nil, true, 0) end
function obj:botright() move(units.botright50, nil, true, 0) end

function obj:maximum() move(units.maximum, nil, true, 0) end

function obj:toggleFullScreen() hs.window.focusedWindow():toggleFullScreen() end
function obj:toggleZoom() hs.window.focusedWindow():toggleZoom() end
function obj:center() hs.window.focusedWindow():centerOnScreen(nil, true, 0) end
function obj:nextScreen() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():next(),false, true, 0) end
function obj:previousScreen() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():previous(),false, true, 0) end

function obj:resizeOut() resizeWindowInSteps(true) end
function obj:resizeIn() resizeWindowInSteps(false) end

--- HammerspoonShiftIt:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for HammerspoonShiftIt
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details (everything is optional) for the following items:
---   * left
---   * right
---   * up
---   * down
---   * upleft
---   * upright
---   * botleft
---   * botright
---   * maximum
---   * toggleFullScreen
---   * toggleZoom
---   * center
---   * nextScreen
---   * previousScreen
---   * resizeOut
---   * resizeIn
function obj:bindHotkeys(mapping)

  if (mapping) then
    for k,v in pairs(mapping) do self.mapping[k] = v end
  end

  hs.hotkey.bind(self.mapping.left[1], self.mapping.left[2], function() self:left() end)
  hs.hotkey.bind(self.mapping.right[1], self.mapping.right[2], function() self:right() end)

  hs.hotkey.bind(self.mapping.left00_20[1], self.mapping.left00_20[2], function() self:left00_20() end)
  hs.hotkey.bind(self.mapping.left20_40[1], self.mapping.left20_40[2], function() self:left20_40() end)
  hs.hotkey.bind(self.mapping.left40_100[1], self.mapping.left40_100[2], function() self:left40_100() end)
  hs.hotkey.bind(self.mapping.left20_100[1], self.mapping.left20_100[2], function() self:left20_100() end)

  hs.hotkey.bind(self.mapping.left00_32[1], self.mapping.left00_32[2], function() self:left00_32() end)
  hs.hotkey.bind(self.mapping.left32_68[1], self.mapping.left32_68[2], function() self:left32_68() end)
  hs.hotkey.bind(self.mapping.left68_100[1], self.mapping.left68_100[2], function() self:left68_100() end)
  hs.hotkey.bind(self.mapping.left32_100[1], self.mapping.left32_100[2], function() self:left32_100() end)

  hs.hotkey.bind(self.mapping.up[1], self.mapping.up[2], function() self:up() end)
  hs.hotkey.bind(self.mapping.down[1], self.mapping.down[2], function() self:down() end)
  hs.hotkey.bind(self.mapping.upleft[1], self.mapping.upleft[2], function() self:upleft() end)
  hs.hotkey.bind(self.mapping.upright[1], self.mapping.upright[2], function() self:upright() end)
  hs.hotkey.bind(self.mapping.botleft[1], self.mapping.botleft[2], function() self:botleft() end)
  hs.hotkey.bind(self.mapping.botright[1], self.mapping.botright[2], function() self:botright() end)
  hs.hotkey.bind(self.mapping.maximum[1], self.mapping.maximum[2], function() self:maximum() end)
  hs.hotkey.bind(self.mapping.toggleFullScreen[1], self.mapping.toggleFullScreen[2], function() self:toggleFullScreen() end)
  hs.hotkey.bind(self.mapping.toggleZoom[1], self.mapping.toggleZoom[2], function() self:toggleZoom() end)
  hs.hotkey.bind(self.mapping.center[1], self.mapping.center[2], function() self:center() end)
  hs.hotkey.bind(self.mapping.nextScreen[1], self.mapping.nextScreen[2], function() self:nextScreen() end)
  hs.hotkey.bind(self.mapping.previousScreen[1], self.mapping.previousScreen[2], function() self:previousScreen() end)
  hs.hotkey.bind(self.mapping.resizeOut[1], self.mapping.resizeOut[2], function() self:resizeOut() end)
  hs.hotkey.bind(self.mapping.resizeIn[1], self.mapping.resizeIn[2], function() self:resizeIn() end)

  return self
end

return obj
