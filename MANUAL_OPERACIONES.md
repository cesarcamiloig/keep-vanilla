# Manual de Operaciones y Mantenimiento: Keep Vanilla

Este documento es el manual técnico y operativo oficial para el desarrollo, mantenimiento, actualización y publicación del modpack **Keep Vanilla**.

Su propósito es proporcionar directrices exactas y procedimientos paso a paso estandarizados (SOPs) para garantizar la consistencia, estabilidad técnica, reproducibilidad y fidelidad del modpack a lo largo del tiempo.

---

## 1. Principios Fundamentales y Filosofía Innegociable

Cualquier cambio, adición o modificación en el repositorio debe alinearse estrictamente con los pilares del proyecto:

1. **Máxima Optimización Técnica:** El objetivo principal es exprimir el rendimiento de Minecraft al límite técnico posible: maximizar fotogramas por segundo (FPS), estabilizar el tiempo de cuadro (*frame time*), erradicar micro-tirones (*stuttering*), acelerar tiempos de carga y optimizar el uso de CPU, GPU y memoria RAM.
2. **Mecánicas 100 % Vanilla:** No se admiten modificaciones que agreguen bloques, ítems, dimensiones, mecánicas de juego ajenas o que alteren los comportamientos nativos de Minecraft (físicas, *spawning* o *despawning* de criaturas, circuitos de redstone, colisiones o tasas de crecimiento de cultivos).
3. **Libertad de Configuración al Usuario:** El modpack proporciona herramientas y configuraciones para que el usuario elija su propio balance entre calidad gráfica y rendimiento.
4. **Fidelidad Gráfica Predeterminada:** La configuración por defecto del modpack **no debe recortar la calidad visual de forma agresiva**. Opciones como calidad de hojas (*Fancy*), nubes, cielo, sol, luna, partículas completas y animaciones deben permanecer activas en la configuración inicial.
5. **Reproducibilidad y Gestión Declarativa:** El modpack no almacena binarios `.jar` en el repositorio Git. Todas las dependencias se gestionan declarativamente mediante **Packwiz**, garantizando firmas criptográficas (SHA-256 / SHA-512) y compilaciones idénticas.

---

## 2. Arquitectura y Estructura del Repositorio

El repositorio se organiza según el estándar de Packwiz y las convenciones de despliegue en Modrinth:

```text
proyecto-modpack-optimizacion/
├── .github/
│   └── workflows/
│       ├── release.yml               # CI/CD: Compilación y publicación en GitHub y Modrinth
│       └── update-mods.yml           # CI/CD: Chequeo semanal de parches de dependencias
├── config/                           # Configuraciones predeterminadas para los mods
│   ├── modmenu.json                  # Ajustes de UI de Mod Menu
│   ├── reeses_sodium_options.json    # Ajustes de interfaz vertical y buscador de Sodium
│   └── sodium-options.json           # Parámetros avanzados del motor Sodium
├── mods/                             # Manifiestos de mods gestionados por Packwiz
│   ├── badoptimizations.pw.toml
│   ├── cloth-config.pw.toml
│   ├── dynamic-fps.pw.toml
│   ├── entityculling.pw.toml
│   ├── fabric-api.pw.toml
│   ├── ferrite-core.pw.toml
│   ├── immediatelyfast.pw.toml
│   ├── iris.pw.toml
│   ├── krypton.pw.toml
│   ├── lithium.pw.toml
│   ├── modernfix-mvus.pw.toml
│   ├── modmenu.pw.toml
│   ├── placeholder-api.pw.toml
│   ├── reeses-sodium-options.pw.toml
│   ├── sodium-extra.pw.toml
│   └── sodium.pw.toml
├── resourcepacks/                    # Recursos integrados en el modpack
│   └── translations-for-sodium.pw.toml
├── .gitattributes                    # Forzado de saltos de línea LF (* text eol=lf)
├── .gitignore                        # Exclusiones de Git (binarios, caches, logs)
├── .packwizignore                    # Exclusiones del paquete .mrpack final
├── Dockerfile                        # Imagen aislada para ejecutar Packwiz CLI
├── icon.png                          # Icono oficial del modpack (512x512)
├── index.toml                        # Índice criptográfico generado por Packwiz (¡NO EDITAR A MANO!)
├── MANUAL_OPERACIONES.md             # Este manual operativo
├── options.txt                       # Configuración base de Minecraft y Sodium (overrides)
├── pack.toml                         # Manifiesto principal del modpack (nombre, versión, motor)
├── POLITICA_VERSIONES.md             # Clasificación técnica de versiones y dependencias
└── README.md                         # Documentación pública principal del proyecto
```

