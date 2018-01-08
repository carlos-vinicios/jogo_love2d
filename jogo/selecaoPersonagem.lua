p1Selecionado = false -- define que o player 1 ainda não foi definido
p2Selecionado = false -- define que o player 2 ainda não foi definido
indexP1 = nil -- index do player 1 dentro do vetor personagens
indexP2 = nil -- index do player 2 dentro do vetor personagens

-- Condicionais para seleção de personagens
function char1(x, y) -- condição para saber se a área do primeiro personagem foi selecinada
  return (x >= 100 and x <= 190) and (y >= 140 and y <= 230)
end

function char2(x, y) -- condição para saber se a área do segundo personagem foi selecinada
  return (x >= 460 and x <= 550) and (y >= 140 and y <= 230)
end
-- fim do controle de seleção de personagens

-- Controla a renderização dos textos e detalhes do menu de seleção de personagens
function renderizarTextTitle() -- renderiza o texto titulo da tela de seleção de personagem
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Selecione o seu Personagem", 90, 30)
end

function renderizarPersonagensDisponiveis() -- cria os quadrados no modo line e coloca as imagens dos personagens disponiveis dentro
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", 100, 140, 90, 90)
  love.graphics.draw(personagens[1].thumb, 115, 145, 0, 2, 2, 0, 0)
  love.graphics.rectangle("line", 460, 140, 90, 90)
  love.graphics.draw(personagens[2].thumb, 535, 145, 0, -2, 2, 0, 0)
  love.graphics.rectangle("line", 150, 270, 90, 90) -- quadrados vazios que são personagens que não estão disponiveis
  love.graphics.rectangle("line", 285, 270, 90, 90)
  love.graphics.rectangle("line", 420, 270, 90, 90)
  love.graphics.rectangle("line", 285, 400, 90, 90)
end

function renderizarTextP1() -- Texto acima da área de seleção do personagem 1
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("P1", 130, 400)
end

function renderizarP1Selected(indexP1) -- renderiza a animação do personagem 1 selecionado
  personagens[indexP1].animParado:draw(personagens[indexP1].imgParado, 155, 510, 0, 1, 1, 29, 63)
end

function renderizarTextP2() -- Texto acima da área de seleção do personagem 2
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("P2", 490, 400)
end

function renderizarP2Selected(indexP2) -- renderiza a animação do personagem 2 selecionado
  personagens[indexP2].animParado:draw(personagens[indexP2].imgParado, 500, 510, 0, -1, 1, 29, 63)
end

function renderizarVoltar() -- renderiza o texto back para voltar ao menu principal
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Back", 10, 600)
end

function renderizarStart() -- renderiza o texto de start para dar inicio ao jogo
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Start", 550, 600)
end
-- fim do controle de renderização

--Controle de animações do menu de seleção
function animacaoSelecionados(dt) -- faz a animação dos personagens selecionados
  if p1Selecionado and p2Selecionado then -- só é executada caso os dois personagens estejam selecionados 
    personagens[indexP1].animParado:update(dt)
    personagens[indexP2].animParado:update(dt)
  end
end
--fim do controle de animação

--funções de click
function clickP1(x, y, botao) -- clica para selecionar o P1 e já define automaticamente o player 2, pois to com preguiça de botar um 3° personagem
  if not p1Selecionado then
    if botao == 1 and char1(x, y) then
      p1Selecionado = true
      indexP1 = 1
      p2Selecionado = true
      indexP2 = 2
    elseif botao == 1 and char2(x, y) then
      p1Selecionado = true
      indexP1 = 2
      p2Selecionado = true
      indexP2 = 1
    end
  end
end

function clickVoltar (x, y, botao) -- clica para voltar ao menu principal
  if botao == 1 and ( x >= 10 and x <= 86) and (y >= 610 and y <= 635) then
    charSelect = false
    menuView = true
    p1Selecionado = false
    p2Selecionado = false
    indexP1 = nil
    indexP2 = nil
  end
end

function clickStart(x, y, botao) -- clica para começar o jogo
  if botao == 1 and (x >= 550 and x <= 640) and (y >= 610 and y <= 635) then
    p1 = indexP1
    p2 = indexP2
    gameStart = true
    charSelect = false
    p1Selecionado = false
    p2Selecionado = false
    indexP1 = nil
    indexP2 = nil
  end
end
-- fim das funções de click
