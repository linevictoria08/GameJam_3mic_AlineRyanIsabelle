extends CharacterBody2D


var SPEED = 300.0
const JUMP_VELOCITY = -400.0
const SPEED_BOOST = 1000.0    
# segundos de duração   
const BOOST_DURATION = 5.0
# variável que controla quando o power-up está ativado ou não
var boosted = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("esquerda", "direita")
	
	# Inverte o sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Altera a animação
	if is_on_floor():	
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


# ...restante do código

# função que aplica o aumento de velocidade
func apply_speed_boost():
		# Se a variável boosted for true
	if boosted:
		return  # Sai da função sem fazer nada
						# evita empilhar o efeito, ou seja, ter vários boosts de uma vez
	# Senão, se a variável boosted for false, segue e muda para true
	boosted = true
	# Altere a velocidade para o valor da varíavel SPEED_BOOST
	SPEED = SPEED_BOOST
	# Cria um timer com a duração da variável BOOST_DURATION e pausa a função
	# até que esse tempo termine
	await get_tree().create_timer(BOOST_DURATION).timeout
	# retorna a variável velocidade ao valor original
	SPEED = 200.0
	# volta a variável boosted para false, sinalizando que o power-up acabou
	boosted = false



func die():
	# get_tree() — acessa o SceneTree, que é o gerenciador geral do jogo. 
	# É por ele que você controla cenas, pausa o jogo, fecha o jogo, etc.
	
	# .reload_current_scene() — reinicia a cena atual do zero, como se 
	# você tivesse fechado e reaberto ela.
	get_tree().reload_current_scene()
