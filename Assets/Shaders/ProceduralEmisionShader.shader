Shader "ShaderLessions/ProceduralEmisionShader"
{
    Properties
    {
        _MaskTex ("Mask texture", 2D) = "black" {}
        _MainTex ("Main texture", 2D) = "white" {}
        _EmissionMaskTex ("Mask texture", 2D) = "black" {}
        _EmissionColor ("Emission Color", Color) = (1,1,1,1)
        _EmissionAppearance ("Emission Appearence" , Range(0, 1)) = 1.0
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
        fixed _EmissionAppearance;

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
            half appearMask = emTex.b;
            appearMask = smoothstep(_EmissionAppearance * 1.2, _EmissionAppearance * 1.2 - 0.2, appearMask);
            o.Emission = appearMask * emTex.r * _EmissionColor;
        }
        ENDCG
    }
}