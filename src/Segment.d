import Measurable1D;
import Vector;

class Segment : Vector, Measurable1D{
	
	public:
	
		/** Basic Segment objects construction needs the two points defining the segment. */
		this(Point p1, Point p2){
			super(p1, p2);
		}
		
		/** As they are Measurable1D, you can get the lenght of the segment calling len() method. */
		double len(){
			return getModule();
		}
		
		/** As Measurable1D you can get the point on the segment given a percentual of it's lenght */
		Point pointAtLen(double l){
			Vector v = new Vector(this);
			v.scale(l);
			return v.getArrow();		
		}
} 