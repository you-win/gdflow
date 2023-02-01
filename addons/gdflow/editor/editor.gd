extends PanelContainer

const StartupScreen := preload("res://addons/gdflow/editor/startup.tscn")
const EditFlow := preload("res://addons/gdflow/editor/edit_flow.tscn")

const CloseIcon := preload("res://addons/gdflow/assets/Close.svg")

const FileOptions := {
	FileSection = {
		NEW_FLOW = {
			text = "New Flow",
			tooltip = "Create a new flow."
		},
		OPEN_FLOW = {
			text = "Open Flow",
			tooltip = "Open an existing flow."
		},
	},
	SaveSection = {
		SAVE = {
			text = "Save",
			tooltip = "Save the current flow."
		},
		SAVE_AS = {
			text = "Save As",
			tooltip = "Save the current flow and specify the file name."
		},
		SAVE_ALL = {
			text = "Save All",
			tooltip = "Save all open flows."
		},
	},
	CloseSection = {
		CLOSE = {
			text = "Close",
			tooltip = "Close the current flow."
		},
		CLOSE_ALL = {
			text = "Close All",
			tooltip = "Close all open flows."
		},
		CLOSE_OTHERS = {
			text = "Close Others",
			tooltip = "Close all open flows besides the current flow."
		}
	}
}

const EditOptions := {
	UndoRedoSection = {
		UNDO = {
			text = "Undo",
			tooltip = "Undo the last action."
		},
		REDO = {
			text = "Redo",
			tooltip = "Redo the last undone action."
		},
	},
	CutPasteSection = {
		CUT = {
			text = "Cut",
			tooltip = "Cut the selected item."
		},
		COPY = {
			text = "Copy",
			tooltip = "Copy the selected item."
		},
		PASTE = {
			text = "Paste",
			tooltip = "Paste the current cut/copied item."
		}
	}
}

const CompileOptions := {
	CompileSection = {
		COMPILE_CURRENT = {
			text = "Compile Current",
			tooltip = "Compile the current flow into GDScript."
		},
		COMPILE_ALL = {
			text = "Compile All",
			tooltip = "Compile all open flows into GDScript."
		},
		COMPILE_PROJECT = {
			text = "Compile Project",
			tooltip = "Compile all flows in the project into GDScript."
		}
	},
	CleanSection = {
		CLEAN_CURRENT = {
			text = "Clean Current",
			tooltip = "Remove the compiled GDScript for the current flow."
		},
		CLEAN_ALL = {
			text = "Clean All",
			tooltip = "Remove all compiled GDScript for all open flows."
		},
		CLEAN_PROJECT = {
			text = "Clean Project",
			tooltip = "Clean all compiled GDScript for all flows in the project."
		}
	}
}

const DEFAULT_FLOW_NAME := "New Flow"

var plugin: Node = null

@onready
var _flows := %Flows

