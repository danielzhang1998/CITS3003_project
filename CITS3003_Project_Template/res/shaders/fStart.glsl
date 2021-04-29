vec4 color;
varying vec4 position;
varying vec3 normal;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform float Shininess;

uniform vec4 LightPosition1;    //  the position of light1
uniform vec3 LightColor1;   //  the color of light1
uniform float LightBrightness1; //  the brightness of light1

uniform vec4 LightPosition2;    //  the position of light2
uniform vec3 LightColor2;   //  the color of light2
uniform float LightBrightness2; //  the brightness of light2


void main() {
    vec3 pos = (ModelView * position).xyz;

    //  part I to add light 2

    // The vector to the light from the vertex
    vec3 Lvec1 = LightPosition1.xyz - pos;
    vec3 Lvec2 = LightPosition1.xyz - pos;

    vec3 L1 = normalize( Lvec1 );   // Direction to the light source
    vec3 L2 = normalize( Lvec2 );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H1 = normalize( L1 + E );  // Halfway vector
    vec3 H2 = normalize( L2 + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz);

    //  part H
    //  Click to know more from: https://en.wikipedia.org/wiki/Phong_reflection_model

    // Compute terms in the illumination equation
    vec3 ambient1 = (LightColor1 * LightBrightness1) * AmbientProduct;
    vec3 ambient2 = (LightColor2 * LightBrightness2) * AmbientProduct;

    float Kd1 = max( dot(L1, N), 0.0);
    float Kd2 = max( dot(L2, N), 0.0);
    vec3 diffuse1 = Kd1 * (LightColor1 * LightBrightness1) * DiffuseProduct;
    vec3 diffuse2 = Kd2 * (LightColor2 * LightBrightness2) * DiffuseProduct;

    float Ks1 = pow( max(dot(N, H1), 0.0), Shininess);
    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess);
    vec3 specular1 = Ks1 * LightBrightness1 * SpecularProduct;
    vec3 specular2 = Ks2 * LightBrightness2 * SpecularProduct;

    if (dot(L1, N) < 0.0 ) {
        specular1 = vec3(0.0, 0.0, 0.0);
    }
    if (dot(L2, N) < 0.0 ) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }

    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    //  part F
    //  with the distance between light source and object increase, idensity will decrease
    //  so if the light source close to the object, the object will be light.
    //  otherwise, it will be dark
    
    float a = 0.1;
    float b = 0.045;
    float c = 0.0075;

    float distance_object_to_light = length(Lvec1);

    float attenuation = 1.0/(a+b*distance_object_to_light+c*(distance_object_to_light*distance_object_to_light));

    //  part I
    //  Phone reflection
    color.rgb = globalAmbient  + ((ambient1 + diffuse1 + specular1) * attenuation) + (ambient2 + diffuse2 + specular2);
    color.a = 1.0;

    gl_FragColor = color * texture2D(texture, texCoord * 2.0);
}
