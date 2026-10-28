// PROCEDURAL GINGERBREAD FACE
//
// Three qualitative parameters on top of the base face, all in [0, 1]:
//   SURPRISE  - eyes open wide, brows shoot up, mouth drops into an O
//   SMUGNESS  - one brow cocked, squinting eyes, lopsided smirk, chin up
//   SADNESS   - brows knit upward, droopy eyes, frown, tears, head hangs
// Set ANIMATE to 0 and edit the constants in faceSDF to play with them.
#define ANIMATE 1

// ---- small helpers -------------------------------------------------------

vec3 rotX(vec3 p, float a)
{
    float c = cos(a), s = sin(a);
    return vec3(p.x, c * p.y - s * p.z, s * p.y + c * p.z);
}

vec3 rotZ(vec3 p, float a)
{
    float c = cos(a), s = sin(a);
    return vec3(c * p.x - s * p.y, s * p.x + c * p.y, p.z);
}

// ellipsoid, iq's bound version
float ellipsoidSDF(vec3 p, vec3 c, vec3 r)
{
    vec3 q = p - c;
    float k0 = length(q / r);
    float k1 = length(q / (r * r));
    return k0 * (k0 - 1.0) / k1;
}

// z on the surface of the head (radius 2, centred at (0,1,0)) for a given x, y
float headZ(vec2 xy)
{
    vec2 d = xy - vec2(0.0, 1.0);
    return sqrt(max(0.0, 4.0 - dot(d, d)));
}

// ring in the xy plane that hugs the head: depth is measured from the local
// head surface instead of a flat z, so the whole ring stays on the face
float ringOnHeadSDF(vec3 p, vec2 c, float R, float r)
{
    vec2 d = vec2(length(p.xy - c) - R, p.z - headZ(p.xy));
    return length(d) - r;
}


// ---- the face ------------------------------------------------------------

