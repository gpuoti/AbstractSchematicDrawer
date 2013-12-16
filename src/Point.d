import std.math;
import std.conv;

import Movable;

/** Class Point definition. A Pointer as a movable behavior. */
class Point : Movable{

private:
	double x;
	double y;

public:
	
	/** construct a Point given its coordinates */ 
	this(double coordX, double coordY){		
		x = coordX;
		y = coordY;
	}
	
	/** Allows to construct copies of the same point. That is Overlapped points are allowed. */
	this(Point other){
		x = other.x;
		y = other.y;
	}
	
	/** Allows to read point's X coordinate.  */
	double getX(){
		return x;
	}
	
	/** Allows to read point's Y coordinate.  */
	double getY(){
		return y;
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

	
	override bool opEquals(Object other){
		Point p2 = cast(Point)(other);
		return p2 && x == p2.getX() && y == p2.getY();		
	}
	
	/** Get a string rappresentation of the vector. */
	override string toString(){
		string s;
		s = std.string.format( "(%.1f, %.1f)", x, y );
		return s;
	}
}


unittest{
	import std.stdio;
	writeln("\nPoint unittest");
	writeln("--------------\n\n");
	Point p1 = new Point(0,4);
	Point p2 = new Point(-3,2);
	
	write("Test basic operations...");
	assert(p1.getX() == 0, "(0,4) getX expected to be 0");
	assert(p1.getY() == 4, "(0,4) getX expected to be 4");
	assert(p2.getX() == -3,"(-3,2) getX expected to be -3");
	assert(p2.getY() == 2, "(-3,2) getX expected to be 2");
	writeln("Ok");
	
	write("Test Distance Calculation...");
	Vector v = new Vector(new Point(0,0), new Point(2,1)); 
	assert(abs( p1.distance(p2) -3.60555) < 0.00001, "(0,4) distance from (-3, 2) is supposed to be 3.6055\n indeed the calculated is " ~ to!string(p1.distance(p2))   );
	writeln("Ok");
	
	write("Test Move Operation...");
	p1.move(v);
	assert(abs(p1.distance(new Point(2, 5))) < 0.00001, "Moving (0,4) by (2,1) expected resulting distance from (2,5) about zero indeed the calculated is " ~ to!string(p1.distance(new Point(2,5))) );
	writeln("Ok");
	
	write("Test equality operator...");
	assert (p2 == new Point (-3,2), "broken equality operator");
	writeln("Ok");
	
	
	
	

}