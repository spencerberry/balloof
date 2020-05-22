extends Node

var rng = RandomNumberGenerator.new()


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_direction(difference: Vector2):
	if difference == Vector2.ZERO:
		return Vector2.ZERO 
	elif abs(difference.y) > abs(difference.x): # Moving more vertically than horizontally
		return Vector2.DOWN if difference.y < 0 else Vector2.UP
	else:
		return Vector2.LEFT if difference.x > 0 else Vector2.RIGHT
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#
#func simplify(long_decimal, decimal_count:int = 2):
#	return round(long_decimal * pow(10, decimal_count)) / pow(10, decimal_count)

func simplify(vec, decimal_count: int = 2):
	var result
	var step = 1/pow(10, decimal_count)
	if typeof(vec) == TYPE_VECTOR2:
		result = Vector2(stepify(vec.x, step), stepify(vec.y, step))
	elif typeof(vec) == TYPE_VECTOR3:
		result = Vector3(stepify(vec.x, step), stepify(vec.y, step), stepify(vec.z, step))
	return result
