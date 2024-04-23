extends CanvasLayer

signal start_game

func update_score(score): # Funcao para atualizar o score na tela
	$ScoreLabel.text = str(score)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_message(text): # Mostra uma mensagem na tela por 2 segundos
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout # Espera o tempo da mensagem acabar
	
	# Aqui, basicamente recia-se a tela inicial
	$Message.text = "Dodge the Creeps!" # Altera o texto na tela
	$Message.show()
	await get_tree().create_timer(1.0).timeout # Cria um timer de uso unico com 1s
	$StartButton.show() # Recoloca o botao na tela

func _on_start_button_pressed():
	$StartButton.hide() # Esconde o botao
	start_game.emit() # Emite um sinal de comeco de jogo


func _on_message_timer_timeout(): # Tira a mensagem da tela quando o timer estoura
	$Message.hide()
