extends Node

export var max_health = 1
onready var health = max_health setget set_health


signal no_health
signal phase_1

func set_health (value):
	health = value
	if health <= 0:
		emit_signal("no_health")
	if health == 10:
		emit_signal("phase_1")
		
