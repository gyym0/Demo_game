extends KinematicBody2D

signal area

export var BULLETACCELERATION = 50
export var MAX_SPEED = 300

onready var timer = $Timer
onready var animatedSprite = $AnimatedSprite

var vec = Vector2(1, 1)
var velocity = Vector2.ZERO


func _physics_process(_delta):
	pass
	
func fire(mouse_pos,cur_pos,type,time):	
	# enemy bullet 
	emit_signal("area",0)
	
	if type == 1:
		animatedSprite.frame = 1
	
	timer.start(time)
	while timer.is_stopped() != true:
		var mous = mouse_pos/cur_pos - Vector2.ONE
		var cur = cur_pos/cur_pos - Vector2.ONE
		mous = mous/(sqrt(pow(mous[0],2)+pow(mous[1],2)))
		#print(cur)
		#break
		velocity += mous * BULLETACCELERATION
		velocity = velocity.clamped(MAX_SPEED)
		velocity = move_and_slide(velocity)
		yield(get_tree(), "idle_frame")
	
		
func _on_Area2D_area_entered(area):
	queue_free()


func _on_Timer_timeout():
	queue_free()
