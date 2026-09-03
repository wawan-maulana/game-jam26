extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 7.0
const GRAVITY_MULTIPLIER = 2.0 # Adjust this to make gravity stronger (e.g., 2.0, 3.0)
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D


func _physics_process(delta: float) -> void:
	
	# Add the gravity with a multiplier to make it heavier/snappier
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MULTIPLIER * delta

	# Handle jump.
	if Input.is_action_just_pressed("lompat") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input for up/down, and force rightward movement for x
	var input_dir := Input.get_vector("kiri", "kanan", "ata", "bawah")
	input_dir.x = max(1.0, input_dir.x) # Automatically forces the character to move right (or faster if right is pressed)
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	update_animation(input_dir)
	move_and_slide()


func update_animation(input_dir: Vector2) -> void:
	# Since x is always at least 1.0, we prioritize vertical animations if up/down are pressed
	if input_dir.y > 0:
		animated_sprite_3d.play("run_front")
		animated_sprite_3d.flip_h = false
	elif input_dir.y < 0:
		animated_sprite_3d.play("run_back")
		animated_sprite_3d.flip_h = false
	else:
		animated_sprite_3d.play("run_right")
		animated_sprite_3d.flip_h = false
