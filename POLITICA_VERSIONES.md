# Política de Versiones y Gestión de Dependencias (Keep Vanilla)

Este documento define las reglas técnicas obligatorias para actualizar dependencias y versionar el modpack, garantizando que la estabilidad y la fidelidad a Vanilla nunca se sacrifiquen por el afán de estar al día.

---

## 1. Clasificación de Cambios (Matriz de Riesgo)

### Categoría A: Parches Menores y Correctivos de Mods
- **Definición:** Actualización de un mod existente para la misma versión de Minecraft (ej. corrección de bugs o mejoras de rendimiento).
- **Riesgo:** Bajo.
- **Política:** Automatizada mediante GitHub Actions a través de **Pull Requests (PR)**. El robot verifica actualizaciones seguras y abre una propuesta con el diff para revisión.

### Categoría B: Dependencias Transitivas y Configuraciones
- **Definición:** Un mod añade nuevas librerías requeridas o modifica archivos en `config/`.
- **Riesgo:** Medio.
- **Política:** Requiere validación técnica humana previa. No se aceptarán dependencias que alteren la estética o mecánicas Vanilla.

### Categoría C: Salto de Versión de Minecraft (Major Upgrade)
- **Definición:** Migrar el modpack a una nueva versión principal o actualización mayor de Minecraft.
- **Riesgo:** Crítico.
- **Política:** **TERMINANTEMENTE PROHIBIDA LA AUTOMATIZACIÓN A CIEGAS.** El pipeline de CI debe abortar si detecta cambios en la versión de Minecraft. La migración requiere ejecutar el Checklist de las 5 Reglas.

---

## 2. Checklist Obligatorio para Migración de Minecraft (Categoría C)

Antes de modificar `minecraft` en `pack.toml`, se debe certificar:
1. **Fabric:** Loader y Fabric API estables y probados.
2. **Núcleo Gráfico:** Sodium e Iris Shaders en versión `Release` oficial (prohibidas `Alpha` para producción).
3. **Lógica y Memoria:** Lithium y FerriteCore adaptados y sin advertencias críticas.
4. **Mods Complementarios:** ImmediatelyFast, Entity Culling, Dynamic FPS y Mod Menu plenamente compatibles.
5. **Prueba Real:** Arranque en launcher local sin excepciones de Mixin en `latest.log` y frame time estable en `F3`.

---

## 3. Reglas de Automatización en CI/CD

- **Regla del Bloqueo:** Todo script automatizado debe validar que la clave `minecraft` en `pack.toml` coincida con la versión congelada del ciclo de soporte.
- **Regla de No Escritura Directa:** Ningún flujo automatizado tiene permisos para empujar commits directamente a la rama `main`; todos los cambios deben ingresar mediante Pull Requests auditables.