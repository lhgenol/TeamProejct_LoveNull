// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/SceneBendReplacementWithColor"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }  // Default Material은 보통 Opaque임
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            // 예시: z에 따라 x축 이동량을 2차 함수로 계산
            // f(z) = 0.2 * z - 0.0175 * z^2
            float2 BendFunction(float z)
            {
                float shiftX = 0.2 * z - 0.0175 * (z * z);
                return float2(shiftX, 0);
            }

            v2f vert(appdata v)
            {
                v2f o;
                // 로컬 좌표를 월드 좌표로 변환
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                // z값에 따라 x축 변위를 계산하여 적용
                float2 shift = BendFunction(worldPos.z);
                worldPos.x += shift.x;

                // 월드 좌표를 클립 공간으로 변환
                o.vertex = mul(UNITY_MATRIX_VP, float4(worldPos, 1.0));
                // uv 좌표는 원래 텍스처 샘플링에 사용
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // 원래 머티리얼의 _MainTex와 _Color를 그대로 사용
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col;
            }
            ENDCG
        }
    }
}


// // Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader "Custom/SceneBendReplacement"
// {
//     // 필요하다면 Properties를 더 넣어도 됨
//     Properties
//     {
//         _Color("Color Tint", Color) = (1,1,1,1)
//     }

//     SubShader
//     {
//         Tags{"RenderType"="Opaque"}  // 불투명용
//         Pass
//         {
//             CGPROGRAM
//             #pragma vertex vert
//             #pragma fragment frag
//             #include "UnityCG.cginc"

//             struct appdata
//             {
//                 float4 vertex : POSITION;
//             };

//             struct v2f
//             {
//                 float4 vertex : SV_POSITION;
//             };

//             // 2차 함수로 계산
//             // f(z) = 0.2z - 0.0175z^2
//             float2 BendFunction(float z)
//             {
//                 float shiftX = 0.2 * z - 0.0175 * (z * z);
//                 return float2(shiftX, 0); // x만 이동
//             }

//             v2f vert(appdata v)
//             {
//                 v2f o;
//                 // (1) 로컬 -> 월드
//                 float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

//                 // (2) z값에 따라 x축 이동량 계산
//                 float2 shift = BendFunction(worldPos.z);
//                 worldPos.x += shift.x;

//                 // (3) 월드 -> 클립
//                 o.vertex = mul(UNITY_MATRIX_VP, float4(worldPos, 1.0));
//                 return o;
//             }

//             fixed4 frag(v2f i) : SV_Target
//             {
//                 // 여기서는 단색으로만 표시.
//                 // 원래 텍스처를 살리고 싶다면 _MainTex 등을 샘플링해야 함.
//                 return fixed4(1,1,1,1);
//             }
//             ENDCG
//         }
//     }
// }
