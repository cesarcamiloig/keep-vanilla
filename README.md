# Modpack de Optimización Vanilla (Minecraft Java Edition)

Modpack orientado exclusivamente al rendimiento, estabilidad de *frame time* y eficiencia de recursos (CPU, GPU y RAM), manteniendo una fidelidad visual y mecánica 100 % Vanilla con soporte opcional para *shaders*.

## Base Tecnológica Actual
- **Versión de Minecraft:** `26.2`
- **Modloader:** `Fabric`
- **Gestión de paquetes:** `Packwiz` (ejecutado en contenedor Docker aislado)

## Stack de Optimización Inicial
| Componente | Capa / Área | Función Principal |
| :--- | :--- | :--- |
| **Fabric API** | Base | Librería de interoperabilidad requerida por mods del stack |
| **Sodium** | Renderizado (GPU/CPU) | Reemplazo del motor de renderizado de terreno |
| **Iris Shaders** | Shaders (GPU) | Soporte opcional de paquetes de shaders integrado con Sodium |
| **ImmediatelyFast** | Renderizado (CPU/GPU) | Agrupación (*batching*) de llamadas para entidades, textos y HUD |
| **Entity Culling** | Oclusión (CPU Async) | Descarte por *path-tracing* asíncrono de entidades tras muros |
| **Lithium** | Lógica (CPU Main) | Optimización de físicas, colisiones, IA y *ticking* sin alterar Vanilla |
| **FerriteCore** | Memoria (RAM/GC) | Reducción del uso de memoria *Heap* en estados y modelos de bloques |
| **Dynamic FPS** | Recursos | Reducción de consumo de GPU/CPU con el juego en segundo plano |
| **Mod Menu** | Utilidad | Interfaz en el menú para visualizar y configurar los mods instalados |