extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _no_beam():
	set_rotation_degrees(-40)

func _low_beam():
	set_rotation_degrees(0)

func _high_beam():
	set_rotation_degrees(40)

func _update_pivot_offset():
	set_pivot_offset(Vector2(rect_size.x / 2, rect_size.y / 2))
