// Copyright (c) Olivier Goguel 2021
// Licensed under the MIT License.


Shader "TriPlanar"
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

            #pragma multi_compile DEVICE UNITY_EDITOR
            #pragma multi_compile __ SHOW_MASK
            #pragma multi_compile_local __ PORTALDEBUG
            #pragma multi_compile_local PORTALDOOR PORTALWALL PORTALDISABLED PORTALFORCED
        
            #include "XPARCommon.cginc"
            #include "PortalCommon.cginc"

            
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
                 
            real4 frag (v2f i) : SV_Target
            {

                // Never  write over humans
                float2 screenUV = i.screenPosition.xy/ i.screenPosition.w;
                float2 texcoord = mul(float3(screenUV, 1.0f), _UnityDisplayTransform).xy;
                if (ARKIT_SAMPLE_TEXTURE2D(_HumanStencil, sampler_HumanStencil, texcoord).r > 0.5h)
                    discard;      

                float2 distAndDepth = GetDistanceAndDepth(i.screenPosition);
                float depth = distAndDepth.y;
                float distance = distAndDepth.x;

                sampler2D tex = _GridTex;

#if PORTALDOOR || PORTALWALL || PORTALDEBUG || PORTALDISABLED || PORTALFORCED

    #if PORTALWALL
                real4 portalColor = tex2D(_PortalAll, screenUV);
    #else
                real4 portalColor = tex2D(_Portal, screenUV);
    #endif
    #if PORTALDEBUG
                return real4(portalColor.xyz*100,1);
    #endif

                float portalDepth = portalColor.r;
                if (IsObfuscatedByPortal(portalDepth,depth))
               { 
                   discard;
                }
#endif // PORTALDOOR || PORTALWALL

                real4 col      = real4(0.,0.,0.,1.);

                float3 w = RotateAroundYInDegrees(i.worldPos,_World_Angle);


                float2 front = i.worldPos.xy ;
                float2 side = i.worldPos.zy ;
                float2 top = w.xz + sin(i.worldPos.yy);

                float3 colFront = tex2D(_GridTex,front);
                float3 colSide  = tex2D(_GridTex,side);
                float3 colTop   = tex2D(_GridTex,top);
  
                float3 blendWeight  = pow(normalize(abs(i.normal)), sharpness);
                blendWeight /= (blendWeight.x+ blendWeight.y+ blendWeight.z);

                col.xyz      = colFront * blendWeight.z* _ColorMask.z + 
                colSide  * blendWeight.x * _ColorMask.x + 
                colTop   * blendWeight.y * _ColorMask.y;

             
                return col ;
            }
            ENDHLSL
        }
    }
}