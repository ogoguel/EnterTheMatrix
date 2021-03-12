
// Copyright (c) Olivier Goguel 2021
// Licensed under the MIT License.

#if !_MATRIX_COMMON_
#define _MATRIX_COMMON_


// Usual shader parameters

    sampler2D _MainTex;
    sampler2D _Portal;
    sampler2D _PortalAll;
    float _World_Angle;
    
    uint _session_rand_seed; // required by the RandomLi Include
    #define rnd(seed, constant)  wang_rnd(seed +triple32(_session_rand_seed) * constant)


    #define sharpness 10.

inline bool IsObfuscatedByPortal(float _portalDepth, float _depth)
{
    #if PORTALDISABLED
        return true;
    #endif

    #if PORTALFORCED
        return false;
    #endif

    #if PORTALDOOR
     if (_portalDepth !=0 &&  _portalDepth >= _depth  )
            return false;
     else
            return true;
    #else // PORTALDOOR
        #if PORTALWALL
            if (_portalDepth ==0 )
                return false;
            if (_depth >=  _portalDepth)
                return false;
            return true;
        #else // !PORTALWALL
            return false;
        #endif // PORTALWALL
     #endif // PORTALDOOR
  
}

inline bool IsObjectObfuscatedByPortal(float _portalDepth, float _depth, float _objDepth)
{
    #if PORTALDISABLED
        return true;
    #endif

    #if PORTALFORCED
        return false;
    #endif

    #if PORTALDOOR
        
        if (_portalDepth !=0 &&  _portalDepth >= _depth  )
                return false;
          
         if (_portalDepth == 0)
                 return true;
         return true;
    #else // PORTALDOOR
        #if PORTALWALL
            if (_portalDepth ==0 )
                return false;
            if (_depth >=  _portalDepth)
                return false;
            if (_objDepth >= _portalDepth)
                return false;
            return true;
        #else // !PORTALWALL
            return false;
        #endif // PORTALWALL
     #endif // PORTALDOOR
  
}


#endif