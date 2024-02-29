extends CharacterBody2D


var movement_speed = 40.0
var hp = 80
var last_movement = Vector2.UP

#Ataques
var Flecha = preload("res://jugador/Attack/flecha.tscn")
var Tompa = preload("res://jugador/Attack/tompa.tscn")
var Jinetompa = preload("res://jugador/Attack/jinetompa.tscn")

#Nodos de ataque
@onready var FlechaTimer = get_node("%FlechaTimer")
@onready var FlechaAttackTimer = get_node("%FlechaAttackTimer")
@onready var TompaTimer = get_node("%TompaTimer")
@onready var TompaAttackTimer = get_node("%TompaAttackTimer")
@onready var JinetompaBase = get_node("%JinetompaBase")

#Flecha
var Flecha_ammo = 0
var Flecha_baseammo = 1
var Flecha_attackspeed = 1.0
var Flecha_level = 1

#Tompa
var Tompa_ammo = 0
var Tompa_baseammo = 1
var Tompa_attackspeed = 3.0
var Tompa_level = 1

#Jinetompa
var Jinetompa_ammo = 1
var Jinetompa_level = 1

#Contra enemigos
var enemy_close = []
#Modelo
@onready var sprite = $Kotone
@onready var walkTimer = get_node("%walkTimer")

func _ready():
	attack()
#movimiento
func _physics_process(_delta):
	movement()

func movement():
	var x_mov = Input.get_axis("left","right")
	var y_mov = Input.get_axis("up","down" )
	var mov = Vector2(x_mov,y_mov)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0: 
		sprite.flip_h = false
		
	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()
#ataque
func attack():
	if Flecha_level > 0:
		FlechaTimer.wait_time = Flecha_attackspeed
		if FlechaTimer.is_stopped():
			FlechaTimer.start()
	if Tompa_level > 0:
		TompaTimer.wait_time = Tompa_attackspeed
		if TompaTimer.is_stopped():
			TompaTimer.start()
	if Jinetompa_level > 0:
		spawn_jinetompa()

#contador de hp
func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= damage
	print(hp)


func _on_flecha_timer_timeout():
	Flecha_ammo += Flecha_baseammo
	FlechaAttackTimer.start()


func _on_flecha_attack_timer_timeout():
	if Flecha_ammo > 0:
		var Flecha_attack = Flecha.instantiate()
		Flecha_attack.position = position
		Flecha_attack.target = get_random_target()
		Flecha_attack.level = Flecha_level
		add_child(Flecha_attack)
		Flecha_ammo -= 1
		if Flecha_ammo > 0:
			FlechaAttackTimer.start()
		else:
			FlechaAttackTimer.stop()

func _on_tompa_timer_timeout():
	Tompa_ammo += Tompa_baseammo
	TompaAttackTimer.start()

func _on_tompa_attack_timer_timeout():
	if Tompa_ammo > 0:
		var Tompa_attack = Tompa.instantiate()
		Tompa_attack.position = position
		Tompa_attack.last_movement = last_movement
		Tompa_attack.level = Tompa_level
		add_child(Tompa_attack)
		Tompa_ammo -= 1
		if Tompa_ammo > 0:
			TompaAttackTimer.start()
		else:
			TompaAttackTimer.stop()

func spawn_jinetompa():
	var get_jinetompa_total = JinetompaBase.get_child_count()
	var calc_spawn = Jinetompa_ammo - get_jinetompa_total
	while calc_spawn > 0:
		var jinetompa_spawn = Jinetompa.instantiate()
		jinetompa_spawn.global_position = global_position
		JinetompaBase.add_child(jinetompa_spawn)
		calc_spawn -= 1

#sistema de apuntado
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

#detección de hit
func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)

