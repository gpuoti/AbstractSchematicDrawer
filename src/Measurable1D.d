import Point;

interface Measurable1D {
	
	/** via this method Measurable1D objects are measured. */
	double len();
	
	/** via this method you can obtain the point on the object at given len. */
	Point pointAtLen(double l);
	
	final pointAt(double l)
	in{
		assert (l>=0);
		assert (l<=1);
	}
	body{
		return pointAtLen(l*len());
	}
	
	final normalizedLen(double l)
	in{
		assert (l>=0);
		assert (l<=len());
	}
	body{
		return l/len();
	}
	
	
}