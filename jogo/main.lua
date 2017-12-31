--[[

--Criar um arquivo para gerir os personagens selecionados no menu, jogando-os dentro de um vetor e colocar estruturas de repetições em cada controle da classe de personagem
]]

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
  cair(dt, personagem1)
  golpear( dt )
  print(personagem1.danos)
end

function love.draw()
  love.graphics.setBackgroundColor(75, 114, 254) -- cor azul do fundo
  renderizarInformacoes()
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
