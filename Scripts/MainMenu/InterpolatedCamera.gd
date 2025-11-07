# Source: http://kidscancode.org/godot_recipes/3.x/3d/interpolated_camera/
extends Camera

export var lerp_speed = 3.0
export var target := Transform()
export (Vector3) var offset = Vector3.ZERO


func _physics_process(delta):
	var lookat: Transform
	lookat.origin = target.translated(offset).origin

	var original_scale: Vector3 = scale;
	lookat = lookat.looking_at(target.origin, Vector3.UP);
	scale = original_scale;

	global_transform = global_transform.interpolate_with(lookat, lerp_speed * delta)
