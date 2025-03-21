extends RigidBody2D

func _ready():
	# Elegir aleatoriamente una animación de los mobs
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.animation = mob_types[randi() % mob_types.size()]

	# Asignar una velocidad al mob
	linear_velocity = Vector2(0, 150)

# Eliminar el Mob cuando salga de la pantalla
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
