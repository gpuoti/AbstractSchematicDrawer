import Point;
import Shape;
import std.conv;
import std.stdio;

class Rectangle : Shape {
	/*
		p +---------------------+ 
		  |                     |
		  |                     |
		  +---------------------+ q
	*/
	
	Point p;
	Point q;
	
	this(Point p1, Point p2){	
		p = p1.minX(p2);
		q = p1.minY(p2);
		
		if(p==q){
			writeln("inverting");
			auto tmp = new Point(p1.getX(), p2.getY());
			p2 = new Point(p2.getX(), p1.getY());
			p1 = tmp;
			p = p1.minX(p2);
			q = p1.minY(p2);
			writeln(to!string(p1) ~  "  " ~to!string(p2));
		}
	}
	
	Point[] vertices(){
		Point[] v;
		
		v ~= new Point(p);
		v ~= new Point(q.getX(), p.getY());
		v ~= new Point(q);
		v ~= new Point(p.getX(), q.getY());
		
		return v;
	}
	
	override bool contains(Point x){
		return p.minX(x) == p && x.minX(q) == x && q.minY(x)== q && x.minY(p) == x;
	}
	
	override bool containsPoint(Point x){ 
		return contains(x) &&( x.getX() == p.getX() || x.getY() == p.getY() || x.getX() == q.getX() || x.getY() == q.getY());
	}
	
	void move(Vector v){
		p.move(v);
		q.move(v);
	}
	
	void scale (double factor){
		p = p* factor;
		q = q* factor;
	}
	
	override string toString(){
		return "Rectangle  [" ~ to!string(p) ~ "  " ~ to!string(q);
	}
	
	override Rectangle bounds(){
		return this;
	}
	
}


unittest {
	import dunit.toolkit;
	import std.stdio;
	
	
	Point p1 = new Point (-1,-1);
	Point p2 = new Point (1,2);
	
	Point q1 = new Point (1,-1);
	Point q2 = new Point (-1,2);
	
	Point p3 = new Point (1,1);
	
	Rectangle r = new Rectangle(p1,p2);
	
	writeln(to!string(r));
	r.vertices().assertHasValue(p1);
	r.vertices().assertHasValue(p2);
	r.vertices().assertHasValue(q1);
	r.vertices().assertHasValue(q2);
	
	r.contains(p3).assertTrue();
	r.contains(new Point(1,-1.1)).assertFalse();
	r.contains(new Point(0,-1)).assertTrue();
	r.containsPoint(new Point(0,-1)).assertTrue();
	r.containsPoint(new Point(1,-1.1)).assertFalse();
	
}