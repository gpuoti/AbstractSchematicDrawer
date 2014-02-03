import std.conv;
import Point;
import Polyline;

version(unittest){
	import dunit.toolkit;
}


class Polygon : Polyline {
	
	this(Polyline p){
		auto closerSegment = new Segment(p.pointAtLen(0), p.pointAtLen(1.0));
		while(p.countComponents()){
			Segment s = p.pop();
			add(s);
		}
		
		add(closerSegment);		
	}
	
	
}


unittest{
	Polygon poly;
	
	Point p1 = new Point (-3, 3);
	Point p2 = new Point ( 4, 3);
	Point p3 = new Point (-3,-1);
	Point p4 = new Point ( 4,-1);
	
	Point q = new Point (1,1);
	
	
	poly.add(new Segment(p1,p2));
	poly.add(new Segment(p2,p3));
	poly.add(new Segment(p3,p4));
	poly.close();
	
	assertTrue(poly.contains(q), "Point " ~ to!string(q) ~ " is expected to be within rectangle (-3,3) (4,3) (-3,-3) (4,-1)");
	
	
	
	
}