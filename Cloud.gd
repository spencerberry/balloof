extends Area2D

#func _init(origin):
#	position.x = origin.x
#	position.y = origin.y

func _ready():
	print(position)
	
func _process(_delta):
	pass

func _on_cloud_exited(area):
	print("it's gone")
	move_within(area.get_top_half()) # Replace with function body.

func move_within(rectangle: Rect2):
	var new_position = Vector2(
			Global.rng.randi_range(rectangle.position.x, rectangle.position.x + rectangle.size.x),
			Global.rng.randi_range(rectangle.position.y, rectangle.position.y + rectangle.size.y))
	set_position(new_position)
