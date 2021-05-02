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

uniform vec4 LightPosition3;    //  the position of spotlight
uniform vec3 LightColor3;   //  the color of spotlight
uniform float LightBrightness3; //  the brightness of spotlight
uniform vec4 LightLoc3; //  location of the spotlight

void main() {
    vec3 pos = (ModelView * position).xyz;

    //  part I to add light 2
    //  part J light3 is spotlight

    // The vector to the light from the vertex
    vec3 Lvec1 = LightPosition1.xyz - pos;
    //  Vector to the light from the origin point
    vec3 Lvec2 = LightPosition2.xyz;
    
    vec3 Lvec3 = LightPosition3.xyz - pos;

    vec3 L1 = normalize( Lvec1 );   // Direction to the light source
    vec3 L2 = normalize( Lvec2 );   // Direction to the light source
    vec3 L3 = normalize( Lvec3 );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H1 = normalize( L1 + E );  // Halfway vector
    vec3 H2 = normalize( L2 + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz);

    vec3 reflectDir = reflect(-Lvec3,N);

    //  part H
    //  Click to know more from: https://en.wikipedia.org/wiki/Phong_reflection_model

    // Compute terms in the illumination equation
    vec3 ambient1 = (LightColor1 * LightBrightness1) * AmbientProduct;
    vec3 ambient2 = (LightColor2 * LightBrightness2) * AmbientProduct;
    vec3 ambient3 = (LightColor3 * LightBrightness3) * AmbientProduct;

    float Kd1 = max( dot(L1, N), 0.0);
    float Kd2 = max( dot(L2, N), 0.0);
    float Kd3 = max( dot(L3, N), 0.0);
    vec3 diffuse1 = Kd1 * (LightColor1 * LightBrightness1) * DiffuseProduct;
    vec3 diffuse2 = Kd2 * (LightColor2 * LightBrightness2) * DiffuseProduct;
    vec3 diffuse3 = Kd3 * (LightColor3 * LightBrightness3) * DiffuseProduct;

    //diffuse3 = clamp(diffuse3, 0.0, 1.0);

    float Ks1 = pow( max(dot(N, H1), 0.0), Shininess);
    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess);
    float Ks3 = pow( max(dot(reflectDir, Lvec3), 0.0),Shininess);
    vec3 specular1 = Ks1 * LightBrightness1 * SpecularProduct;
    vec3 specular2 = Ks2 * LightBrightness2 * SpecularProduct;
    vec3 specular3 = Ks3 * LightBrightness3 * SpecularProduct;


    float cutoff = 3.1415926/180.0*12.5;

    float theta = dot( L3, vec3(LightLoc3));

    specular3 = clamp(specular3, 0.0, 1.0);

    if (dot(L1, N) < 0.0 ) {
        specular1 = vec3(0.0, 0.0, 0.0);
    }
    if (dot(L2, N) < 0.0 ) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }
    if (dot(L3, N) < 0.0) {
        specular3 = vec3(0.0, 0.0, 0.0);
    }

    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    //  part F
    //  with the distance between light source and object increase, idensity will decrease
    //  so if the light source close to the object, the object will be light.
    //  otherwise, it will be dark
    
    float a = 0.03;
    float b = 0.027;
    float c = 0.0028;

    float distance_object_to_light = length(Lvec1);

    float attenuation = 1.0/(a+b*distance_object_to_light+c*(distance_object_to_light*distance_object_to_light));

    //  part I
    //  Phone reflection
    //if (theta > cutoff){
        color.rgb = globalAmbient  + ((ambient1 + diffuse1) * attenuation) + (ambient2 + diffuse2) + ambient3 + (diffuse3 * attenuation);
        color.a = 1.0;
        gl_FragColor = color * texture2D(texture, texCoord * 2.0) + vec4((specular1*attenuation) + (specular3*attenuation) + specular2, 1.0);
    
    //}
    /*
    else{
        color.rgb = globalAmbient  + ((ambient1 + diffuse1) * attenuation) + (ambient2 + diffuse2);
        color.a = 1.0;
        gl_FragColor = color * texture2D(texture, texCoord * 2.0) + vec4((specular1*attenuation) + specular2, 1.0);
    }
    */
}
