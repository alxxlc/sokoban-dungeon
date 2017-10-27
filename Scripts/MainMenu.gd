extends Node2D

var diffSelected = 0

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_LevelSelectButton_pressed():
	get_node("MainMenu").hide()
	get_node("DiffMenu").show()

func _on_PlayBackBtn_pressed():
	get_node("PlayMenu").hide()
	get_node("MainMenu").show()

func _on_DiffBackBtn_pressed():
	get_node("MainMenu").show()
	get_node("DiffMenu").hide()

func _on_LevelBackBtn_pressed():
	get_node("LevelMenu").hide()
	get_node("DiffMenu").show()

func _on_StartGameBtn_pressed():
	var setDiff = get_node("PlayMenu/VBoxContainer/HBoxContainer/DiffEdit").get_value()
	var setLevel = get_node("PlayMenu/VBoxContainer/HBoxContainer/LevelEdit").get_value()
	
	GameController.SetNextLevel(setDiff, setLevel)
	get_tree().change_scene("res://Scenes/LevelScene.tscn")

func _on_DiffMenu_draw():
	var diffCount = LevelLoader.levelStrings.size()
	
	# Clear DiffBtnContainer
	for curNode in get_node("DiffMenu/VBoxContainer/DiffBtnContainer").get_children():
		curNode.free()
	
	for i in range(diffCount):
		var DiffBtn = load("res://Scenes/StoneButton.tscn").instance()
		DiffBtn.SetText(str(i+1))
		DiffBtn.connect("pressed", self, "_on_DiffNum_pressed", [i])
		get_node("DiffMenu/VBoxContainer/DiffBtnContainer").add_child(DiffBtn)

func _on_DiffNum_pressed(numPressed):
	print("SETTING BUTTONS")
	diffSelected = numPressed
	var levelCount = LevelLoader.levelStrings[diffSelected].size()
	
	for curNode in get_node("LevelMenu/CenterContainer/VBoxContainer/GridContainer").get_children():
		curNode.free()
	
	for i in range(levelCount):
		var LevelBtn = load("res://Scenes/StoneButton.tscn").instance()
		LevelBtn.SetText(str(i+1))
		LevelBtn.connect("pressed", self, "_on_LevelNum_pressed", [i])
		get_node("LevelMenu/CenterContainer/VBoxContainer/GridContainer").add_child(LevelBtn)
		LevelBtn.raise()
	
	get_node("DiffMenu").hide()
	get_node("LevelMenu").show()

func _on_LevelNum_pressed(numPressed):
	GameController.nextDiff = diffSelected
	GameController.nextLevel = numPressed
	
	get_tree().change_scene("res://Scenes/LevelScene.tscn")
