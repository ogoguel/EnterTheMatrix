// Copyright (c) Olivier Goguel 2021
// Licensed under the MIT License.


#if !_XPAR_COMMON_
#define _XPAR_COMMON_

// Includes

    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

// Arkit

CBUFFER_START(UnityARFoundationPerFrame)
    float4x4 _UnityDisplayTransform;
    float _UnityCameraForwardScale;
CBUFFER_END

   #define ARKIT_TEXTURE2D_HALF(texture) TEXTURE2D(texture)
    #define ARKIT_SAMPLER_HALF(sampler) SAMPLER(sampler)
    #define ARKIT_TEXTURE2D_FLOAT(texture) TEXTURE2D(texture)
    #define ARKIT_SAMPLER_FLOAT(sampler) SAMPLER(sampler)
    #define ARKIT_SAMPLE_TEXTURE2D(texture,sampler,texcoord) SAMPLE_TEXTURE2D(texture,sampler,texcoord)

   sampler2D _CameraDepthTexture;
   float _Global_FloorY;

#if UNITY_EDITOR
    SamplerState sampler_EnvironmentDepth;
    sampler2D _EnvironmentDepth;
#else
     ARKIT_TEXTURE2D_FLOAT(_EnvironmentDepth);
     ARKIT_SAMPLER_FLOAT(sampler_EnvironmentDepth);
#endif
    
    ARKIT_TEXTURE2D_HALF(_HumanStencil);
    ARKIT_SAMPLER_HALF(sampler_HumanStencil);
    ARKIT_TEXTURE2D_FLOAT(_HumanDepth);
    ARKIT_SAMPLER_FLOAT(sampler_HumanDepth);

// helpers

inline float3 GetWorldPosFromUV(float2 uv, float depth)
{
    float4 ndc = float4(2.0 * uv - 1.0, 1, -1); 
    float4 viewDir = mul(unity_CameraInvProjection, ndc);
    #if UNITY_REVERSED_Z
        viewDir.z = -viewDir.z;
    #endif
    float3 viewPos = viewDir * LinearEyeDepth(depth,_ZBufferParams);
    float3 worldPos = mul(unity_CameraToWorld, float4(viewPos, 1)).xyz;
    return worldPos;
}

inline float ConvertDistanceToDepth(float d)
{       
    d = _UnityCameraForwardScale > 0.0 ? _UnityCameraForwardScale * d : d;
    return (d < _ProjectionParams.y) ? 0.0f : ((1.0f / _ZBufferParams.z) * ((1.0f / d) - _ZBufferParams.w));
}
    
inline float2 GetDistanceAndDepth(float4 screenPosition)
{
    float2 screenUV = screenPosition.xy / screenPosition.w; 
    float depthValue = tex2D(_CameraDepthTexture, screenUV).r;
    float distance = LinearEyeDepth(depthValue,_ZBufferParams);
    return float2(distance,depthValue);
}

inline float3 RotateAroundYInDegrees (float3 vertex, float degrees)
{
    float alpha = degrees * 3.14159265359 / 180.0;
    float sina, cosa;
    sincos(alpha, sina, cosa);
    float3x3 m = float3x3(cosa, 0, sina, 0, 1, 0, -sina, 0, cosa); 
    return mul(m, vertex);
}

#endif