### Roles de los Archivos Clave

| Archivo / Carpeta | Tipo | ¿Se edita a mano? | Descripción y Reglas |
| :--- | :--- | :--- | :--- |
| `pack.toml` | Configuración | **SÍ** | Define el nombre, versión del modpack (`version`), y versiones base de Minecraft (`minecraft = "26.2"`) y Fabric Loader (`fabric = "0.19.5"`). Solo se edita al cambiar de versión del modpack o migrar Minecraft. |
| `index.toml` | Generado | **NUNCA** | Contiene los hashes SHA-256 de todos los componentes y archivos locales. Se actualiza exclusivamente ejecutando `pw refresh`. Cualquier edición manual corromperá las firmas. |
| `mods/*.pw.toml` | Metadatos | **Raramente** | Manifiestos individuales generados por Packwiz. Contienen URLs de descarga, ID de Modrinth y hashes SHA-512. Se manipulan mediante comandos de `pw`. |
| `config/*.json` | Configuración | **SÍ** | Configuraciones empaquetadas en `overrides/config/`. Deben usar formato JSON válido y saltos de línea `LF`. |
| `options.txt` | Configuración | **SÍ** | Ajustes gráficos de Minecraft/Sodium distribuidos en `overrides/options.txt`. |
| `.packwizignore` | Infraestructura | **SÍ** | Lista de exclusión para evitar que archivos de repositorio (Dockerfile, documentación, icon.png, etc.) se incluyan dentro del archivo `.mrpack`. |

---

## 3. Entorno de Trabajo y Herramientas

Para garantizar que el modpack se desarrolle de manera idéntica en cualquier sistema operativo (Windows, Linux o macOS), el proyecto utiliza un contenedor Docker ligero con Alpine Linux que contiene el binario compilado oficial de Packwiz.

### 3.1. Requisitos Previos

- **Docker Desktop** (en Windows/macOS) o **Docker Engine** (en Linux) instalado y en ejecución.
- **Git** configurado con soporte de saltos de línea LF.
- Terminal **PowerShell** (en Windows) o **Bash/Zsh** (en Linux/macOS).

### 3.2. Configuración del Entorno de Desarrollo

1. Comprobar que el demonio de Docker está activo:
   ```powershell
   docker ps
   ```

2. Construir la imagen local de Packwiz (solo es necesario ejecutarlo la primera vez o tras modificar el `Dockerfile`):
   ```powershell
   docker build -t packwiz-cli .
   ```

3. Declarar el alias de conveniencia en la sesión de terminal:
   - **En Windows (PowerShell):**
     ```powershell
     function pw { docker run --rm -it -v "${PWD}:/workspace" packwiz-cli $args }
     ```
     > **Nota:** Para scripts automatizados o cuando no se disponga de TTY interactivo, omite el flag `-it`:
     > ```powershell
     > docker run --rm -v "${PWD}:/workspace" packwiz-cli <comando>
     > ```
   - **En Linux / macOS (Bash/Zsh):**
     ```bash
     alias pw='docker run --rm -it -v "$(pwd):/workspace" packwiz-cli'
     ```

### 3.3. Comandos Esenciales de Packwiz

| Comando | Función Técnica | Cuándo Utilizarlo |
| :--- | :--- | :--- |
| `pw refresh` | Recalcula los hashes de todos los archivos y actualiza `index.toml` y `pack.toml`. | Tras añadir/eliminar mods, modificar `options.txt` o alterar archivos en `config/`. |
| `pw update --all` | Consulta Modrinth y actualiza todos los mods compatibles a su última versión. | Durante revisiones de mantenimiento o resolución de incidencias. |
| `pw update <mod>` | Actualiza un componente específico. | Para probar un parche puntual de un único mod. |
| `pw modrinth add <slug>` | Descarga los metadatos de un mod desde Modrinth y crea su archivo `.pw.toml`. | Al incorporar un nuevo mod al modpack. |
| `pw remove <slug>` | Elimina un mod del manifiesto y borra su archivo `.pw.toml`. | Al desestimar un mod. |
| `pw modrinth export` | Compila y empaqueta el modpack completo en formato estándar `.mrpack`. | Para verificar la integridad de la compilación antes de lanzar una release. |

---

## 4. Flujo de Trabajo Estándar en Git

