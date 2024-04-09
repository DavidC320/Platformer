shader_type canvas_item;
// inital code from https://youtu.be/sCZFttl8TZk?si=FRDJpc9doO28QCGG
// fix from https://forum.godotengine.org/t/shader-works-in-editor-but-not-in-runtime-why/15993

uniform vec4 origin_1:source_color;
uniform vec4 new_1:source_color;
uniform vec4 origin_2:source_color;
uniform vec4 new_2:source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 current_pixel = texture(TEXTURE, UV);
	
	if (distance(current_pixel, origin_1) <.01)
		COLOR = new_1;
	else if (distance(current_pixel, origin_2) <.01)
		COLOR = new_2;
	else
		COLOR = current_pixel;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
