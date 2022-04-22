#!/usr/bin/env sh

function mkvextract() {
    docker run -it --rm -w "$(pwd)" \
        -v "/path/to/data:/path/to/data" \
        thecatlady/mkvtoolnix mkvextract "$@"
}
function mkvinfo() {
    docker run -it --rm -w "$(pwd)" \
        -v "/path/to/data:/path/to/data" \
        thecatlady/mkvtoolnix mkvinfo "$@"
}
function mkvmerge() {
    docker run -it --rm -w "$(pwd)" \
        -v "/path/to/data:/path/to/data" \
        -v "~/Downloads:/share/Downloads" \
        thecatlady/mkvtoolnix mkvmerge "$@"
}
function mkvpropedit() {
    docker run -it --rm -w "$(pwd)" \
        -v "/path/to/data:/path/to/data" \
        thecatlady/mkvtoolnix mkvpropedit "$@"
}
