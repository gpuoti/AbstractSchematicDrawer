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
		
		if(p.equals(q)){ 
			auto tmp = new Point(p1.getX(), p2.getY());
			p2 = new Point(p2.getX(), p1.getY());
			p1 = tmp;
			p = p1.minX(p2);
			q = p1.minY(p2);
		}
	}
	
	this(const ref Rectangle other){
		p = new Point(other.p);
		q = new Point(other.q);
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
	
	override string toString() const {
		return "Rectangle  [ " ~ to!string(p) ~ "  " ~ to!string(q) ~ " ]";
	}
	
	override Rectangle bounds(){
		return this;
	}
	
	double bottom(){
		return q.getY();
	}
	
	double top(){
		return p.getY();
	}
	
	double left(){
		return p.getX();
	}
	
	double right(){
		return q.getX();
	}
	
	bool collides(Rectangle r){
		return (left <= r.right && r.left <= right && top >= r.bottom && r.top >= bottom);
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

unittest{
	import dunit.toolkit;
	Rectangle r = new Rectangle(new Point(0, 0), new Point(1, 1));
	
	auto collidingRegion = new Rectangle(new Point(-0.1, -0.9), new Point(0.1, 0.9) );
	auto notCollidingRegion = new Rectangle(new Point(-2, -2), new Point(-1, -1) );
	
	r.collides(collidingRegion).assertTrue;
}