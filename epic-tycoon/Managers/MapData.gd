# MapData.gd
class_name MapData
extends RefCounted

# Key: Vector2i(x, y), Value: Dictionary or custom object containing tile properties
var grid: Dictionary = {}

func set_tile(coords: Vector2i, tile_id: int, custom_data: Dictionary = {}) -> void:
	grid[coords] = {
		"id": tile_id,
		"data": custom_data
	}

func get_tile(coords: Vector2i) -> Dictionary:
	return grid.get(coords, {"id": -1}) # Return empty/void tile if it doesn't exist
