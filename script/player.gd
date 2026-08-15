extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
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
	if input_dir == Vector2.ZERO:
		animated_sprite_3d.stop()
		return

	# Prioritize horizontal movement over vertical, or adjust as needed
	if abs(input_dir.x) > abs(input_dir.y):
		animated_sprite_3d.play("run_right")
		animated_sprite_3d.flip_h = input_dir.x < 0
	elif input_dir.y > 0:
		animated_sprite_3d.play("run_front")
		animated_sprite_3d.flip_h = false
	elif input_dir.y < 0:
		animated_sprite_3d.play("run_back")
		animated_sprite_3d.flip_h = false
