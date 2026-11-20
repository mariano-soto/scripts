# Scripts de terminal

- `batch` ejecuta comandos de Bash desde un archivo o una tubería e imprime cada comando junto con su salida.
- `clip` guarda y recupera texto por nombre en `~/.clip`. Sin argumentos, envía la entrada al búfer de tmux.

## Instalación

Necesitas `curl`, `tar` y Bash para instalar los scripts desde tu terminal.

```sh
curl -fsSL https://raw.githubusercontent.com/mariano-soto/scripts/main/install.sh | sh
```

El instalador copia ambos comandos a `~/.local/bin` sin `sudo`. Para actualizar, vuelve a ejecutar el mismo comando. La instalación reemplaza los archivos `batch` y `clip` que ya existan en el directorio de destino.

Si el directorio aún no está al inicio de tu `PATH`, agrega esta línea a `~/.zshrc` si usas Zsh o a `~/.bashrc` si usas Bash. Abre una terminal nueva para aplicar el cambio.

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Para instalar en otro directorio, usa `SCRIPTS_BIN_DIR` y agrega ese directorio a tu `PATH`.

```sh
curl -fsSL https://raw.githubusercontent.com/mariano-soto/scripts/main/install.sh | SCRIPTS_BIN_DIR="$HOME/bin" sh
```

## Uso de `batch`

```sh
batch comandos.txt
printf '%s\n' 'pwd' 'date' | batch
```

Cada línea se ejecuta en un proceso de Bash independiente. Un `cd` o una variable definida en una línea solo se aplica a esa línea. Usa un archivo de comandos de confianza.

## Uso de `clip`

```sh
printf '%s\n' 'Hola' | clip notas  # Guardar el clip notas
clip notas                       # Mostrar su contenido
clip --list                      # Listar los clips guardados
clip --delete notas              # Borrar el clip notas
```

También puedes usar un clip como entrada de otro comando. Este ejemplo guarda dos líneas de un registro y muestra solo la que empieza con `ERROR:`.

```sh
printf '%s\n' 'INFO: Conectando al servidor' 'ERROR: Se agotó el tiempo de espera' | clip error
clip error | grep '^ERROR:'
```

En una sesión de tmux, omite el nombre para cargar la entrada directamente en el búfer.

```sh
printf '%s\n' 'Hola, tmux' | clip
```
