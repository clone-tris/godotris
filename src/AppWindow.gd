extends Node

## Godot window sizes are in physical pixels (Window.size is documented as "the
## window's physical size in pixels"), so handing it CANVAS_WIDTH/HEIGHT gives a
## window that shrinks as the display gets denser — on a 2x screen 384x480 pixels
## is only 192x240 points, which is unreadable. There is no project setting for a
## DPI-independent window size, so do what the docs prescribe for games: size the
## window in an autoload, and let the canvas_items stretch mode scale the 384x480
## canvas up to fill it.
##
## Godot's pixel space on macOS is the screen's points multiplied by the display
## scale, so multiplying the canvas by that scale is what makes 384x480 mean
## 384x480 points — the same apparent size c-tris gets from SDL, which sizes its
## window in points to begin with. Clamped to the usable area so a screen too
## small for the canvas still gets a window that fits on it.
func _ready() -> void:
  var window := get_window()
  window.size = windowSize()
  window.move_to_center()


static func windowSize() -> Vector2i:
  var canvas := Vector2(Config.CANVAS_WIDTH, Config.CANVAS_HEIGHT)
  var usable := Vector2(DisplayServer.screen_get_usable_rect(currentScreen()).size)

  return Vector2i((canvas * displayScale()).min(usable))


static func displayScale() -> float:
  # Reported for real on macOS, Android, iOS, Linux/Wayland and Web; elsewhere it
  # is always 1.0 and the screen DPI is the only hint at the display density.
  var scale := DisplayServer.screen_get_max_scale()
  if is_equal_approx(scale, 1.0):
    scale = maxf(1.0, roundf(DisplayServer.screen_get_dpi(currentScreen()) / 96.0))

  return scale


static func currentScreen() -> int:
  return DisplayServer.window_get_current_screen()
