class_name EditorFlowNode
extends GraphNode

class NodeItem extends HBoxContainer:
	signal delete_pressed(item: NodeItem)
	
	var slot: int = -1
	
	var _inner_hbox: HBoxContainer = null
	var delete: Button = null
	
	func _init(label_name: String, slot: int = -1) -> void:
		self.slot = slot
		
		var label := Label.new()
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.text = label_name
		
		_inner_hbox = HBoxContainer.new()
		_inner_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		delete = Button.new()
		delete.text = "X"
		delete.pressed.connect(func() -> void:
			delete_pressed.emit(self)
		)
		
		add_child(label)
		_inner_hbox.add_child(delete)
		add_child(_inner_hbox)
	
	func _add_main_element(control: Control) -> void:
		_inner_hbox.add_child(control)
		_inner_hbox.move_child(control, 0)
	
	static func _expand_control(control: Control) -> void:
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	func get_data() -> Variant:
		return null

enum SlotType {
	NONE,
	
	ANY,
	PARAM,
	RETURN,
}

const Groups := {
	VAR = "var_node",
	CONST = "const_node",
	FUNCTION = "function_node",
	CLASS = "class_node",
	COMMENT = "comment_node",
	RAW = "raw_node",
}

const DEFAULT_COLOR := Color.WHITE
const PARAM_COLOR := Color.GOLDENROD
const RETURN_COLOR := Color.VIOLET

var uuid: int = GDFlowUtil.uuid()

var _slots: int = 0

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init(title: String, group: String) -> void:
	self.title = title if not title.is_empty() else "__nyi__"
	add_to_group(group)
	
	show_close = true
	resizable = true
	custom_minimum_size = Vector2(200, 100)
	
	close_request.connect(func() -> void:
		queue_free()
	)
	resize_request.connect(func(new_size: Vector2) -> void:
		size = new_size
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

## Adds a slot with the given parameters and increments the slot count.
func _add_slot(
	left: bool, left_type: int, left_color: Color,
	right: bool, right_type: int, right_color: Color
) -> EditorFlowNode:
	set_slot(_slots, left, left_type, left_color, right, right_type, right_color)
	
	_slots += 1
	
	return self

## Adds a slot on the left and increments the slot count.
func _add_left_slot(type: int, color: Color) -> EditorFlowNode:
	return _add_slot(true, type, color, false, SlotType.NONE, DEFAULT_COLOR)

## Adds a slot on the right and increments the slot count.
func _add_right_slot(type: int, color: Color) -> EditorFlowNode:
	return _add_slot(false, SlotType.NONE, DEFAULT_COLOR, true, type, color)

## Edits the last used slot on the left.
func _edit_left_slot(
	enabled: bool, type: int = SlotType.NONE, color: Color = DEFAULT_COLOR
) -> EditorFlowNode:
	set_slot(
		_slots,
		
		enabled, type, color,
		
		is_slot_enabled_right(_slots),
		get_slot_type_right(_slots),
		get_slot_color_right(_slots)
	)
	
	return self

## Edits the last used slot on the right.
func _edit_right_slot(
	enabled: bool, type: int = SlotType.NONE, color: Color = DEFAULT_COLOR
) -> EditorFlowNode:
	set_slot(
		_slots,
		
		is_slot_enabled_left(_slots),
		get_slot_type_left(_slots),
		get_slot_color_left(_slots),
		
		enabled, type, color,
	)
	
	return self

## Remove a slot and shift all applicable slots over. Generally should not be called
## by itself since the slots <-> item relationship will no longer be valid.
func _remove_slot(idx: int) -> EditorFlowNode:
	clear_slot(idx)
	
	# Shift all slots over by 1 index
	for i in range(idx + 1, _slots):
		set_slot(
			i - 1,
			is_slot_enabled_left(i), get_slot_type_left(i), get_slot_color_left(i),
			is_slot_enabled_right(i), get_slot_type_right(i), get_slot_color_right(i)
		)
		clear_slot(i)
	clear_slot(_slots)
	
	_slots -= 1
	
	return self

## Deletes an item from the current item and adjusts the slots automatically.
func _delete_item(item: NodeItem) -> void:
	_remove_slot(item.slot)
	for i in range(item.slot, get_child_count() - 1):
		get_child(i).slot = i - 1
	
	item.queue_free()

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Gets the node data contained by the node.
func get_data() -> Variant:
	return "not yet implemented"

## Get all valid actions for the node.
func get_actions() -> PackedStringArray:
	var r := PackedStringArray()
	
	r.push_back("not yet implemented")
	
	return r

func handle_action(action: String) -> void:
	pass
