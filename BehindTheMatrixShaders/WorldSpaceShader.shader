// Copyright (c) Olivier Goguel 2021
// Licensed under the MIT License.

Shader "WorldSpaceshader"
{
    Properties
    {
        _GridThickness ("Grid Thickness", Float) = 0.005
        _GridSpacing ("Grid Spacing", Float) = 0.5
        _GridColour ("Grid Colour", Color) = (0.5, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        LOD 100
         Cull Off
 
         Pass
         {
             HLSLPROGRAM
             #pragma vertex   vert
             #pragma fragment frag

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

        uniform float _GridThickness;
        uniform float _GridSpacing;
        uniform real4 _GridColour;


         real4 frag (v2f i) : SV_Target
         {
            float3 wp = i.worldPos;
            if (!(abs(frac(wp.x/_GridSpacing)) < _GridThickness || abs(frac(wp.y/_GridSpacing)) < _GridThickness || abs(frac(wp.z/_GridSpacing)) < _GridThickness) )
            {
                discard;
            }
            return _GridColour;
            
         }
         ENDHLSL
}


    }
}