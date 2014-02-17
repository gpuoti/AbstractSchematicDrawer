import Point;
import Line;
import Scalable;
import std.math;
import std.conv;

version(unittest){
	import dunit.toolkit;
	import Point;
}


class Vector : Scalable, Movable{
	private:
		Point o;
		Point arrow;
		
	
	public:
		/** Construct a vector given its base point and its arrow position */
		this(Point origin, Point arrowPoint){
			o = origin;
			arrow = arrowPoint;
		}
		
		this(Vector other){
			o = other.o;
			arrow = other.arrow;
		}
		
		/** Retrieve the base point of the vector */
		Point getOrigin(){
			return o;
		}
			
		/** Retrieve the arrow position of the vector */	
		Point getArrow(){
			return arrow;
		}
		
		/** Read the projection along X axis */ 
		double dx(){
			return arrow.getX() - o.getX();
		}
		
		/** Read the projection along Y axis */
		double dy(){
			return arrow.getY() - o.getY();
		}
		
		/** Get the actual line direction of the vector */
		Line getLine(){
			return new Line(o, arrow);
		}
		
		/** Calculate the module of the vector */
		double getModule(){
			return o.distance(arrow);
		}
		
		/** Get a vector rappresenting the actual versor of the vector */
		Vector getVersor(){
			double mod = getModule();
			Point versorArrow = new Point(dx()/mod, dy()/mod);
			versorArrow.move(new Vector(new Point(0,0), o));
			return new Vector(o, versorArrow); 
		}
		
		/** Get the slope of the line direction of this vector */
		double direction(){
			return dy() / dx();
		}
		
		/** Checks if two vector has equal slope, that is if they are parallel */
		bool equalDirection(Vector other){
			return other.direction() == direction();
		}
		
		/** implements the Scale interface. Scale the vector by the given factor */
		void scale(double factor){
			double x = arrow.getX() * factor;
			double y = arrow.getY() * factor;
			
			arrow = new Point(x, y);
			
			o = new Point( o.getX() * factor, o.getY()*factor);
		}
		
		/** Move the vector arround by appling a 2D translation to both base and arrow position. This implement the Movable interface. */
		void move(Vector v){
			o.move(v);
			arrow.move(v);
		}
		
		/** Make a vector opposite to this */
		Vector opNeg() {
			return new Vector(arrow, o);
		}
		
		/** Make a vector by summing this vector with the other given as parameter */
		Vector opAdd(Vector other) {
			Point newArrow = new Point(arrow);
		
			newArrow.move(other);
			return new Vector( o, newArrow );
		
		}
		
		/** Make a vector by subtracting this vector with the other given as parameter */
		Vector opSub(Vector other) {
			Point newArrow = new Point(arrow);
		
			newArrow.move(-other);
			return new Vector( o, newArrow );
		
		}
		
		/** Checks if two vector are equal by appling the natural equality relation:
			two vector are equal if have the same base and arrow point */
		override bool opEquals(Object other){
			Vector v2 = cast(Vector)(other);
			return v2 && o == v2.getOrigin() && arrow == v2.getArrow();
		}
		
		/** Make a readable reppresentation of the vector */ 
		override string toString(){
			string s;
			s = std.string.format("%s ---> %s", o.toString(), arrow.toString() );
			return s;
		}
		
}

int main(string[] args){
	return 0;
	
}


unittest{
	/** Check module and scale calculation on vector (0,0)-->(12,0)*/
	Vector v = new Vector(new Point(0,0), new Point (12, 0));
	
	v.dx().assertEqual(12);
	v.dy().assertEqual(0);
	v.getModule().assertEqual(12);
	
	v.scale(1.5);
	v.getModule().assertApprox(12*1.5);
	v.scale(0.6666667);
	v.getModule().assertApprox(12.0, 0.0001);
}

unittest{
	
	/** Check module and scale calculation on vector (10,5)-->(0,0) */
	Vector v = new Vector(new Point(10,5), new Point (0, 0));

	v.dx().assertApprox(-10.0);
	v.dy().assertApprox(-5.0);
	v.getModule().assertApprox(11.1803, 0.0001);
	
	v.scale(1.5);
	v.getModule().assertApprox(11.1803*1.5, 0.0001);
	v.scale(0.6666667);
	v.getModule().assertApprox(11.1803, 0.0001);
}

unittest{
	
	/** Check module and scale calculation on vector (5,1)-->(9,-1) */
	Vector v = new Vector(new Point(5,1), new Point (9, -1));

	v.dx().assertEqual(4.0);
	v.dy().assertEqual(-2.0);
	v.getModule().assertApprox(4.47214, 0.0001);
	
	v.scale(1.5);
	v.getModule().assertApprox(4.47214*1.5, 0.0001);
	v.scale(0.6666667);
	v.getModule().assertApprox(4.47214, 0.0001);
}


unittest{
	
	/** Check sum and difference operator, taken:
		v0 = (5,1)-->(9,-1)
		v2 = (0,0)-->(5,0)
		
	check that v = v0+v2 == (5,1)-->(14-1)
	and than that v-v2 == v0 	*/
	
	Vector v0 = new Vector(new Point(5,1), new Point (9, -1));
	Vector v = new Vector(new Point(5,1), new Point (9, -1));
	Vector v2 = new Vector(new Point(0,0), new Point (5, 0));
	Vector sum = new Vector(new Point(5,1), new Point (14,-1));
	
			
	v = v0+v2;
	v.dx().assertApprox(sum.dx(), 0.0001);
	v.dy().assertApprox(sum.dy(), 0.0001);
	v.getModule.assertApprox(sum.getModule(), 0.0001);
	
	v = v-v2;
	v.dx().assertApprox(v0.dx(), 0.0001);
	v.dy().assertApprox(v0.dy(), 0.0001);
	v.getModule().assertApprox(v0.getModule(), 0.0001);	
}

unittest{
	import std.stdio;
	
	Point p1 = new Point(4, 3);
	Point p2 = new Point(4,-1);
	
	Vector v = new Vector(new Point(4,3), new Point(4,-1));
	Line l = v.getLine();
	writeln("Line " ~ to!string(l));
}

