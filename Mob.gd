extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names() # Cria-se uma lista com todos os nomes das animacoes
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()]) # Escolhemos uma aleatoriamente com randi()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited(): # funcao executada quando VisibleOnScreen.... emitir um sinal de que o mob saiu da tela
	queue_free() # Deleta essa instancia do mob
