require 'plataformas'
local anim = require 'anim8'

carlim = {
  thumb = love.graphics.newImage("imagens/thumb.png"), --foto do personagem exibida na tela
  initPosY = 570,
  initPosX = 100,
  posX = 100, -- posição inicial do personagem no eixo X
  posY = 570, -- posição inicial do personagem no eixo Y
  velY = 0,
  danos = 0,
  alturaPulo = 350, --define a altura do salto do boneco
  direcao = true, --define a direcao true = right / false = left
  parado = true, --define se o boneco esta parado
  movimentando = false, --define se o boneco esta se movimentando
  pulando = false, --define se o boneco esta pulando
  golpeando = false, --define se o boneco esta dando golpes
  urlMovimento = "imagens/movimento.png",
  imgMovimento = nil,
  imgMovimentoX = 58,
  imgMovimentoY = 63,
  gridMovimento = '1-8',
  animMovimento = nil,
  urlParado = "imagens/parado.png",
  imgParado = nil,
  imgParadoX = 41,
  imgParadoY = 72,
  gridParado = '1-4',
  animParado = nil,
  imgPulo = love.graphics.newImage("imagens/pulo.png"),
  imgGolpe = love.graphics.newImage('imagens/soco.png'),
  imgGolpeX = 63,
  imgGolpeY = 66,
  gridGolpe = '1-5',
  animGolpe = nil
}

leleo = {
  initPosY = 570,
  initPosX = 500,
  thumb = love.graphics.newImage("imagens/thumb2.png"),
  posX = 500,
  posY = 570,
  velY = 0,
  danos = 0,
  alturaPulo = 350,
  direcao = true,
  parado = true,
  movimentando = false,
  pulando = false,
  golpeando = false,
  urlMovimento = "imagens/movimento2.png",
  imgMovimento = nil,
  imgMovimentoX = 69,
  imgMovimentoY = 72,
  gridMovimento = '1-6',
  animMovimento = nil,
  urlParado = "imagens/parado2.png",
  imgParado = nil,
  imgParadoX = 49,
  imgParadoY = 72,
  gridParado = '1-4',
  animParado = nil,
  imgPulo = love.graphics.newImage("imagens/pulo2.png"),
  imgGolpe = love.graphics.newImage("imagens/soco2.png"),
  imgGolpeX = 65,
  imgGolpeY = 72,
  gridGolpe = '1-6',
  animGolpe = nil
}

personagens = {carlim, leleo}

--Controle de informações do personagem
function renderizarInformacoes(personagem1, personagem2)
  love.graphics.setColor(239, 239, 239)
  love.graphics.setFont(fonteInLuta)
  love.graphics.print(tostring(math.floor(personagem1.danos)).."%", 100, 30)
  love.graphics.print(tostring(math.floor(personagem2.danos)).."%", 510, 30)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(personagem1.thumb, 30, 20, 0, 1.5, 1.5, 0, 0)
  love.graphics.draw(personagem2.thumb, 580, 20, 0, 1.5, 1.5, 0, 0)
end
--Fim do controle de informações do personagem

--Controle de movimentacao
function loadMovimentacao(personagem)
  personagem.imgParado = love.graphics.newImage(personagem.urlParado)
  local parado = anim.newGrid( personagem.imgParadoX, personagem.imgParadoY, personagem.imgParado:getWidth(), personagem.imgParado:getHeight() )
  personagem.animParado = anim.newAnimation( parado( personagem.gridParado, 1), 0.20 )
  personagem.imgMovimento = love.graphics.newImage(personagem.urlMovimento)
  local movi = anim.newGrid( personagem.imgMovimentoX, personagem.imgMovimentoY, personagem.imgMovimento:getWidth(), personagem.imgMovimento:getHeight() )
  personagem.animMovimento = anim.newAnimation( movi( personagem.gridMovimento, 1), 0.09 )
end

function movimentacao( dt, personagem1, personagem2 )
  if love.keyboard.isDown('left') then --quando o botão da esquerda no teclado, for apertado
    movimentarBonecos(false, personagem1, dt)
  end
  if love.keyboard.isDown('a') then
    movimentarBonecos(false, personagem2, dt)
  end
  if love.keyboard.isDown('right') then --quando o botão da direita no teclado, for apertado
    movimentarBonecos(true, personagem1, dt)
  end
  if love.keyboard.isDown('d') then
    movimentarBonecos(true, personagem2, dt)
  end
  personagem1.animParado:update(dt)
  personagem2.animParado:update(dt)
end

function movimentarBonecos(orientacao, personagem, dt)
  movimentacaoAr(estruturas, personagem)
  personagem.parado = false
  if not orientacao then
    personagem.posX = personagem.posX - 150 * dt
    personagem.direcao = false
  end
  if orientacao then
    personagem.posX = personagem.posX + 150 * dt
    personagem.direcao = true
  end
  personagem.animMovimento:update(dt)
end

function parou( key, personagem1, personagem2 ) --quando as teclas de movimentação deixam de ser pressionadas ele volta a animação de parado
  if ( key == 'left' or key == 'right' or key == 'up' or key == 'q' ) then
    personagem1.parado = true
    personagem1.movimentando = false
    personagem1.golpeando = false
  end
  if (key == 'a' or key == 'd' or key == 'w' or key == 'u' ) then
    personagem2.parado = true
    personagem2.movimentando = false
    personagem2.golpeando = false
  end
end

