extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(origin):
	position.x = origin.x
	position.y = origin.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