var _undo_redo_popup: PopupMenu = null
var _undo_option_idx: int = -1
var _redo_option_idx: int = -1

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	_setup_menu_button(%File, FileOptions, func(idx: int, pm: PopupMenu) -> void:
		match pm.get_item_text(idx):
			FileOptions.FileSection.NEW_FLOW.text:
				_add_flow()
			FileOptions.FileSection.OPEN_FLOW.text:
				plugin.nyi()
			FileOptions.SaveSection.SAVE.text:
				plugin.nyi()
			FileOptions.SaveSection.SAVE_AS.text:
				plugin.nyi()
			FileOptions.SaveSection.SAVE_ALL.text:
				plugin.nyi()
			FileOptions.CloseSection.CLOSE.text:
				plugin.nyi()
			FileOptions.CloseSection.CLOSE_ALL.text:
				plugin.nyi()
			FileOptions.CloseSection.CLOSE_OTHERS.text:
				plugin.nyi()
	)
	_setup_menu_button(%Edit, EditOptions, func(idx: int, pm: PopupMenu) -> void:
		match pm.get_item_text(idx):
			EditOptions.UndoRedoSection.UNDO.text:
				plugin.nyi()
			EditOptions.UndoRedoSection.REDO.text:
				plugin.nyi()
			EditOptions.CutPasteSection.CUT.text:
				plugin.nyi()
			EditOptions.CutPasteSection.COPY.text:
				plugin.nyi()
			EditOptions.CutPasteSection.PASTE.text:
				plugin.nyi()
	)
	_setup_menu_button(%Compile, CompileOptions, func(idx: int, pm: PopupMenu) -> void:
		match pm.get_item_text(idx):
			CompileOptions.CompileSection.COMPILE_CURRENT.text:
				plugin.nyi()
			CompileOptions.CompileSection.COMPILE_ALL.text:
				plugin.nyi()
			CompileOptions.CompileSection.COMPILE_PROJECT.text:
				plugin.nyi()
			CompileOptions.CleanSection.CLEAN_CURRENT.text:
				plugin.nyi()
			CompileOptions.CleanSection.CLEAN_ALL.text:
				plugin.nyi()
			CompileOptions.CleanSection.CLEAN_PROJECT.text:
				plugin.nyi()
	)
	
	# Search for the undo/redo options. A bit inefficient but it keeps the setup
	# function clean.
	_undo_redo_popup = %Edit.get_popup()
	for i in _undo_redo_popup.item_count:
		match _undo_redo_popup.get_item_text(i):
			EditOptions.UndoRedoSection.UNDO.text:
				_undo_option_idx = i
			EditOptions.UndoRedoSection.REDO.text:
				_redo_option_idx = i
		
		if _undo_option_idx > -1 and _redo_option_idx > -1:
			break
	
	var remove_tab := func(tab: int) -> void:
		# TODO check if anything should be saved before closing the tab
		_flows.get_tab_control(tab).queue_free()
	_flows.tab_button_pressed.connect(remove_tab)
	_flows.tab_changed.connect(func(tab: int) -> void:
		_flows.set_tab_button_icon(_flows.get_previous_tab(), null)
		_flows.set_tab_button_icon(tab, CloseIcon)
	)
	var tab_bar: TabBar = _flows.get_child(0, true)
	tab_bar.gui_input.connect(func(event: InputEvent) -> void:
		if (
			not event is InputEventMouseButton or
			not event.pressed or
			not event.button_index == MOUSE_BUTTON_MIDDLE
		):
			return
		
		remove_tab.call(tab_bar.get_tab_idx_at_point(event.position))
	)
	
	# TODO try to load last editor state beforehand, otherwise load the startup screen
	var startup_screen := StartupScreen.instantiate()
	plugin.inject_tool(startup_screen)
	_flows.add_child(startup_screen)
	startup_screen.new_flow.pressed.connect(func() -> void:
		_add_flow()
	)
	startup_screen.open_flow.pressed.connect(func() -> void:
		plugin.nyi()
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

## Populates a [code]MenuButton[/code] with items and tooltips.
static func _setup_menu_button(mb: MenuButton, data: Dictionary, callback: Callable) -> void:
	var popup := mb.get_popup()
	
	var expected_len := data.size()
	var actual_len: int = 0
	
	for section in data.values():
		actual_len += 1
		for item in section.values():
			popup.add_item(item.text)
			popup.set_item_tooltip(popup.item_count - 1, item.tooltip)
		
		if actual_len != expected_len:
			popup.add_separator()
	
	popup.index_pressed.connect(callback.bind(popup))

func _add_flow(data: GDFlowResource = null) -> void:
	var flow := EditFlow.instantiate()
	plugin.inject_tool(flow)
	
	_flows.add_child(flow)
	_flows.current_tab = _flows.get_tab_count() - 1
	_flows.set_tab_title(_flows.current_tab, data.name if data != null else DEFAULT_FLOW_NAME)

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#
