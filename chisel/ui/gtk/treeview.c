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

/* Returns a set of flags supported by this interface.
 * The flags are a bitwise combination of GtkTreeModelFlags.
 * The flags supported should not change during the lifecycle
 * of the tree_model. */
static GtkTreeModelFlags get_flags( GtkTreeModel *tree_model ) {
	return 0;
}

static gboolean iter_nth_child( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent, gint n );

/* Sets iter to a valid iterator pointing to path. */
static gboolean get_iter( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreePath *path ) {
	g_return_val_if_fail (CHISEL_IS_TREE_STORE (tree_model), FALSE);
	
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	gint *indices = gtk_tree_path_get_indices (path);
	gint depth = gtk_tree_path_get_depth (path);
	
	//printf( "get_iter( %p, %p, %p )\n", tree_model, iter, path );
	
	GtkTreeIter parent_node;
	GtkTreeIter *parent = NULL;
	int i;
	for ( i = 0; i < depth; i++ ) {
		GtkTreeIter child;
		if ( !iter_nth_child( tree_model, &child, parent, indices[i] ) ) {
			//printf( " -- could not find child!\n" );
			return FALSE;
		}
		parent_node = child;
		parent = &parent_node;
	}
	
	*iter = parent_node;
	
	assert( iter->stamp == priv->stamp );
	
	return TRUE;
}

/* Returns the number of columns supported by tree_model. */
static gint get_n_columns( GtkTreeModel *tree_model ) {
	return 1;
}

/* Returns the type of the column. */
static GType get_column_type( GtkTreeModel *tree_model, gint index ) {
	return G_TYPE_STRING;
}

static gboolean iter_nth_child( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent, gint n );

/* Sets iter to point to the node following it at the current level.
 * If there is no next iter, FALSE is returned and iter is set to be invalid. */
static gboolean iter_next( GtkTreeModel *tree_model, GtkTreeIter *iter ) {
	g_return_val_if_fail (CHISEL_IS_TREE_STORE (tree_model), FALSE);
	
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	g_return_val_if_fail (iter->stamp == priv->stamp, FALSE);
	
	native_handle item = iter->user_data;
	int index = (int)g_object_get_data( G_OBJECT(item), "chisel-treemodel-index" );
	native_handle parent = g_object_get_data( G_OBJECT(item), "chisel-treemodel-parent" );
	
	index++;
	
	GtkTreeIter iparent_, *iparent;
	iparent = &iparent_;
	iparent->stamp = priv->stamp;
	iparent->user_data = parent;
	
	if ( parent == NULL ) {
		iparent = NULL;
	}
	
	//printf( "iter_next( %p, %p ) -> %p, %d\n", tree_model, iter, iparent, index );
	return iter_nth_child( tree_model, iter, iparent, index );
}

/* Sets iter to be the child of parent, using the given index. The first
 * index is 0. If n is too big, or parent has no children, iter is set to 
 * an invalid iterator and FALSE is returned. parent will remain a valid 
 * node after this function has been called. As a special case, if parent 
 * is NULL, then the nth root node is set. */
static gboolean iter_nth_child( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent, gint n ) {
	g_return_val_if_fail (CHISEL_IS_TREE_STORE (tree_model), FALSE);
	
	//printf( "iter_nth_child( %p, %p, %p, %d )\n", tree_model, iter, parent, n );
	
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	if ( parent != NULL ) g_return_if_fail (priv->stamp == parent->stamp);
	
	native_handle treeview = g_object_get_data( G_OBJECT(tree_model), "chisel-treeview" );
	assert( treeview != NULL );
	
	native_handle nparent = NULL;
	
	if ( parent != NULL )
		nparent = parent->user_data;
	
	int numRootItems = _chisel_native_treeview_child_count_callback( treeview, nparent );
	
	if ( n >= numRootItems ) {
		//printf( " -> returning null\n\n" );
		iter->stamp = 0;
		return FALSE;
	}
	
	iter->stamp = priv->stamp;
	iter->user_data = _chisel_native_treeview_child_at_index_callback( treeview, nparent, n );
	g_object_set_data( G_OBJECT(iter->user_data), "chisel-treemodel-parent", nparent );
	g_object_set_data( G_OBJECT(iter->user_data), "chisel-treemodel-index", (void*)n );
	assert( parent == NULL || nparent != NULL );
	//printf( " -> returning object\n\n" );
	
	assert( iter->stamp == priv->stamp );
	assert( iter->user_data != NULL );
	return TRUE; // true if iter now points to the Nth child of parent
}

