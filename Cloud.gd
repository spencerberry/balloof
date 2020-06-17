extends Area2D

onready var shape = $Shape.shape

#func _init(origin):
#	position.x = origin.x
#	position.y = origin.y

func _ready():
	pass
	#print(position)
	
func _process(_delta):
	pass

func _on_cloud_exited(area):

#	$Sprite.modulate(Color(1.0,0.0,0.0))
	var difference = area.global_position - global_position
	var direction = Global.get_direction(difference)
	#print(direction)
	
	var new_rect: Rect2
	match direction:

		Vector2.DOWN:
			new_rect = area.get_top_bumper()
		Vector2.UP:
			new_rect = area.get_bottom_bumper()
		Vector2.LEFT:
			new_rect = area.get_right_bumper()
			#print(new_rect)
		Vector2.RIGHT:
			new_rect = area.get_left_bumper()
			

	move_within(new_rect) # Replace with function body.

func move_within(rectangle: Rect2):
	var new_position = Vector2(
			Global.rng.randi_range(rectangle.position.x, rectangle.position.x + rectangle.size.x - shape.extents.x * 2),
			Global.rng.randi_range(rectangle.position.y, rectangle.position.y + rectangle.size.y - shape.extents.y * 3))
	
	set_position(new_position)

