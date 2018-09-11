include "../objects/hitbox"

class Leafgem::Hitbox
	# Macro to make it easier to check for the mouse
	macro mouse_in?
		point_in? Mouse.pos.x, Mouse.pos.y 
	end

	macro pressed?
		mouse_in? && Mouse.pressed?
	end

	macro held?
		mouse_in? && Mouse.held? 
	end
end