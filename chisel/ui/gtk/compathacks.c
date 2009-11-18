#include <gtk/gtk.h>

#if GTK_MINOR_VERSION <= 12

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

