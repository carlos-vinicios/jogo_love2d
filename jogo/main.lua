--[[

--Criar um arquivo para gerir os personagens selecionados no menu, jogando-os dentro de um vetor e colocar estruturas de repetições em cada controle da classe de personagem
]]

initPosY = 570
initPosX = 100
gravidade = 600
velY = 0
require "menuPrincipal"
require "selecaoPersonagem"
require "personagem"

function love.load()
  loadMovimentacao(personagens[1])
  loadMovimentacao(personagens[2])
  loadGolpe(personagens[1])
  loadGolpe(personagens[2])
end

function love.update( dt )
  movimentacao(dt, personagens[1], personagens[2])
  cair(dt, personagens[1])
  cair(dt, personagens[2])
  golpear( dt )
end

function love.draw()
  love.graphics.setBackgroundColor(75, 114, 254) -- cor azul do fundo
  renderizarInformacoes(personagens[1], personagens[2])
  renderizarMovimento(personagens[1])
  renderizarMovimento(personagens[2])
  renderizarGolpes(personagens[1])
  renderizarGolpes(personagens[2])
  renderizarEstruturas()
end

function love.keyreleased( key ) --saber quando uma dada tecla deixou de ser apertada no teclado
  parou( key )
end

function love.keypressed(key) --saber quando uma dada teclada foi pressionada
  pular( key )
end
