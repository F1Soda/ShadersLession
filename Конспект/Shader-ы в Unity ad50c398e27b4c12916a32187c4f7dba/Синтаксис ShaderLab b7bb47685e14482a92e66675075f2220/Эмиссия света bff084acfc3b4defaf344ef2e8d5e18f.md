# Эмиссия света

Помимо компонента `Albedo`, который отвечает за цвет пикселя на объекте, в `SurfaceOutput` есть ещё параметр `Emision`, отвечающие за свечение объекта. На самом деле этот параметр показывает, насколько нужно добавить цвет к поверхности, независимо от того — освещена поверхность или нет.

```c
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
```

![Untitled](%D0%AD%D0%BC%D0%B8%D1%81%D1%81%D0%B8%D1%8F%20%D1%81%D0%B2%D0%B5%D1%82%D0%B0%20bff084acfc3b4defaf344ef2e8d5e18f/Untitled.png)

![Untitled](%D0%AD%D0%BC%D0%B8%D1%81%D1%81%D0%B8%D1%8F%20%D1%81%D0%B2%D0%B5%D1%82%D0%B0%20bff084acfc3b4defaf344ef2e8d5e18f/Untitled%201.png)

Это самый простой вариант. Можно сделать круче! Добавим карту свечения, её цвет и коэффициент появления свечения:

```c
Shader "ShaderLessions/EmisionShader"
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
            o.Emission = appearMask * emTex.g * _EmissionColor;
        }
        ENDCG
    }
}
```

![Untitled](%D0%AD%D0%BC%D0%B8%D1%81%D1%81%D0%B8%D1%8F%20%D1%81%D0%B2%D0%B5%D1%82%D0%B0%20bff084acfc3b4defaf344ef2e8d5e18f/Untitled%202.png)

![Untitled](%D0%AD%D0%BC%D0%B8%D1%81%D1%81%D0%B8%D1%8F%20%D1%81%D0%B2%D0%B5%D1%82%D0%B0%20bff084acfc3b4defaf344ef2e8d5e18f/Untitled%203.png)

Теперь, двигая ползунок, можно добиться нужной прозрачности свечения или даже сделать анимацию её появления