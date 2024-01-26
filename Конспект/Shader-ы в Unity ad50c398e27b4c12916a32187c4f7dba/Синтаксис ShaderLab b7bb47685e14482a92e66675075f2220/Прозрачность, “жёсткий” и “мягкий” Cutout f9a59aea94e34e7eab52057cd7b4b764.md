# Прозрачность, “жёсткий” и “мягкий” Cutout

Попробуем создать шейдер, который будет отбрасывать те пиксели, у которых альфа канал принимает определённое значением.

- Рассмотрим простой диффузный шейдер и на его основе начнем создавать новый.
    
    ```c
    Shader "ShaderLessions/Diffuse-Transp"
    {
        Properties
        {
            _Color ("Color", Color) = (1,1,1,1)
            _MainTex ("Albedo (RGB)", 2D) = "white" {}
        }
        SubShader
        {
            Tags
            {
                "RenderType"="Opaque"
            }
            LOD 200
    
            CGPROGRAM
            #pragma surface surf Lambert
    
            #pragma target 3.0
    
            sampler2D _MainTex;
            fixed4 _Color;
    
            struct Input
            {
                float2 uv_MainTex;
            };
    
            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }
            ENDCG
        }
        FallBack "Legacy Shaders/VertexLit"
    }
    ```
    

```c
Shader "ShaderLessions/Diffuse-Transp"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "Queue"="AlphaTest" 
            "RenderType"="TransparentCutout"
            "IgnoreProjector"="True" 
        }
        LOD 200
        Cull Off // и ещё Off и Front, Back -- по умолчанию
        
        
        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff

        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/VertexLit"
}
```

![Untitled](%D0%9F%D1%80%D0%BE%D0%B7%D1%80%D0%B0%D1%87%D0%BD%D0%BE%D1%81%D1%82%D1%8C,%20%E2%80%9C%D0%B6%D0%B5%CC%88%D1%81%D1%82%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20%D0%B8%20%E2%80%9C%D0%BC%D1%8F%D0%B3%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20Cutout%20f9a59aea94e34e7eab52057cd7b4b764/Untitled.png)

![Untitled](%D0%9F%D1%80%D0%BE%D0%B7%D1%80%D0%B0%D1%87%D0%BD%D0%BE%D1%81%D1%82%D1%8C,%20%E2%80%9C%D0%B6%D0%B5%CC%88%D1%81%D1%82%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20%D0%B8%20%E2%80%9C%D0%BC%D1%8F%D0%B3%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20Cutout%20f9a59aea94e34e7eab52057cd7b4b764/Untitled%201.png)

`"IgnoreProjector"="False"` — стоит по умолчанию

![Untitled](%D0%9F%D1%80%D0%BE%D0%B7%D1%80%D0%B0%D1%87%D0%BD%D0%BE%D1%81%D1%82%D1%8C,%20%E2%80%9C%D0%B6%D0%B5%CC%88%D1%81%D1%82%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20%D0%B8%20%E2%80%9C%D0%BC%D1%8F%D0%B3%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20Cutout%20f9a59aea94e34e7eab52057cd7b4b764/Untitled%202.png)

текстура с параметром `Cull Back` — оно стоит по умолчанию

Как ты мог заметить, тут большая часть работы была проделана в `ShaderLab`, нежели чем в `CgFX`.  Для начала мы определили параметр типа `Range` `_Cutoff`. Затем мы изменили тег `RenderType` и добавили новые. Это `Queue` и `IgnoreProjectile`. Сначала для тега `RenderType` стояло значение `Opaque`. Этот тип рендеринга позволяет снизить нагрузки на GPU за счёт просчитывания расстояния между полигонами — тот, который находится за текущим, можно не отрисовывать. Поменяем его на `TransparentCutout`. Этот тип рендеринга позволяет не рендерить некоторые пиксели, если они удовлетворяют некоторому условию. Затем мы добавили тегу `Queue` значение `AlphaTest`. Установив его, мы позволили оптимизировать работу видеокарты за счёт того, что перед тем как рендерить следующий полигон, видеокарта проверит, на прозрачность пиксели, которые этот полигон закрывают. `"IgnoreProjector"="True"` — установили специально, чтобы модель с данной текстурой не отбрасывала тени, так как выглядеть это будет довольно странно. Затем мы добавили пункт `Cull off`. Cull — от английского отбросить. У него есть 3 параметра `back`, `front`, `off`. Эти параметры будут отвечать за то, будет ли отображаться задняя часть текстуры или передняя. Ну а в самом `CgFX` мы лишь изменили следующую строчку:

