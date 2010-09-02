#include <gtk/gtk.h>

#if !GTK_CHECK_VERSION(2, 14, 7)
// GTK_MINOR_VERSION <= 12

gdouble gtk_adjustment_get_upper( GtkWidget *w ) {
    gdouble d;
    
    g_object_get( G_OBJECT(w), "upper", &d );
    
    return d;
}

gdouble gtk_adjustment_get_lower( GtkWidget *w ) {
    gdouble d;
    
    g_object_get( G_OBJECT(w), "lower", &d );
    
    return d;
}

#endif

#if !GTK_CHECK_VERSION(2, 18, 5)

gboolean gtk_widget_get_sensitive( GtkWidget *widget ) {
	return GTK_WIDGET_SENSITIVE(widget);
}

void gtk_widget_get_allocation( GtkWidget *widget, GtkAllocation *allocation ) {
	*allocation = widget->allocation;
}

void gtk_file_chooser_set_create_folders( GtkFileChooser *chooser, gboolean create_folders ) {

}

gboolean gtk_file_chooser_get_create_folders( GtkFileChooser *chooser ) {
	return TRUE;
}

#endif
