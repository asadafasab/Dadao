using Gtk;
using i3ipc;
using GtkLayerShell;
using Gdk;

public class Panels:Gtk.Application{
    private i3ipc.Connection connection;
    private Dadao.Panel[] panels;
    private Gdk.Monitor[] displays;

    public Panels(){
        Object(
            application_id:"com.github.asadafasab.dadao",
            flags:ApplicationFlags.FLAGS_NONE
        );
    }
    protected override void activate(){
        //ipc
        connection = new Connection(null);
        var ws_event = connection.subscribe(i3ipc.Event.WORKSPACE);
        connection.workspace.connect(update_workspaces);
        var out_event = connection.subscribe(i3ipc.Event.OUTPUT);
        connection.output.connect(update_panels);

        // output(s)
        update_panels();
        //  var window = new Dadao.Panel(this,true);
        //  add_window(window);
        //  window.update_workspace_buttons(connection);

    }
    private void update_workspaces(){
        foreach(var panel in panels){
            panel.update_workspace_buttons(connection);
        }
    }
    private void update_panels(){
        if (panels.length>0){
            //TODO iterate over panels...
            
        }else{
            var default_out = Gdk.Display.get_default();
            string[] outputs ={};
            connection.get_outputs().foreach((el)=>{
                outputs+=el.name;
            });
            
            for(var i=0;i<default_out.get_n_monitors();i++){
                var monitor=default_out.get_monitor(i);
                // monitor.is_primary();
                var panel = new Dadao.Panel(this,false);

                panel.output_monitor=outputs[i];
                GtkLayerShell.set_monitor(panel, monitor);
                panels+=panel;
                var last = panels.length-1;
                add_window(panels[last]);
                panels[last].update_workspace_buttons(connection);
            }
           
        }
    }
}