Shader "ShaderLessions/FirstShader"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {} // 1.
    }
    SubShader
    {
        CGPROGRAM
        // 2. Декларация типа шейдера
        #pragma surface surf Lambert

        // 3. Объявление переменных
        sampler2D _MainTex;

        struct Input
        {
            // Определяем, какие данные будут передаваться шейдеру
            half2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }
        ENDCG
    }
}