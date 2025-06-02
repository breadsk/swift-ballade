extends CharacterBody2D
@onready var sprite: Sprite2D = $Player

@onready var anims: AnimationPlayer = $AnimationPlayer



var speed = 50
var lastDir = "D"
var life = 5

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
		
func hurt():
	life -= 1
	print(life)

func _on_hurt_box_body_entered(body: Node2D):
	if body.name == "Skull":
		hurt()
