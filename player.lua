Player = {}

local canShootTimerMax = 0.2
local canShootTimer

local bulletImg = nil

function Player.load()
	local playerImage = love.graphics.newImage('assets/sprites/ship.png')
	bulletImg = love.graphics.newImage('assets/sprites/bullet.png')
	playerTable = { x = 200, y = 710, speed = 500, img = playerImage }

	Player.init()
end

function Player.init()
	playerTable.x = 200
	playerTable.y = 710

	canShoot = true
	canShootTimer = canShootTimerMax

	bullets = {}
	
end

function Player.draw()
	love.graphics.draw(playerTable.img, playerTable.x, playerTable.y)
end

function Player.update(dt)
	-- Update shot timer
	canShootTimer = canShootTimer - (1 * dt)
	if(canShootTimer < 0) then
		canShootTimer = 0
		canShoot = true
	end
end

function Player.moveLeft(dt)
	if playerTable.x > 0 then
		playerTable.x = playerTable.x - (playerTable.speed * dt)
	end
end

function Player.moveRight(dt)
	if playerTable.x < (love.graphics.getWidth() -  playerTable.img:getWidth()) then
		playerTable.x = playerTable.x + (playerTable.speed * dt)
	end
end

function Player.shoot()
	local newBullet = { x = playerTable.x + ((playerTable.img:getWidth() / 2) - (bulletImg:getWidth() / 2)), 
					  y = playerTable.y - bulletImg:getHeight(), 
					  img = bulletImg }

	table.insert(bullets, newBullet)
	canShoot = false
	canShootTimer = canShootTimerMax

	love.audio.play(fireSound)
end