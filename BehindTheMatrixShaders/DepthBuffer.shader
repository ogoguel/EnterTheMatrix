// Copyright (c) Olivier Goguel 2021
// Licensed under the MIT License.

Shader "DepthBuffer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
         Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
         LOD 100
         Cull Off
         ZWrite Off
 
         Pass
         {
             HLSLPROGRAM
             #pragma vertex   vert
             #pragma fragment frag
            #pragma multi_compile __ UNITY_EDITOR

             #include "XPARCommon.cginc"
             #include "PortalCommon.cginc"

             struct appdata
             {
                 float4 vertex : POSITION;
                 float2 uv     : TEXCOORD0;
                 float3 normal : NORMAL;
             };
             
             struct v2f
             {
                 float4 vertex    : SV_POSITION;
                 float3 worldPos  : TEXCOORD0;
                 float3 normal    : NORMAL;
                 float4 screenPos : TEXCOORD2;
             };
         
             v2f vert (appdata v)
             {
                 v2f o;
                 o.vertex    = TransformObjectToHClip(v.vertex);
                 o.worldPos  = mul(unity_ObjectToWorld, v.vertex);
                 o.normal    = TransformObjectToWorldNormal(v.normal);
                 o.screenPos = ComputeScreenPos(o.vertex);
                 return o;
             }
             
    
         real4 frag (v2f i) : SV_Target
         {

            float2 screenUV = i.screenPos.xy/ i.screenPos.w;
            float2 texcoord = mul(float3(screenUV, 1.0f), _UnityDisplayTransform).xy;
      
    #if UNITY_EDITOR
                float depthValue = tex2D(_EnvironmentDepth, texcoord).r;
    #else // UNITY_EDITOR
                float depthRawValue = ARKIT_SAMPLE_TEXTURE2D(_EnvironmentDepth, sampler_EnvironmentDepth, texcoord).r;
                float depthValue = ConvertDistanceToDepth(depthRawValue);
    #endif // UNITY_EDITOR

                float dc = depthValue*100;
                return real4(0,dc,0,1);

         }
         ENDHLSL
}


    }
}