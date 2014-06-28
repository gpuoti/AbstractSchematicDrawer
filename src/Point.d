import std.math;
import std.conv;


import Movable;
import dunit.mockable;



/** Class Point definition. A Pointer as a movable behavior. */
class Point : Movable{
 
private:
	double x;
	double y;
	
	immutable static double eps = 0.0001;
	
	

public:
	const static Point ORIGIN = new Point(0,0);
	
	
	/** construct a Point given its coordinates */ 
	this(double coordX, double coordY){		
		x = coordX;
		y = coordY;
	}
	
	/** Allows to construct copies of the same point. That is Overlapped points are allowed. */
	this(const ref Point other){
		x = other.x;
		y = other.y;
	}  
	
	this(){
		this(0,0);
	}
	
	
	/** Allows to read point's X coordinate.  */
	double getX(){
		return x;
	}
	
	/** Allows to read point's Y coordinate.  */
	double getY(){
		return y;
	}
	
	/** Return the leftmost point between this and the other one */
	Point minX(Point other){
		if(getX() > other.getX()){
			return other;
		}
		return this;
	}
	
	/** Return the lower point between this and the other one */
	Point minY(Point other){
		if(getY() > other.getY()){
			return other;
		}
		return this;
	}
	
	/** Return the leftmost point between this and the other one */
	Point maxX(Point other){
		if(getX()< other.getX()){
			return other;
		}
		return this;
	}
	
	/** Return the lower point between this and the other one */
	Point maxY(Point other){
		if(getY() < other.getY()){
			return other;
		}
		return this;
	}
	
	/** Calculate the distance between the point to the other given as parameter */
	double distance(Point other){
		double d = pow( (x-other.x), 2) + pow( (y-other.y), 2);
		d = sqrt(d);
		return d;
		
	}
	
	/** Move the point by the vector given as parameter. */ 
	override void move(Vector v){
		
		x += v.dx();
		y += v.dy(); 
	}

	/** Two points are considered equal if their distance is less then epsilon */
	override bool opEquals(Object other){
		Point p2 = cast(Point)(other);
		return p2 && p2.distance(this)<eps ;		
	}
	
	/** Two points are considered equal if their distance is less then epsilon */
	bool equals(Object other){
		Point p2 = cast(Point)(other);
		return p2 && p2.distance(this)<eps ;		
	}
	
	
	/** Get a string rappresentation of the vector. */
	override string toString() const {
		string s;
		s = std.string.format( "(%.1f, %.1f)", x, y );
		return s;
	}
	import std.traits;
	
	Point opBinary(string op, T)(T n) if (isNumeric!T) {
		static if (op == "*"){
			x *= n;
			y *= n;
			return this;
		}
		else static assert(0, "Operator "~op~" not implemented");
	}

}


unittest {
	import dunit.toolkit;
	import std.conv;
	import std.stdio;
	
	Point pminx = new Point(0,9);
	Point pmaxx = new Point(9,0);
	
	pminx.maxX(pmaxx).assertEqual(pmaxx);
}


unittest{
	import dunit.toolkit;
	
	Point p = new Point(0,4);
	Point p2 = new Point(-3,2);
	
	p.getX().assertEqual(0);
	p.getY().assertEqual(4);
	p2.getX().assertEqual(-3);
	p2.getY().assertEqual(2);
	 
	p.distance(p2).assertApprox(3.6055, 0.0001);
	p2.distance(p).assertApprox(3.6055, 0.0001);
	
	Vector v = new Vector(new Point(0,0), new Point(2,1)); 
	p.move(v);
	p.distance(new Point(2, 5)).assertEqual(0);
	
	assertTrue(p2 == new Point (-3,2));
	
}

unittest{
	/** checks that two different point objects are equals if they rappresents the same geometrical point */
	import dunit.toolkit;
	Point p1 = new Point(2,3);
	Point p2 = new Point(2,3);
	
	assertEqual(p1,p2);
}

unittest{
	/** checks that two different point objects are different if they rappresents the same geometrical point */
	import dunit.toolkit;
	Point p1 = new Point(2,3);
	Point p2 = new Point(2,3.1);
	
	assertFalse(p1 == p2);
	assertTrue(p1 != p2);
}

unittest{
	import dunit.toolkit;
	Point p1 = new Point (1,1);
	Point p2 = new Point (-1,-1);
	Point p3 = new Point (-1,3);
	
	assertEqual(p1 * (1.5), new Point(1.5,1.5));
	assertEqual(p2 * (1.5), new Point(-1.5,-1.5));
	assertEqual(p3 * (1.5), new Point(-1.5,4.5));

}
