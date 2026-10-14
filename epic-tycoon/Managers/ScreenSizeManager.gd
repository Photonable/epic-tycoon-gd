extends Node

# Signals to notify UI and game elements of layout updates
signal screen_resized(new_size: Vector2, aspect_ratio: float)
signal device_category_changed(category: DeviceCategory)
signal fold_state_changed(is_folded: bool)

enum DeviceCategory {
	DESKTOP,
	PHONE_PORTRAIT,
	PHONE_LANDSCAPE,
	FOLDABLE_UNFOLDED,
	TABLET
}

# Current screen states
var current_size: Vector2 = Vector2.ZERO
var current_aspect_ratio: float = 1.0
var current_category: DeviceCategory = DeviceCategory.DESKTOP
var is_folded: bool = false
var is_mobile: bool = false

func _ready() -> void:
	# Detect OS platform
	var os_name := OS.get_name()
	is_mobile = os_name in ["Android", "iOS"]
	
	# Connect to viewport size changes (triggers on PC window resize, rotation, or fold/unfold)
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	
	# Initial calculation
	_update_screen_metrics()

func _on_viewport_size_changed() -> void:
	_update_screen_metrics()

func _update_screen_metrics() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	if viewport_size == current_size:
		return
		
	current_size = viewport_size
	current_aspect_ratio = current_size.x / maxf(current_size.y, 1.0)
	
	var new_category := _classify_device(current_size, current_aspect_ratio)
	var new_fold_state := _check_folded_state(current_aspect_ratio)
	
	var category_changed := (new_category != current_category)
	var fold_changed := (new_fold_state != is_folded)
	
	current_category = new_category
	is_folded = new_fold_state
	
	# Emit signals for listeners
	screen_resized.emit(current_size, current_aspect_ratio)
	
	if category_changed:
		device_category_changed.emit(current_category)
		
	if fold_changed:
		fold_state_changed.emit(is_folded)

func _classify_device(size: Vector2, aspect: float) -> DeviceCategory:
	if not is_mobile:
		return DeviceCategory.DESKTOP
		
	# Unfolded foldables and square tablets have aspect ratios close to 1:1 (0.8 to 1.35)
	if aspect >= 0.8 and aspect <= 1.35:
		return DeviceCategory.FOLDABLE_UNFOLDED
	elif aspect > 1.35:
		return DeviceCategory.PHONE_LANDSCAPE
	else:
		return DeviceCategory.PHONE_PORTRAIT

func _check_folded_state(aspect: float) -> bool:
	if not is_mobile:
		return false
		
	# Outer screen on foldables is typically very tall/narrow (< 0.8 in portrait) or long in landscape
	# Inner unfolded screen falls roughly between 0.8 and 1.35
	return aspect < 0.8 or aspect > 1.35

# Helper method to query if current layout is wide/desktop-like
func is_wide_screen() -> bool:
	return current_aspect_ratio > 1.35
