require 'plataformas'
local anim = require 'anim8'
local imgMovimento, imgParado, imgPulo, imgGolpe, animParado, animMovimento, animGolpe

leleo = {
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
  imgMovimento = nil,
  imgParado = nil,
  imgPulo = nil,
  imgGolpe = nil,
  animParado = nil,
  animMovimento = nil,
  animGolpe = nil
}

carlim = {
  thumb = love.graphics.newImage("nada até agr"),
  posX = initPosX + 400,
  posY = initPosY,
  danos = 0,
  alturaPulo = 350,
  direcao = true,
  parado = true,
  movimentando = false,
  pulando = false,
  golpeando = false,
  imgMovimento = nil,
  imgParado = nil,
  imgPulo = nil,
  imgGolpe = nil,
  animParado = nil,
  animMovimento = nil,
  animGolpe = nil
}

--Controle de informações do personagem
function renderizarInformacoes(personagens)
  love.graphics.draw(personagem1.thumb, 30, 20, 0, 1.5, 1.5, 0, 0)
  love.graphics.print(tostring(personagem1.danos).."%", 100, 45)
end
--Fim do controle de informações do personagem

--Controle de movimentacao
function loadMovimentacao(personagens)
  personagem1.imgMovimento = love.graphics.newImage("imagens/movimento.png")
  personagem1.imgParado = love.graphics.newImage("imagens/parado.png")
  personagem1.imgPulo = love.graphics.newImage("imagens/pulo.png")
  local parado = anim.newGrid( 41, 72, imgParado:getWidth(), imgParado:getHeight() )
  personagem1.animParado = anim.newAnimation( parado( '1-4', 1), 0.20 )
  local movi = anim.newGrid( 58, 63, imgMovimento:getWidth(), imgMovimento:getHeight() )
  personagem1.animMovimento = anim.newAnimation( movi( '1-8', 1), 0.09 )
end

function movimentacao( dt, personagens )
  if love.keyboard.isDown('left') then --quando o botão da esquerda no teclado, for apertado
    movimentacaoAr(estruturas)
    personagem1.parado = false
    personagem1.posX = personagem1.posX - 150 * dt
    direcao = false
    animMovimento:update(dt)
  end
  if love.keyboard.isDown('right') then --quando o botão da direita no teclado, for apertado
    movimentacaoAr(estruturas)
    personagem1.parado = false
    personagem1.posX = personagem1.posX + 150 * dt
    direcao = true
    animMovimento:update(dt)
  end
  animParado:update(dt)
end

function parou( key, personagens ) --quando as teclas de movimentação deixam de ser pressionadas ele volta a animação de parado
  if ( key == 'left' or key == 'right' or key == 'q' or key == 'up' ) then
    personagem1.parado = true
    personagem1.movimentando = false
    personagem1.golpeando = false
  end
end

function pular(key) --realiza a ação do pulo com keypressed
  personagem1.pulando = true
  personagem1.movimentando = false
  if key == 'up' then
    if velY == 0 and (not personagem1.golpeando) then
      velY = personagem1.alturaPulo
    end
  end
end

function movimentacaoAr(vetorPlat, personagens) --verifica a posição do personagem no eixo y e retorna se o mesmo esta se movimentando em uma plataforma ou no ar
  if movimentarNaPlataforma(vetorPlat) then
    personagem1.movimentando = true
    personagem1.pulando = false
  elseif personagem1.posY ~= initPosY then
    personagem1.movimentando = false
    personagem1.pulando = true
  else
    personagem1.movimentando = true
  end
end

function movimentarNaPlataforma(plats, personagens) --define se o boneco esta se movimentando em uma dada plataforma, checando dentre
  for i=1, #plats do                 --todas desenhadas na tela (recebe como parametro o vetor de todas as contidas na fase)
    if (personagem1.posY == plats[i].y and (personagem1.posX >= plats[i].x and personagem1.posX <= (plats[i].largura + plats[i].x))) then
      return true
    end
  end
  return false
end

function renderizarMovimento(personagens) --renderiza todas as sprites de movimentação
  love.graphics.setColor(255, 255, 255) --define a cor (branco) devido a imagem ser transparente e o fundo vai interferir na cor do personagem
  if ( personagem1.movimentando and direcao and ( not personagem1.parado ) ) then
    animMovimento:draw( imgMovimento, personagem1.posX, personagem1.posY + 8, 0, 1, 1, 29, 63 )
  elseif ( personagem1.movimentando and (not direcao) and (not personagem1.parado) ) then
    animMovimento:draw( imgMovimento, personagem1.posX, personagem1.posY + 8, 0, -1, 1, 29, 63 )
  end
  if ( direcao and personagem1.parado and (not personagem1.pulando) ) then
    animParado:draw( imgParado, personagem1.posX, personagem1.posY, 0, 1, 1, 20, 63 )
  elseif ( not direcao and personagem1.parado and not personagem1.pulando ) then
    animParado:draw( imgParado, personagem1.posX, personagem1.posY, 0, -1, 1, 20, 63 )
  end
  if( personagem1.pulando and direcao and (not personagem1.movimentando) ) then
    love.graphics.draw( imgPulo, personagem1.posX, personagem1.posY, 0, 1, 1, 27, 63 )
  elseif ( personagem1.pulando and (not direcao) and (not personagem1.movimentando) ) then
    love.graphics.draw( imgPulo, personagem1.posX, personagem1.posY, 0, -1, 1, 27, 63 )
  end
end
--fim do controle de movimentacao

--controle de golpes
function loadGolpe()
  imgGolpe = love.graphics.newImage('imagens/soco.png')
  local socos = anim.newGrid(  63, 66, imgGolpe:getWidth(), imgGolpe:getHeight() )
  animGolpe = anim.newAnimation( socos( '1-5', 1), 0.15)
end

function golpear( dt, personagens )
  if love.keyboard.isDown('q') then
    personagem1.golpeando = true
    personagem1.movimentando = false
    personagem1.parado = false
    personagem1.pulando = false
    if direcao then --soco right
      personagem1.posX = personagem1.posX + 20 * dt
    else --soco left
      personagem1.posX = personagem1.posX - 20 * dt
    end
    animGolpe:update( dt )
  end
end

function renderizarGolpes(personagens)
  love.graphics.setColor(255, 255, 255)
  if ( direcao and ( not personagem1.parado ) and (not personagem1.movimentando) and (not personagem1.pulando) ) then
    animGolpe:draw( imgGolpe, personagem1.posX, personagem1.posY + 10, 0, 1, 1, 31, 63 )
  elseif ( (not direcao) and ( not personagem1.parado) and (not personagem1.movimentando) and (not personagem1.pulando) ) then
    animGolpe:draw( imgGolpe, personagem1.posX, personagem1.posY + 10, 0, -1, 1, 31, 63 )
  end
end
--fim do controle de golpes

--Controle de danos
function golpeado(personagens)
  personagem1.danos = personagem1.danos + 15
end
--fim do controle de danos
