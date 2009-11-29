#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <glib-object.h>
#include <gtk/gtktreemodel.h>
#include <gtk/gtk.h>

#include <chisel-native.h>
#include <chisel-native-ui.h>

#include <chisel-native-view.h>
#include <chisel-native-treeview.h>

#include "treeview.h"

static void tree_model_init( GtkTreeModelIface *iface );

G_DEFINE_TYPE_EXTENDED (ChiselTreeStore, chisel_tree_store, G_TYPE_OBJECT, 0,
						G_IMPLEMENT_INTERFACE (GTK_TYPE_TREE_MODEL, tree_model_init));

#define TREE_STORE_PRIVATE(o) \
		(G_TYPE_INSTANCE_GET_PRIVATE ((o), \
		CHISEL_TYPE_TREE_STORE, \
		ChiselTreeStorePrivate))

typedef struct _ChiselTreeStorePrivate ChiselTreeStorePrivate;

struct _ChiselTreeStorePrivate
{
	gint stamp;
	GType g_type;
};

static void chisel_tree_store_get_property( GObject *object, guint property_id, GValue *value, GParamSpec *pspec ) {
	G_OBJECT_WARN_INVALID_PROPERTY_ID( object, property_id, pspec );
}

static void chisel_tree_store_set_property( GObject *object, guint property_id, const GValue *value, GParamSpec *pspec ) {
	G_OBJECT_WARN_INVALID_PROPERTY_ID( object, property_id, pspec );
}

static void chisel_tree_store_dispose( GObject *object ) {
	if ( G_OBJECT_CLASS(chisel_tree_store_parent_class)->dispose )
		G_OBJECT_CLASS(chisel_tree_store_parent_class)->dispose( object );
}

static void chisel_tree_store_finalize( GObject *object ) {
	G_OBJECT_CLASS(chisel_tree_store_parent_class)->finalize( object );
}

static void chisel_tree_store_class_init( ChiselTreeStoreClass *klass ) {
	GObjectClass *object_class = G_OBJECT_CLASS (klass);
	
	g_type_class_add_private( klass, sizeof(ChiselTreeStorePrivate) );
	
	object_class->get_property = chisel_tree_store_get_property;
	object_class->set_property = chisel_tree_store_set_property;
	object_class->dispose = chisel_tree_store_dispose;
	object_class->finalize = chisel_tree_store_finalize;
}

static GtkTreeModelFlags get_flags( GtkTreeModel *tree_model ) {
	return 0;
}
 
static gboolean get_iter( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreePath *path ) {
	g_return_val_if_fail (CHISEL_IS_TREE_STORE (tree_model), FALSE);
	
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	gint *indices = gtk_tree_path_get_indices (path);
	gint depth = gtk_tree_path_get_depth (path);
	
	if (depth == 0)
		return FALSE;
	
	return FALSE; // return TRUE if iter filled in
}

static gint get_n_columns( GtkTreeModel *tree_model ) {
	return 1;
}

static GType get_column_type( GtkTreeModel *tree_model, gint index ) {
	return G_TYPE_STRING;
}

static gboolean iter_next( GtkTreeModel *tree_model, GtkTreeIter *iter ) {
	g_return_val_if_fail (CHISEL_IS_TREE_STORE (tree_model), FALSE);
	
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	g_return_val_if_fail (iter->stamp == priv->stamp, FALSE);
	
	return FALSE; // true if iter now points to the next item
}

static gboolean iter_nth_child( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent, gint n ) {
	g_return_val_if_fail (CHISEL_IS_TREE_STORE (tree_model), FALSE);
	
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	
	return FALSE; // true if iter now points to the Nth child of parent
}
 
static void get_value( GtkTreeModel *tree_model, GtkTreeIter *iter, gint column, GValue *value ) {
	g_return_if_fail (CHISEL_IS_TREE_STORE (tree_model));
	
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	g_return_if_fail (priv->stamp == iter->stamp);
	
	g_value_set_string( value, "lulz" );
}
 
