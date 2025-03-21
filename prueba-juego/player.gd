extends Area2D

signal hit # Señal para detectar cuando el jugador es golpeado

@export var speed = 400 # Velocidad del jugador (pixeles/segundo)
var screen_size # Tamaño de la ventana del juego

func _ready():
	screen_size = get_viewport_rect().size
	start(Vector2(screen_size.x / 2, screen_size.y / 2)) # Asegura que el jugador aparezca al inicio

func _process(delta):	
	var velocity = Vector2.ZERO # Vector de movimiento del jugador.

	# Capturar la entrada del jugador
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# Actualizar animaciones basadas en la dirección del movimiento
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

	# Normalizar velocidad y reproducir animación
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# Mover al jugador
	position += velocity * delta
	
	# Limitar la posición dentro de la pantalla
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

# Detectar colisiones con enemigos
func _on_body_entered(_body):
	hide() # Oculta al jugador tras el golpe
	hit.emit()
	# Deshabilitar la colisión para evitar más impactos
	$CollisionShape2D.set_deferred("disabled", true)

# Función para reaparecer al jugador
func start(pos):
	position = pos
	show() # Ahora el jugador vuelve a aparecer
	$CollisionShape2D.set_deferred("disabled", false) # Reactivar la colisión
