local anim = require 'anim8'
local larguraTela = love.graphics.getWidth()
local alturaTela = love.graphics.getHeight()
local initPosY = 507
local imgMovimento, imgParado, imgGolpe, animParado, animMovimento, animGolpe

local posX = 100 -- posição inicial do personagem no eixo X
local posY = initPosY -- posição inicial do personagem no eixo Y
local direcao = true --define a direcao true = right / false = left
local parado = true
local movimentando = true
local pulando = true
local gravidade = 400
local alturaPulo = 300
local velY = 0

function love.load()
  loadMovimento()
  loadGolpe()
end

function love.update( dt )
  movimentar( dt )
  pulo(dt)
  golpear( dt )
end

function love.draw()
  love.graphics.setBackgroundColor(75, 114, 254)
  renderizarMovimento()
  renderizarGolpes()
  renderizarChao()
end

function love.keyreleased( key ) --saber quando uma dada tecla deixou de ser apertada no teclado
  parou( key )
end

function love.keypressed(key) --saber quando uma dada teclada foi pressionada
  pular( key )
end

--Controle do mundo
function renderizarChao()
  love.graphics.setColor(168, 168, 168)
  love.graphics.rectangle( "fill", 0, initPosY + 63, larguraTela, 80)
end
--fim do controle do mundo

--Controle de movimento
function loadMovimento()
  imgMovimento = love.graphics.newImage("imagens/movimento.png")
  imgParado = love.graphics.newImage("imagens/parado.png")
  local parado = anim.newGrid( 41, 72, imgParado:getWidth(), imgParado:getHeight() )
  animParado = anim.newAnimation( parado( '1-4', 1), 0.02 )
  local movi = anim.newGrid( 58, 63, imgMovimento:getWidth(), imgMovimento:getHeight() )
  animMovimento = anim.newAnimation( movi( '1-8', 1), 0.09 )
end

function movimentar( dt )
  if love.keyboard.isDown('left') then --quando o botão da esquerda no teclado, for apertado
    movimentando = true
    parado = false
    pulando = false
    posX = posX - 150 * dt
    direcao = false
    animMovimento:update(dt)
  end
  if love.keyboard.isDown('right') then --quando o botão da direita no teclado, for apertado
    movimentando = true
    parado = false
    pulando = false
    posX = posX + 150 * dt
    direcao = true
    animMovimento:update(dt)
  end
end

function renderizarMovimento()
  love.graphics.setColor(255, 255, 255) --define a cor devido a imagem ser transparente e o fundo vai interferir na cor do personagem
  if ( movimentando and direcao and ( not parado ) ) then
    animMovimento:draw( imgMovimento, posX, posY + 8, 0, 1, 1, 29, 0 )
  elseif ( movimentando and (not direcao) and (not parado) ) then
    animMovimento:draw( imgMovimento, posX, posY + 8, 0, -1, 1, 29, 0 )
  end
  if ( direcao and parado ) then
    animParado:draw( imgParado, posX, posY, 0, 1, 1, 20, 0 )
  elseif ( not direcao and parado ) then
    animParado:draw( imgParado, posX, posY, 0, -1, 1, 20, 0 )
  end
end

function parou( key )
  if ( key == 'left' or key == 'right' or key == 'q' or key == 'up' ) then
    parado = true
  end
end

function pulo(dt) -- realiza os calculos para o pulo do personagem
  if velY ~= 0 then
    posY = posY - velY * dt
    velY = velY - gravidade * dt
    if posY > initPosY then
      velY = 0
      posY = initPosY
    end
  end
end

function pular(key) -- realiza a ação do pulo
  pulando = true
  parado = false
  movimento = false
  if key == 'up' then
    if velY == 0 then
      velY = alturaPulo
    end
  end
end

function renderizarPulo()

end
--fim do controle de movimento

--controle de golpes
function loadGolpe()
  imgGolpe = love.graphics.newImage('imagens/soco.png')
  local socos = anim.newGrid(  63, 66, imgGolpe:getWidth(), imgGolpe:getHeight() )
  animGolpe = anim.newAnimation( socos( '1-5', 1), 0.15)
end

function golpear( dt )
  if love.keyboard.isDown('q') then
    movimentando = false
    parado = false
    pulando = false
    if direcao then --soco right
      posX = posX + 20 * dt
    else --soco left
      posX = posX - 20 * dt
    end
    animGolpe:update( dt )
  end
end

function renderizarGolpes()
  love.graphics.setColor(255, 255, 255)
  if ( direcao and ( not parado ) and (not movimentando) ) then
    animGolpe:draw( imgGolpe, posX, posY + 10, 0, 1, 1, 31, 0 )
  elseif ( (not direcao) and ( not parado) and (not movimentando) ) then
    animGolpe:draw( imgGolpe, posX, posY + 10, 0, -1, 1, 31, 0 )
  end
end
--fim do controle de golpes
