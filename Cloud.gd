extends Sprite


func _init(origin):
	print("hey " + origin)
	position.x = origin.x
	position.y = origin.y

func _ready():
	print(position)
