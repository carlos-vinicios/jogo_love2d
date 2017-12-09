local anim = require 'anim8'
local larguraTela = love.graphics.getWidth()
--local alturaTela = love.graphics.getHeight()
local initPosY = 570
local chao = { x= larguraTela, y= 570 }
local plat1 = { x= 0, y= 480, largura = 200, espessura = 30 }
local plat2 = { x= 270, y= 390, largura = 240, espessura = 30 }
local plat3 = { x= 170, y= 290, largura = 210, espessura = 30}
local plataformas = {plat1, plat2, plat3}
local imgMovimento, imgParado, imgPulo, imgGolpe, animParado, animMovimento, animGolpe
local gravidade = 600
local velY = 0

local personagem = {
  posX = 100, -- posição inicial do personagem no eixo X
  posY = initPosY, -- posição inicial do personagem no eixo Y
  alturaPulo = 350, --define a altura do salto do boneco
  direcao = true, --define a direcao true = right / false = left
  parado = true, --define se o boneco esta parado
  movimentando = false, --define se o boneco esta se movimentando
  pulando = false, --define se o boneco esta pulando
  golpeando = false --define se o boneco esta dando golpes
}

function love.load()
  loadMovimentacao()
  loadGolpe()
end

function love.update( dt )
  movimentacao(dt)
  cair(dt)
  golpear( dt )
end

function love.draw()
  love.graphics.setBackgroundColor(75, 114, 254) -- cor azul do fundo
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
  love.graphics.setColor(168, 168, 168) --cor de cinza do chão
  love.graphics.rectangle( "fill", 0, chao.y, chao.x, 80) --chão 63 a diferença do desenho da imagem, assim como, qualquer 63 abaixo
  for i=1, #plataformas do
    love.graphics.rectangle( "fill", plataformas[i].x, plataformas[i].y, plataformas[i].largura, plataformas[i].espessura) --plataforma
  end
end
--fim do controle do mundo

--Controle de movimentacao
function loadMovimentacao()
  imgMovimento = love.graphics.newImage("imagens/movimento.png")
  imgParado = love.graphics.newImage("imagens/parado.png")
  imgPulo = love.graphics.newImage("imagens/pulo.png")
  local parado = anim.newGrid( 41, 72, imgParado:getWidth(), imgParado:getHeight() )
  animParado = anim.newAnimation( parado( '1-4', 1), 0.20 )
  local movi = anim.newGrid( 58, 63, imgMovimento:getWidth(), imgMovimento:getHeight() )
  animMovimento = anim.newAnimation( movi( '1-8', 1), 0.09 )
end

function movimentacao( dt )
  if love.keyboard.isDown('left') then --quando o botão da esquerda no teclado, for apertado
    movimentacaoAr(plataformas)
    personagem.parado = false
    personagem.posX = personagem.posX - 150 * dt
    direcao = false
    animMovimento:update(dt)
  end
  if love.keyboard.isDown('right') then --quando o botão da direita no teclado, for apertado
    movimentacaoAr(plataformas)
    personagem.parado = false
    personagem.posX = personagem.posX + 150 * dt
    direcao = true
    animMovimento:update(dt)
  end
  animParado:update(dt)
end

function cair(dt) -- realiza os calculos para o pulo do personagem
  limitesPlataforma(plataformas)
  if velY ~= 0 then
    personagem.posY = personagem.posY - velY * dt
    velY = velY - gravidade * dt
    if personagem.posY > initPosY then --para parar no chão
      velY = 0
      personagem.posY = initPosY
    end
    tocarPlataforma(plataformas)
  end
  pararPulo(initPosY)
  for i=1, #plataformas do
    pararPulo(plataformas[i].y)
  end
end

function parou( key ) --quando as teclas de movimentação deixam de ser pressionadas ele volta a animação de parado
  if ( key == 'left' or key == 'right' or key == 'q' or key == 'up' ) then
    personagem.parado = true
    personagem.movimentando = false
    personagem.golpeando = false
  end
end

function pular(key) --realiza a ação do pulo com keypressed
  personagem.pulando = true
  personagem.movimentando = false
  if key == 'up' then
    if velY == 0 and (not personagem.golpeando) then
      velY = personagem.alturaPulo
    end
  end
end

function pararPulo(coordenaY) --para o pulo ao encostar no chão ou em uma plataforma
  if personagem.posY == coordenaY then
    personagem.pulando = false
  end
