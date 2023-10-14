color = Color
mesh = Mesh

image = function (param, ...)
	if type(param) == 'number' then
	 	return FrameBuffer(param, ...)
	else
		return getImage(param)
	end
end

function getImage(param)
	if type(param) == 'string' then
		return Image('resources/images/'..param:gsub(':', '/')..'.png')
	end
	return param
end

spriteSize = function (param)
	return Graphics2d.spriteSize(getImage(param))
end

sprite = function (param, ...)
	return Graphics2d.sprite(getImage(param), ...)
end

viewer = {}

alias = {
	elapsedTime = 'ElapsedTime',
	WIDTH = 'W',
	HEIGHT = 'H',
	font = 'fontName',
}

function smooth()
end

function textWrapWidth()
end

function textAlign()
end

physics = class()

function physics.gravity()
end

function physics.resume()
end

function physics.body(...)
	return Body(...)
end

Body = class()

function Body:setup()
	CIRCLE = 'circle'
	POLYGON = 'polygon'

	DYNAMIC = 'dynamic'
end

function Body:init(shapeType)
	self.shapeType = shapeType
	self.type = DYNAMIC

	self.points = {}

	self.angle = angle
end

requireLib {
	'Levels',
	'Solutions',
	'ABCMusic',
	'ABCMusicData',
	'Sounds',
	'Music',
	'Table',
	'Stack',
	'Events',
	'ShakeDetector',
	'Tweener',
	'PositionObj',
	'RectObj',
	'SpriteObj',
	'ShadowObj',
	'Button',
	'Panel',
	'ScrollingTexture',
	'Smoke',
	'StageWall',
	'Crate',
	'Claw',
	'Pile',
	'BaseStage',
	'Stage',
	'StagePhysics',
	'Command',
	'Register',
	'Goal',
	'Program',
	'Toolbox',
	'Popover',
	'Screen',
	'Level',
	'Tutorial',
	'BaseSelect',
	'PackSelect',
	'LevelSelect',
	'WinScreen',
	'StartScreen',
	'CreditsScreen',
	'TransitionScreen',
	'HowScreen',
	'SplashScreen',
	'IO',
	'Main',
	'Notes',
}
