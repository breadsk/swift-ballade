extends CharacterBody2D

@onready var sprite: Sprite2D = $Player
@onready var effects: AnimationPlayer = $Effects
@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var hurtTimer: Timer = $HurtTimer

var speed = 60
var lastDir = "D"
var attackDir = ""
var life = 5
var knoBackPower = 400
var isHurting = false
var isAttacking = false
var enemyCollisions = []

func _ready():
	$HitBox/CollisionShape2D.disabled = true

func _physics_process(delta: float):
	move(delta)
	animCtrl()
	attack()
	if not isHurting:
		for enemyArea in enemyCollisions:
			hurt(enemyArea)
		
func move(delta: float):
	velocity = Input.get_vector("left","right","up","down") * speed
	move_and_collide(velocity * delta)
	#move_and_slide()
	
func animCtrl():
	#La primera animación es la predefinida
	if isAttacking: return
	if velocity.x > 0:		
		sprite.flip_h = false
		anims.play("walkR")
		lastDir = "R"
		attackDir = "R"
	elif velocity.x < 0:
		sprite.flip_h = true
		anims.play("walkR")
		lastDir = "R"
		attackDir = "L"
	elif velocity.y > 0:
		anims.play("walkD")
		lastDir = "D"
		attackDir = "D"
	elif velocity.y < 0:
		anims.play("walkU")
		lastDir = "U"
		attackDir = "U"
	else:
		anims.play("idle"+lastDir)#Lo concatena
		
func attack():
	if Input.is_action_just_pressed("attack"):
		isAttacking = true
		if attackDir == "D":
			anims.play("attackD")
		elif attackDir == "R":
			anims.play("attackR")
		elif attackDir == "L":
			anims.play("attackL")
		elif attackDir == "U":
			anims.play("attackU")
		await anims.animation_finished
		isAttacking = false
		
func hurt(area):
	#if isHurting: return
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
		enemyCollisions.append(area)
		#hurt()

func _on_hit_box_area_exited(area: Area2D):
	enemyCollisions.erase(area)
