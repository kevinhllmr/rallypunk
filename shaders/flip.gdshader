shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x, 1.0 - SCREEN_UV.y));
}