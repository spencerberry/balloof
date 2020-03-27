extends Area2D

var speed = 15.0
var direction:int
var vision_distance = 120.0
var speed_up = 1.5

var balloon = null

func _ready():
	$Vision/CollisionShape2D.shape = CircleShape2D.new()
	$Vision/CollisionShape2D.shape.radius = vision_distance

func _physics_process(delta):
	position += Vector2(direction * speed * delta, 0)
	
func _process(delta):
	$Sprite.flip_h = direction < 0

func init(origin):
	position.x = origin.x
	position.y = origin.y
	direction = 1 if origin.x > 0 else -1


func _on_Vision_body_entered(body):
	if body.name == 'Balloon':
		balloon = body
		speed *= speed_up

func _on_Vision_body_exited(body):
	if body == balloon:
		direction = sign(body.position.x - position.x)
		speed /= speed_up
		balloon = null
