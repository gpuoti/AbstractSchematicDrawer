import std.conv;
import std.stdio; 
import Point;
import Polyline;
import std.algorithm;

version(unittest){
	import dunit.toolkit;
}

/** For the purposes of this library a Polygon is a closed Polyline so it is basically constructed from a polilyne
	adding a last segment from the last to the first edge. */
 
class Polygon : Polyline {
	
	/** Construct the Polygon by cloning the given polyline and adding to it a last segment 
		from the last to the first edge of the polyline */ 
	this(Polyline p){
		super(p); 
		close();	
	}
	
	this(Polygon p){
		super(p);
	}
	
	private void close(){
		add(new Segment(pointAtLen(len()), pointAtLen(0.0)) );
	} 
	
	/** Check if a given point is inside the polygon's area*/
	override bool contains(Point p){
		Point[] intersectionPoints = intersect(new Line(0, p.getY()));
	
		auto c = count!(delegate (Point q){return q.getX() >= p.getX();} ) (intersectionPoints);
		return c % 2 == 1;
	}
	
	
}


unittest{
	
	Point p1 = new Point (-3, 3);
	Point p2 = new Point ( 4, 3);
	Point p3 = new Point ( 4,-1);
	Point p4 = new Point (-3,-1);
	Polyline poly = new Polyline(p1,p2);
	
	Point w1 = new Point (-2, -2);
	Point w2 = new Point ( 2, 2);
	Point w3 = new Point ( 1, 1);
	Polyline poly2 = new Polyline(w1,w2);
	poly2.add(new Segment(w2,w3));
	
	Point q = new Point (1,1);
	Point q2 = new Point (-3,2);
	
	poly.add(new Segment(p2,p3));
	poly.add(new Segment(p3,p4));
	Polygon polygon = new Polygon(poly);
	
	polygon.contains(q).assertTrue( "Point " ~ to!string(q) ~ " is expected to be within rectangle (-3,3) (4,3) (4,-1) (-3, -1) (-3,-3) ");
	polygon.contains(q2).assertFalse( "Point " ~ to!string(q2) ~ " is expected to be within rectangle (-3,3) (4,3) (4,-1) (-3, -1) (-3,-3) ");
	polygon.contains(w1).assertTrue();
	polygon.contains(w2).assertTrue();
	polygon.contains(w3).assertTrue();
	polygon.containsShape!Polyline(poly2).assertTrue();
	polygon.containsShape!Polyline(poly2).assertTrue();
}