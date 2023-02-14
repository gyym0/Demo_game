extends KinematicBody2D

export var ACCELERATION = 10
export var MAX_SPEED = 10
export var TELEPORT = 1.05
export var ATTACK = 1
var velocity = Vector2.ZERO
var pos = 0

signal start_timer

onready var stats = $Stats
onready var animatedSprite = $AnimatedSprite
onready var area = $Area2D
onready var time = $Timer

onready var color = $AnimatedSprite.get_modulate()

func _ready():
	print(stats.max_health)
	pass

func _process(delta):
	pass
	
func _on_Area2D_area_entered(area):
	stats.health-=1
	$AnimatedSprite.modulate = Color(227, 61, 148)
	
func _on_Stats_no_health():
	queue_free()

func _on_Stats_phase_1():
	animatedSprite.scale = Vector2(4, 4)
	area.scale = Vector2(4, 4)
	TELEPORT = 5



func _on_Player_player_pos(pos):
	var a = rand_range(1,10)
	var mous = pos/global_position - Vector2.ONE
	mous = mous/(sqrt(pow(mous[0],2)+pow(mous[1],2)))
	velocity += mous * ACCELERATION
	velocity = velocity.clamped(MAX_SPEED)
	velocity = move_and_slide(velocity)
	emit_signal("start_timer")
	if a < TELEPORT:
		global_position = pos - Vector2(rand_range(50,200),rand_range(50,200))
	
func fire_bullet(target):
	var Bullet = load("res://Enemies/Bullet.tscn")
	var bullet = Bullet.instance()
	var area = bullet.get_node("Area2D")
	area.set_collision_layer_bit(2,true)
	var world = get_tree().current_scene
	world.add_child(bullet)
	bullet.global_position = global_position
	
	bullet.fire(target,global_position,1,ATTACK)



func _on_Player_player_pos_1(pos):
	fire_bullet(pos)



func _on_Timer_timeout():
	$AnimatedSprite.modulate = Color(0, 0, 1)
	$AnimatedSprite.modulate = Color(color)
