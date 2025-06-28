extends Control

func _ready():
	anchor_left = 0
	anchor_top = 0
	anchor_right = 1
	anchor_bottom = 1
	var background = ColorRect.new()
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	var center = CenterContainer.new()
	var vbox = VBoxContainer.new()
	var title = Label.new()

	background.color = Color(0.08, 0.01, 0.01)
	background.anchor_right = 1
	background.anchor_bottom = 1
	add_child(background)
	panel.anchor_left = 0.25
	panel.anchor_top = 0.2
	panel.anchor_right = 0.75
	panel.anchor_bottom = 0.8
	style.bg_color = Color(0.12, 0, 0)
	style.set_corner_radius_all(12)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	panel.add_child(center)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.custom_minimum_size = Vector2(360, 280)
	center.add_child(vbox)
	title.text = "FAITH CLICKER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color(0.9, 0.2, 0.2))
	title.add_theme_font_size_override("font_size", 52)
	vbox.add_child(title)
	vbox.add_spacer(1)
	for text in ["PLAY", "QUIT"]:
		var btn = Button.new()
		btn.text = text
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 60)
		btn.add_theme_color_override("font_color", Color(1, 1, 1))
		btn.add_theme_color_override("font_color_hover", Color(1, 0.6, 0.6))
		btn.add_theme_color_override("bg_color", Color(0.2, 0, 0))
		btn.add_theme_color_override("bg_color_hover", Color(0.4, 0, 0))
		if text == "PLAY":
			btn.connect("pressed", Callable(self, "_on_play_pressed"))
		else:
			btn.connect("pressed", Callable(self, "_on_quit_pressed"))
		vbox.add_child(btn)
	vbox.add_spacer(1)
func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
func _on_quit_pressed():
	get_tree().quit()
