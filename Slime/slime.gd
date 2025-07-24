extends CharacterBody2D

@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var slime: Sprite2D = $Slime

@export var endPoint: Marker2D
var speed = 60
var startPosition
var endPosition
var limit = 0.5
var lastDir = "R"
var slimeLife = 2
var isDied = false

func _ready():#Solo lo ejecuta una vez	
	startPosition = position
	endPosition = endPoint.global_position	
	
func _physics_process(delta: float):
	if isDied: return
	move(delta)
	animCtrl()
func _process(delta: float):
	die()
	
func changeDirection():	
	var tempEnd = endPosition
	endPosition = startPosition	
	startPosition = tempEnd
	
func move(delta: float):
	var moveDirection = (endPosition - position)
	#anims.play("walkR")
	
	if moveDirection.length() < limit:
		changeDirection()
		
	velocity = moveDirection.normalized() * speed
	move_and_collide(velocity * delta)
	
func animCtrl():
	#La primera animación es la predefinida
	if velocity.x > 0:		
		slime.flip_h = false
		anims.play("walkR")
		lastDir = "R"
	elif velocity.x < 0:
		slime.flip_h = true
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

func hurt():
	slimeLife -= 1
	
func die():
	if slimeLife <= 0:
		isDied = true
		anims.play("die")
		await anims.animation_finished
		queue_free()

func _on_hurt_box_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		hurt()
		#queue_free()