### 4.1. Estrategia de Ramas

- **`main`:** Rama de producción protegida. Siempre debe estar en un estado funcional, estable, probado y listo para exportar.
- **Ramas de funcionalidad (`feat/...`):** Para incorporar nuevos mods o configuraciones de calado.
- **Ramas de corrección (`fix/...`):** Para solucionar problemas de compatibilidad o bugs.
- **Ramas de mantenimiento (`chore/...` o `automation/...`):** Para bumps de versiones, mantenimiento general o PRs generados por el workflow automático.

### 4.2. Convención de Commits (Conventional Commits)

Todos los commits deben seguir el formato estandarizado:

- `feat(scope): descripción` — Nuevos mods, configuraciones o características.
- `fix(scope): descripción` — Corrección de errores, incompatibilidades o parámetros erróneos.
- `perf(scope): descripción` — Ajustes específicos enfocados en rendimiento puro.
- `chore(scope): descripción` — Tareas de mantenimiento, actualización de dependencias, bumping de versión o configuración de herramientas.
- `docs(scope): descripción` — Modificaciones exclusivamente en documentación.
- `ci(scope): descripción` — Cambios en los flujos de GitHub Actions o Dockerfile.
- `refactor(scope): descripción` — Reorganización de archivos o código sin alterar el comportamiento.

*Ejemplo:* `feat(config): aplicar configuracion predeterminada de alto rendimiento y fidelidad Vanilla`

### 4.3. Regla Estricta de Saltos de Línea (LF)

Todos los archivos de texto (`.json`, `.txt`, `.toml`, `.md`, `.yml`) **deben usar saltos de línea LF (`\n`)**.
El repositorio cuenta con un archivo `.gitattributes` configurado con `* text eol=lf`. Al editar archivos manualmente en Windows, asegúrate de que tu editor (VS Code, Notepad++, etc.) guarde con formato de fin de línea UNIX (LF).

---

## 5. Procedimientos Operativos Paso a Paso (SOPs)

---

### Procedimiento 1: Añadir un Nuevo Mod al Modpack

Antes de agregar cualquier mod, debe pasar por la **comprobación de admisión**:
1. ¿Aporta una mejora técnica medible (FPS, frametime, memoria, carga, red)?
2. ¿Respeta el principio Vanilla (cero bloques nuevos, cero alteración de físicas, redstone o spawning)?
3. ¿Dispone de versión nativa y estable para la versión objetivo de Minecraft (`26.2`) y Fabric Loader?
4. ¿Es compatible con el stack existente (Sodium, Iris, Lithium, ModernFix, ImmediatelyFast)?

**Pasos:**
1. Crear una rama de trabajo:
   ```powershell
   git checkout -b feat/incorporar-<nombre-mod>
   ```
2. Añadir el mod mediante Packwiz (usando su slug o ID de Modrinth):
   ```powershell
   pw modrinth add <slug-del-mod>
   ```
3. Si el mod requiere configuración inicial:
   - Crear el archivo correspondiente en la carpeta `config/<nombre-del-mod>.json` o `.properties`.
   - Asegurarse de que el archivo use saltos de línea LF.
4. Refrescar el índice criptográfico:
   ```powershell
   pw refresh
   ```
5. Probar la compilación del paquete:
   ```powershell
   pw modrinth export
   ```
   *(Verificar que el `.mrpack` se genera sin advertencias y eliminar el archivo `.mrpack` generado localmente tras la prueba).*
6. Actualizar la tabla de componentes en `README.md` detallando el componente, su capa técnica y su función.
7. Confirmar y enviar los cambios:
   ```powershell
   git add mods/ config/ index.toml pack.toml README.md
   git commit -m "feat(mods): agregar <nombre-mod> para optimizacion de <area>"
   git push origin feat/incorporar-<nombre-mod>
   ```
8. Abrir un Pull Request hacia `main`, revisar el diff y fusionar tras validar.

---

### Procedimiento 2: Actualizar Dependencias (Mods)

#### Actualización individual (Recomendada para mods mayores como Sodium o Iris):
```powershell
git checkout -b chore/update-<nombre-mod>
pw update <slug-del-mod>
pw refresh
pw modrinth export
git add mods/<nombre-mod>.pw.toml index.toml pack.toml
git commit -m "chore(deps): actualizar <nombre-mod> a su ultima version"
git push origin chore/update-<nombre-mod>
```

