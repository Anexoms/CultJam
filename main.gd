extends Control

class UpgradeData:
	var name: String
	var cost: float
	var effect: float
	var effect_type: String
	var description: String
	var icon_path: String
	var on_activate: Callable

	func _init(name, cost, effect, effect_type, description, icon_path, on_activate):
		self.name = name
		self.cost = cost
		self.effect = effect
		self.effect_type = effect_type
		self.description = description
		self.icon_path = icon_path
		self.on_activate = on_activate


var faith = 0
var faith_per_click = 1
var faith_per_second = 0
var followers_will = 100
var followers = 0
var upgrades: Array[UpgradeData] = []

@onready var faith_label = $FaithLabel
@onready var faith_button = $FaithButton

@onready var back = $back1
@onready var fpc = $TextureRect/fpc
@onready var fps = $TextureRect/fps

var upgrade1_cost = 10
const UPGRADE1_REWARD = 2
@onready var upgrade1_button = $TextureRect/Upgrade1
@onready var upgrade1CostLabel = $TextureRect/Upgrade1/Cost
@onready var upgrade1RewardLabel = $TextureRect/Upgrade1/Reward

var upgrade2_cost = 25
const UPGRADE2_REWARD = 1
@onready var upgrade2_button = $TextureRect/Upgrade2
@onready var upgrade2CostLabel = $TextureRect/Upgrade2/Cost
@onready var upgrade2RewardLabel = $TextureRect/Upgrade2/Reward

@onready var shop_toggle_button = $ShopToggleButton
@onready var shop_panel = $TextureRect
@onready var close_button = $TextureRect/CloseButton
@onready var shop_list = $TextureRect/ShopList


func _ready():
	faith_button.pressed.connect(_FaithButton_pressed)
	upgrade1_button.pressed.connect(upgrade1_pressed)
	upgrade2_button.pressed.connect(upgrade2_pressed)
	update_faith_label()
	update_upg1_label()
	update_upg2_label()
	shop_toggle_button.pressed.connect(toggle_shop)
	shop_panel.visible = false
	close_button.pressed.connect(hide_shop)

	upgrades = [
		UpgradeData.new("Recruit Follower", 10, 0.1, "fps", "Converts barista", "", func(): add_fps(0.1)),
		UpgradeData.new("Propaganda Leaflets", 50, 1, "fpc", "Poorly xeroxed", "", func(): add_fpc(1)),
		UpgradeData.new("Blood Ritual", 200, 2, "fps", "Faith is thicker than blood", "", func(): add_fps(2)),
		UpgradeData.new("Dark Sermons", 500, 5, "fpc", "Void gospel", "", func(): add_fpc(5)),
		UpgradeData.new("Hooded Acolytes", 1000, 10, "fps", "Creepy but efficient", "", func(): add_fps(10)),
		UpgradeData.new("Mind Control", 5000, 50, "fps", "Tune in...", "", func(): add_fps(50)),
		UpgradeData.new("Summon Demon", 10000, 100, "fpc", "Recruiter demon", "", func(): add_fpc(100)),
		UpgradeData.new("The Ascension", 50000, 0, "end", "Become All-Eye", "", func(): trigger_ending()),
	]

func _process(delta):
	faith += faith_per_second * delta
	update_global_infos()
	update_faith_label()
	
	if followers_will <= faith:
		for i in range(5):
			spawn_sprite()
			followers += 1
		followers_will += 500
	
	elif followers_will - 500 >= faith and followers != 0:
		for i in range(5):
			back.remove_child(back.get_child(0))
			followers -= 1
		followers_will -= 500


func upgrade1_pressed():
	if faith >= upgrade1_cost:
		faith_per_click += UPGRADE1_REWARD
		faith -= upgrade1_cost
		upgrade1_cost *= 1.15
		update_upg1_label()


func update_upg1_label():
	upgrade1CostLabel.text = str(floor(upgrade1_cost)) + " Faith"
	upgrade1RewardLabel.text = "+ " + str(UPGRADE1_REWARD) + " fpc"


func upgrade2_pressed():
	if (faith_per_click >= upgrade2_cost):
		faith_per_second += upgrade2_cost / 4 + 1
		faith_per_click -= upgrade2_cost
		upgrade2_cost *= 1.5
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
		randi_range(220, 860),
		randi_range(200, 270)
	)
	sprite.scale = Vector2(randf_range(0.4, 0.6), randf_range(0.4, 0.6))
	back.add_child(sprite)

func toggle_shop():
	shop_panel.visible = !shop_panel.visible
	
func hide_shop():
	shop_panel.visible = false

func add_fps(amount: float):
	faith_per_second += amount
	update_global_infos()

func add_fpc(amount: float):
	faith_per_click += amount
	update_global_infos()

func trigger_ending():
	pass
