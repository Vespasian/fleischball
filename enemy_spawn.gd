extends Timer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enemyScene = preload("res://fleischball.tscn")
var screenWidth

func _ready():
	screenWidth = get_viewport().size.x

func _on_enemy_spawn_timeout():
	var enemy = enemyScene.instance()
	enemy.position.x = rand_range(0, screenWidth)
	get_parent().add_child(enemy)