#### Actualización en lote de todos los mods:
```powershell
git checkout -b chore/update-all-mods
pw update --all
```
> **ADVERTENCIA:** Tras ejecutar `pw update --all`, verifica inmediatamente en `pack.toml` que la clave `minecraft` siga siendo exactamente `"26.2"`. Si algún mod actualizó a una versión distinta de Minecraft, revierte ese archivo `.pw.toml` específico.

```powershell
pw refresh
pw modrinth export
git add mods/ index.toml pack.toml
git commit -m "chore(deps): actualizar parches menores de dependencias"
git push origin chore/update-all-mods
```

---

### Procedimiento 3: Eliminar o Reemplazar un Mod

1. Eliminar el mod mediante Packwiz:
   ```powershell
   pw remove <slug-del-mod>
   ```
2. Comprobar si quedaron archivos de configuración huérfanos en la carpeta `config/` pertenecientes a dicho mod y eliminarlos.
3. Si el mod requería librerías auxiliares que ningún otro mod utiliza, eliminarlas también.
4. Refrescar el índice:
   ```powershell
   pw refresh
   ```
5. Actualizar `README.md` eliminando la fila correspondiente de la tabla de componentes.
6. Probar la compilación del `.mrpack`:
   ```powershell
   pw modrinth export
   ```
7. Confirmar cambios en Git:
   ```powershell
   git add mods/ config/ index.toml pack.toml README.md
   git commit -m "refactor(mods): remover <nombre-mod> por <motivo>"
   ```

---

### Procedimiento 4: Modificar la Configuración Predeterminada (`options.txt` o `config/`)

Las configuraciones iniciales forman parte del empaquetado del modpack y se extraen en la carpeta raíz del cliente de Minecraft (`overrides/`).

**Reglas de configuración:**
- **`options.txt`:** Controla opciones de Minecraft y Sodium (distancia de renderizado, distancia de simulación, partículas, límite de FPS, modo de gráficos, etc.).
- **`config/sodium-options.json`:** Controla parámetros del pipeline de Sodium (hilos de compilación, modo diferido de mallas, oclusión de caras, oclusión de niebla, fluidos ocultos).
- **`config/reeses_sodium_options.json`:** Controla la interfaz y búsqueda del menú de vídeo.

**Pasos para modificar una opción:**
1. Abrir el archivo correspondiente (`options.txt` o `config/<archivo>.json`) en el editor.
2. Aplicar el ajuste técnico requerido.
3. Asegurar que el archivo conserve formato de fin de línea LF.
4. Ejecutar el refresco de Packwiz para actualizar su firma SHA-256 en `index.toml`:
   ```powershell
   pw refresh
   ```
5. Validar que la firma cambió correctamente con `git diff index.toml`.
6. Probar exportación a `.mrpack` e inspeccionar el archivo zip generado para certificar que el archivo modificado reside bajo `overrides/`.
7. Si el cambio afecta a los valores descritos en `README.md`, actualizar la sección correspondiente.
8. Confirmar y enviar el commit:
   ```powershell
   git add options.txt config/ index.toml pack.toml README.md
   git commit -m "feat(config): ajustar <parametro> en <archivo> para <beneficio>"
   ```

---

### Procedimiento 5: Publicación de una Nueva Versión (Release)

El modpack utiliza un pipeline de integración y entrega continua (CI/CD) completamente automatizado en GitHub Actions (`.github/workflows/release.yml`). 

Cuando se empuja un tag Git con prefijo `v` (por ejemplo, `v0.2.0`), el robot:
1. Descarga el repositorio y compila Packwiz en un entorno Linux aislado.
2. Ejecuta `packwiz refresh` y `packwiz modrinth export`.
3. Crea automáticamente una **GitHub Release** formal con el archivo `Keep Vanilla-X.Y.Z.mrpack` adjunto.
4. Publica la nueva versión directamente en **Modrinth** vinculándola al proyecto `keep-vanilla`, marcándola como versión destacada (*featured*) y publicando el archivo `.mrpack`.

#### Pasos para publicar una nueva versión:

1. **Asegurar que la rama `main` esté limpia y al día:**
   ```powershell
   git checkout main
   git pull origin main
   git status
   ```

2. **Determinar la nueva versión SemVer:**
   - **Patch (`0.2.1`):** Actualizaciones menores de mods, ajustes pequeños de configuración o parches de bugs.
   - **Minor (`0.3.0`):** Inclusión/reemplazo de nuevos mods, cambios estructurales en configuraciones o rediseño de UI.
   - **Major (`1.0.0`):** Hitos de madurez completa del modpack o migración mayor de versión de Minecraft.

