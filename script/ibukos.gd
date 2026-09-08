extends AnimatedSprite3D
@export var player: CharacterBody3D
@export var speed: float = 5.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		# Ambil posisi player dan sprite di sumbu yang sama (misal XZ jika game top-down/3D biasa)
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * speed * delta
		
		# Opsional: Membalik arah sprite menghadap player (jika sprite menghadap ke kanan/kiri)
		if direction.x != 0:
			flip_h = direction.x < 0
