require('enemies')
require('player')
require('util')


debug = true

isAlive = true
score = 0

bullets = {}
bulletImg = nil

fireSound = nil
enemyHitSounds = nil
playerHitSound = nil

keyPressed = false

function love.load(arg)
	bulletImg = love.graphics.newImage('assets/sprites/bullet.png')

	fireSound = love.audio.newSource('assets/sound/fire.wav', static)
	
	playerHitSound = love.audio.newSource('assets/sound/playerhit.wav', static)

	local music = love.audio.newSource('assets/sound/music1.mp3', static)
	print (music)
	love.audio.play(music)

	Enemies.load()
	Player.load()
	
end

function processKeypress(dt)
	-- Quit
	if love.keyboard.isDown('escape') then
		print('Score', score)
		love.event.push('quit')
	end

	-- Restart
	if love.keyboard.isDown('r') then
		-- enemies = {}
		Enemies.init()
		Player.init()
		bullets = {}
		score = 0

		isAlive = true
	end

	-- Move
	if love.keyboard.isDown('left') then
		Player.moveLeft(dt)
	elseif love.keyboard.isDown('right') then
		Player.moveRight(dt)
	end

	-- Shoot
	if love.keyboard.isDown('a') and canShoot and isAlive then
		Player.shoot()
	end
end



function updateShots(dt)
	-- Update shots
	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (250 * dt)

		if(bullet.y < 0) then
			table.remove(bullet, i)
		end
	end
end

function updateGameState(dt)
	Player.update(dt)
	updateShots(dt)
	Enemies.update(dt)
end





function love.update(dt)
	-- print 'love.update'

	if keyPressed then
		processKeypress(dt)
	end

	updateGameState(dt)
	Enemies.spawn()

	if isAlive then
		local bulletHit, playerHit = false, false

		bulletHit, playerHit = Enemies.checkCollision()

		if bulletHit then
			Enemies.playHitSound()
			score = score + 1
		end

		if playerHit then
			love.audio.play(playerHitSound)
			isAlive = false;
		end
	end

end




function love.draw(dt)
	-- Draw player
	if isAlive then
		Player.draw()
	else
		love.graphics.print("Press 'R' to restart", (love.graphics:getWidth() / 2) - 50, (love.graphics:getHeight() / 2) - 10)
	end

	-- Draw bullets
	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

	Enemies.draw()

end

function love.keypressed(key)
	keyPressed = true
end

function love.keyreleased(key)
	keyPresssed = false
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end


