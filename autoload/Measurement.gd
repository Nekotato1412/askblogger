extends Node
signal root_font_size_changed

# Semi-constant variables
var _root_font_size:float = 16.0 setget set_root_font_size, get_root_font_size

var _root_height_px:int = 480 setget set_root_height, get_root_height

# Setters & Getters

func set_root_font_size(size: float):
	if (size == _root_font_size): return
	_root_font_size = size
	emit_signal("root_font_size_changed", size)

func get_root_font_size() -> float:
	return _root_font_size
	

func set_root_height(height_px: int):
	_root_height_px = height_px

func get_root_height() -> int:
	return _root_height_px

# Conversion Functions


## Returns the REM measurement of px
## @tutorial: https://www.w3schools.com/cssref/css_units.php
func rem(px: float) -> float:
	return px / _root_font_size

## Returns the EM measurement of px
## @info: https://www.w3schools.com/cssref/css_units.php
func em(parent_size: float, px: float) -> float:
	return px / parent_size

## Returns the pM(Portrait Meters) measurement of px
## pM is used to measure portrait height assuming half the room size is 5ft as a baseline.
func pm(px: float) -> float:
	return px / ((float(_root_height_px) / 2) / 5)

## Returns the px measurement of REM
## @info: https://www.w3schools.com/cssref/css_units.php
func rem_to_px(rem: float) -> float:
	return _root_font_size / rem

## Returns the px measurement of REM
## @info: https://www.w3schools.com/cssref/css_units.php
func em_to_px(parent_size: float, em: float) -> float:
	return parent_size / em

## Returns the px measurement of pM
## pM is used to measure portrait height in terms of feet assuming half the room size is 5ft.
func pm_to_px(pm: float) -> float:
	return pm * ((float(_root_height_px) / 2) / 5)