float faceSDF(vec3 queryPos)
{
    // Procedural Face Attributes
    // These should all be values [0, 1]
    float EYE_SEPARATION = 0.5;
    float SURPRISE = 0.0;
    float SMUGNESS = 0.0;
    float SADNESS  = 0.0;

#if ANIMATE
    // cycle through the three parameters, 4 seconds each
    float cyc = mod(iTime, 12.0);
    float wave = 0.5 - 0.5 * cos(cyc * 3.14159 * 0.5);
    SURPRISE = cyc < 4.0 ? wave : 0.0;
    SMUGNESS = (cyc >= 4.0 && cyc < 8.0) ? wave : 0.0;
    SADNESS  = cyc >= 8.0 ? wave : 0.0;
#endif

    // Head tilt. The head is a sphere around (0,1,0), so only the features
    // move: sad hangs the head forward, smug lifts the chin and cocks it.
    vec3 p = queryPos - vec3(0.0, 1.0, 0.0);
    p = rotX(p, 0.22 * SMUGNESS - 0.16 * SADNESS);
    p = rotZ(p, 0.12 * SMUGNESS);
    p += vec3(0.0, 1.0, 0.0);

    float ball = sphereSDF(p, vec3(0.0, 1.0, 0.0), 2.0);

    // ---- eyes
    // surprise: bigger and a little higher. sad: smaller and lower.
    // smug: squashed vertically into a squint.
    float eyePosition = mix(0.5, 0.9, EYE_SEPARATION);
    float eyeR = 0.3 + 0.17 * SURPRISE - 0.06 * SADNESS;
    float eyeY = 0.9 + 0.10 * SURPRISE - 0.12 * SADNESS;
    vec3  eyeScale = vec3(1.0 + 0.15 * SMUGNESS, 1.0 - 0.6 * SMUGNESS, 1.0);
    vec3  eyeLPos = vec3(-eyePosition, eyeY, headZ(vec2(-eyePosition, eyeY)) + 0.13);
    vec3  eyeRPos = vec3( eyePosition, eyeY, headZ(vec2( eyePosition, eyeY)) + 0.13);
    float eyeLeft  = ellipsoidSDF(p, eyeLPos, eyeR * eyeScale);
    float eyeRight = ellipsoidSDF(p, eyeRPos, eyeR * eyeScale);

    // ---- eyebrows
    // inner end at x = +-0.5, outer end at x = +-0.9, resting height 1.5.
    // surprise: both lift and arch. sad: inner ends up, outer ends down.
    // smug: one brow cocked way up, the other pressed down.
    float browLift = 0.35 * SURPRISE;
    float innerY = 1.5 + browLift + 0.25 * SADNESS;
    float outerY = 1.5 + browLift + 0.22 * SURPRISE - 0.20 * SADNESS;
    float browR  = 0.1 + 0.03 * SURPRISE;
    float cockL  =  0.30 * SMUGNESS;
    float cockR  = -0.12 * SMUGNESS;
    vec2 bLi = vec2(-0.5, innerY + cockL);
    vec2 bLo = vec2(-0.9, outerY + cockL * 1.3);
    vec2 bRi = vec2( 0.5, innerY + cockR);
    vec2 bRo = vec2( 0.9, outerY + cockR * 0.5);
    float eyeBrowLeft  = capsuleSDF(p, vec3(bLi, headZ(bLi) + 0.12), vec3(bLo, headZ(bLo) + 0.12), browR);
    float eyeBrowRight = capsuleSDF(p, vec3(bRi, headZ(bRi) + 0.12), vec3(bRo, headZ(bRo) + 0.12), browR);

    // ---- mouth
    // the base mouth is a sphere carved out of the head. surprise: bigger,
    // lower and deeper (an O). sad: shrinks to a little hole and the corners
    // pull down into a frown. smug: slides to one side and flattens into a
    // tilted smirk.
    float mouthY = -0.2 - 0.08 * SURPRISE + 0.25 * SADNESS + 0.10 * SMUGNESS;
    float mouthX = 0.35 * SMUGNESS;
    float mouthR = max(0.5 + 0.25 * SURPRISE - 0.5 * SADNESS, 0.02);
    vec3  mouthScale = vec3(1.0 + 0.5 * SMUGNESS, 1.0 - 0.55 * SMUGNESS, 1.0 + 0.2 * SURPRISE);
    vec3  mouthC = vec3(mouthX, mouthY, headZ(vec2(mouthX, mouthY)) - 0.10 - 0.10 * SURPRISE);
    vec3  mp = mouthC + rotZ(p - mouthC, -0.35 * SMUGNESS);
    float mouthBase = ellipsoidSDF(mp, mouthC, mouthR * mouthScale);

    // frown: the upper arc of a ring carved into the face as a groove. the
    // ring is centred below the mouth so the corners curve down.
    vec2  fC = vec2(0.0, mouthY - 0.45);
    float frownArc = ringOnHeadSDF(p, fC, 0.6, 0.13 * SADNESS);
    float frown = max(frownArc, (fC.y + 0.25) - p.y);

    // tears, once the face is sad enough they slide down the cheeks
    float tearT = smoothstep(0.3, 1.0, SADNESS);
    float tearY = eyeY - eyeR - 0.06 - 0.18 * tearT;
    vec3  tearR = vec3(0.09, 0.15, 0.08) * max(tearT, 0.001);
    vec2  tL = vec2(-eyePosition - 0.05, tearY);
    vec2  tR = vec2( eyePosition + 0.05, tearY);
    float tears = min(ellipsoidSDF(p, vec3(tL, headZ(tL) + 0.04), tearR),
                      ellipsoidSDF(p, vec3(tR, headZ(tR) + 0.04), tearR));

    // ---- put it together
    float eyes = smoothUnion(eyeRight, eyeLeft, 0.1);
    float eyebrows = smoothUnion(eyeBrowLeft, eyeBrowRight, 0.1);
    float eyeStuff = smoothUnion(eyes, eyebrows, 0.0);
    float mouth = (SADNESS > 0.001) ? smoothUnion(mouthBase, frown, 0.1) : mouthBase;
    float faceBase = smoothSubtraction(mouth, ball, 0.05);
    float face = smoothUnion(faceBase, eyeStuff, 0.1);
    if (tearT > 0.0) face = smoothUnion(face, tears, 0.05);
    return face;
}


