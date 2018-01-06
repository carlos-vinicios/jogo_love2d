require 'plataformas'
local anim = require 'anim8'
--local imgMovimento, imgParado, imgPulo, imgGolpe, animParado, animMovimento, animGolpe

carlim = {
  thumb = love.graphics.newImage("imagens/thumb.png"), --foto do personagem exibida na tela
  posX = initPosX, -- posição inicial do personagem no eixo X
  posY = initPosY, -- posição inicial do personagem no eixo Y
  danos = 0,
  alturaPulo = 350, --define a altura do salto do boneco
  direcao = true, --define a direcao true = right / false = left
  parado = true, --define se o boneco esta parado
  movimentando = false, --define se o boneco esta se movimentando
  pulando = false, --define se o boneco esta pulando
  golpeando = false, --define se o boneco esta dando golpes
  imgMovimento = "imagens/movimento.png",
  imgMovimentoX = 58,
  imgMovimentoY = 63,
  gridMovimento = '1-8',
  animMovimento = nil,
  imgParado = "imagens/parado.png",
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
  thumb = love.graphics.newImage("imagens/thumb2.png"),
  posX = initPosX + 400,
  posY = initPosY,
  danos = 0,
  alturaPulo = 350,
  direcao = true,
  parado = true,
  movimentando = false,
  pulando = false,
  golpeando = false,
  imgMovimento = "imagens/movimento2.png",
  imgMovimentoX = 61,
  imgMovimentoY = 75,
  gridMovimento = '1-6',
  animMovimento = nil,
  imgParado = "imagens/parado2.png",
  imgParadoX = 57,
  imgParadoY = 75,
  gridParado = '1-4',
  animParado = nil,
  imgPulo = love.graphics.newImage("imagens/pulo2.png"),
  imgGolpe = love.graphics.newImage("imagens/soco2.png"),
  imgGolpeX = 65,
  imgGolpeY = 86,
  gridGolpe = '1-6',
  animGolpe = nil
}

personagens = {carlim, leleo}

--Controle de informações do personagem
function renderizarInformacoes(personagem1, personagem2)
  love.graphics.draw(personagem1.thumb, 30, 20, 0, 1.5, 1.5, 0, 0)
  love.graphics.print(tostring(personagem1.danos).."%", 100, 45)
  love.graphics.draw(personagem2.thumb, 630, 20, 0, 1.5, 1.5, 0, 0)
  love.graphics.print(tostring(personagem2.danos).."%", 560, 45)
end
--Fim do controle de informações do personagem

--Controle de movimentacao
function loadMovimentacao(personagem)
  local imgParado = love.graphics.newImage(personagem.imgParado)
  local parado = anim.newGrid( personagem.imgParadoX, personagem.imgParadoY, imgParado:getWidth(), imgParado:getHeight() )
  personagem.animParado = anim.newAnimation( parado( personagem.gridParado, 1), 0.20 )
  local imgMovimento = love.graphics.newImage(personagem.imgMovimento)
  local movi = anim.newGrid( personagem.imgMovimentoX, personagem.imgMovimentoY, imgMovimento:getWidth(), imgMovimento:getHeight() )
  personagem.animMovimento = anim.newAnimation( movi( personagem.gridMovimento, 1), 0.09 )
end

function movimentacao( dt, personagem1, personagem2 )
  if love.keyboard.isDown('left') then --quando o botão da esquerda no teclado, for apertado
    movimentarBonecos(0, personagem1)
  end
  if love.keyboard.isDown('a') then
    movimentarBonecos(0, personagem2)
  end
  if love.keyboard.isDown('right') then --quando o botão da direita no teclado, for apertado
    movimentarBonecos(1, personagem1)
  end
  if love.keyboard.isDown('d') then
    movimentarBonecos(1, personagem2)
  end
  personagem1.animParado:update(dt)
  personagem2.animParado:update(dt)
end

function movimentarBonecos(orientacao, personagem)
  movimentacaoAr(estruturas)
  personagem.parado = false
  if not orientacao then
    personagem.posX = personagem.posX - 150 * dt
    direcao = false
  end
  if orientacao then
    personagem.posX = personagem.posX + 150 * dt
    direcao = true
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
    if velY == 0 and (not personagem1.golpeando) then
      velY = personagem1.alturaPulo
    end
  end
  if key == 'w' then
    personagem2.pulando = true
    personagem2.movimentando = false
    if velY == 0 and (not personagem2.golpeando) then
      velY = personagem2.alturaPulo
    end
  end
