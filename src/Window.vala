using Gtk;
using GtkLayerShell;
using i3ipc;

public class Dadao.Window: Gtk.ApplicationWindow{

    private Gtk.Box workspace_box;
    private Gtk.Box main_box;
    private Label date_label;
    private i3ipc.Connection connection;


    public Window(Gtk.Application app){
        Object(
            application:app
        );
        
    }
    construct{
        // Gtk layer shell stuff
        GtkLayerShell.init_for_window(this);
        GtkLayerShell.auto_exclusive_zone_enable(this);
        GtkLayerShell.set_margin(this, GtkLayerShell.Edge.TOP, 1);
        GtkLayerShell.set_margin(this, GtkLayerShell.Edge.BOTTOM, 1);

        GtkLayerShell.set_anchor(this, GtkLayerShell.Edge.BOTTOM, true);
        GtkLayerShell.set_anchor(this, GtkLayerShell.Edge.LEFT, true);
        GtkLayerShell.set_anchor(this, GtkLayerShell.Edge.RIGHT, true);


        main_box = new Box(Gtk.Orientation.HORIZONTAL,5);
        workspace_box = new Box(Gtk.Orientation.HORIZONTAL,5);

        date_label = new Label("");
        Timeout.add_seconds(1, update_date_label,Priority.LOW);
        main_box.pack_end(date_label,false,true,0);

        var menu_button = new Button.with_label("Menu");
        menu_button.clicked.connect(run_menu);
        main_box.pack_start(menu_button,false,true,0);
        main_box.pack_start(workspace_box,false,true,0);
        
        // ipc
        connection = new Connection(null);
        var ws_event=connection.subscribe(i3ipc.Event.WORKSPACE);
        connection.workspace.connect(update_workspace_buttons);

        add(main_box);
        update_workspace_buttons();
    }
    private void run_menu(){
        print("menu...\n");
    }

    private bool update_date_label(){
        var time = new DateTime.now_local().format ("%x %X").to_string();
        date_label.label = time;
        return true;
    }
    private void update_workspace_buttons(){
        workspace_box.foreach((el)=>{workspace_box.remove(el);});
        foreach (var workspace in connection.get_workspaces()){
            var workspace_btn = new Button.with_label(workspace.name);
            workspace_btn.clicked.connect(()=>{
                connection.message(
                    i3ipc.MessageType.COMMAND, 
                    @"workspace $(workspace.name)"
                );
            });
            workspace_box.add(workspace_btn);
        }
        show_all();

    }
}