```c
#pragma surface surf Lambert alphatest:_Cutoff
```

Указав `alphatest:_Cutoff` мы указали видеокарте, что проверку по альфа каналу можно проводить через сравнивание значения с переменной `_Cutoff`

Есть ещё другой вариант сделать текстуру прозрачной. Этот метод будет иметь название “мягкий” Cutout. Теперь не будет никакого порогового значения для альфа канала: пиксель будет иметь ту прозрачность, которая установлена в текстуре. Заметь, в первом случае могло быть только две ситуации с пикселем: либо он прозрачный, либо нет. Второй вариант позволяет добавить промежуточные значения.

```c
Shader "ShaderLessions/LoftCutoutSShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent" 
            "RenderType"="Transparent"
            "IgnoreProjector"="True" 
        }
        LOD 200
        Cull Back 
        
        
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade 
				//  есть ещё auto, premul

        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/VertexLit"
}
```

![Untitled](%D0%9F%D1%80%D0%BE%D0%B7%D1%80%D0%B0%D1%87%D0%BD%D0%BE%D1%81%D1%82%D1%8C,%20%E2%80%9C%D0%B6%D0%B5%CC%88%D1%81%D1%82%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20%D0%B8%20%E2%80%9C%D0%BC%D1%8F%D0%B3%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20Cutout%20f9a59aea94e34e7eab52057cd7b4b764/Untitled%203.png)

Сама текстура:

![PixelHeartWithVinetka.png](%D0%9F%D1%80%D0%BE%D0%B7%D1%80%D0%B0%D1%87%D0%BD%D0%BE%D1%81%D1%82%D1%8C,%20%E2%80%9C%D0%B6%D0%B5%CC%88%D1%81%D1%82%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20%D0%B8%20%E2%80%9C%D0%BC%D1%8F%D0%B3%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20Cutout%20f9a59aea94e34e7eab52057cd7b4b764/PixelHeartWithVinetka.png)

![Untitled](%D0%9F%D1%80%D0%BE%D0%B7%D1%80%D0%B0%D1%87%D0%BD%D0%BE%D1%81%D1%82%D1%8C,%20%E2%80%9C%D0%B6%D0%B5%CC%88%D1%81%D1%82%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20%D0%B8%20%E2%80%9C%D0%BC%D1%8F%D0%B3%D0%BA%D0%B8%D0%B8%CC%86%E2%80%9D%20Cutout%20f9a59aea94e34e7eab52057cd7b4b764/Untitled%204.png)

`alpha:premul`

Как ты заметил, мы поменяли очередь рендеринга(`Queue`) и сам тип рендера(`RenderType`) на прозрачный(`Transparent`). Также мы добавили такой параметр как `alpha`. Но ведь там не просто `alpha`, там `alpha:fade`.  В чем суть? Дело в том, что текстуры, которые используются для рендеринга порой приходят с различными параметрами альфа канала. Некоторые программы могут сохранять текстуру, применив к ним сразу альфа прозрачность, а некоторые этого не делают. Это важно учитывать и выставлять правильные режимы, чтобы текстура выглядела так, как она должна выглядеть. Есть конечно ещё тип `auto`, но он не всегда правильно работает. Потому просто поочерёдно используй тип `fade` или `premul`, чтобы понять какой лучше. А ещё, как ты мог заметить, текстура не отображает свою заднюю часть. Вызвано это тем, что если включить режим `Cull off`,  то мы получим неправильное отображение текстуры — задние грани будут лежать на гранях, которые ближе к камере. Вызвано это тем, что при типе рендера `Transparent` в буфер не закладывается информация о глубине(z-координате) полигона. Потому Unity не может определить, какой полигон ближе: она рендерит тот, у которого ID выше(или ниже, точно не знаю).