static gboolean iter_children( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent ) {
	return FALSE;
}

static gboolean iter_has_child( GtkTreeModel *tree_model, GtkTreeIter *iter ) {
	return FALSE;
}

static int iter_n_children( GtkTreeModel *tree_model, GtkTreeIter *iter ) {
	g_return_val_if_fail (CHISEL_IS_TREE_STORE (tree_model), 0);

	if (iter)
		return 0;
	
	return 0;
}
 
static gboolean iter_parent( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent ) {
	return FALSE;
}

static GtkTreePath *get_path( GtkTreeModel *tree_model, GtkTreeIter *iter ) {
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	g_return_val_if_fail (priv->stamp == iter->stamp, NULL);
	
	gint index = GPOINTER_TO_INT (iter->user_data);
	return gtk_tree_path_new_from_indices (index - 1, -1);
}
 
static void tree_model_init( GtkTreeModelIface *iface ) {
	iface->get_flags = get_flags;
	iface->get_iter = get_iter;
	iface->get_n_columns = get_n_columns;
	iface->get_column_type = get_column_type;
	iface->iter_next = iter_next;
	iface->iter_nth_child = iter_nth_child;
	iface->get_value = get_value;
	iface->iter_children = iter_children;
	iface->iter_has_child = iter_has_child;
	iface->iter_n_children = iter_n_children;
	iface->iter_parent = iter_parent;
	iface->get_path = get_path;
}
 
static void chisel_tree_store_init( ChiselTreeStore *self ) {
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (self);
	
	priv->stamp = g_random_int ();
}
 
ChiselTreeStore *chisel_tree_store_new( void ) {
	return g_object_new (CHISEL_TYPE_TREE_STORE, NULL);
}

native_handle _chisel_native_treeview_create( ) {
	GtkWidget *treeview = gtk_tree_view_new( );
	
	ChiselTreeStore *model = chisel_tree_store_new( );
	
	gtk_tree_view_set_model( GTK_TREE_VIEW(treeview), GTK_TREE_MODEL(model) );
	
	return (native_handle)treeview;
}

void _chisel_native_treeview_prepare( native_handle native ) {
	
}

void _chisel_native_treeview_reload( native_handle native ) {
	
}

void _chisel_native_treeview_add_column( native_handle ntreeview, native_handle ncolumn ) {
	gtk_tree_view_append_column( GTK_TREE_VIEW(ntreeview), GTK_TREE_VIEW_COLUMN(ncolumn) );
}

void _chisel_native_treeview_remove_column( native_handle ntreeview, native_handle ncolumn ) {
	gtk_tree_view_remove_column( GTK_TREE_VIEW(ntreeview), GTK_TREE_VIEW_COLUMN(ncolumn) );
}

void _chisel_native_treeview_set_reorder_columns( native_handle ntreeview, int flag ) {
	
}

int _chisel_native_treeview_get_reorder_columns( native_handle ntreeview ) {
	return 0;
}

void _chisel_native_treeview_set_resize_columns( native_handle ntreeview, int flag ) {
	
}

int _chisel_native_treeview_get_resize_columns( native_handle ntreeview ) {
	return 0;
}

void _chisel_native_treeview_set_outline_column( native_handle ntreeview, native_handle ncolumn ) {
	
}

native_handle _chisel_native_treeview_get_outline_column( native_handle ntreeview ) {
	return NULL;
}

void _chisel_native_treeview_set_multiple_selection( native_handle ntreeview, int flag ) {
	
}

int _chisel_native_treeview_get_multiple_selection( native_handle ntreeview ) {
	return 0;
}

void _chisel_native_treeview_set_empty_selection( native_handle ntreeview, int flag ) {
	
}

int _chisel_native_treeview_get_empty_selection( native_handle ntreeview ) {
	return 0;
}

native_handle _chisel_native_treeview_get_selected_rows( native_handle ntreeview ) {
	return NULL;
}

