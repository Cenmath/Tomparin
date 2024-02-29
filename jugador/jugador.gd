extends CharacterBody2D


var movement_speed = 40.0
var hp = 80

#Ataques
var Flecha = preload("res://jugador/Attack/flecha.tscn")

#Nodos de ataque
@onready var FlechaTimer = get_node("%FlechaTimer")
@onready var FlechaAttackTimer = get_node("%FlechaAttackTimer")

#Flecha
var Flecha_ammo = 0
var Flecha_baseammo = 1
var Flecha_attackspeed = 1.0
var Flecha_level = 1

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
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()
#ataques
func attack():
	if Flecha_level > 0:
		FlechaTimer.wait_time = Flecha_attackspeed
		if FlechaTimer.is_stopped():
			FlechaTimer.start()
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
