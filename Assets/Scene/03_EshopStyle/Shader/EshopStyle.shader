Shader "Custom/SceneFade"
{
    Properties
    {
        _NoiseTex ("_NoiseTex", 2D) = "white" {}
        GRID_COUNT("GRID_COUNT",int)=6

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


            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = TransformObjectToHClip(v.vertex);
                o.uv = v.uv;
                return o;
            }
                const float GRID_COUNT = 2;

                const float T1 = PI;
                const float T2 = PI * 2.;
                const float T3 = PI * 3.;
                const float T4 = PI * 4.;
            float4 frag(VertexOutput i) : SV_Target
            {
                const float TOTAL_TIME = PI * 4.;
                const float3 C0 = float3(1., 0.4667, 0.);
                const float3 C1 = float3(1., 0.5882, 0.0784);
                const float3 C2 = float3(0.9686, 0.6980, 0.2314);
                const float3 C3 = float3(1., 0.8471, 0.3765);
                const float3 C4 = float3(1., 0.4667, 0.);
                float2 uv = i.pos / _ScreenParams.xy;
                uv.y = 1.0 - uv.y;
                uv.x = uv.x * 2.0 - 1.0;
                uv.x *= 0.9;

                float3 col = C0;
                float t = fmod(_Time.y * 2.5, TOTAL_TIME);
                float mask = 1.0;
                float h = 1.5;

                float offsety = floor(uv.y * GRID_COUNT) / GRID_COUNT;
                mask = 1.0 - step(-cos(clamp(t - offsety, 0., TOTAL_TIME)), uv.x);
                col = lerp(col, C1, mask);

                t += h;
                mask = step(-cos(clamp(t - offsety, T1, TOTAL_TIME)), uv.x) * step(T1, t);
                col = lerp(col, C2, mask);

                t += h;
                mask = (1.0 - step(-cos(clamp(t - offsety, T2, TOTAL_TIME)), uv.x)) * step(T2, t);
                col = lerp(col, C3, mask);

                t += h;
                mask = step(-cos(clamp(t - offsety, T3, TOTAL_TIME)), uv.x) * step(T3, t);
                col = lerp(col, C4, mask);

                float4 fragColor = float4(col, 1.0);
                return fragColor;
            }
            ENDHLSL

        }
    }
}