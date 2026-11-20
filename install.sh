#!/bin/sh
set -eu

main() {
    command -v bash >/dev/null 2>&1 || {
        printf '%s\n' 'Instala Bash antes de continuar.' >&2
        exit 1
    }

    bin_dir=${SCRIPTS_BIN_DIR:-${HOME:?Define HOME o SCRIPTS_BIN_DIR.}/.local/bin}
    case $bin_dir in
        /*) ;;
        *) bin_dir=$PWD/$bin_dir ;;
    esac

    for script in batch clip; do
        target=$bin_dir/$script
        if [ -L "$target" ] || { [ -e "$target" ] && [ ! -f "$target" ]; }; then
            printf 'No se puede reemplazar %s.\n' "$target" >&2
            exit 1
        fi
    done

    mkdir -p "$bin_dir"
    staging_dir=$(mktemp -d "$bin_dir/.scripts.XXXXXXXX")
    trap 'rm -rf "$staging_dir"' EXIT
    trap 'exit 1' HUP INT TERM

    curl -fsSL --retry 3 -o "$staging_dir/scripts.tar.gz" \
        'https://codeload.github.com/mariano-soto/scripts/tar.gz/refs/heads/main'
    tar -xzf "$staging_dir/scripts.tar.gz" -C "$staging_dir" \
        scripts-main/batch scripts-main/clip

    for script in batch clip; do
        bash -n "$staging_dir/scripts-main/$script"
        chmod 755 "$staging_dir/scripts-main/$script"
    done
    for script in batch clip; do
        mv -f "$staging_dir/scripts-main/$script" "$bin_dir/$script"
    done

    printf 'Se instalaron batch y clip en %s.\n' "$bin_dir"
    case :${PATH:-}: in
        *:"$bin_dir":*) ;;
        *) printf 'Agrega %s a tu PATH.\n' "$bin_dir" ;;
    esac
}

main