function pular(key, personagem1, personagem2) --realiza a ação do pulo com keypressed
  if key == 'up' then
    personagem1.pulando = true
    personagem1.movimentando = false
    if personagem1.velY == 0 and (not personagem1.golpeando) then
      personagem1.velY = personagem1.alturaPulo
    end
  end
  if key == 'w' then
    personagem2.pulando = true
    personagem2.movimentando = false
    if personagem2.velY == 0 and (not personagem2.golpeando) then
      personagem2.velY = personagem2.alturaPulo
    end
  end
end

function movimentacaoAr(vetorPlat, personagem) --verifica a posição do personagem no eixo y e retorna se o mesmo esta se movimentando em uma plataforma ou no ar
  if movimentarNaPlataforma(vetorPlat, personagem) then
    personagem.movimentando = true
    personagem.pulando = false
  elseif personagem.posY ~= initPosY then
    personagem.movimentando = false
    personagem.pulando = true
  else
    personagem.movimentando = true
  end
end

function movimentarNaPlataforma(plats, personagem) --define se o boneco esta se movimentando em uma dada plataforma, checando dentre
  for i=1, #plats do                 --todas desenhadas na tela (recebe como parametro o vetor de todas as contidas na fase)
    if (personagem.posY == plats[i].y and (personagem.posX >= plats[i].x and personagem.posX <= (plats[i].largura + plats[i].x))) then
      return true
    end
  end
  return false
end

function renderizarMovimento(personagem) --renderiza todas as sprites de movimentação
  love.graphics.setColor(255, 255, 255) --define a cor (branco) devido a imagem ser transparente e o fundo vai interferir na cor do personagem
  if ( personagem.movimentando and personagem.direcao and ( not personagem.parado ) ) then
    personagem.animMovimento:draw( personagem.imgMovimento, personagem.posX, personagem.posY + 8, 0, 1, 1, 29, 63 )
  elseif ( personagem.movimentando and (not personagem.direcao) and (not personagem.parado) ) then
    personagem.animMovimento:draw( personagem.imgMovimento, personagem.posX, personagem.posY + 8, 0, -1, 1, 29, 63 )
  end
  if ( personagem.direcao and personagem.parado and (not personagem.pulando) ) then
    personagem.animParado:draw( personagem.imgParado, personagem.posX, personagem.posY, 0, 1, 1, 20, 63 )
  elseif ( not personagem.direcao and personagem.parado and not personagem.pulando ) then
    personagem.animParado:draw( personagem.imgParado, personagem.posX, personagem.posY, 0, -1, 1, 20, 63 )
  end
  if( personagem.pulando and personagem.direcao and (not personagem.movimentando) ) then
    love.graphics.draw( personagem.imgPulo, personagem.posX, personagem.posY, 0, 1, 1, 27, 63 )
  elseif ( personagem.pulando and (not personagem.direcao) and (not personagem.movimentando) ) then
    love.graphics.draw( personagem.imgPulo, personagem.posX, personagem.posY, 0, -1, 1, 27, 63 )
  end
end
--fim do controle de movimentacao

--controle de golpes
function loadGolpe(personagem)
  local socos = anim.newGrid(  personagem.imgGolpeX, personagem.imgGolpeY, personagem.imgGolpe:getWidth(), personagem.imgGolpe:getHeight() )
  personagem.animGolpe = anim.newAnimation( socos( personagem.gridGolpe, 1), 0.15)
end

function socar( dt, personagem1, personagem2 )
  if love.keyboard.isDown('q') then
    realizarSocos(personagem1, dt)
    acertarSoco(dt, personagem1, personagem2)
    personagem1.animGolpe:update( dt )
  end
  if love.keyboard.isDown('u') then
    realizarSocos(personagem2, dt)
    acertarSoco(dt, personagem1, personagem2)
    personagem2.animGolpe:update( dt )
  end
end

function realizarSocos(personagem, dt)
  personagem.golpeando = true
  personagem.movimentando = false
  personagem.parado = false
  personagem.pulando = false
  if personagem.direcao then --soco right
    personagem.posX = personagem.posX + 20 * dt
  else --soco left
    personagem.posX = personagem.posX - 20 * dt
  end
end

function renderizarGolpes(personagem)
  love.graphics.setColor(255, 255, 255)
  if ( personagem.direcao and ( not personagem.parado ) and (not personagem.movimentando) and (not personagem.pulando) ) then
    personagem.animGolpe:draw( personagem.imgGolpe, personagem.posX, personagem.posY + 10, 0, 1, 1, 31, 63 )
  elseif ( (not personagem.direcao) and ( not personagem.parado) and (not personagem.movimentando) and (not personagem.pulando) ) then
    personagem.animGolpe:draw( personagem.imgGolpe, personagem.posX, personagem.posY + 10, 0, -1, 1, 31, 63 )
  end
end
--fim do controle de golpes

--Controle de danos
function acertarSoco(dt, personagem1, personagem2)
  if ((personagem1.posX + personagem1.imgGolpeX / 2) >= personagem2.posX - 5 and (personagem1.posX + personagem1.imgGolpeX / 2) <= personagem2.posX + 70 ) and (personagem1.posY == personagem2.posY) and (personagem1.golpeando) then
    golpeado(personagem2)
  elseif ((personagem2.posX + personagem2.imgGolpeX / 2) >= personagem1.posX - 5 and (personagem2.posX + personagem2.imgGolpeX / 2) <= personagem1.posX + 70 ) and (personagem2.posY == personagem1.posY) and (personagem2.golpeando) then
    golpeado(personagem1)
  end
end

function golpeado(personagem)
  personagem.danos = personagem.danos + 0.009
end
--fim do controle de danos
