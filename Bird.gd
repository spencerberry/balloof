extends Area2D

var speed = randi() % 120 + 100
var direction:int
var window_size = OS.get_window_size()
var offscreen = false

var target = null

onready var shape = $ShapeToKill.shape

func _ready() -> void:
	pass

func _physics_process(delta) -> void:
	position += Vector2(direction * speed * delta, 0)

func _process(_delta):
	if target:
		if direction != direction_to_target() and $TimeToTurn.time_left == 0:
			$TimeToTurn.start()
#	if target and direction_to_target() != direction:
#		$TimeToTurn.start()

	$Sprite.flip_h = direction < 0

#func init(origin):
#	position.x = origin.x
#	position.y = origin.y
#	direction = 1 if origin.x > 0 else -1

func direction_to_target():
	var new_direction = target.global_position.x - global_position.x
	if new_direction == 0: new_direction = 1
	return sign(new_direction)

func _on_screen_exited(): 
#	if target and target.position.y > position.y: #offscreen but above balloon
#		direction = direction_to_target()
#		#position.y += 40
#		#position.x -= direction * window_size.x * 1.5
	pass
func _on_screen_entered():
	#offscreen = false
	pass

	
func _on_time_to_turn():
	direction = direction_to_target()
	position.y += 10



func move_within(rectangle: Rect2):
	var new_position = Vector2(
			Global.rng.randi_range(rectangle.position.x, rectangle.position.x + rectangle.size.x - shape.extents.x * 2),
			Global.rng.randi_range(rectangle.position.y, rectangle.position.y + rectangle.size.y - shape.extents.y * 2))
	set_position(new_position)
	direction = direction_to_target()



func _on_area_exited(area):
	move_within(area.get_top_bumper())
	direction = 1

	#if target: print(String(global_position.x) + " minus " + String(target.global_position.x))
	#make sure that bird is only monitoring active_area and we should be good here