float sceneSDF(vec3 queryPos)
{
    return faceSDF(queryPos);
}


Ray getRay(vec2 uv) {
    Ray ray;
    
    float len = tan(3.14159 * 0.125) * distance(EYE, REF);
    vec3 H = normalize(cross(vec3(0.0, 1.0, 0.0), REF - EYE));
    vec3 V = normalize(cross(H, EYE - REF));
    V *= len;
    H *= len * iResolution.x / iResolution.y;
    vec3 p = REF + uv.x * H + uv.y * V;
    vec3 dir = normalize(p - EYE);
    
    ray.origin = EYE;
    ray.direction = dir;
    return ray;
}

Intersection getRaymarchedIntersection(vec2 uv)
{
    Ray ray = getRay(uv);
    Intersection intersection;
    
    vec3 queryPoint = ray.origin;
    for (int i=0; i < MAX_RAY_STEPS; ++i)
    {
        float distanceToSurface = sceneSDF(queryPoint);
        
        if (distanceToSurface < EPSILON)
        {
            
            intersection.position = queryPoint;
            intersection.normal = vec3(0.0, 0.0, 1.0);
            intersection.distance = length(queryPoint - ray.origin);
            
            return intersection;
        }
        
        queryPoint = queryPoint + ray.direction * distanceToSurface;
    }
    
    intersection.distance = -1.0;
    return intersection;
}


vec3 estimateNormal(vec3 p) {
    return normalize(vec3(
        sceneSDF(vec3(p.x + EPSILON, p.y, p.z)) - sceneSDF(vec3(p.x - EPSILON, p.y, p.z)),
        sceneSDF(vec3(p.x, p.y + EPSILON, p.z)) - sceneSDF(vec3(p.x, p.y - EPSILON, p.z)),
        sceneSDF(vec3(p.x, p.y, p.z + EPSILON)) - sceneSDF(vec3(p.x, p.y, p.z - EPSILON))
    ));
}

vec3 getSceneColor(vec2 uv)
{
    Intersection intersection = getRaymarchedIntersection(uv);
    
    DirectionalLight lights[3];
    vec3 backgroundColor = vec3(0.);
    
    
    lights[0] = DirectionalLight(normalize(vec3(10.0, 10.0, 15.0)),
                                 SUN_KEY_LIGHT);
    lights[1] = DirectionalLight(vec3(0., 1., 0.),
                                 SKY_FILL_LIGHT);
    lights[2] = DirectionalLight(normalize(-vec3(15.0, 0.0, 10.0)),
                                 SUN_AMBIENT_LIGHT);
    backgroundColor = SUN_KEY_LIGHT;
    
    vec3 albedo = vec3(0.5);
    vec3 n = estimateNormal(intersection.position);
        
    vec3 color = albedo *
                 lights[0].color *
                 max(0.0, dot(n, lights[0].dir));
    
    if (intersection.distance > 0.0)
    { 
        for(int i = 1; i < 3; ++i) {
            color += albedo *
                     lights[i].color *
                     max(0.0, dot(n, lights[i].dir));
        }
    }
    else
    {
        color = vec3(0.5, 0.7, 0.9);
    }
        color = pow(color, vec3(1. / 2.2));
        return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    // Make symmetric [-1, 1]
    uv = uv * 2.0 - 1.0;

    // Time varying pixel color
    vec3 col = getSceneColor(uv);

    // Output to screen
    fragColor = vec4(col,1.0);
}
