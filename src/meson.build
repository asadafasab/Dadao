deps = [dependency('gtk+-3.0'), dependency('gtk-layer-shell-0'),dependency('glib-2.0'),dependency('i3ipc-glib-1.0'),dependency('json-glib-1.0')]

executable(
    meson.project_name(),
    'Main.vala',
    'Panels.vala',
    'widgets/Panel.vala',
    'widgets/Settings.vala',
    dependencies: deps,
    install:true,
    link_args: '-O3')