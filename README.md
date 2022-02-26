# Dadao
Sway panel written in Vala.

Version 0.0.1 (pre alpha quality).

## Build
### ubuntu
```sh
sudo apt install ...
```
### fedora
```sh
sudo dnf install meson gtk3-devel gtk3-devel-docs gtk-doc dh-autoreconf json-glib-devel gobject-introspection-devel vala wayland-protocols-devel

# compile i3ipc and gtk-layer-shell
# in case of GIR file error
# sudo cp /usr/share/gir-1.0/i3ipc-1.0.gir  /usr/share/gir-1.0/i3ipc-glib-1.0.gir # might not work
```

### meson
```sh
meson --prefix=/usr
ninja -C build

sudo ninja -C build install 
# or
./build/src/com.github.asadafasab.dadao
```


## Contribute

to do

### Formatting
```sh
uncrustify -c uncrustify.cfg --replace src/*/*.vala src/*.vala
```
