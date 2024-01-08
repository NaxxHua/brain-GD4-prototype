extends Node2D

@onready var player = get_node("../Player")
@onready var gui = get_node("../GUI")
@onready var cam = get_node("../Player/Camera2D")

var map_key = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_map"):
		map_key += 1
		if map_key == 1:
			get_tree().paused = true
			$PlayerHead.position = player.global_position
			visible = true
			gui.visible = false
			cam.zoom = Vector2(1,1)
			cam.offset = Vector2(-100, -140)
		if map_key >= 2:
			$PlayerHead.position = self.position
			visible = false
			map_key = 0
			get_tree().paused = false
			gui.visible = true
			cam.zoom = Vector2(3,3)
			cam.offset = Vector2(0, 0)
