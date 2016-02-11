Enemies = {}

local enemyTimerMax = 0.5
local enemyImg = nil

local enemyHitSounds = nil

function Enemies.init ()
	-- print('enemies:init')
	enemyTable = {}	
	enemyTimer = enemyTimerMax
end

function Enemies.load()
	enemyImg = love.graphics.newImage('assets/sprites/enemy.png')

	enemyHitSounds = {
		love.audio.newSource('assets/sound/enemyhit1.wav', static),
		love.audio.newSource('assets/sound/enemyhit2.wav', static),
		love.audio.newSource('assets/sound/enemyhit3.wav', static),
		love.audio.newSource('assets/sound/enemyhit4.wav', static)
	}

	Enemies.init()
end

function Enemies.update(dt)
	-- print 'enemies:update'
	-- Update enemyTable
	for i, enemy in ipairs(enemyTable) do
		enemy.y = enemy.y + (200 * dt)
		if(enemy.y > love.graphics.getHeight()) then
			table.remove(enemyTable, i)
		end

	end

	-- Update enemy timer
	enemyTimer = enemyTimer - (1 * dt)
end

function Enemies.spawn()
	-- Create enemyTable
	if enemyTimer < 0 then
		local randomNumber = math.random(10, love.graphics.getWidth() - 10)
		local newEnemy = { x =  randomNumber, y = -10, img = enemyImg }
		table.insert(enemyTable, newEnemy)
		enemyTimer = enemyTimerMax
	end
end	

function Enemies.draw()
	-- Draw enemyTable
	for i, enemy in ipairs(enemyTable) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end
end

function Enemies.checkCollision()
	-- print('enemies:checkCollision')
	local hitEnemy, hitBullet = false, false

	for j, enemy in ipairs(enemyTable) do
		for i, bullet in ipairs(bullets) do
			-- Check Enemy / Bullet collision
			local bulletCollision = CheckCollision( enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight() )
			if(isAlive and bulletCollision) then
				table.remove(bullets, i)
				table.remove(enemyTable, j)
				hitBullet = true
			end
		end

		-- Check Enemy / player collision
		local playerCollision = CheckCollision( enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), playerTable.x, playerTable.y, playerTable.img:getWidth(), playerTable.img:getHeight() )
		if(isAlive and playerCollision) then
			table.remove(enemyTable, j)
			hitEnemy = true
		end
	end

	return hitBullet, hitEnemy
end

function Enemies.playHitSound()
	local randomNumber = math.random(1, table.getn(enemyHitSounds))
	love.audio.play(enemyHitSounds[randomNumber])
end