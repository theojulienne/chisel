#if !GTK_CHECK_VERSION(2, 14, 7)

#define gtk_widget_get_allocation(w,x) *(x) = GTK_WIDGET(w)->allocation

#define gtk_widget_get_sensitive(x) GTK_WIDGET_SENSITIVE(x)

gdouble gtk_adjustment_get_upper( GtkWidget *w );
gdouble gtk_adjustment_get_lower( GtkWidget *w );

#endif

#if !GTK_CHECK_VERSION(2, 18, 5)

gboolean gtk_widget_get_sensitive( GtkWidget *widget );
void gtk_widget_get_allocation( GtkWidget *widget, GtkAllocation *allocation );

void gtk_file_chooser_set_create_folders( GtkFileChooser *chooser, gboolean create_folders );
gboolean gtk_file_chooser_get_create_folders( GtkFileChooser *chooser );

#endif

