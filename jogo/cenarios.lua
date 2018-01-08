
function loadBackground()
  imgBackground = love.graphics.newImage("imagens/cenarios/backgroundMenu.png")
end

function loadCenario()
  imgCenario = love.graphics.newImage("imagens/cenarios/night.png")
--  print("carregou")
end

function renderizarBackground()
  --print("renderizou")
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(imgCenario, 0, 0 )
end

function renderizarBackgroundMenu()
  love.graphics.draw(imgBackground, 0, 0)
end
