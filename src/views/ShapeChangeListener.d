import dunit.mockable;

/** General interface to let any actual view builder be used with an uniform interface.
	OutType is the kind of output the builder is expected to create.
 */
 
interface ModelChangeListener (ObjectType) {
	/** build is the method called to actually build the representation of an object of any type.
		Specializations may be available for any object type used as parameter in a call. */
	
	void update (ObjectType obj); 
	mixin Mockable!ModelChangeListener;
	
	
}