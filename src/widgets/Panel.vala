using Gtk;
using GtkLayerShell;
using i3ipc;

public class Dadao.Panel : Gtk.ApplicationWindow {
   public string output_monitor;

   private Gtk.Box workspace_box;
   private Gtk.Box main_box;
   private Label date_label;
   private Gtk.Window settings_window;


   public Panel(Gtk.Application app, bool main_panel) {
      Object(
         application: app
         );
   }
   construct {
      // Gtk layer shell stuff
      GtkLayerShell.init_for_window(this);
      GtkLayerShell.auto_exclusive_zone_enable(this);
      GtkLayerShell.set_margin(this, GtkLayerShell.Edge.TOP, 1);
      GtkLayerShell.set_margin(this, GtkLayerShell.Edge.BOTTOM, 1);

      GtkLayerShell.set_anchor(this, GtkLayerShell.Edge.BOTTOM, true);
      GtkLayerShell.set_anchor(this, GtkLayerShell.Edge.LEFT, true);
      GtkLayerShell.set_anchor(this, GtkLayerShell.Edge.RIGHT, true);

      main_box      = new Box(Gtk.Orientation.HORIZONTAL, 0);
      workspace_box = new Box(Gtk.Orientation.HORIZONTAL, 0);

      var menu_button = new Button.with_label("Menu");
      menu_button.clicked.connect(run_menu);
      main_box.pack_start(menu_button, false, true, 0);
      main_box.pack_start(workspace_box, false, true, 0);

      var settings_button = new Button.from_icon_name("settings", Gtk.IconSize.BUTTON);
      settings_button.clicked.connect(open_settings_window);
      main_box.pack_end(settings_button, false, true, 0);

      date_label = new Label("");
      Timeout.add_seconds(1, update_date_label, Priority.LOW);
      main_box.pack_end(date_label, false, true, 0);

      add(main_box);
   }
   public void update_workspace_buttons(i3ipc.Connection connection) {
      workspace_box.foreach ((el) => { workspace_box.remove(el); }) {
         ;
      }
      try{
         connection.get_workspaces().foreach ((workspace) => {
            if (workspace.output == output_monitor) {
               var workspace_btn = new Button.with_label(workspace.name);
               workspace_btn.clicked.connect(() => {
                  switch_workspace(connection, workspace.name);
               });
               workspace_box.add(workspace_btn);
            }
         }) {
            ;
         }
      }catch (Error e) {
         stderr.printf(e.message);
      }

      show_all();
   }

   private void run_menu() {
      print("menu...\n");
      open_settings_window();
   }

   private bool update_date_label() {
      var time = new DateTime.now_local().format("%x %X").to_string();

      date_label.label = time;
      return(true);
   }

   private void switch_workspace(i3ipc.Connection connection, string name) {
      try{
         connection.message(
            i3ipc.MessageType.COMMAND,
            @"workspace $(name)"
            );
      }catch (Error e) {
         stderr.printf(e.message);
      }
   }

   private void open_settings_window() {
      settings_window = new Dadao.Settings();
   }
}
