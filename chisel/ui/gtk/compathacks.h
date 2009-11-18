#if GTK_MINOR_VERSION <= 12

#define gtk_widget_get_allocation(w,x) *(x) = GTK_WIDGET(w)->allocation

#define gtk_widget_get_sensitive(x) GTK_WIDGET_SENSITIVE(x)

gdouble gtk_adjustment_get_upper( GtkWidget *w );
gdouble gtk_adjustment_get_lower( GtkWidget *w );

#endif
