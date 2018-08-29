gravidade = 600
menuView = true
gameStart= false
charSelect = false
gameover = false
p1 = nil
p2 = nil
fontePrincipal = love.graphics.newFont("fontes/bubble & soap.ttf", 20)
fonteInLuta = love.graphics.newFont("fontes/Double_Bubble_shadow.otf", 35)

require "cenarios"
require "personagem"
require "menuPrincipal"
require "selecaoPersonagem"

function love.load()
  loadCenario()
  loadBackground()
  for i=1, #personagens do
    loadMovimentacao(personagens[i])
  end
  for i=1, #personagens do
    loadGolpe(personagens[i])
  end
  for i=1, #personagens do
    loadDamages(personagens[i])
  end
end

function love.update( dt )
  if not gameover then
    if charSelect then
      animacaoSelecionados(dt)
    end
    if gameStart then
      setPosicao1(personagens[p1])
      setPosicao2(personagens[p2])
      movimentacao(dt, personagens[p1], personagens[p2])
      cair(dt, personagens[p1])
      cair(dt, personagens[p2])
      socar( dt, personagens[p1], personagens[p2] )
      empurrar( dt, personagens[p1], personagens[p2] )
      damageControl(dt, personagens[p1], personagens[p2] )
      if personagens[p1].danos >= 100 then
        gameover = true
      end
      if personagens[p2].danos >= 100 then
        gameover = true
      end
    end
  end
end

function love.draw()
  if gameover then
    gameOverView(personagens[p1], personagens[p2])
  else
    if menuView then
      renderizarBackgroundMenu()
      renderizarTextos()
    end
    if charSelect then
      love.graphics.setBackgroundColor(120, 120, 120) --cor de cinza
      renderizarTextTitle()
      renderizarPersonagensDisponiveis()
      renderizarTextP1()
      renderizarTextP2()
      if p1Selecionado then
        renderizarP1Selected(indexP1)
      end
      if p2Selecionado then
        renderizarP2Selected(indexP2)
      end
      renderizarVoltar()
      renderizarStart()
    end
    if gameStart then
      renderizarBackground()
      renderizarInformacoes(personagens[p1], personagens[p2])
      renderizarMovimento(personagens[p1])
      renderizarMovimento(personagens[p2])
      renderizarGolpes(personagens[p1])
      renderizarGolpes(personagens[p2])
      renderizarEstruturas()
      renderizarDamage(personagens[p1])
      renderizarDamage(personagens[p2])
    end
  end
end

function love.keyreleased( key ) --saber quando uma dada tecla deixou de ser apertada no teclado
  parou( key, personagens[p1], personagens[p2] )
end

function love.keypressed(key) --saber quando uma dada teclada foi pressionada
  pular( key, personagens[p1], personagens[p2] )
  backMainMenu(key)
end

function love.mousepressed(x, y, button) --saber qual parte da tela do jogo foi clicada pelo mouse
  if menuView then
    play(x, y, button)
    exit(x, y, button)
  end
  if charSelect then
    clickP1(x, y, button)
    clickVoltar(x, y, button)
    clickStart(x, y, button)
  end
end
