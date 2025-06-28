extends Control

var faith = 0
var faith_per_click = 1
var faith_per_second = 0
var upgrade1_cost = 10

@onready var faith_label = $FaithLabel
@onready var faith_button = $FaithButton
@onready var upgrade1_button = $TextureRect/GlobalInfos/Upgrade1
@onready var upgrade1Label = $TextureRect/GlobalInfos/Upgrade1/Upgrade1Cost
@onready var globalInfos = $TextureRect/GlobalInfos

func _ready():
	faith_button.pressed.connect(_FaithButton_pressed)
	upgrade1_button.pressed.connect(_UpgradeButton_pressed)
	update_faith_label()

func _UpgradeButton_pressed():
	if (faith >= upgrade1_cost):
		faith_per_click += faith_per_click / 2 + 1
		faith -= upgrade1_cost
		upgrade1_cost += upgrade1_cost + randi_range(4,8)
		update_upg1_label()

func update_upg1_label():
	upgrade1Label.text = "Cost: " + str(floor(upgrade1_cost)) + " Faith"

func _FaithButton_pressed():
	faith += faith_per_click
	update_faith_label()

func _process(delta):
	faith += faith_per_second * delta
	update_global_infos()
	update_faith_label()

func update_global_infos():
	globalInfos.text = "fpc: " + str(floor(faith_per_click))

func update_faith_label():
	faith_label.text = "Faith: " + str(floor(faith))
