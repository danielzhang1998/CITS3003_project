vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 dir_light;
varying vec3 dir_eye;

uniform sampler2D texture;

uniform vec3 LightColor1;
uniform float LightBrightness1;
uniform vec4 LightPosition1;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess;
//uniform vec3 Lvec;
uniform vec3 pos;

void main()
{
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition1.xyz - pos;
    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( dir_eye );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( dir_light );

    // Compute terms in the illumination equation
    vec3 ambient = (LightColor1 * LightBrightness1) * AmbientProduct;

    float Kd1 = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd1 * (LightColor1*LightBrightness1) * DiffuseProduct;

    float Ks1 = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks1 * LightBrightness1 * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    //  part F
    //  with the distance between light source and object increase, idensity will decrease
    //  so if the light source close to the object, the object will be light.
    //  otherwise, it will be dark
    
    float a = 0.01;
    float b = 0.03;
    float c = 0.08;

    float distance_object_to_light = length(Lvec);

    float attenuation = 1.0/(a+b*distance_object_to_light+c*distance_object_to_light*distance_object_to_light);

    color.rgb = globalAmbient  + ((ambient + diffuse + specular) * attenuation);
    color.a = 1.0;

    gl_FragColor = color * texture2D( texture, texCoord * 2.0 );
}
