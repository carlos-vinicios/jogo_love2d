initPosY = 570
initPosX = 100
gravidade = 600
velY = 0
require "personagem"

function love.load()
  loadMovimentacao()
  loadGolpe()
end

function love.update( dt )
  movimentacao(dt)
  cair(dt, personagem)
  golpear( dt )
end

function love.draw()
  love.graphics.setBackgroundColor(75, 114, 254) -- cor azul do fundo
  renderizarMovimento()
  renderizarGolpes()
  renderizarEstruturas()
end

function love.keyreleased( key ) --saber quando uma dada tecla deixou de ser apertada no teclado
  parou( key )
end

function love.keypressed(key) --saber quando uma dada teclada foi pressionada
  pular( key )
end
