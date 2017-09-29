extends Sprite

var tileScale = 32
var inputTime = 0.0
var inputLimit = .25

func _ready():
	set_process(true)

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
	
	if ((not Input.is_action_pressed("Move_U")) and (not Input.is_action_pressed("Move_D")) and (not Input.is_action_pressed("Move_L")) and (not Input.is_action_pressed("Move_R"))):
		inputTime = inputLimit

func MoveDir(sentVec):
	var curPos = self.get_pos()
	curPos += (sentVec * tileScale)
	self.set_pos(curPos)