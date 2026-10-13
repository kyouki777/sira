shader_type canvas_item;

uniform vec2 mouse_position; 
uniform float circle_size : hint_range(0.01, 0.5) = 0.12; 
uniform float softness : hint_range(0.0, 0.5) = 0.15; 
uniform vec4 overlay_color : source_color = vec4(0.05, 0.05, 0.08, 0.98); 
uniform float aspect_ratio = 1.777777; 

// 0.0 = circle reveals everything normally
// 1.0 = view fully fades back into thick fog
uniform float fade_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 diff = SCREEN_UV - mouse_position;
    diff.x *= aspect_ratio;
    float dist = length(diff);
    
    // Smooth circle cutout (0 inside circle, 1 outside)
    float mask = smoothstep(circle_size - softness, circle_size, dist);

    // Blend the cutout back to solid fog based on fade_amount
    float final_mask = mix(mask, 1.0, fade_amount);

    COLOR = vec4(overlay_color.rgb, overlay_color.a * final_mask);
}