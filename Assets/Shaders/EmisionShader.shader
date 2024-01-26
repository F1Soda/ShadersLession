Shader "ShaderLessions/EmisionShader"
{
    Properties
    {
        _MaskTex ("Mask texture", 2D) = "black" {}
        _MainTex ("Main texture", 2D) = "white" {}
        _EmissionMaskTex ("Mask texture", 2D) = "black" {}
        _EmissionColor ("Emission Color", Color) = (1,1,1,1)
    }
    
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D
            _MainTex,
            _MaskTex,
            _EmissionMaskTex;
        
        fixed3 _EmissionColor;
            
        struct Input
        {
            half2 uv_MaskTex;
            half2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed3 col = tex2D(_MainTex, IN.uv_MainTex);

            o.Albedo = col;
            fixed3 emTex = tex2D(_EmissionMaskTex, IN.uv_MaskTex);
            o.Emission = emTex.r * _EmissionColor;
        }
        ENDCG
    }
}