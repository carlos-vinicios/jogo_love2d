
function renderizarButoes()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle( "fill", 150, 270, 170, 80 )
  love.graphics.rectangle( "fill", 350, 270, 170, 80 )
  love.graphics.rectangle( "fill", 245, 380, 170, 80 )
end

function renderizarTextos()
  love.graphics.setFont(fonteInLuta)
  love.graphics.setColor( 0, 0, 0)
  love.graphics.print("PLAY", 200, 290)
  love.graphics.print("SETTINGS", 365, 290)
  love.graphics.print("EXIT", 300, 400)
end

function play(x, y, botao)
  if botao == 1 and (x >= 200 and x <= 276) and ( y >= 301 and y <= 325) then
    menuView = false
    charSelect = true
  end
end

function settings()

end

function exit(x, y, botao)
  if botao == 1 and (x >= 300 and x <= 367) and (y >= 410 and y <= 435) then
    print("exit")
    love.event.quit()
  end
end
