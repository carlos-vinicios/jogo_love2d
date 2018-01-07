p1Selecionado = false
p2Selecionado = false
indexP1 = nil
indexP2 = nil

-- Condicionais para seleção de personagens
function char1(x, y)
  return (x >= 100 and x <= 190) and (y >= 140 and y <= 230)
end

function char2(x, y)
  return (x >= 460 and x <= 550) and (y >= 140 and y <= 230)
end
-- fim do controle de seleção de personagens

-- Controla a renderização dos textos e detalhes do menu de seleção de personagens
function renderizartextTitle()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Selecione o seu Personagem", 90, 30)
end

function renderizarpersonagensDisponiveis()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", 100, 140, 90, 90)
  love.graphics.draw(personagens[1].thumb, 115, 145, 0, 2, 2, 0, 0)
  love.graphics.rectangle("line", 460, 140, 90, 90)
  love.graphics.draw(personagens[2].thumb, 535, 145, 0, -2, 2, 0, 0)
  love.graphics.rectangle("line", 150, 270, 90, 90)
  love.graphics.rectangle("line", 285, 270, 90, 90)
  love.graphics.rectangle("line", 420, 270, 90, 90)
  love.graphics.rectangle("line", 285, 400, 90, 90)
end

function renderizartextP1()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("P1", 130, 400)
end

function renderizarp1Selected(indexP1)
  personagens[indexP1].animParado:draw(personagens[indexP1].imgParado, 155, 510, 0, 1, 1, 29, 63)
end

function renderizartextP2()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("P2", 490, 400)
end

function renderizarp2Selected(indexP2)
  personagens[indexP2].animParado:draw(personagens[indexP2].imgParado, 500, 510, 0, -1, 1, 29, 63)
end

function renderizarvoltar()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Back", 10, 600)
end
-- fim do controle de renderização

--Controle de animações do menu de seleção
function animacaoSelecionados(dt)
  if p1Selecionado and p2Selecionado then
    personagens[indexP1].animParado:update(dt)
    personagens[indexP2].animParado:update(dt)
  end
end
--fim do controle de animação

--funções de click
function clickP1(x, y, botao)
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

function clickVoltar (x, y, botao)
  if botao == 1 and ( x >= 10 and x <= 86) and (y >= 610 and y <= 635) then
    charSelect = false
    menuView = true
    p1Selecionado = false
    p2Selecionado = false
    indexP1 = nil
    indexP2 = nil
  end
end

--[[function clickP2(x, y, botao)
  if not p2Selecionado then
    if botao == 1 and char1(x, y) then
      p2Selecionado = true
      j = 1
    elseif botao == 1 and char2(x, y) then
      p2Selecionado = true
      j = 2
    end
  end
end--]]
-- fim das funções de click
