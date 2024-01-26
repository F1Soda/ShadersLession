# Shader-ы в Unity

Источники: [курс в youtube](https://www.youtube.com/playlist?list=PLATnLipPUmffTTeo6DOglispY6Hw1QU6s), **[An introduction to Shader Art Coding](https://www.youtube.com/watch?v=f4s1h2YETNY&t=781s&ab_channel=kishimisu)**

---

Написание шейдера в unity требует знание двух языков — **ShaderLab** и **CgFx**. ShaderLab — это некоторая оболочка над CgFx, которая служит для удобного использования и настройки шейдера в самом unity. Сами шейдеры пишутся на CgFx, хотя есть ещё другие поддерживаемые языки. Шейдеры, которые можно создавать в Unity делятся на 2 типа:

1. Вершинный + пиксельный шейдер
2. Surface-шейдер

Первый вариант требует от разработчика написание низкоуровневых операций, так как перемножение матриц, сложение векторов, а затем уже написание самого шейдера. Surface-шейдер отвечает лишь за то, как будет отображаться поверхность объекта, все инструменты для этого предоставлены. 

Для просмотра результата написанного шейдера можно использовать сайт [ShadeToy](https://www.shadertoy.com/new#)

[Синтаксис языка CgFx](Shader-%D1%8B%20%D0%B2%20Unity%20ad50c398e27b4c12916a32187c4f7dba/%D0%A1%D0%B8%D0%BD%D1%82%D0%B0%D0%BA%D1%81%D0%B8%D1%81%20%D1%8F%D0%B7%D1%8B%D0%BA%D0%B0%20CgFx%20dc4a4200dc5842c691797e9e2928ca6a.md)

[Синтаксис ShaderLab](Shader-%D1%8B%20%D0%B2%20Unity%20ad50c398e27b4c12916a32187c4f7dba/%D0%A1%D0%B8%D0%BD%D1%82%D0%B0%D0%BA%D1%81%D0%B8%D1%81%20ShaderLab%20b7bb47685e14482a92e66675075f2220.md)