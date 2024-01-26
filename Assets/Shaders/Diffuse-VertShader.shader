Shader "ShaderLessions/Diffuse-VertShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Extrude ("Extrude", Float) = 0.0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200
        Cull off


        CGPROGRAM
        #pragma surface surf Standard vertex:vert

        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;
        float _Extrude;

        struct Input
        {
            float2 uv_MainTex;
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            v.vertex.xyz += v.normal * _Extrude;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}