extends Sprite

var tileSize = 32
var inputTime = 0.0
var inputLimit = .25
var moveCount = 0
var levelController

func _ready():
	set_process(true)

func SetLevelController(sentNode):
	levelController = sentNode

func _process(delta):
	inputTime += delta
	
	if (inputTime >= inputLimit):
		if (Input.is_action_pressed("Move_U")):
			MoveDir(Vector2(0, -1))
			inputTime = 0.0
		elif (Input.is_action_pressed("Move_D")):
			MoveDir(Vector2(0, 1))
			inputTime = 0.0
		elif (Input.is_action_pressed("Move_L")):
			MoveDir(Vector2(-1, 0))
			inputTime = 0.0
		elif (Input.is_action_pressed("Move_R")):
			MoveDir(Vector2(1, 0))
			inputTime = 0.0
	
	if (Input.is_action_pressed("LevelReset")):
		levelController.DrawLevel()
	
	if ((not Input.is_action_pressed("Move_U")) and (not Input.is_action_pressed("Move_D")) and (not Input.is_action_pressed("Move_L")) and (not Input.is_action_pressed("Move_R"))):
		inputTime = inputLimit

func MoveDir(sentVec):
	var curPos = self.get_pos()
	var tilePos = Vector2((curPos.x / tileSize), (curPos.y / tileSize))
	if (levelController.CheckPlayerMove(tilePos, sentVec)):
		curPos += (sentVec * tileSize)
	self.set_pos(curPos)
	moveCount += 1
	if (levelController.levelWon):
		levelController.LevelWin()

func ShowWinMessage():
	pass
	