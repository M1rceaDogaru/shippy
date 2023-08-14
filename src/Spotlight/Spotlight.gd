extends Area2D

func _on_Spotlight_area_entered(_area):
	get_tree().call_group("main", "spawn_wave")
