shader_type canvas_item;

// Suction control parameters
uniform float suction_intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec2 suction_center = vec2(0.5, 0.5);
uniform float max_blur_radius : hint_range(0.0, 0.2) = 0.08;
uniform float time : hint_range(0.0, 10.0) = 0.0;

// Visual effect parameters
uniform vec4 suction_color : source_color = vec4(0.3, 0.5, 1.0, 0.3);
uniform float pulse_speed : hint_range(0.0, 5.0) = 2.0;
uniform float ring_count : hint_range(1.0, 10.0) = 3.0;

void fragment() {
    vec2 center = suction_center;
    vec2 dir = UV - center;
    float distance_from_center = length(dir);
    
    // Pulsing effect for active suction
    float pulse = 0.8 + 0.2 * sin(time * pulse_speed);
    float active_intensity = suction_intensity * pulse;
    
    // Calculate blur amount - stronger near center
    float blur_amount = active_intensity * (1.0 - smoothstep(0.0, 0.4, distance_from_center)) * max_blur_radius;
    
    // Radial blur toward center
    int samples = 8;
    vec4 final_color = vec4(0.0);
    float total_weight = 0.0;
    
    for (int i = 0; i < samples; i++) {
        float t = float(i) / float(samples - 1);
        
        // Sample along direction toward center (negative dir)
        vec2 sample_uv = UV - dir * blur_amount * t;
        vec4 sample_color = texture(TEXTURE, sample_uv);
        
        // Weight samples (center samples contribute more)
        float weight = 1.0 - abs(t - 0.5) * 2.0;
        final_color += sample_color * weight;
        total_weight += weight;
    }
    
    final_color /= total_weight;
    
    // Add suction color overlay
    float color_influence = active_intensity * (1.0 - smoothstep(0.0, 0.3, distance_from_center));
    final_color = mix(final_color, suction_color, color_influence * suction_color.a);
    
    // Add energy rings
    float ring_pattern = sin(distance_from_center * ring_count * 6.283 - time * 3.0) * 0.5 + 0.5;
    float ring_visibility = active_intensity * (1.0 - smoothstep(0.1, 0.4, distance_from_center));
    float ring_effect = ring_pattern * ring_visibility * 0.3;
    
    final_color.rgb += vec3(ring_effect * suction_color.rgb);
    
    // Brighten center for energy effect
    float center_glow = active_intensity * (1.0 - smoothstep(0.0, 0.2, distance_from_center)) * 0.5;
    final_color.rgb += vec3(center_glow);
    
    COLOR = final_color;
}