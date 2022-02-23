using Gtk;

public class Panel:Gtk.Application{
    public Panel(){
        Object(
            application_id:"com.github.asadafasab.dadao",
            flags:ApplicationFlags.FLAGS_NONE
        );
    }
    protected override void activate(){
        var window = new Dadao.Window(this);
        add_window(window);
    }
}