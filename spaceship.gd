extends Area2D

# Movement speed
# Signal, was ausgesendet wird, wenn man getroffen wird
signal hit
signal powerup
var speed = 500
var viewportSize
var spriteSize
var shotScene = preload("res://laser.tscn")
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	viewportSize = get_viewport().size
	position.x = viewportSize.x / 2
	position.y = viewportSize.y - 75
	var sprite = get_node("Sprite")
	spriteSize = sprite.get_rect().size * sprite.scale

func _process(delta):
	var sprite = get_node("Sprite")
	if dead:
		return
	sprite.frame = 0
	if Input.is_action_pressed("ui_left"):
		position.x -= speed * delta
		sprite.frame = 1
	if Input.is_action_pressed("ui_right"):
		position.x += speed * delta
		sprite.frame = 1
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta
		sprite.frame = 1
	if Input.is_action_pressed("ui_down"):
		position.y += speed * delta
		sprite.frame = 1
	position.x = clamp(position.x, spriteSize.x / 2, viewportSize.x - (spriteSize.x / 2))
	position.y = clamp(position.y, spriteSize.y / 2, viewportSize.y - (spriteSize.y / 2))
	
	if Input.is_action_just_pressed("player_shoot"):
		var shot = shotScene.instance()
		shot.position.x = position.x
		shot.position.y = position.y - spriteSize.y + 19
		get_parent().add_child(shot)

func _on_spaceship_area_entered(area):
	if "powerup" in area.get_name():
		emit_signal("powerup")
		area.queue_free()
		get_node("powerup_sound").play()
		return

	if not "laser" in area.get_name():
		emit_signal("hit")
		area.queue_free()

func _on_health_dead():
	if dead:
		return
	dead = true
	get_node("AnimationPlayer").play("die")
	get_node("AudioStreamPlayer").play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		var gameOverScene = load("res://game_over.tscn")
		var gameOver = gameOverScene.instance()
		var score = get_parent().get_node("score").score
		gameOver.score = score
		get_parent().add_child(gameOver)
		queue_free()
