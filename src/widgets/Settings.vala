using Gtk;


public class Dadao.Settings : Gtk.ApplicationWindow {
   public Settings() {
   }

   construct {
      title = "Settings";
      var tmp = new Label("test");
      add(tmp);
      show_all();
   }
}
