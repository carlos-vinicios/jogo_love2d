gravidade = 600
menuView = true
gameStart= false
charSelect = false
fontePrincipal = love.graphics.newFont("fontes/bubble & soap.ttf", 20)
fonteInLuta = love.graphics.newFont("fontes/Double_Bubble_shadow.otf", 35)

require "personagem"
require "menuPrincipal"
require "selecaoPersonagem"

function love.load()
  for i=1, #personagens do
    loadMovimentacao(personagens[i])
  end
  if gameStart then
    loadGolpe(personagens[1])
    loadGolpe(personagens[2])
  end
end

function love.update( dt )
  if charSelect then
    animacaoSelecionados(dt)
  end
  if gameStart then
    movimentacao(dt, personagens[1], personagens[2])
    cair(dt, personagens[1])
    cair(dt, personagens[2])
    socar( dt, personagens[1], personagens[2] )
  end
end

function love.draw()
  if menuView then
    renderizarButoes()
    renderizarTextos()
  end
  if charSelect then
    renderizartextTitle()
    renderizarpersonagensDisponiveis()
    renderizartextP1()
    renderizartextP2()
    if p1Selecionado then
      renderizarp1Selected(indexP1)
    end
    if p2Selecionado then
      renderizarp2Selected(indexP2)
    end
    renderizarvoltar()
  end
  if gameStart then
    love.graphics.setBackgroundColor(75, 114, 254) -- cor azul do fundo
    renderizarInformacoes(personagens[1], personagens[2])
    renderizarMovimento(personagens[1])
    renderizarMovimento(personagens[2])
    renderizarGolpes(personagens[1])
    renderizarGolpes(personagens[2])
    renderizarEstruturas()
  end
end

function love.keyreleased( key ) --saber quando uma dada tecla deixou de ser apertada no teclado
  parou( key, personagens[1], personagens[2] )
end

function love.keypressed(key) --saber quando uma dada teclada foi pressionada
  pular( key, personagens[1], personagens[2] )
end

function love.mousepressed(x, y, button) --saber qual parte da tela do jogo foi clicada pelo mouse
  play(x, y, button)
  exit(x, y, button)
  clickP1(x, y, button)
  clickVoltar(x, y, button)
  if button == 1 then
    print(x)
    print(y)
  end
end
