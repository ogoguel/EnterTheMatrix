// Copyright (c) Olivier Goguel 2021
// Licensed under the MIT License.


Shader "TriPlanarLight"
{

    Properties
    {
        _GridTex ("GridTex", 2D) = "white" {}

    }
    
    SubShader
    {
        LOD 100
        Blend One One
        ZWrite Off
        
        Pass
        {
            HLSLPROGRAM
            #pragma vertex   vert
            #pragma fragment frag

          
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            
            struct v2f
            {
                float4 vertex    : SV_POSITION;
                float3 worldPos  : TEXCOORD0;
                float3 normal    : NORMAL;
                float4 screenPosition : TEXCOORD2;
            };
     
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex    = TransformObjectToHClip(v.vertex);
                o.worldPos  = mul(unity_ObjectToWorld, v.vertex);
                o.normal    = TransformObjectToWorldNormal(v.normal);
                o.screenPosition = ComputeScreenPos(o.vertex);
                return o;
            }

            sampler2D _GridTex;
            #define sharpness 10.
                 
            real4 frag (v2f i) : SV_Target
            {

                real4 col      = real4(0.,0.,0.,1.);

                float2 front = i.worldPos.xy ;
                float2 side = i.worldPos.zy ;
                float2 top = i.worldPos.xz ;

                float3 colFront = tex2D(_GridTex,front);
                float3 colSide  = tex2D(_GridTex,side);
                float3 colTop   = tex2D(_GridTex,top);
  
                float3 blendWeight  = pow(normalize(abs(i.normal)), sharpness);
                blendWeight /= (blendWeight.x+ blendWeight.y+ blendWeight.z);

                col.xyz      = colFront*blendWeight.z + colSide*blendWeight.x + colTop*blendWeight.y ;
                return col ;
            }
            ENDHLSL
        }
    }
}