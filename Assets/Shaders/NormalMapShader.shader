Shader "ShaderLessions/NormalMapShader"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}
        _BumpMap ("Normal map", 2D) = "bump" {}
        
        _Shiness ("Shiness", Range(0,1)) = 0.07
        _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1.0)
        _Gloss ("Specular intensity", Float) = 0.5 
    }

    SubShader
    {
        CGPROGRAM
        #pragma surface surf BlinnPhong

        sampler2D
            _MainTex,
            _BumpMap;

        half _Shiness;
        half _Gloss;
        
        struct Input
        {
            half2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
            o.Specular = _Shiness; // резкость
            o.Gloss = _Gloss; // блестящесть
        }
        ENDCG
    }
}