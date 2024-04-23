extends Area2D

# Sinal para ser enviado quando o player bater em algum objeto
signal hit

# export permite que a variavel seja modificada no inspetor
@export var speed = 400
var screen_size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size # armazenamos o tamanho da tela para limitar o movimento do jogador
	hide() # instancia o objeto invisivel, que so sera mostrado quando o jogo comecar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"): # o ponto (0,0) eh o do canto superior esquerdo, portanto andar para baixo aumenta y
		velocity.y += -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x += -1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # vetor eh normalizado para nao movimentar mais rapido na diagonal 
		$AnimatedSprite2D.play() # Usar $ eh o mesmo que usar get_node()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) # restringe a posicao dentro da tela
	
	if velocity.x != 0: # Se estiver caminhando horizontalmente, ativa a animacao walk
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false # pra ter certeza que o sprite nao girara verticalmente
		$AnimatedSprite2D.flip_h = velocity.x < 0 # Gira o sprite caso o movimento seja pra esquerda x = -1
	elif velocity.y != 0: # se mover verticalmente, utiliza a animacao up
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # flipa verticalmente o sprite se estiver se movendo para baixo
		
		


func _on_body_entered(body): # funcao realizada quando um objeto entra na area2D do player
	hide() # esconde o jogador
	hit.emit() # emite o sinal de hit
	$CollisionShape2D.set_deferred("disabled", true) # desabilitamos a colisao pra nao tomar mais de 1 hit por vez
