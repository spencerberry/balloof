extends Node2D

var game_over = false
var game_over_reset_time = 0
var score = 0

onready var active_area = $Balloon/Camera2D/ActiveArea/
onready var balloon = $Balloon
#onready var active_area = $HUD/ActiveArea/

var Bird = preload("res://Bird.tscn")
export(int) var bird_count = 1
var birds = []

var Cloud = preload("res://Cloud.tscn")
var cloud_count = 80
var clouds = []

func _ready():
	screen_metrics()
	#$HUD/Label.text  = String(window_size)
	Global.rng.randomize()
	#create_cloud()
	
	for _i in range(cloud_count):
		create_cloud_within(active_area.get_all())
	for _i in range(bird_count):
		create_bird(active_area.get_top_full())

func _process(delta):

	if Input.is_action_just_pressed("ui_accept"):
		$Balloon/Camera2D.zoom = Vector2(1,1) if $Balloon/Camera2D.zoom.x !=1.0 else Vector2(4,4)

	if birds.size() < bird_count:
		create_bird()

#TO PLAY DEATH ANIMATION?
	if not $Balloon.alive:
		game_over = true
		
	if game_over:

		$HUD/Label.text = " Game Over \n you flew " + String(score) + " high"

		
		if game_over_reset_time > 1:
			get_tree().reload_current_scene()
		elif $Balloon.press:
			game_over_reset_time += delta
		else:
			game_over_reset_time = max(0, game_over_reset_time - delta)
		$HUD/FadeOut.set_frame_color(Color(1,1,1, game_over_reset_time))


	else:
#GAME LOOP
		var balloon_x = $Balloon.position.x
		var balloon_y = $Balloon.position.y
		if score < abs(balloon_y):
			score = abs(int(balloon_y))

#GROUND
		$GroundRect.set_position(Vector2(balloon_x - 600, 0))


func create_cloud_within(rectangle: Rect2):
	var new_cloud = Cloud.instance()
	var new_position = Vector2(
			Global.rng.randi_range(rectangle.position.x, rectangle.position.x + rectangle.size.x),
			Global.rng.randi_range(rectangle.position.y, rectangle.position.y + rectangle.size.y))
	new_cloud.set_position(new_position)
	clouds.append(new_cloud)
	add_child(new_cloud)

func create_bird(within_area = active_area.get_top_bumper()):
	var new_bird = Bird.instance()
	add_child(new_bird)
	new_bird.target = balloon
	new_bird.move_within(within_area)
	birds.append(new_bird)
		
func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("             View size: ", get_viewport_rect().size)
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 

