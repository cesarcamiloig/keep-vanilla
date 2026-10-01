# Política de Versiones y Gestión de Dependencias

Este documento establece el flujo técnico de actualización de dependencias y control de versiones para **Keep Vanilla**. El objetivo es garantizar que las mejoras de rendimiento y correcciones de errores se incorporen de forma controlada, sin comprometer la estabilidad del juego ni romper la compatibilidad con mundos existentes.

---

## 1. Clasificación de Actualizaciones

### Parches de Mods (Misma versión de Minecraft)
- **Alcance:** Actualizaciones de corrección de bugs o mejoras internas publicadas por los autores de los mods para la versión actual de Minecraft (`26.2`).
- **Flujo:** Automatizado mediante GitHub Actions. El flujo ejecuta `packwiz update --all` semanalmente y, si detecta cambios compatibles, abre un Pull Request contra la rama `main`.
- **Criterio de aprobación:** Se revisa el diff en los archivos `.pw.toml` e `index.toml`. Si los hashes son válidos y la versión de Minecraft permanece inalterada, el cambio se fusiona.

### Nuevas Dependencias o Configuraciones
- **Alcance:** Introducción de librerías requeridas por nuevos parches o ajustes en la carpeta `config/`.
- **Flujo:** Manual o auditado en PR.
- **Criterio de aceptación:** Se descarta cualquier librería o ajuste que altere las mecánicas base de Minecraft, introduzca contenido ajeno a Vanilla o comprometa la estabilidad técnica del juego.

### Saltos de Versión de Minecraft (Major Updates)
- **Alcance:** Migración del modpack a una nueva versión mayor de Minecraft (ej. de `26.2` a futuras versiones).
- **Flujo:** Exclusivamente manual. El pipeline automatizado tiene una compuerta que aborta la ejecución si detecta cualquier intento de modificar la versión base de Minecraft.
- **Criterio de migración:** No se actualiza la versión del modpack hasta validar los siguientes puntos:
  1. Fabric Loader y Fabric API disponen de builds estables para la nueva versión.
  2. Los motores centrales (Sodium, Iris, Lithium y FerriteCore) cuentan con versiones oficiales de producción (se evitan alphas tempranas inestables).
  3. Los complementos (ImmediatelyFast, Entity Culling, Dynamic FPS, Mod Menu) son plenamente compatibles.
  4. Se ejecuta una prueba de arranque y juego en entorno local, confirmando cero excepciones de Mixin en `latest.log` y tiempos de cuadro estables.

---

## 2. Reglas del Pipeline de Integración (CI/CD)

1. **Bloqueo de versión base:** Toda rutina automatizada en GitHub Actions verifica que la clave `minecraft` en `pack.toml` coincida exactamente con la versión soportada antes de generar cambios.
2. **Sin commits directos a `main`:** La automatización nunca escribe directamente en la rama principal. Todos los cambios entran como Pull Requests etiquetados para revisión visual.
3. **Reproducibilidad:** Todos los archivos de manifiesto se procesan con saltos de línea LF y firmas SHA-256 para evitar discrepancias entre sistemas operativos (Windows/Linux).