extends CanvasLayer

var mouseX;
var mouseY;

const HORIZONTAL_CENTER: int = 100;
const HORIZONTAL_BIAS: int = 39;
const MULTIPLIERS = [2, 4, 3];

const VERTICAL_CENTER: int = 67;
	
func almphy_cursor_position():
	$cursorhitbox.set_position(get_viewport().get_mouse_position());
	var temp = $cursorhitbox.get_overlapping_bodies()
	
	match str(temp):
		"[right:<StaticBody2D#26390561932>]":
			mouseX = get_viewport().get_mouse_position().x + -HORIZONTAL_CENTER;
			mouseX *= MULTIPLIERS[0];
			mouseY = get_viewport().get_mouse_position().y - VERTICAL_CENTER;
			mouseY *= MULTIPLIERS[1];
		_:
			mouseX = get_viewport().get_mouse_position().x + -HORIZONTAL_CENTER - HORIZONTAL_BIAS;
			mouseX *= MULTIPLIERS[0];
			mouseY = get_viewport().get_mouse_position().y - VERTICAL_CENTER;
			mouseY *= MULTIPLIERS[1];
		
	mouseX *= MULTIPLIERS[2];
	mouseY *= MULTIPLIERS[2];
	return(Vector2(mouseX, mouseY));