3. **Actualizar el número de versión en `pack.toml`:**
   Edita la línea `version = "..."` con el nuevo número (ej. `"0.2.0"`):
   ```toml
   name = "Keep Vanilla"
   author = "Cesar Camilo"
   version = "0.2.0"
   pack-format = "packwiz:1.1.0"
   ```

4. **Sincronizar el índice de Packwiz:**
   ```powershell
   pw refresh
   ```

5. **Verificar la compilación localmente:**
   ```powershell
   pw modrinth export
   ```
   *(Eliminar el `.mrpack` local de prueba tras validar).*

6. **Confirmar los cambios de versión en Git:**
   ```powershell
   git add pack.toml index.toml
   git commit -m "chore(release): v0.2.0"
   git push origin main
   ```

7. **Crear y empujar el Tag Git anotado:**
   ```powershell
   git tag v0.2.0
   git push origin v0.2.0
   ```

8. **Monitorear el despliegue automático:**
   - Accede a la pestaña **Actions** en el repositorio de GitHub: `https://github.com/cesarcamiloig/keep-vanilla/actions`
   - Comprueba que el workflow **Publicar Release** termine con éxito (icono verde).
   - Verifica la publicación en GitHub Releases: `https://github.com/cesarcamiloig/keep-vanilla/releases`
   - Verifica la publicación en Modrinth: `https://modrinth.com/modpack/keep-vanilla`

---

### Procedimiento 6: Gestión de Pull Requests Automatizados de Dependencias

El flujo de trabajo `.github/workflows/update-mods.yml` se ejecuta automáticamente todos los lunes a las 12:00 UTC (o manualmente desde la pestaña *Actions* con *Run workflow*).

**Mecanismo de seguridad:**
El workflow contiene una compuerta que lee `pack.toml` y aborta inmediatamente si detecta que algún mod intentó alterar la versión base de Minecraft (`26.2`). Si todos los parches son seguros, el robot abre un Pull Request titulado:
`chore(deps): parches de mods detectados para Minecraft 26.2`

**Cómo procesar el Pull Request:**
1. Entrar en la pestaña **Pull Requests** del repositorio en GitHub.
2. Seleccionar el PR abierto por `github-actions[bot]`.
3. Ir a la pestaña **Files changed**:
   - Verificar que solo se modifican archivos `.pw.toml` en `mods/` y las firmas en `index.toml`.
   - Comprobar que en ningún `.pw.toml` se modifica la compatibilidad hacia versiones snapshot inestables.
4. Si todo es correcto, pulsar en **Merge pull request** (o **Squash and merge**).
5. En tu máquina local, sincroniza tu rama `main`:
   ```powershell
   git checkout main
   git pull origin main
   ```
6. Si las actualizaciones justifican una nueva versión pública, seguir el **Procedimiento 5** para lanzar una release de parche (ej. `v0.2.1`).

---

### Procedimiento 7: Migración a una Nueva Versión Mayor de Minecraft (Major Update)

Una migración a una nueva versión de Minecraft (ejemplo: de `26.2` a una futura versión) es un proceso **estrictamente manual**.

#### Checklist de viabilidad técnica antes de iniciar:
- [ ] Fabric Loader dispone de versión estable para la nueva versión de Minecraft.
- [ ] Fabric API cuenta con versión oficial publicada y probada.
- [ ] El motor gráfico central (**Sodium**) tiene build compatible estable.
- [ ] **Iris Shaders** y **Lithium** cuentan con versiones compatibles.
- [ ] **FerriteCore**, **ImmediatelyFast** y **Entity Culling** son compatibles.
- [ ] **Mod Menu** y **Cloth Config** están disponibles para la nueva versión.

#### Pasos para la migración:
1. Crear una rama dedicada a la migración:
   ```powershell
   git checkout -b migration/mc-<nueva-version>
   ```
2. Modificar la clave de Minecraft en `pack.toml`:
   ```toml
   [versions]
   fabric = "<version-fabric>"
   minecraft = "<nueva-version>"
   ```
3. Actualizar la compuerta de seguridad en `.github/workflows/update-mods.yml`:
   Modificar la comprobación `if [ "$MC_VERSION" != "26.2" ]; then` con la nueva versión objetivo.