/* Initializes and sets value to that at column. When done with value, 
 * g_value_unset() needs to be called to free any allocated memory. */
static void get_value( GtkTreeModel *tree_model, GtkTreeIter *iter, gint column, GValue *value ) {
	assert( FALSE );
	
	g_return_if_fail (CHISEL_IS_TREE_STORE (tree_model));
	
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	g_return_if_fail (priv->stamp == iter->stamp);
	
	g_value_set_string( value, "lulz" );
}

/* Sets iter to point to the first child of parent. If parent has no 
 * children, FALSE is returned and iter is set to be invalid. parent 
 * will remain a valid node after this function has been called.
 *
 * If parent is NULL returns the first node, equivalent to 
 * gtk_tree_model_get_iter_first (tree_model, iter); */
static gboolean iter_children( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent ) {
	//printf( "iter_children( %p, %p, %p )\n", tree_model, iter, parent );

	return iter_nth_child( tree_model, iter, parent, 0 );
}

/* Returns TRUE if iter has children, FALSE otherwise. */
static gboolean iter_has_child( GtkTreeModel *tree_model, GtkTreeIter *iter ) {
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	g_return_if_fail (priv->stamp == iter->stamp);
	
	native_handle treeview = g_object_get_data( G_OBJECT(tree_model), "chisel-treeview" );
	assert( treeview != NULL );
	
	native_handle item = iter->user_data;
	
	//printf( "iter_has_child( %p, %p ), item=%p\n", tree_model, iter, item );
	
	return _chisel_native_treeview_item_expandable_callback( treeview, (native_handle)item ) &&
			_chisel_native_treeview_child_count_callback( treeview, (native_handle)item );
}

/* Returns the number of children that iter has. As a special case, 
 * if iter is NULL, then the number of toplevel nodes is returned. */
static int iter_n_children( GtkTreeModel *tree_model, GtkTreeIter *iter ) {
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	g_return_if_fail (priv->stamp == iter->stamp);
	
	native_handle treeview = g_object_get_data( G_OBJECT(tree_model), "chisel-treeview" );
	assert( treeview != NULL );
	
	//printf( "iter_n_children( %p, %p )\n", tree_model, iter );
	
	native_handle parent = NULL;
	
	if ( iter != NULL ) {
		parent = iter->user_data;
	}
	
	return _chisel_native_treeview_child_count_callback( treeview, parent );
}

/* Sets iter to be the parent of child. If child is at the toplevel, 
 * and doesn't have a parent, then iter is set to an invalid iterator 
 * and FALSE is returned. child will remain a valid node after this 
 * function has been called. */
static gboolean iter_parent( GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *child ) {
	//printf( "iter_parent( %p, %p, %p )\n", tree_model, iter, child );
	
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	g_return_if_fail (priv->stamp == child->stamp);
	assert( priv->stamp == child->stamp );

	native_handle item = child->user_data;
	native_handle nparent = g_object_get_data( G_OBJECT(item), "chisel-treemodel-parent" );
	
	if ( nparent != NULL ) {
		iter->stamp = priv->stamp;
		iter->user_data = nparent;
		
		assert( iter->stamp == priv->stamp );
		return TRUE;
	}
	
	return FALSE;
}

/* Returns a newly-created GtkTreePath referenced by iter. This path 
 * should be freed with gtk_tree_path_free(). */
