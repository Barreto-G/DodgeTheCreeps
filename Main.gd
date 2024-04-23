extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free") # Limpa todos os mobs da tela de um jogo anterior
	$Player.start($StartPosition.position) # chama a funcao start usando a posicao definida em startPosition
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func _on_mob_timer_timeout(): # Quando o timer estoura, um novo mob eh instanciado
	# Instancia um novo mob
	var mob = mob_scene.instantiate()
	
	# Pegamos de mobSpawnLocation a posicao em que ele spawnara
	var mob_spawn_location = $MobPath/MobSpawnLocation
	# Isso eu nao faco ideia do que eh
	mob_spawn_location.progress_ratio = randf()
	
	# O Mob eh instanciado perpendicular a tela, portanto +PI/2 faz com que ele vire para dentro da tela
	var direction = mob_spawn_location.rotation + PI/2
	
	# setamos a posicao do mob
	mob.position = mob_spawn_location.position
	
	# Adicionamos uma direcao aleatoria pequena, para cada mob se mover diferente dos outros
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	# Nossa velocidade tambem sera aleatoria, mas apenas no eixo X e positiva,
	# Assim, o mob vai se mover sempre para frente, na direcao indicada
	var velocity = Vector2(randf_range(150.0,250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Adicionamos o mob a cena
	add_child(mob)


func _on_score_timer_timeout():
	score += 1 # Aumenta em 1 ponto a cada vez que o timer estoura (1s)
	$HUD.update_score(score)

func _on_start_timer_timeout(): # Quando o contador de inicio estoura
	$MobTimer.start() # Comeca a contagem pra instanciar mobs
	$ScoreTimer.start() # comeca a contagem de pontos
