import Point;

interface Measurable1D {
	
	/** via this method Measurable1D objects are measured. */
	double len();
	
	/** via this method you can obtain the point on the object at given percentual of it's len. */
	Point pointAtLen(double l);
}