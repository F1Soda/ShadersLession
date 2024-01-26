Shader "ShaderLessions/PBRMetalicShader"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}
        _BumpMap ("Normal map", 2D) = "bump" {}
        _Shiness ("Shiness", Range(0,1)) = 0.07 // резкость/яркость отражения
        _Specularity("Specularity", Range(0,1)) = 0.5 // Отражаемость
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex,
                  _BumpMap;

        fixed _Specularity;

        half _Shiness;

        struct Input
        {
            half2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed3 col = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = col;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
            o.Metallic = _Specularity;
            o.Smoothness = _Shiness;
        }
        ENDCG
    }
}