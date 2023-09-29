extends Node2D

var lives = 3
var score = 0

@onready var player = $Player
@onready var hud = $UI/HUD
@onready var ui = $UI

@onready var enemy_hit_sound = $EnemyHitSound
@onready var player_hit_sound = $PlayerHitSound

var gos_scene = preload("res://scenes/game_over_screen.tscn")

func _ready():
	hud.set_score_label(0)
	hud.set_lives(lives)

func _on_death_zone_area_entered(area):
	area.queue_free()

func _on_player_took_damage():
	player_hit_sound.play()
	lives -= 1
	hud.set_lives(lives)
	if (lives == 0):
		player.die()
		
		await  get_tree().create_timer(1.5).timeout
		
		var gos = gos_scene.instantiate()
		gos.set_score(score)
		ui.add_child(gos)

func _on_enemy_spawner_enemy_spawned(enemy_instance):
	enemy_instance.connect("died", _on_enemy_died)
	add_child(enemy_instance)

func _on_enemy_died():
	score += 100
	hud.set_score_label(score)
	enemy_hit_sound.play()
