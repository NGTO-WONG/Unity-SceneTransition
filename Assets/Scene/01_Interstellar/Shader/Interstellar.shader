Shader "Custom/SceneFade"
{
    Properties
    {
        _NoiseTex ("_NoiseTex", 2D) = "white" {}
        _Value("_Value",range(18.62,31.6))=6

    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent" "RenderType"="Transparent" "RenderPipeline" = "UniversalPipeline"
        }
        LOD 100
        ZWrite Off 
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv:TEXCOORD0;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                //VertexInput
            };


            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float2 uv:TEXCOORD0;
                //VertexOutput
            };

            //Variables
            sampler2D _NoiseTex;
            float _Value;


            const float tau = 6.28318530717958647692;

            // Gamma correction
            #define GAMMA (2.2)

            float3 ToLinear(in float3 col)
            {
                // simulate a monitor, converting colour values into light values
                return pow(col, float3(GAMMA,GAMMA,GAMMA));
            }

            float3 ToGamma(in float3 col)
            {
                // convert back into colour values, so the correct light will come out of the monitor
                return pow(col, float3(1.0 / GAMMA, 1.0 / GAMMA, 1.0 / GAMMA));
            }

            float4 Noise(in float2 x)
            {
                return tex2D(_NoiseTex, (x + 0.5) / 256.0);
            }

            float4 Rand(in int x)
            {
                float2 uv;
                uv.x = (float(x) + 0.5) / 256.0;
                uv.y = (floor(uv.x) + 0.5) / 256.0;
                return tex2D(_NoiseTex, uv);
            }


            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = TransformObjectToHClip(v.vertex);
                o.uv = v.uv;
                //VertexFactory
                return o;
            }

            float4 frag(VertexOutput i) : SV_Target
            {
                float3 ray;
                ray.xy = 2.0 * (i.uv - 1 * .5) / 1;
                ray.z = 1.0;

                float offset = _Value * .5;
                float speed2 = (cos(offset) + 1.0) * 2.0;
                float speed = speed2 + .1;
                offset += sin(offset) * .96;
                offset *= 2.0;


                float3 col = float3(0, 0, 0);

                float3 stp = ray / max(abs(ray.x), abs(ray.y));

                float3 pos = 2.0 * stp + .5;
                for (int i = 0; i < 20; i++)
                {
                    float z = Noise(float2(pos.xy)).x;
                    z = frac(z - offset);
                    float d = 50.0 * z - pos.z;
                    float w = pow(max(0.0, 1.0 - 8.0 * length(frac(pos.xy) - .5)), 2.0);
                    float3 c = max(float3(0, 0, 0),float3(1.0 - abs(d + speed2 * .5) / speed, 1.0 - abs(d) / speed,
                                                          1.0 - abs(d - speed2 * .5) / speed));
                    col += 1.5 * (1.0 - z) * c * w;
                    pos += stp;
                }
                return float4(col,1);
            }
            ENDHLSL
         
        }
    }
}