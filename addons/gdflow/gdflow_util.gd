class_name GDFlowUtil
extends Object

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	pass

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

static func uuid() -> int:
	var current_time_mil := int(Time.get_unix_time_from_system())
	var time_low := (current_time_mil & 0x0000_0000_FFFF_FFFF) << 32
	var time_mid := ((current_time_mil >> 32) & 0xFFFF) << 16
	var version := 1 << 12
	var time_hi = ((current_time_mil >> 48) & 0x0FFF)
	
	return time_low | time_mid | version | time_hi

static func editor_manager() -> GDFlowEditorManager:
	return Engine.get_main_loop().root.get_node("/root/GDFlowEditorManager")
