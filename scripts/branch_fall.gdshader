
shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 0.8);

// Size of the clear center, as a fraction of the item's dimensions
uniform float ellipse_width : hint_range(0.01, 1.0) = 0.4;
uniform float ellipse_height : hint_range(0.01, 1.4) = 0.4;
uniform float edge_smoothing : hint_range(0.001, 0.5) = 0.12;
// 0 = hidden, 1 = fully visible
uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Center the coordinates: UV ranges from 0 to 1
    vec2 centered_uv = (UV - vec2(0.5)) * 2.0;

    // Scale coordinates to create an editable ellipse
    vec2 ellipse_uv = centered_uv / vec2(ellipse_width, ellipse_height);

    // Distance from the ellipse center
    float dist = length(ellipse_uv);

    // 0 inside the clear area, smoothly increasing to 1 outside
    float mask = smoothstep(
        1.0 - edge_smoothing,
        1.0 + edge_smoothing,
        dist
    );

    // Apply the overlay color and its alpha
    COLOR = vec4(color.rgb, color.a * mask * progress);
}
