shader_type canvas_item;

uniform vec2 mouse_position;
uniform float circle_size : hint_range(0.01, 0.5) = 0.12;
uniform float softness : hint_range(0.0, 0.5) = 0.15;

uniform vec4 overlay_color : source_color = vec4(0.05, 0.05, 0.08, 0.98);

// Outline settings
uniform vec4 outline_color : source_color = vec4(1.0, 0.2, 0.1, 1.0);
uniform float outline_thickness : hint_range(0.001, 0.1) = 0.005;

uniform float aspect_ratio = 1.777777;

// 0.0 = circle reveals everything normally
// 1.0 = view fully fades back into thick fog
uniform float fade_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 diff = SCREEN_UV - mouse_position;
    diff.x *= aspect_ratio;

    float dist = length(diff);

    // Smooth circle cutout
    float mask = smoothstep(circle_size - softness, circle_size, dist);

    // Blend the cutout back to solid fog
    float final_mask = mix(mask, 1.0, fade_amount);

    // Outline mask
    float outline_outer = smoothstep(
        circle_size + outline_thickness,
        circle_size + outline_thickness + softness * 0.1,
        dist
    );

    float outline_inner = smoothstep(
        circle_size - outline_thickness,
        circle_size - outline_thickness + softness * 0.01,
        dist
    );

    float outline = outline_inner * (1.0 - outline_outer);

    // Apply fog
    vec4 final_color = vec4(
        overlay_color.rgb,
        overlay_color.a * final_mask
    );

    // Draw outline on top
    final_color.rgb = mix(final_color.rgb, outline_color.rgb, outline * outline_color.a);
    final_color.a = max(final_color.a, outline * outline_color.a);

    COLOR = final_color;
}