4. Actualizar la clave `game-versions` en `.github/workflows/release.yml`.
5. Ejecutar la actualización masiva de mods contra la nueva versión:
   ```powershell
   pw update --all
   ```
6. Si algún mod no dispone de actualización automática o falló el endpoint, actualizar su slug manualmente o deshabilitarlo temporalmente hasta que el autor publique la actualización.
7. Refrescar índices:
   ```powershell
   pw refresh
   ```
8. Realizar una exportación de prueba y probar el `.mrpack` resultante en una instancia limpia de Prism Launcher o Modrinth App:
   - Comprobar que el juego arranca sin bloqueos (*crash-reports*).
   - Revisar `logs/latest.log` verificando que no existan errores críticos de Mixin.
   - Entrar a un mundo de pruebas y verificar frametimes, shaders y mecánicas.
9. Actualizar toda la documentación (`README.md`, `POLITICA_VERSIONES.md`, etc.).
10. Abrir Pull Request, revisar exhaustivamente y fusionar en `main`.
11. Lanzar la nueva versión mayor mediante el **Procedimiento 5**.

---

## 6. Resolución de Problemas Frecuentes (Troubleshooting)

### Problema 1: "index.toml is out of date" o discrepancia de hashes
- **Causa:** Se modificó un archivo local (`options.txt`, archivo en `config/`, etc.) o se agregó un archivo sin refrescar Packwiz.
- **Solución:**
  ```powershell
  pw refresh
  ```
  Esto recalcula todos los hashes SHA-256 y sincroniza `index.toml` con el estado del árbol de trabajo.

### Problema 2: Error "The input device is not a TTY" en Docker
- **Causa:** Se ejecutó el alias `pw` (que contiene `-it`) dentro de un script de automatización o un pipeline donde no hay terminal interactiva.
- **Solución:** Ejecutar el comando de Docker directamente sin los modificadores `-i` y `-t`:
  ```powershell
  docker run --rm -v "${PWD}:/workspace" packwiz-cli refresh
  ```

### Problema 3: Error de autenticación en GitHub Actions al publicar en Modrinth
- **Causa:** El secret `MODRINTH_TOKEN` no está configurado en el repositorio de GitHub, o el token de Modrinth expiró / carece de permisos de escritura.
- **Solución:**
  1. Generar un nuevo token en Modrinth: **Settings -> Access Tokens** con permisos para modificar proyectos y versiones.
  2. Ir al repositorio en GitHub: **Settings -> Secrets and variables -> Actions**.
  3. Crear o actualizar el secret llamado `MODRINTH_TOKEN`.
  4. Re-ejecutar el trabajo fallido desde la pestaña *Actions*.

### Problema 4: Discrepancias de saltos de línea CRLF en Windows
- **Causa:** Git convirtió automáticamente los saltos de línea a CRLF al hacer checkout en Windows, alterando los hashes calculados por Packwiz.
- **Solución:**
  Asegurar que Git respete los saltos LF del repositorio ejecutando:
  ```powershell
  git config core.autocrlf input
  ```
  Y normalizar los archivos existentes comprobando que `.gitattributes` contenga `* text eol=lf`.

---

## 7. Tabla Resumen de Operaciones (Cheat Sheet)

| Operación | Comandos Principales | Archivos a Modificar / Revisar |
| :--- | :--- | :--- |
| **Añadir mod** | `pw modrinth add <slug>`<br>`pw refresh`<br>`pw modrinth export` | `mods/<slug>.pw.toml`<br>`index.toml`<br>`README.md` |
| **Actualizar todos los mods** | `pw update --all`<br>`pw refresh` | `mods/*.pw.toml`<br>`index.toml`<br>`pack.toml` |
| **Actualizar un mod** | `pw update <slug>`<br>`pw refresh` | `mods/<slug>.pw.toml`<br>`index.toml` |
| **Eliminar mod** | `pw remove <slug>`<br>`pw refresh` | `mods/<slug>.pw.toml` (borrado)<br>`config/` (limpieza)<br>`index.toml` |
| **Ajustar opciones / config** | Edición en archivo<br>`pw refresh` | `options.txt` o `config/*.json`<br>`index.toml` |
| **Lanzar Release** | Bumping en `pack.toml`<br>`pw refresh`<br>`git tag vX.Y.Z`<br>`git push origin vX.Y.Z` | `pack.toml`<br>`index.toml`<br>GitHub Actions (`release.yml`) |
| **Sincronizar hashes** | `pw refresh` | `index.toml`<br>`pack.toml` |
