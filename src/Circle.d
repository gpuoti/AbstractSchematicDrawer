import Movable;
import Scalable;


import Point;
import Segment;
import Vector; 


import std.stdio;
import std.math;
import std.conv;

version (unittest){
	import dunit.toolkit;
}

/** Object of this class reppresentes, quite obviously 2D circles */ 
class Circle : Shape, Movable, Scalable{
	private Point c;
	private double r;
	
	private uint approxSteps = 16; 
	
	public:
	/** A Circle can be created given its center point and its radius */
	this(Point center, double ray){
		c = center;
		r = ray;
	}
	
	/**This methods will return a set of arbitrary points on the circumference but equally spaced.
	The number of returned points depends on the object setup, default is 16, but it can be set up by calling
	steps method specifying the required approxymation step required. */
	Point[] vertices(){
		double alphaStep = 2*PI / approxSteps;
		int step = 0;
		Point[] vertices;
		vertices.length = approxSteps;
		
		for(double alpha = 0; alpha<2*PI; alpha += alphaStep){
			auto p = new Point(c);
			Vector centerOffset = new Vector(new Point(), new Point( cos(alpha), sin(alpha)));
			centerOffset.scale(r);
			p.move(centerOffset);
			vertices[step++] = p;
			
		} 
		return vertices;
	}
	
	/** Retrieve the radius of the circle */
	double getRay() {
		return r;
	}
	
	/** Retrieve the center point of the circle */
	Point getCenter() {
		return c;
	}
	
	/** Sets the number of approximation steps to be used when the circle is approximated with polygon. */
	void steps(uint steps) { 
		approxSteps = steps;
	}
	
	/** As the circle is a shape, a point can be tested for containment in its area */
	bool contains(Point p){
		return p.distance(c) <= r;
	}
	
	/** As the circle is a shape, a point can be tested for containment in its perimeter */
	bool containsPoint(Point p){
		return p.distance(c) == r;
	}
	
	/** Circle objects are Moveable so, move method can be called to move the circle arround with a translate transform. */
	void move(Vector v){
		c.move(v);
	}
	
	/** Circle objects are Scalable so, scale method can be called to scale its radius */
	void scale(double factor){
		r *= factor;
	}
	
	
}

unittest {
	Point center = new Point(1,1);
	double ray = 1;
	
	Circle c = new Circle(center, ray);
	c.getCenter().assertEqual(center);
	c.getRay().assertEqual(ray);
}

unittest {
	Point center = new Point(1,1);
	double ray = 1;
	
	Circle c = new Circle(center, ray);
	c.scale(1.5);
	
	c.getRay().assertEqual(ray*1.5);
	c.getCenter.assertEqual(center);
}

unittest {
	Point center = new Point(1,1);
	double ray = 1;
	
	Circle c = new Circle(center, ray);
	Vector v = new Vector(new Point(0,0), new Point(-1,-1));
	c.move(v);
	c.getCenter().assertEqual(new Point(0,0));
	c.getRay().assertEqual(ray);
}

unittest {
	Point center = new Point(1,1);
	double ray = 1;
	
	Circle c = new Circle(center, ray);
	
	c.contains(new Point(0.5, 0.5)).assertTrue;
	c.contains(new Point(1.1, 0.5)).assertTrue;
	c.contains(new Point(0.0, 0.9)).assertFalse;
}

unittest {
	
	Point center = new Point(0,0);
	double ray = 1;
	
	Circle c = new Circle(center, ray);
	Point[] vs = c.vertices();
	
	// Every vertex shall solve the circumference equation x^2+y^2 = 1
	foreach (Point p; vs){
		string s = "returned point " ~ to!string(p); 
		p.distance(center).assertApprox(1.0, 0.0001,s);
		s = "the circle shall contain all its vertex\n" ~ "vertex " ~ to!string(p) ~ " is not recognized within the area of circle " ~ to!string(c); 
		c.contains(p).assertTrue(s);
		s = "the circle perimeter shall contain all its vertex\n" ~ "vertex " ~ to!string(p) ~ " is not recognized on the perimeter of circle " ~ to!string(c);
		c.containsPoint(p).assertTrue(s);
	} 
	
}


	