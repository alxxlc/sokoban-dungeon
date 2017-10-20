extends Light2D

var cameraNode

func _ready():
	cameraNode = get_parent().get_node("Camera2D")
	set_process(true)

func _process(delta):
	self.set_global_pos(cameraNode.get_camera_screen_center())
