sounds = {
	blocks = {
		I = love.audio.newSource("res/se/piece_i.wav", "static"),
		J = love.audio.newSource("res/se/piece_j.wav", "static"),
		L = love.audio.newSource("res/se/piece_l.wav", "static"),
		O = love.audio.newSource("res/se/piece_o.wav", "static"),
		S = love.audio.newSource("res/se/piece_s.wav", "static"),
		T = love.audio.newSource("res/se/piece_t.wav", "static"),
		Z = love.audio.newSource("res/se/piece_z.wav", "static")
	},
	move = love.audio.newSource("res/se/move.wav", "static"),
	bottom = love.audio.newSource("res/se/bottom.wav", "static"),
	cursor = love.audio.newSource("res/se/cursor.wav", "static"),
	cursor_lr = love.audio.newSource("res/se/cursor_lr.wav", "static"),
	main_decide = love.audio.newSource("res/se/main_decide.wav", "static"),
	mode_decide = love.audio.newSource("res/se/mode_decide.wav", "static"),
	lock = love.audio.newSource("res/se/lock.wav", "static"),
	hold = love.audio.newSource("res/se/hold.wav", "static"),
	erase = love.audio.newSource("res/se/erase.wav", "static"),
	fall = love.audio.newSource("res/se/fall.wav", "static"),
	ready = love.audio.newSource("res/se/ready.wav", "static"),
	go = love.audio.newSource("res/se/go.wav", "static"),
	irs = love.audio.newSource("res/se/irs.wav", "static"),
	ihs = love.audio.newSource("res/se/ihs.wav", "static"),
	-- a secret sound!
	welcome = love.audio.newSource("res/se/welcomeToCambridge.wav", "static"),
	-- and here come the new sounds:
	caution = love.audio.newSource("res/se/caution.wav", "static"),
	topout = love.audio.newSource("res/se/topout.wav", "static"),
	powermode = love.audio.newSource("res/se/powermode.wav", "static"),
	danger = love.audio.newSource("res/se/danger.wav", "static"),
	garbage = love.audio.newSource("res/se/garbage.wav", "static"),
	powererase = love.audio.newSource("res/se/powererase.wav", "static"),
	finalerase = love.audio.newSource("res/se/finalerase.wav", "static"),
	wrongerase = love.audio.newSource("res/se/wrongerase.wav", "static"),
	input = love.audio.newSource("res/se/input.wav", "static"),
	menu_back = love.audio.newSource("res/se/menu_back.wav", "static"),
	singlecaution = love.audio.newSource("res/se/singlecaution.wav", "static"),
}

function playSE(sound, subsound)
	if sound ~= nil then
		if subsound ~= nil then
			sounds[sound][subsound]:setVolume(config.sfx_volume)
			if sounds[sound][subsound]:isPlaying() then
				sounds[sound][subsound]:stop()
			end
			sounds[sound][subsound]:play()
		else
			sounds[sound]:setVolume(config.sfx_volume)
			if sounds[sound]:isPlaying() then
				sounds[sound]:stop()
			end
			sounds[sound]:play()
		end
	end
end

function playSEOnce(sound, subsound)
	if sound ~= nil then
		if subsound ~= nil then
			sounds[sound][subsound]:setVolume(config.sfx_volume)
			if sounds[sound][subsound]:isPlaying() then
				return
			end
			sounds[sound][subsound]:play()
		else
			sounds[sound]:setVolume(config.sfx_volume)
			if sounds[sound]:isPlaying() then
				return
			end
			sounds[sound]:play()
		end
	end
end
