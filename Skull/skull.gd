extends CharacterBody2D
@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var skull: Sprite2D = $Skull

@export var endPoint: Marker2D

var speed = 60
var startPosition
var endPosition
var limit = 0.5

func _ready():#Solo lo ejecuta una vez
	startPosition = position
	endPosition = endPoint.global_position
	print("Se esta cargando")
	
func _physics_process(delta: float):
	move()
	
func changeDirection():
	skull.flip_h = false
	var tempEnd = endPosition
	endPosition = startPosition
	skull.flip_h = true
	startPosition = tempEnd
	
	anims.play("walkR")
	
func move():
	var moveDirection = (endPosition - position)
	anims.play("walkR")
	
	if moveDirection.length() < limit:
		changeDirection()
		
	velocity = moveDirection.normalized() * speed
	move_and_slide()
