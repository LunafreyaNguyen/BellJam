shader_type canvas_item;
uniform float scrollSpeed;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 shifteduv = UV;
    shifteduv .y += TIME * scrollSpeed;
    vec4 color = texture(TEXTURE, shifteduv);
    COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
