extends Node2D

var game_over = false
var score = 0

onready var active_area = $Balloon/Camera2D/ActiveArea/
#onready var active_area = $HUD/ActiveArea/

var Bird = preload("res://Bird.tscn")
export(int) var bird_count = 12
var birds = []

var Cloud = preload("res://Cloud.tscn")
var cloud_count = 80
var clouds = []

func _ready():
	#screen_metrics()
	#$HUD/Label.text  = String(window_size)
	Global.rng.randomize()
	#create_cloud()
	
	for _i in range(cloud_count):
		create_cloud_within(active_area.get_all())
	for _i in range(bird_count):
		create_bird()

func _process(_delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		$Balloon/Camera2D.zoom = Vector2(1,1) if $Balloon/Camera2D.zoom.x !=1.0 else Vector2(3,3)

#TO PLAY DEATH ANIMATION?
	if not $Balloon.alive:
		game_over = true
		
	if game_over:
		print('game over')
		get_tree().set_pause(true)
		$HUD/Label.text = " Game Over \n you flew " + String(score) + " high"
	else:
#GAME LOOP
		var balloon_x = $Balloon.position.x
		var balloon_y = $Balloon.position.y
		if score < abs(balloon_y):
			score = abs(int(balloon_y))

#GROUND
		$GroundRect.set_position(Vector2(balloon_x - 600, 0))
		#$DEBUG.text = String(active_area)

func create_cloud_within(rectangle: Rect2):
	var new_cloud = Cloud.instance()
	var new_position = Vector2(
			Global.rng.randi_range(rectangle.position.x, rectangle.position.x + rectangle.size.x),
			Global.rng.randi_range(rectangle.position.y, rectangle.position.y + rectangle.size.y))
	new_cloud.set_position(new_position)
	clouds.append(new_cloud)
	add_child(new_cloud)

func create_bird():
	var new_bird = Bird.instance()
	add_child(new_bird)
	
func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("             View size: ", get_viewport_rect().size)
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 

