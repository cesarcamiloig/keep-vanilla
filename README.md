# Keep Vanilla

Una experiencia de **Minecraft Vanilla optimizada, estable y eficiente**, acompañada de **mejoras de calidad de vida cuidadosamente seleccionadas** para hacer el juego más cómodo sin alterar su esencia ni mecánicas base.

Diseñado para **Minecraft 26.2** sobre **Fabric Loader**.

---

## Filosofía de Keep Vanilla

*Keep Vanilla* combina dos objetivos fundamentales en perfecta armonía:

> **Optimización profunda + estabilidad + eficiencia + mejoras de calidad de vida, manteniendo intacta la esencia y jugabilidad de Vanilla.**

- **Esencia 100 % Vanilla:** No añade bloques, criaturas, dimensiones, armas ni altera el sistema de combate, progresión o recetas. Las físicas, el *spawning* y *despawning* de criaturas, los circuitos de redstone y los tiempos de crecimiento permanecen exactamente idénticos al juego base.
- **Optimización Integral del Motor:** Sodium, Lithium, ImmediatelyFast, FerriteCore, ModernFix y Entity Culling rediseñan el renderizado, el consumo de memoria Heap y la lógica en CPU para erradicar micro-tirones (*stuttering*) y maximizar la estabilidad del *frame time*.
- **Mejoras de Calidad de Vida (Quality of Life):** Funcionalidades discretas y altamente prácticas que eliminan fricciones cotidianas (zoom suave configurable con tecla `C`, previsualización de cajas de shulker en inventario, transparencia de valores de saturación, arrastre ergonómico de ítems y buscador de controles).
- **Libertad Total de Configuración:** Las herramientas de personalización gráfica y visual permiten que cada jugador encuentre su equilibrio deseado entre rendimiento y estética, manteniendo por defecto una fidelidad gráfica limpia y completa (hojas en *Fancy*, partículas y animaciones nativas).

---

## Criterios de Calidad de Vida (QoL)

Para que una funcionalidad sea admitida en *Keep Vanilla*, debe superar una evaluación rigurosa:

- **Mejorar comodidad y usabilidad:** Solucionar pequeñas molestias o fricciones de interacción en la experiencia diaria.
- **Aportar practicidad sin ventajas desleales:** Facilitar información que el juego ya calcula (como datos NBT de shulkers o saturación de alimentos) sin otorgar ventajas de tipo *cheat* ni alterar la dificultad.
- **Discreción y estética Vanilla:** Cero interfaces sobrecargadas, barras de vida estilo RPG, números de daño flotantes o minimapas invasivos.
- **Cero penalización de rendimiento:** Los mods QoL seleccionados son ultra ligeros, no generan picos de *Garbage Collection* ni degradan el *frametime*.
- **Configuración al alcance del usuario:** Cada aspecto puede ajustarse o desactivarse fácilmente desde los menús del juego.

---

## Configuración Predeterminada de Alto Rendimiento

*Keep Vanilla* incluye una configuración predeterminada equilibrada desde el primer inicio, diseñada para ofrecer la máxima estabilidad y suavidad sin deteriorar los gráficos:

- **Distancia de Renderizado (12 chunks):** Horizonte amplio y natural (~441 chunks cargados) reduciendo en más del 60 % la carga geométrica en GPU frente a distancias excesivas (20-24 chunks).
- **Distancia de Simulación (10 chunks):** Mantiene la esfera de *spawning* y comportamiento de entidades idéntica a Vanilla (128 bloques / 8 chunks), garantizando el funcionamiento exacto de granjas y circuitos de redstone con una reducción del 30 % en tiempo de tick de CPU.
- **Pipeline de Terreno y Chunks:** Generación multihilo adaptada a la CPU (`chunkBuilderThreads: 0`), aplazamiento suave de mallas (`chunkBuildDeferMode: ALWAYS`) para eliminar micro-tirones al romper/colocar bloques, y oclusión de caras internas y fluidos ocultos.
- **Fidelidad Gráfica Intacta:** Gráficos en modo detallado (*Fancy*), iluminación suave máxima (*Ambient Occlusion*), todas las partículas y animaciones de fluidos activas, y distancia de entidades al 100 %.

---

## Stack de Componentes

El modpack se compone de 23 componentes estrictamente seleccionados y organizados por capas técnicas:

### 1. Renderizado y Gráficos
| Componente | Capa / Área | Función Técnica |
| :--- | :--- | :--- |
| **Sodium** | Renderizado (GPU/CPU) | Motor de renderizado moderno para bloques y terreno |
| **Iris Shaders** | Shaders (GPU) | Pipeline moderno para shaders compatible con Sodium |
| **ImmediatelyFast** | Renderizado (CPU) | Agrupación (*batching*) de llamadas de render para HUD, GUI y entidades |
| **Entity Culling** | Oclusión (CPU Async) | Descarte de entidades ocultas tras muros mediante path-tracing en CPU |

