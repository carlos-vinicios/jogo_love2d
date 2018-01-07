local larguraTela = love.graphics.getWidth()
local chao = { x= (larguraTela/2)/2 - 80, y= 570, largura = larguraTela/2 + 160, espessura = 80 }
local plat1 = { x= 40, y= 450, largura = 230, espessura = 30 }
local plat2 = { x= 380, y= 451, largura = 230, espessura = 30 }
local plat3 = { x= 130, y= 340, largura = 380, espessura = 30}

estruturas = {plat1, plat2, plat3, chao}

function renderizarEstruturas()
  love.graphics.setColor(168, 168, 168) --cor de cinza do chão
  for i=1, #estruturas do
    love.graphics.rectangle( "fill", estruturas[i].x, estruturas[i].y, estruturas[i].largura, estruturas[i].espessura) --plataforma
  end
end

function cair(dt, personagem) -- realiza os calculos para o pulo do personagem
  limitesPlataforma(estruturas, personagem)
  if personagem.velY ~= 0 then
    personagem.posY = personagem.posY - personagem.velY * dt
    personagem.velY = personagem.velY - gravidade * dt
    tocarPlataforma(estruturas, personagem)
  end
  pararPulo(personagem.initPosY, personagem)
  for i=1, #estruturas do
    pararPulo(estruturas[i].y, personagem)
  end
  if personagem.posY > 2500 then --trecho que realiza a retorno do personagem a plataforma central
    personagem.velY = 1
    personagem.posY = personagem.initPosY - 30
    personagem.posX = personagem.initPosX
    personagem.pulando = true
    personagem.danos = personagem.danos + 25
  end
end

function pararPulo(coordenaY, personagem) --para o pulo ao encostar no chão ou em uma plataforma
  if personagem.posY == coordenaY then
    personagem.pulando = false
  end
end

function limitesPlataforma(plats, personagem) --checa se o boneco ultrapassou o limite de certa plataforma, fazendo com que cai (recebe como parametro uma plataforma)
  for i=1,#plats do
    if personagem.posY == plats[i].y and ( personagem.posX < plats[i].x or personagem.posX > (plats[i].largura + plats[i].x)) then
        personagem.velY = 1 --para ativar a gravidade e fazer com que o boneco tenha uma queda vertical
    end
  end
end

function tocarPlataforma(plats, personagem) --checa se o personagem esta sobre uma plataforma, fazendo com que pare sua queda vertical
  for i=1, #plats do
    --posição do y do personagem maior que a posição da plataforma no eixo y, e menor que sua posição mais espessura, fazendo com que calcule o espaço ocupado na tela
    if (personagem.posY >= plats[i].y and personagem.posY <= plats[i].y + plats[i].espessura) and (personagem.posX >= plats[i].x and personagem.posX <= (plats[i].largura + plats[i].x)) then --para parar em plataforma
      personagem.velY = 0
      personagem.posY = plats[i].y
    end
  end
end
