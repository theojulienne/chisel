G_BEGIN_DECLS

#define CHISEL_TYPE_TREE_STORE chisel_tree_store_get_type()

#define CHISEL_TREE_STORE(obj) ( \
		G_TYPE_CHECK_INSTANCE_CAST ((obj), \
		CHISEL_TYPE_TREE_STORE, \
		ChiselTreeStore))

#define CHISEL_TREE_STORE_CLASS(klass) ( \
		G_TYPE_CHECK_CLASS_CAST ((klass), \
		CHISEL_TYPE_TREE_STORE, \
		ChiselTreeStoreClass))

#define CHISEL_IS_TREE_STORE(obj) ( \
		G_TYPE_CHECK_INSTANCE_TYPE ((obj), \
		CHISEL_TYPE_TREE_STORE))

#define CHISEL_IS_TREE_STORE_CLASS(klass) ( \
		G_TYPE_CHECK_CLASS_TYPE ((klass), \
		CHISEL_TYPE_TREE_STORE))

#define CHISEL_TREE_STORE_GET_CLASS(obj) ( \
		G_TYPE_INSTANCE_GET_CLASS ((obj), \
		CHISEL_TYPE_TREE_STORE, \
		ChiselTreeStoreClass))

typedef struct _ChiselTreeStore ChiselTreeStore;
typedef struct _ChiselTreeStoreClass ChiselTreeStoreClass;

struct _ChiselTreeStore
{
	GObject parent;
};

struct _ChiselTreeStoreClass
{
	GObjectClass parent_class;
};

GType chisel_tree_store_get_type(void);
ChiselTreeStore *chisel_tree_store_new(void);

G_END_DECLS

