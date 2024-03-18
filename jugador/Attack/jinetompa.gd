extends Area2D

var level = 1
var hp = 9999
var speed = 200
var damage = 10
var knockback_amount = 100
var paths = 1
var attack_size = 1.0
var attack_speed = 5.0

var target = Vector2.ZERO
var target_array = []

var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

var spr_jin_stb = preload("res://Textures/Items/Weapons/Jinetompa.png")
var spr_jin_atk = preload("res://Textures/Items/Weapons/JinetompaA.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var ChargeTimer = get_node("%ChargeTimer")
@onready var ChangeDirectionTimer = get_node("%ChangeDirection")
@onready var StandbyTimer = get_node("%StandbyReset")
@onready var Charge_jin = $Charge_jin

signal remove_from_array(object)

func _ready():
	update_jinetompa()
	_on_standby_reset_timeout()

func update_jinetompa():
	level = player.Jinetompa_level
	match level:
		1:
			hp = 9999
			speed = 200
			damage = 10
			knockback_amount = 100
			paths = 1
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1- player.spell_cooldown)
		2:
			hp = 9999
			speed = 220
			damage = 15
			knockback_amount = 110
			paths = 1
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1- player.spell_cooldown)
		3:
			hp = 9999
			speed = 220
			damage = 15
			knockback_amount = 110
			paths = 2
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1- player.spell_cooldown)
		4:
			hp = 9999
			speed = 220
			damage = 20
			knockback_amount = 120
			paths = 3
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 4.0 * (1- player.spell_cooldown)
	
	scale = Vector2(1.0,1.0) * attack_size
	ChargeTimer.wait_time = attack_speed

func _physics_process(delta):
	if target_array.size() > 0:
		position += angle*speed*delta
	else:
		var player_angle = global_position.direction_to(reset_pos)
		var distance_dif = global_position - player.global_position
		var return_speed = 60
		if abs(distance_dif.x) > 500 or abs(distance_dif.y) > 500:
			return_speed = 200
		position += player_angle*return_speed*delta
	var angle_tar = global_position.angle_to_point(target)
	if abs(angle_tar) > PI/2:
		scale.x = -1
	else:
		scale.x = 1

func add_paths():
	Charge_jin.play()
	emit_signal("remove_from_array",self)
	target_array.clear()
	var counter = 0
	while counter < paths:
		var new_path = player.get_random_target()
		target_array.append(new_path)
		counter += 1
		enable_attack(true)
	target = target_array[0]
	process_path()
	

func process_path():
	angle = global_position.direction_to(target)
	ChangeDirectionTimer.start()

func enable_attack(atk = true):
	if atk:
		collision.call_deferred("set","disabled",false)
		sprite.texture = spr_jin_atk
	else:
		collision.call_deferred("set","disabled",true)
		sprite.texture = spr_jin_stb

func _on_charge_timer_timeout():
	add_paths()

func _on_change_direction_timeout():
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			Charge_jin.play()
			emit_signal("remove_from_array",self)
		else:
			ChangeDirectionTimer.stop()
			ChargeTimer.start()
			enable_attack(false)
	else:
		ChangeDirectionTimer.stop()
		ChargeTimer.start()
		enable_attack(false)


func _on_standby_reset_timeout():
	var choose_direction = randi() % 4
	reset_pos = player.global_position
	match choose_direction:
		0:
			reset_pos.x += 50
		1:
			reset_pos.x -= 50
		2:
			reset_pos.y += 50
		3:
			reset_pos.y -= 50
