Shader "Custom/CircleZoom"
{
    Properties
    {
        _MainTex ("_MainTex", 2D) = "white" {}
        _Value("_Value",range(0,2))=1
        _Center("_Center",vector)=(1,1,1,1)

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

            float _Value;
            float4 _Center;


            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = TransformObjectToHClip(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag(VertexOutput i) : SV_Target
            {
                float2 center;
                center.x = -_Center.x * _ScreenParams.x + _ScreenParams.x / 2;
                center.y = _Center.y * _ScreenParams.y - _ScreenParams.y / 2;

                float distanceToCenter = distance(i.pos + center, _ScreenParams.xy / float2(2, 2));


                // White background
                float4 outputColor = float4(0, 0, 0, 1);


                if (distanceToCenter <= _Value * _ScreenParams.x)
                {
                    outputColor = 0;
                }


                // Output to screen
                float4 fragColor = float4(outputColor);
                return fragColor;
            }
            ENDHLSL

        }
    }
}