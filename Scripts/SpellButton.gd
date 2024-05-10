extends TextureButton

@onready var cooldown = $Cooldown
@onready var key = $Key
@onready var time = $Time
@onready var timer = $Timer

func _input(event):
	if disabled:
		return
	var player = get_player_reference()
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				print("Left mouse button pressed.")
				# 在这里调用左键对应的技能
				if skill != null and change_key == "MOUSE_LEFT":
					skill.cast_spell(player)
					timer.start()
					disabled = true
					set_process(true)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				print("Right mouse button pressed.")
				# 在这里调用右键对应的技能
				if skill != null and change_key == "MOUSE_RIGHT":
					skill.cast_spell(player)
					timer.start()
					disabled = true
					set_process(true)

var skill = null

var change_key = "":
	set(value):
		change_key = value
		key.text = value
		
		if value in ["MOUSE_LEFT", "MOUSE_RIGHT"]:
			var input_event = InputEventMouseButton.new()
			if value == "MOUSE_LEFT":
				input_event.button_index = MOUSE_BUTTON_LEFT
			else:
				input_event.button_index = MOUSE_BUTTON_RIGHT
			shortcut.events = [input_event]
		else:
			shortcut = Shortcut.new()
			var input_key = InputEventKey.new()
			input_key.keycode = value.unicode_at(0)
			
			shortcut.events = [input_key]
		
func _ready():
	change_key = "1"
	cooldown.max_value = timer.wait_time
	set_process(false)


func _process(_delta):
	time.text = "%3.1f" % timer.time_left
	cooldown.value = timer.time_left
	
func _on_pressed():
	var player = get_player_reference()
	if skill != null:
		skill.cast_spell(player)
		
		timer.start()
		disabled = true
		set_process(true)

func get_player_reference():
	return get_tree().get_nodes_in_group("player_group")[0]
	
func _on_timer_timeout():
	disabled = false
	time.text = ""
	cooldown.value = 0
	set_process(false)
