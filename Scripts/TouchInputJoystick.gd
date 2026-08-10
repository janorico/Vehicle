extends Control

onready var dot = $Dot
var active := -1


func _physics_process(_delta: float) -> void:
	var pos = dot.position
	var x = pos.x / 125
	var y = pos.y / 125
	if y > 0:
		Input.action_press("accelerate_back", y)
	elif y < 0:
		Input.action_press("accelerate", abs(y))
	if x > 0:
		Input.action_press("steer_right", x)
	elif x < 0:
		Input.action_press("steer_left", abs(x))


func _input(e: InputEvent) -> void:
	if e is InputEventScreenDrag or (e is InputEventScreenTouch and e.is_pressed()):
		if get_global_rect().has_point(e.position):
			active = e.index
		if active == e.index:
			dot.position = (e.position - Vector2(125, 125) - rect_global_position).limit_length(125)
	if e is InputEventScreenTouch and not e.is_pressed() and e.index == active:
		dot.position = Vector2.ZERO
		active = -1
		Input.action_release("accelerate")
		Input.action_release("accelerate_back")
		Input.action_release("steer_left")
		Input.action_release("steer_right")
