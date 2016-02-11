debug = true

player = { x = 200, y = 710, speed = 500, img = nil }
isAlive = true
score = 0

bullets = {}
bulletImg = nil
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

enemies = {}
enemyTimerMax = 0.5
enemyTimer = enemyTimerMax
enemyImg = nil

function love.load(arg)
	-- Images
	player.img = love.graphics.newImage('assets/ship.png')
	bulletImg = love.graphics.newImage('assets/bullet.png')
	enemyImg = love.graphics.newImage('assets/enemy.png')
end

function love.update(dt)
	-- Quit
	if love.keyboard.isDown('escape') then
		print('Score', score)
		love.event.push('quit')
	end

	-- Restart
	if love.keyboard.isDown('r') then
		enemies = {}
		bullets = {}

		player.x = 200
		player.y = 710

		score = 0

		canShootTimer = canShootTimerMax
		canShoot = true

		enemyTimer = enemyTimerMax

		isAlive = true

	end

	-- Move
	if love.keyboard.isDown('left','a') then
		if player.x > 0 then
			player.x = player.x - (player.speed * dt)
		end
	elseif love.keyboard.isDown('right','d') then
		if player.x < (love.graphics.getWidth() -  player.img:getWidth()) then
			player.x = player.x + (player.speed * dt)
		end
	end

	-- Shoot
	if love.keyboard.isDown('space', 'rctrl', 'lctrl', 'ctrl') and canShoot and isAlive then
		local newBullet = { x = player.x + ((player.img:getWidth() / 2) - (bulletImg:getWidth() / 2)), 
					  y = player.y - bulletImg:getHeight(), 
					  img = bulletImg }

		table.insert(bullets, newBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end

	-- Update shot timer
	canShootTimer = canShootTimer - (1 * dt)
	if(canShootTimer < 0) then
		canShootTimer = 0
		canShoot = true
	end

	-- Update shots
	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (250 * dt)

		if(bullet.y < 0) then
			table.remove(bullet, i)
		end
	end

	-- Update enemy timer
	enemyTimer = enemyTimer - (1 * dt)

	-- Create enemies
	if enemyTimer < 0 then
		local randomNumber = math.random(10, love.graphics.getWidth() - 10)
		local newEnemy = { x =  randomNumber, y = -10, img = enemyImg }
		table.insert(enemies, newEnemy)
		enemyTimer = enemyTimerMax
	end

	-- Update enemies
	for i, enemy in ipairs(enemies) do
		enemy.y = enemy.y + (200 * dt)
		if(enemy.y > love.graphics.getHeight()) then
			table.remove(enemies, i)
		end

	end

	

	
	
	for j, enemy in ipairs(enemies) do
		for i, bullet in ipairs(bullets) do
			-- Check Enemy / Bullet collision
			local bulletCollision = CheckCollision( enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight() )
			if(isAlive and bulletCollision) then
				table.remove(bullets, i)
				table.remove(enemies, j)
				score = score + 1
			end
		end

		-- Check Enemy / player collision
		local playerCollision = CheckCollision( enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight() )
		if(isAlive and playerCollision) then
			print('boom!')
			isAlive = false
			table.remove(enemies, j)
		end
	end
	

end

function love.draw(deltaTime)
	-- Draw player
	if isAlive then
		print('Alive!')
		love.graphics.draw(player.img, player.x, player.y)
	else
		print('dead!')
		love.graphics.print("Press 'R' to restart", (love.graphics:getWidth() / 2) - 50, (love.graphics:getHeight() / 2) - 10)
	end

	-- Draw bullets
	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

	-- Draw enemies
	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end

end

function love.keypressed(key)
	-- print('pressed:', key)
end


function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end


