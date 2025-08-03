class_name TypeoutLabel extends Label

const TYPE_OUT_DURATION: float = 0.5

func populate(display_text: String):
	text = display_text
	visible_ratio = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "visible_ratio", 1, TYPE_OUT_DURATION)
