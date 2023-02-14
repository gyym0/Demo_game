extends KinematicBody2D

signal player_pos
signal player_pos_1

onready var timer = $Timer
onready var stats = $Stats

# export variables
export var ACCELERATION = 6
export var MAX_SPEED = 3
export var FRICTION = 20

# variables
var velocity = Vector2.ZERO
var time = 0.01

func _ready():
	timer.start(time)
	
func _physics_process(delta):
	move(delta)
	fire_bullet()
	emit_signal("player_pos_1", global_position)
	
func fire_bullet():
	if Input.is_action_just_pressed("Attack"):
		var Bullet = load("res://Enemies/Bullet.tscn")
		var bullet = Bullet.instance()
		var area = bullet.get_node("Area2D")
		var world = get_tree().current_scene
		world.add_child(bullet)
		bullet.global_position = global_position
		area.set_collision_layer_bit(3,true)
		#area.get_overlapping_bodies()
		bullet.fire(get_global_mouse_position(),global_position,0,30)
		
func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right_d") - Input.get_action_strength("ui_left_a")
	input_vector.y = Input.get_action_strength("ui_down_s") - Input.get_action_strength("ui_up_w")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		
		# diagnal fuckery 
		if input_vector.y == 0:
			velocity.y = velocity.move_toward(Vector2.ZERO, FRICTION * delta)[1]
		if input_vector.x == 0:
			velocity.x = velocity.move_toward(Vector2.ZERO, FRICTION * delta)[0]
		 
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide(velocity * 50)
	
func print_pos():
	print(get_viewport().get_mouse_position())


func _on_Timer_timeout():
	emit_signal("player_pos", global_position)
	
func _on_Boss_start_timer():
	timer.start(time)

func _on_Stats_no_health():
	queue_free()


func _on_Area2D2_area_entered(area):
	stats.health -= 1
