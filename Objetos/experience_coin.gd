extends Area2D

@export var experience = 1

var spr_cobre = preload("res://Textures/Items/Gems/Cobre.png")
var spr_plata = preload("res://Textures/Items/Gems/Plata.png")
var spr_oro = preload("res://Textures/Items/Gems/Oro.png")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $aud_gemc

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spr_plata
	else:
		sprite.texture = spr_oro

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collect():
	sound.play()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	return experience


func _on_aud_gemc_finished():
	queue_free()