static GtkTreePath *get_path( GtkTreeModel *tree_model, GtkTreeIter *iter ) {
	ChiselTreeStorePrivate *priv = TREE_STORE_PRIVATE (tree_model);
	g_return_val_if_fail (priv->stamp == iter->stamp, NULL);
	
	//printf( "get_path( %p, %p )\n", tree_model, iter );
	assert( FALSE );
	
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

static void _chisel_native_treeview_update_selection( native_handle ntreeview );

native_handle _chisel_native_treeview_create( ) {
	GtkWidget *scrollview = gtk_scrolled_window_new( NULL, NULL );
	GtkWidget *treeview = gtk_tree_view_new( );
	
	g_object_set_data( G_OBJECT(scrollview), "chisel-treeview-multiple-sel", (void*)0 );
	g_object_set_data( G_OBJECT(scrollview), "chisel-treeview-empty-sel", (void*)1 );
	
	gtk_scrolled_window_set_policy( GTK_SCROLLED_WINDOW(scrollview), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC );
	
	gtk_container_add( GTK_CONTAINER(scrollview), GTK_WIDGET(treeview) );
	g_object_set_data( G_OBJECT(scrollview), "chisel-treeview", treeview );
	gtk_widget_show( treeview );
	
	_chisel_native_treeview_update_selection( (native_handle)scrollview );
	
	return (native_handle)scrollview;
}

void _chisel_native_treeview_prepare( native_handle native ) {
	GtkWidget *treeview = g_object_get_data( G_OBJECT(native), "chisel-treeview" );

	ChiselTreeStore *model = chisel_tree_store_new( );
	g_object_set_data( G_OBJECT(model), "chisel-treeview", native );
	
	gtk_tree_view_set_model( GTK_TREE_VIEW(treeview), GTK_TREE_MODEL(model) );
}

void _chisel_native_treeview_reload( native_handle native ) {
	GtkWidget *treeview = g_object_get_data( G_OBJECT(native), "chisel-treeview" );

	GtkTreeModel *model = gtk_tree_view_get_model( GTK_TREE_VIEW(treeview) );
	gtk_tree_view_set_model( GTK_TREE_VIEW(treeview), NULL );
	gtk_tree_view_set_model( GTK_TREE_VIEW(treeview), GTK_TREE_MODEL(model) );
}

void _chisel_native_treeview_add_column( native_handle ntreeview, native_handle ncolumn ) {
	GtkWidget *treeview = g_object_get_data( G_OBJECT(ntreeview), "chisel-treeview" );
	
	gtk_tree_view_append_column( GTK_TREE_VIEW(treeview), GTK_TREE_VIEW_COLUMN(ncolumn) );
}

void _chisel_native_treeview_remove_column( native_handle ntreeview, native_handle ncolumn ) {
	GtkWidget *treeview = g_object_get_data( G_OBJECT(ntreeview), "chisel-treeview" );

	gtk_tree_view_remove_column( GTK_TREE_VIEW(treeview), GTK_TREE_VIEW_COLUMN(ncolumn) );
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

static void _chisel_native_treeview_update_selection( native_handle ntreeview ) {
	GtkWidget *treeview = g_object_get_data( G_OBJECT(ntreeview), "chisel-treeview" );
	
	int multiple = (int)g_object_get_data( G_OBJECT(ntreeview), "chisel-treeview-multiple-sel" );
	int empty = (int)g_object_get_data( G_OBJECT(ntreeview), "chisel-treeview-empty-sel" );
	
	GtkTreeSelection *sel = gtk_tree_view_get_selection( GTK_TREE_VIEW(treeview) );
	
	GtkSelectionMode mode = GTK_SELECTION_MULTIPLE;
	
	if ( !multiple ) {
		mode = empty ? GTK_SELECTION_SINGLE : GTK_SELECTION_BROWSE;
	}
	
	gtk_tree_selection_set_mode( GTK_TREE_VIEW(treeview), mode );
}

void _chisel_native_treeview_set_multiple_selection( native_handle ntreeview, int flag ) {
	g_object_set_data( G_OBJECT(ntreeview), "chisel-treeview-multiple-sel", (void*)flag );
	_chisel_native_treeview_update_selection( ntreeview );
}

int _chisel_native_treeview_get_multiple_selection( native_handle ntreeview ) {
	return (int)g_object_get_data( G_OBJECT(ntreeview), "chisel-treeview-multiple-sel");
}

void _chisel_native_treeview_set_empty_selection( native_handle ntreeview, int flag ) {
	g_object_set_data( G_OBJECT(ntreeview), "chisel-treeview-empty-sel", (void*)flag );
	_chisel_native_treeview_update_selection( ntreeview );
}

int _chisel_native_treeview_get_empty_selection( native_handle ntreeview ) {
	return (int)g_object_get_data( G_OBJECT(ntreeview), "chisel-treeview-empty-sel");
}

native_handle _chisel_native_treeview_get_selected_rows( native_handle ntreeview ) {
	return NULL;
}