end

function movimentacaoAr(vetorPlat) --verifica a posição do personagem no eixo y e retorna se o mesmo esta se movimentando em uma plataforma ou no ar
  if movimentarPlataforma(vetorPlat) then
    personagem.movimentando = true
    personagem.pulando = false
  elseif personagem.posY ~= initPosY then
    personagem.movimentando = false
    personagem.pulando = true
  else
    personagem.movimentando = true
  end
end

function movimentarPlataforma(plats) --define se o boneco esta se movimentando em uma dada plataforma, checando dentre
  for i=1, #plats do                 --todas desenhadas na tela (recebe como parametro o vetor de todas as contidas na fase)
    if (personagem.posY == plats[i].y and (personagem.posX >= plats[i].x and personagem.posX <= (plats[i].largura + plats[i].x))) then
      return true
    end
  end
  return false
end

function limitesPlataforma(plats) --checa se o boneco ultrapassou o limite de certa plataforma, fazendo com que cai (recebe como parametro uma plataforma)
  for i=1,#plats do
    if personagem.posY == plats[i].y and ( personagem.posX < plats[i].x or personagem.posX > (plats[i].largura + plats[i].x)) then
        velY = 1 --para ativar a gravidade e fazer com que o boneco tenha uma queda vertical
    end
  end
end

function tocarPlataforma(plats) --checa se o personagem esta sobre uma plataforma, fazendo com que pare sua queda vertical
  for i=1, #plats do
    --posição do y do personagem maior que a posição da plataforma no eixo y, e menor que sua posição mais espessura, fazendo com que calcule o espaço ocupado na tela
    if (personagem.posY >= plats[i].y and personagem.posY <= plats[i].y + plats[i].espessura) and (personagem.posX >= plats[i].x and personagem.posX <= (plats[i].largura + plats[i].x)) then --para parar em plataforma
      velY = 0
      personagem.posY = plats[i].y
    end
  end
end

function renderizarMovimento() --renderiza todas as sprites de movimentação
  love.graphics.setColor(255, 255, 255) --define a cor (branco) devido a imagem ser transparente e o fundo vai interferir na cor do personagem
  if ( personagem.movimentando and direcao and ( not personagem.parado ) ) then
    animMovimento:draw( imgMovimento, personagem.posX, personagem.posY + 8, 0, 1, 1, 29, 63 )
  elseif ( personagem.movimentando and (not direcao) and (not personagem.parado) ) then
    animMovimento:draw( imgMovimento, personagem.posX, personagem.posY + 8, 0, -1, 1, 29, 63 )
  end
  if ( direcao and personagem.parado and (not personagem.pulando) ) then
    animParado:draw( imgParado, personagem.posX, personagem.posY, 0, 1, 1, 20, 63 )
  elseif ( not direcao and personagem.parado and not personagem.pulando ) then
    animParado:draw( imgParado, personagem.posX, personagem.posY, 0, -1, 1, 20, 63 )
  end
  if( personagem.pulando and direcao and (not personagem.movimentando) ) then
    love.graphics.draw( imgPulo, personagem.posX, personagem.posY, 0, 1, 1, 27, 63 )
  elseif ( personagem.pulando and (not direcao) and (not personagem.movimentando) ) then
    love.graphics.draw( imgPulo, personagem.posX, personagem.posY, 0, -1, 1, 27, 63 )
  end
end
--fim do controle de movimentacao

--controle de golpes
function loadGolpe()
  imgGolpe = love.graphics.newImage('imagens/soco.png')
  local socos = anim.newGrid(  63, 66, imgGolpe:getWidth(), imgGolpe:getHeight() )
  animGolpe = anim.newAnimation( socos( '1-5', 1), 0.15)
end

function golpear( dt )
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
    animGolpe:update( dt )
  end
end

function renderizarGolpes()
  love.graphics.setColor(255, 255, 255)
  if ( direcao and ( not personagem.parado ) and (not personagem.movimentando) and (not personagem.pulando) ) then
    animGolpe:draw( imgGolpe, personagem.posX, personagem.posY + 10, 0, 1, 1, 31, 63 )
  elseif ( (not direcao) and ( not personagem.parado) and (not personagem.movimentando) and (not personagem.pulando) ) then
    animGolpe:draw( imgGolpe, personagem.posX, personagem.posY + 10, 0, -1, 1, 31, 63 )
  end
end
--fim do controle de golpes
