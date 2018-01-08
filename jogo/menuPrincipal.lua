function renderizarTextos() -- renderiza os textos que serviram para click e execução do jogo
  love.graphics.setFont(fonteInLuta)
  love.graphics.setColor( 255, 255, 255)
  love.graphics.print("PLAY", 295, 290) -- passa para o menu de seleção de personagem
  love.graphics.print("EXIT", 300, 350) -- finaliza o jogo
end

function play(x, y, botao) -- clica no botao de play para ir a seleção de personagens
  if botao == 1 and (x >= 295 and x <= 380) and ( y >= 300 and y <= 325) then
    menuView = false
    charSelect = true
  end
end

function exit(x, y, botao) -- clica para encerrar o jogo
  if botao == 1 and (x >= 300 and x <= 366) and (y >= 360 and y <= 390) then
    print("exit")
    love.event.quit()
  end
end
