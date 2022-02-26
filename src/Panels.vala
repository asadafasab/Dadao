using Gtk;
using i3ipc;
using GtkLayerShell;
using Gdk;

public class Panels : Gtk.Application {
private i3ipc.Connection connection;
private Dadao.Panel[] panels;

public Panels () {
	Object (
		application_id: "com.github.asadafasab.dadao",
		flags : ApplicationFlags.FLAGS_NONE
		);
}

protected override void activate () {
	// ipc
	try {
		connection = new Connection (null);
		connection.subscribe (i3ipc.Event.WORKSPACE);
		connection.subscribe (i3ipc.Event.OUTPUT);
	} catch (Error e) {
		GLib.error (e.message);
	}
	connection.output.connect (update_panels);
	connection.workspace.connect (update_panels);

	// output(s)
	update_panels ();
}

private void update_workspaces () {
	foreach (var panel in panels)
		panel.update_workspace_buttons (connection);
}

private void update_panels () {
	string[] outputs = {};
	try {
		connection.get_outputs ().foreach ((el) => {
				outputs += el.name;
			})
			;
	} catch (Error e) {
		stderr.printf (e.message);
	}

	if (outputs.length == panels.length) {
		update_workspaces ();
	} else {
		for (var i = 0; i < panels.length; ++i)
			panels[i].destroy ();
		var default_out = Gdk.Display.get_default ();

		for (var i = 0; i < default_out.get_n_monitors (); i++) {
			var monitor = default_out.get_monitor (i);
			// monitor.is_primary();
			var panel = new Dadao.Panel (this, false);

			panel.output_monitor = outputs[i];
			GtkLayerShell.set_monitor (panel, monitor);
			panels += panel;
			var last = panels.length - 1;
			add_window (panels[last]);
			panels[last].update_workspace_buttons (connection);
		}
	}
}
}
