extends VBoxContainer

enum SpeedUnit {
	METERS_PER_SECOND = 0,
	KILOMETERS_PER_HOUR = 1,
	MILES_PER_HOUR = 2
}

export(SpeedUnit) var speed_unit := SpeedUnit.KILOMETERS_PER_HOUR

func _process(_delta):
	var vehicle = get_vehicle()
	if vehicle != null:
		# Speed
		var velocity = vehicle.local_velocity
		var unit_suffix: String
		match speed_unit:
			SpeedUnit.METERS_PER_SECOND:
				unit_suffix = "m/s"
			SpeedUnit.KILOMETERS_PER_HOUR:
				unit_suffix = "km/h"
				velocity *= 3.6
			SpeedUnit.MILES_PER_HOUR:
				unit_suffix = "mph"
				velocity *= 2.23694
		var item_speedometer = $Items/Speedometer
		item_speedometer.value = velocity.z
		item_speedometer.content_text = "%5.1f %s" % [velocity.z, unit_suffix]
		# Power
		var power = vehicle.get_power()
		var item_power = $Items/Power
		item_power.value = power
		item_power.content_text = "%5.2f" % power
		if vehicle.has_method("get_power_target"):
			$Items/Power/PointerTarget.rect_rotation = range_lerp(vehicle.get_power_target(), item_power.minimum, item_power.maximum, -90, 90)
		else:
			$Items/Power/PointerTarget.visible = false
		# Braking
		if vehicle is Vehicle:
			$LEDs/BrakeLED.enabled = vehicle.brake > 0.0

func get_vehicle(): return get_node("../../../Vehicles").get_vehicle()

func _change_speed_unit():
	speed_unit = ((speed_unit + 1) % SpeedUnit.size())
	match speed_unit:
		SpeedUnit.METERS_PER_SECOND: $Items/Speedometer.maximum = 60
		SpeedUnit.KILOMETERS_PER_HOUR: $Items/Speedometer.maximum = 200.0
		SpeedUnit.MILES_PER_HOUR: $Items/Speedometer.maximum = 120

func _refresh():
	var vehicle = get_vehicle()
	if vehicle != null:
		$Items/Power.minimum = vehicle.power_min
		$Items/Power.maximum = vehicle.power_max
