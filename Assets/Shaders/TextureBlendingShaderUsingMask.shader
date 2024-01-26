Shader "ShaderLessions/TextureBlendingShaderUsingMask"
{
    Properties
    {
        _MaskTex ("Mask texture", 2D) = "black" {}
        _MainTex ("Main texture", 2D) = "white" {}
        _BlendTex1 ("Blending texture 1", 2D) = "white" {}
        _BlendTex2 ("Blending texture 2", 2D) = "white" {}
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D
            _MainTex,
            _BlendTex1,
            _BlendTex2,
            _MaskTex;

        struct Input
        {
            half2 uv_MaskTex;
            half2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed3 masks = tex2D(_MaskTex, IN.uv_MaskTex);
            fixed3 col = tex2D(_MainTex, IN.uv_MainTex) * masks.r
                       + tex2D(_BlendTex1, IN.uv_MainTex) * masks.g
                       + tex2D(_BlendTex2, IN.uv_MainTex) * masks.b;
            o.Albedo = col;
        }
        ENDCG
    }
}