end

function movimentacaoAr(vetorPlat, personagem) --verifica a posição do personagem no eixo y e retorna se o mesmo esta se movimentando em uma plataforma ou no ar
  if movimentarNaPlataforma(vetorPlat) then
    personagem.movimentando = true
    personagem.pulando = false
  elseif personagem.posY ~= initPosY then
    personagem.movimentando = false
    personagem.pulando = true
  else
    personagem.movimentando = true
  end
end

function movimentarNaPlataforma(plats, personagem, personagem) --define se o boneco esta se movimentando em uma dada plataforma, checando dentre
  for i=1, #plats do                 --todas desenhadas na tela (recebe como parametro o vetor de todas as contidas na fase)
    if (personagem.posY == plats[i].y and (personagem.posX >= plats[i].x and personagem.posX <= (plats[i].largura + plats[i].x))) then
      return true
    end
  end
  return false
end

function renderizarMovimento(personagem) --renderiza todas as sprites de movimentação
  love.graphics.setColor(255, 255, 255) --define a cor (branco) devido a imagem ser transparente e o fundo vai interferir na cor do personagem
  if ( personagem.movimentando and direcao and ( not personagem.parado ) ) then
    personagem.animMovimento:draw( imgMovimento, personagem.posX, personagem.posY + 8, 0, 1, 1, 29, 63 )
  elseif ( personagem.movimentando and (not direcao) and (not personagem.parado) ) then
    personagem.animMovimento:draw( imgMovimento, personagem.posX, personagem.posY + 8, 0, -1, 1, 29, 63 )
  end
  if ( direcao and personagem.parado and (not personagem.pulando) ) then
    personagem.animParado:draw( imgParado, personagem.posX, personagem.posY, 0, 1, 1, 20, 63 )
  elseif ( not direcao and personagem.parado and not personagem.pulando ) then
    personagem.animParado:draw( imgParado, personagem.posX, personagem.posY, 0, -1, 1, 20, 63 )
  end
  if( personagem.pulando and direcao and (not personagem.movimentando) ) then
    love.graphics.draw( imgPulo, personagem.posX, personagem.posY, 0, 1, 1, 27, 63 )
  elseif ( personagem.pulando and (not direcao) and (not personagem.movimentando) ) then
    love.graphics.draw( imgPulo, personagem.posX, personagem.posY, 0, -1, 1, 27, 63 )
  end
end
--fim do controle de movimentacao

--controle de golpes
function loadGolpe(personagem)
  local socos = anim.newGrid(  personagem.imgGolpeX, personagem.imgGolpeY, personagem.imgGolpe:getWidth(), personagem.imgGolpe:getHeight() )
  personagem.animGolpe = anim.newAnimation( socos( personagem.gridGolpe, 1), 0.15)
end

function golpear( dt, personagem )
  if love.keyboard.isDown('q') then
    personagem.golpeando = true
    personagem.movimentando = false
    personagem.parado = false
    personagem.pulando = false
    if direcao then --soco right
      personagem.posX = personagem.posX + 20 * dt
    else --soco left
      personagem.posX = personagem.posX - 20 * dt
    end
    personagem.animGolpe:update( dt )
  end
end

function renderizarGolpes(personagem)
  love.graphics.setColor(255, 255, 255)
  if ( direcao and ( not personagem.parado ) and (not personagem.movimentando) and (not personagem.pulando) ) then
    animGolpe:draw( imgGolpe, personagem.posX, personagem.posY + 10, 0, 1, 1, 31, 63 )
  elseif ( (not direcao) and ( not personagem.parado) and (not personagem.movimentando) and (not personagem.pulando) ) then
    animGolpe:draw( imgGolpe, personagem.posX, personagem.posY + 10, 0, -1, 1, 31, 63 )
  end
end
--fim do controle de golpes

--Controle de danos
function golpeado(personagem)
  personagem.danos = personagem.danos + 15
end
--fim do controle de danos
