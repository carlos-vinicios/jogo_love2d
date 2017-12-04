--movimentação de sprites no eixo x
local anim = require 'anim8' --importa a biblioteca de animação

local imagem, animation

local posX = 100 --posicao inicial
local direcao = true --define a direcao

function love.load()
  imagem = love.graphics.newImage("imagens/personagem.png") --importa a imagem para o programa
  local g = anim.newGrid( 180, 340, imagem:getWidth(), imagem:getHeight() ) --define o tamanho de cada sprite, recebendo como parametro a largura e a altura de cada uma, assim como, o tamanho da imagem completa
  animation = anim.newAnimation( g( '1-9', 1, '1-9', 2, '1-9', 3, '1-9', 4, '1-9', 5, '1-9', 6, '1-9', 7, '1-7', 8 ), 0.01) --define o tempo de animação e o numero de sprites que estarão contidos no game
end

function love.update( dt )
  if love.keyboard.isDown('left') then --quando o botão da esquerda no teclado, for apertado
    posX = posX - 150 * dt
    direcao = false
    animation:update(dt)
  end
  if love.keyboard.isDown('right') then --quando o botão da direita no teclado, for apertado
    posX = posX + 150 * dt
    direcao = true
    animation:update(dt)
  end
end

function love.draw()
  love.graphics.setBackgroundColor( 255, 255, 255) --muda o background
  if direcao then
    animation:draw( imagem, posX, 50, 0, 1, 1, 90, 0 ) --parametros: arquivo, posiçao no eixo x, posiçõa no eixo y, rotacao, tamanho no eixo x, e y, ponto pivo nos eixo x, e y
  elseif not direcao then
    animation:draw( imagem, posX, 50, 0, -1, 1, 90, 0 ) --noventa para garatinr que o ponto pivo fique no centro da imagem, logo sera width/2, na sprite. E o -1 indica a inversão da imagem horizontalmente
  end
end
