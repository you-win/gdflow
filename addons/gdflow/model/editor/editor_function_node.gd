class_name EditorFunctionNode
extends EditorFlowNode

class Param extends NodeItem:
	var line_edit: LineEdit = null
	
	func _init(auto_name: String, slot: int) -> void:
		super._init("Param", slot)
		
		line_edit = LineEdit.new()
		_expand_control(line_edit)
		line_edit.text = auto_name
		
		_add_main_element(line_edit)
	
	func get_data() -> Variant:
		return line_edit.text

class Return extends NodeItem:
	const Options := {
		VOID = "void",
		STRING = "String",
		INTEGER = "int",
		FLOAT = "float",
		NODE = "Node",
		VARIANT = "Variant"
	}
	
	var option_button: OptionButton = null
	
	func _init() -> void:
		super._init("Return")
		
		option_button = OptionButton.new()
		_expand_control(option_button)
		for i in Options.values():
			option_button.add_item(i)
		
		option_button.select(Options.size() - 1)
		
		_add_main_element(option_button)
	
	func get_data() -> Variant:
		return option_button.get_item_text(self.selected)

class Name extends NodeItem:
	var line_edit: LineEdit = null
	
	func _init() -> void:
		super._init("Name")
		
		line_edit = LineEdit.new()
		_expand_control(line_edit)
		line_edit.text = "my_func"
		
		_add_main_element(line_edit)
	
	func get_data() -> Variant:
		return line_edit.text

class IfNode extends EditorFlowNode:
	pass

class WhileNode extends EditorFlowNode:
	pass

class ForNode extends EditorFlowNode:
	pass

class MatchNode extends EditorFlowNode:
	pass

class CallNode extends EditorFlowNode:
	var line_edit: LineEdit = null
	
	func _init() -> void:
		super._init("Call", Groups.FUNCTION)
		
		line_edit = LineEdit.new()
		line_edit.text = ""
		
		add_child(line_edit)

const Actions := {
	PARAM = "Param",
	RETURN = "Return",
	IF = "If",
	FOR = "For",
	WHILE = "While",
	MATCH = "Match",
	CALL = "Call"
}

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	super._init("Function", Groups.FUNCTION)
	
	add_child(Name.new())
	_slots += 1

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func get_data() -> Variant:
	# TODO stub
	return null

func get_actions() -> PackedStringArray:
	var r := PackedStringArray()
	
	for value in Actions.values():
		r.push_back(value)
	
	return r
	
func handle_action(action: String) -> void:
	match action:
		Actions.PARAM:
			var item := Param.new("param_%d" % get_child_count(), _slots)
			item.delete_pressed.connect(_delete_item)
			
			add_child(item)
			_add_right_slot(SlotType.PARAM, PARAM_COLOR)
		Actions.RETURN:
			var item := Return.new()
			item.delete_pressed.connect(func(_item) -> void:
				item.queue_free()
			)
			
			add_child(item)
		Actions.IF:
			pass
		Actions.FOR:
			pass
		Actions.WHILE:
			pass
		Actions.MATCH:
			pass
		Actions.CALL:
			pass
		_:
			print_debug("Unhandled action %s" % action)
