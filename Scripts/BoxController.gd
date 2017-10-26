extends Sprite

var tileSize = 32
var onTarget = false
var glowWaitLimit = 0.0
var glowWait = 0.0
var levelController

func Init(sentNode, tilePosX, tilePosY):
	SetLevelController(sentNode)
	SetPos(tilePosX, tilePosY)
	if (not onTarget):
		glowWaitLimit = tilePosY / 10
		set_process(true)

func _process(delta):
	glowWait += delta
	if ((glowWait >= glowWaitLimit) and (!onTarget)):
		get_node("AnimationPlayer").play("glow")
		set_process(false)

func SetLevelController(sentNode):
	levelController = sentNode

func SetPos(tilePosX, tilePosY):
	self.set_pos(Vector2((tilePosX * tileSize), (tilePosY * tileSize)))
	
	# Check if box is on target
	if ((levelController.levelStrAry[tilePosY][tilePosX] == "*") or (levelController.levelStrAry[tilePosY][tilePosX] == ".")):
		# On target
		if (not onTarget):
			onTarget = true
			get_node("AnimationPlayer").play("onTarget")
			#self.set_frame(22)
		levelController.CheckWin()
	elif (onTarget):
		onTarget = false
		self.set_frame(21)
		get_node("AnimationPlayer").play("glow")

func GetTilePos():
	var curPos = self.get_pos()
	curPos.x = int(curPos.x / tileSize)
	curPos.y = int(curPos.y / tileSize)
	return curPos