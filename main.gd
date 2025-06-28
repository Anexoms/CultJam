extends Control

var faith = 0
var faith_per_click = 1
var faith_per_second = 0
var followers_will = 100
var followers = 0

@onready var faith_label = $FaithLabel
@onready var faith_button = $FaithButton

@onready var back = $back1
@onready var fpc = $TextureRect/fpc
@onready var fps = $TextureRect/fps

var upgrade1_cost = 10
@onready var upgrade1_button = $TextureRect/Upgrade1
@onready var upgrade1CostLabel = $TextureRect/Upgrade1/Cost
@onready var upgrade1RewardLabel = $TextureRect/Upgrade1/Reward

var upgrade2_cost = 10
@onready var upgrade2_button = $TextureRect/Upgrade2
@onready var upgrade2CostLabel = $TextureRect/Upgrade2/Cost
@onready var upgrade2RewardLabel = $TextureRect/Upgrade2/Reward


func _ready():
	faith_button.pressed.connect(_FaithButton_pressed)
	upgrade1_button.pressed.connect(upgrade1_pressed)
	upgrade2_button.pressed.connect(upgrade2_pressed)
	update_faith_label()
	update_upg1_label()
	update_upg2_label()

func _process(delta):
	faith += faith_per_second * delta
	update_global_infos()
	update_faith_label()
	if (followers_will <= faith):
		for i in range(0, 5):
			spawn_sprite()
			followers += 1
		followers_will += 500
	if (followers_will - 500 >= faith && followers != 0):
		for i in range(0, 5):
			back.remove_child(back.get_child(0))
			followers -= 1
		followers_will -= 500

func upgrade1_pressed():
	if (faith >= upgrade1_cost):
		faith_per_click += upgrade1_cost / 3 + 1
		faith -= upgrade1_cost
		upgrade1_cost += upgrade1_cost + randi_range(4,8)
		update_upg1_label()

func update_upg1_label():
	upgrade1CostLabel.text = str(floor(upgrade1_cost)) + " Faith"
	upgrade1RewardLabel.text = "+ " + str(floor(upgrade1_cost / 3 + 1)) + " fpc"

func upgrade2_pressed():
	if (faith_per_click >= upgrade2_cost):
		faith_per_second += upgrade2_cost / 4 + 1
		faith_per_click -= upgrade2_cost
		upgrade2_cost += upgrade2_cost + randi_range(4, 10)
		update_upg2_label()

func update_upg2_label():
	upgrade2CostLabel.text = str(floor(upgrade2_cost)) + " fpc"
	upgrade2RewardLabel.text = "+ " + str(floor(upgrade2_cost / 4 + 1)) + " fps"

func _FaithButton_pressed():
	faith += faith_per_click
	update_faith_label()

func update_global_infos():
	fpc.text = "fpc: " + str(floor(faith_per_click))
	fps.text = "fps: " + str(floor(faith_per_second))

func update_faith_label():
	faith_label.text = "Faith: " + str(floor(faith))

func spawn_sprite():
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/sprites/cultist.png")
	sprite.position = Vector2(
		randi_range(220,860),
		randi_range(200, 270)
	)
	sprite.scale = Vector2(randf_range(0.4,0.6), randf_range(0.4,0.6))
	back.add_child(sprite)
