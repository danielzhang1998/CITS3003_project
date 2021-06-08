attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec3 normal;
varying vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;

varying vec3 fN;
varying vec3 fV;
varying vec3 Lvec1;
varying vec3 Lvec2;
varying vec3 Lvec3;

uniform vec4 LightPosition1;    //  the position of light1
uniform vec4 LightPosition2;    //  the position of light2
uniform vec4 LightPosition3;    //  the position of spotlight



void main() {

    fN = (ModelView*vec4(vNormal, 0.0)).xyz;
    fV = -(ModelView*vec4(vPosition, 1.0)).xyz;
    Lvec1 = LightPosition1.xyz-(ModelView*vec4(vPosition, 1.0)).xyz;
    Lvec2 = LightPosition2.xyz;
    Lvec3 = LightPosition3.xyz-(ModelView*vec4(vPosition, 1.0)).xyz;

    normal = vNormal;
    texCoord = vTexCoord;

    gl_Position = Projection * ModelView * vec4(vPosition, 1.0);
}


//  version for part F
/*
attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;


    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    //  part F
    //  with the distance between light source and object increase, idensity will decrease
    //  so if the light source close to the object, the object will be light.
    //  otherwise, it will be dark
    float a = 0.1;
    float b = 0.08;
    float c = 0.08;

    float distance_object_to_light = length(Lvec);

    float attenuation = 1.0/(a+b*distance_object_to_light+c*distance_object_to_light*distance_object_to_light);
    
    //  An error here, should not multiple attenuation with the ambient term
    color.rgb = globalAmbient  + ((ambient + diffuse + specular) * attenuation);
    color.a = 1.0;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
*/
