# Keep Vanilla

Modpack de optimización, estabilidad de *frame time* y eficiencia de recursos para **Minecraft 26.2** sobre **Fabric Loader**.

Diseñado bajo un principio estricto: **fidelidad 100 % a la experiencia Vanilla**. Sin degradar gráficos, sin apagar partículas esenciales, sin alterar mecánicas del juego y con soporte nativo de shaders vía Iris que no consume recursos cuando los shaders están desactivados.

---

## ¿Por qué Keep Vanilla?

Muchos paquetes de optimización consiguen números altos de FPS a costa de recortar la experiencia gráfica: reduciendo distancia de animación, eliminando efectos de partículas, bajando la calidad del cielo o modificando interfaces.

**Keep Vanilla** toma el camino de la ingeniería:
- **Reemplazo del pipeline de renderizado:** Sodium reescribe el renderizado de terreno con OpenGL moderno y técnicas avanzadas de frustum culling.
- **Optimización de memoria y recolector de basura:** FerriteCore reduce el peso de estados y modelos de bloques en la memoria Heap de Java, mitigando los tirones causados por el Garbage Collector (GC).
- **Lógica interna sin cambios mecánicos:** Lithium rediseña la matemática de colisiones, físicas y procesamiento de chunks en hilos del procesador sin alterar el comportamiento de granjas ni redstone.
- **Oclusión asíncrona:** Entity Culling descarta el renderizado de entidades que están completamente ocultas detrás de bloques opacos mediante trazado de rayos liviano en CPU.
- **Batching en interfaz y textos:** ImmediatelyFast agrupa llamadas de dibujo para el HUD, nombres y entidades, evitando cuellos de botella en la CPU.
- **Soporte de Shaders moderno:** Iris Shaders permite activar paquetes de shaders compatibles con Sodium al vuelo, con impacto cero cuando se mantienen apagados.

---

## Stack de Componentes

El modpack se compone de 11 elementos estrictamente seleccionados y probados:

| Componente | Capa / Área | Función Técnica |
| :--- | :--- | :--- |
| **Fabric API** | Base | API de interoperabilidad esencial para el ecosistema Fabric |
| **Sodium** | Renderizado (GPU/CPU) | Motor de renderizado moderno para bloques y terreno |
| **Iris Shaders** | Shaders (GPU) | Pipeline moderno para shaders compatible con Sodium |
| **ImmediatelyFast** | Renderizado (CPU) | Agrupación (*batching*) de llamadas de render para HUD, GUI y entidades |
| **Entity Culling** | Oclusión (CPU Async) | Descarte de entidades ocultas tras muros mediante path-tracing en CPU |
| **Lithium** | Lógica y Ticking (CPU) | Optimización de físicas, colisiones, IA y chunk loading |
| **FerriteCore** | Memoria (RAM / GC) | Reducción de huella en memoria para modelos y estados de bloques |
| **Dynamic FPS** | Consumo energético | Reduce el consumo de CPU/GPU cuando el juego está en segundo plano |
| **Mod Menu** | Interfaz | Menú dentro del juego para consultar y configurar mods |
| **Cloth Config API** | Librería de UI | Motor de pantallas de configuración requerido por mods del stack |
| **Placeholder API** | Librería de texto | Utilidad para formateo de cadenas usada por complementos de UI |

---

## Rendimiento Verificado

Pruebas reales en entorno local (Prism Launcher / PineconeMC):
- **Hardware:** Intel Core i5-12600KF · AMD Radeon RX 7600 · 32 GB RAM (ZGC habilitado)
- **Tasa media de cuadros:** ~1.400 FPS (distancia de render 12 chunks, Vanilla default)
- **Estabilidad (1 % Lows / p99.5):** ~658 FPS
- **Tiempo interno de tick:** 4.9 ms (margen amplio sobre el límite de 50 ms por tick)
- **Estabilidad de Mixins:** 0 excepciones o colisiones registradas en `latest.log`

---

## Instalación

### Método recomendado (Prism Launcher / Modrinth App / PineconeMC)
1. Ve a la pestaña de [Releases](https://github.com/cesarcamiloig/keep-vanilla/releases) y descarga el archivo más reciente con extensión `.mrpack` (ej. `Keep Vanilla-0.1.0.mrpack`).
2. Abre tu launcher:
   - **Prism Launcher / PineconeMC:** Haz clic en *Añadir instancia* -> *Importar* y selecciona el archivo `.mrpack`.
   - **Modrinth App:** Arrastra el archivo `.mrpack` a la ventana de la aplicación o pulsa en *Add instance -> From file*.
3. Inicia la instancia. Las dependencias y versiones de mods se descargan y verifican automáticamente contra los hashes oficiales.

---

## Desarrollo y Mantenimiento

Este proyecto utiliza [Packwiz](https://packwiz.infra.link/) para la gestión reproducible del modpack sin almacenar binarios `.jar` en el repositorio Git.

### Entorno aislado con Docker
Para no requerir Go ni herramientas adicionales en la máquina anfitriona, el proyecto incluye un `Dockerfile` multi-stage ligero basado en Alpine Linux.

En PowerShell de Windows, puedes usar la función local:

```powershell
function pw { docker run --rm -it -v "${PWD}:/workspace" packwiz-cli $args }
```

Comandos útiles:
```powershell
# Actualizar el índice tras modificar archivos
pw refresh

# Exportar paquete en formato Modrinth (.mrpack)
pw modrinth export

# Comprobar actualizaciones de dependencias
pw update --all
```

Las políticas técnicas de actualización y versionado están documentadas en [POLITICA_VERSIONES.md](POLITICA_VERSIONES.md).