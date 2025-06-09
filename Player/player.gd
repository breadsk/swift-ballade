extends CharacterBody2D

@onready var sprite: Sprite2D = $Player
@onready var effects: AnimationPlayer = $Effects
@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var hurtTimer: Timer = $HurtTimer


var speed = 50
var lastDir = "D"
var life = 5
var knoBackPower = 400
var isHurting = false

func _physics_process(delta: float):
	move(delta)
	animCtrl()
	
func move(delta: float):
	velocity = Input.get_vector("left","right","up","down") * speed
	move_and_slide()
	
func animCtrl():
	#La primera animación es la predefinida
	if velocity.x > 0:		
		sprite.flip_h = false
		anims.play("walkR")
		lastDir = "R"
	elif velocity.x < 0:
		sprite.flip_h = true
		anims.play("walkR")
		lastDir = "R"
	elif velocity.y > 0:
		anims.play("walkD")
		lastDir = "D"
		
	elif velocity.y < 0:
		anims.play("walkU")
		lastDir = "U"
	else:
		anims.play("idle"+lastDir)#Lo concatena
		
func hurt(area):
	if isHurting: return
	life -= 1
	isHurting = true
	effects.play("hurts")
	hurtTimer.start()
	knockBack(area.get_parent().velocity)
	print(life)
	await hurtTimer.timeout
	#await effects.animation_finished
	effects.play("RESET")
	isHurting = false

func knockBack(enemyVelocity: Vector2):
	var knockBackDir = (enemyVelocity).normalized() * knoBackPower
	velocity = knockBackDir
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D):
	if area.is_in_group("Enemies"):
		hurt(area)
