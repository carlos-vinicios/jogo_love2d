function love.conf (t) --arquivo para gerenciar as configurações do game
  t.identity = nil
  t.externalstorage = false
  t.gammacorrect = false
  t.console = true

  --controle de janela
  t.window.title = "PFF - Panelinha Full Fight"
  t.window.icon = nil
  t.window.width = 650
  t.window.height = 650
  t.window.borderless = false
  t.window.resizable = true
  t.window.minwidth = 1
  t.window.minheight = 1
  t.window.fullscreen = false
  t.window.fullscreentype = "desktop"
  t.window.vsync = true
  t.window.msaa = 0
  t.window.display = 1
  t.window.highdpi = false
  t.window.x = nil
  t.window.y = nil

  --modulos do love2d
  t.modules.audio = true
  t.modules.event = true
  t.modules.graphcis = true
  t.modules.image = true
  t.modules.joystick = true
  t.modules.keyboard = true
  t.modules.math = true
  t.modules.mouse = true
  t.modules.physics = true
  t.modules.sound = true
  t.modules.system = true
  t.modules.timer = true
  t.modules.touch = true
  t.modules.video = true
  t.modules.window = true
  t.modules.thread = true
end