### 2. Calidad de Vida (Quality of Life)
| Componente | Capa / Área | Función Técnica |
| :--- | :--- | :--- |
| **FabZoom** | Cámara / Zoom | Zoom suave y cinemático accionado por tecla configurable (por defecto `C`) |
| **Shulker Box Tooltip** | Inventario / UI | Previsualización emergente del contenido de cajas de shulker sin colocarlas |
| **AppleSkin** | HUD / Información | Visualización transparente de saturación, agotamiento y restauración de comida |
| **Mouse Tweaks** | Controles / Inventario | Arrastre fluido y manipulación continua de ítems en contenedores y crafteo |
| **Controlling** | Menú / Controles | Buscador y gestor de conflictos en la pantalla de asignación de teclas |

### 3. Configuración Visual y Opciones Avanzadas
| Componente | Capa / Área | Función Técnica |
| :--- | :--- | :--- |
| **Sodium Extra** | Opciones Gráficas | Control granular de partículas, animaciones individuales, niebla, cielo y detalles |
| **Reese's Sodium Options** | Navegación de Menú | Panel vertical con desplazamiento y buscador integrado para las opciones de vídeo |
| **Translations for Sodium** | Localización | Paquete de traducción multiidioma (incluyendo español) para Sodium y sus complementos |

### 4. Lógica, Memoria y Eficiencia de CPU
| Componente | Capa / Área | Función Técnica |
| :--- | :--- | :--- |
| **Lithium** | Lógica y Ticking (CPU) | Optimización de físicas, colisiones, IA y chunk loading sin tocar mecánicas Vanilla |
| **FerriteCore** | Memoria (RAM / GC) | Reducción de huella en memoria para modelos y estados de bloques en el Heap |
| **ModernFix (mVUS)** | Rendimiento y Memoria | Aceleración de arranque, reducción de uso de RAM y corrección de fugas de memoria |
| **BadOptimizations** | Tick de Cliente | Micro-optimizaciones: bypass de recálculo de lightmap y optimización de color del cielo |
| **Dynamic FPS** | Consumo energético | Reduce el consumo de CPU/GPU cuando el juego está en segundo plano |

### 5. Red y Conectividad
| Componente | Capa / Área | Función Técnica |
| :--- | :--- | :--- |
| **Krypton** | Red (Netty) | Optimización de la pila de red y serialización eficiente de buffers de paquetes |

### 6. Base, Librerías e Interfaz
| Componente | Capa / Área | Función Técnica |
| :--- | :--- | :--- |
| **Fabric API** | Base | API de interoperabilidad esencial para el ecosistema Fabric |
| **Mod Menu** | Interfaz | Menú dentro del juego para consultar y configurar mods |
| **Cloth Config API** | Librería de UI | Motor de pantallas de configuración requerido por mods del stack |
| **Searchables** | Librería de búsqueda | Componente auxiliar de filtrado para Controlling |
| **Placeholder API** | Librería de texto | Utilidad para formateo de cadenas usada por complementos de UI |

---

## Instalación

### Opción 1: Directa desde tu Launcher (Recomendada)
1. Abre **Prism Launcher**, **Modrinth App**, **PineconeMC** o **ATLauncher**.
2. Pulsa en **Añadir Instancia** y busca `Keep Vanilla`.
3. Selecciona la versión deseada e inicia el juego.

### Opción 2: Importar archivo `.mrpack`
1. Descarga el archivo `.mrpack` desde [Releases](https://github.com/cesarcamiloig/keep-vanilla/releases) o desde [Modrinth](https://modrinth.com/modpack/keep-vanilla).
2. En tu launcher, pulsa en **Añadir Instancia -> Importar** y selecciona el archivo `.mrpack`.
3. Inicia la instancia. Todas las dependencias se descargan y verifican automáticamente contra los hashes oficiales.

---

## Desarrollo y Mantenimiento

Este proyecto utiliza [Packwiz](https://packwiz.infra.link/) para la gestión reproducible del modpack sin almacenar binarios `.jar` en el repositorio Git.

### Entorno aislado con Docker
El proyecto incluye un `Dockerfile` multi-stage ligero basado en Alpine Linux para ejecutar Packwiz de forma aislada sin requerir Go en la máquina anfitriona.

1. Construir la imagen local (solo la primera vez):
```powershell
docker build -t packwiz-cli .
```

2. Definir el alias de conveniencia en PowerShell:
```powershell
function pw { docker run --rm -it -v "${PWD}:/workspace" packwiz-cli $args }
```

3. Comandos útiles:
```powershell
# Actualizar el índice tras modificar archivos
pw refresh

# Exportar paquete en formato Modrinth (.mrpack)
pw modrinth export

# Comprobar actualizaciones de dependencias
pw update --all
```

Para consultar el flujo de trabajo técnico paso a paso para añadir mods, actualizar componentes, alterar configuraciones y publicar releases, revisa el [Manual de Operaciones y Mantenimiento](MANUAL_OPERACIONES.md). Las reglas de clasificación de dependencias se detallan en [POLITICA_VERSIONES.md](POLITICA_VERSIONES.md).
