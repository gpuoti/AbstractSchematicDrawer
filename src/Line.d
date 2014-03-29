import Vector;
import Point;

import std.stdio;
import std.math;
import std.conv;

version (unittest){
	import dunit.toolkit;
}
class ParallelLineException : Exception{
			this(){
				super("");
			}
		}

class Line {
	private double a;
	private double b;
	private double c;
	
	public:
		
		/** Construct a line given its slope and the projection of its intersection point with the y axis. 
		@param m the line slope
		@param b the projection of the intersection point of the line with the y axis  */
		this(double m, double q){
			 a = m;
			 b = -1;
			 c = q;
		}
		
		/** Construct a line passing by the two given points */
		this(Point p1, Point p2){
			auto horizontal = p1.getY() == p2.getY();
			auto vertical 	= p1.getX() == p2.getX();
			
			if(horizontal){
				a = 0;
				b = -1;
				c = p1.getY();
			}
			else if(vertical){
				a = 1;
				b = 0;
				c = -p1.getX();
			}
			else{
				a = (p2.getY() - p1.getY()) / (p2.getX() - p1.getX());
				b = -1;
				c = (-a * p1.getX()) + p1.getY();
			}
			
			
		}
		
	
		
		/** Check if this Line is parallel to the given one 
		@param const Line other the Line to check parallelism against */
		bool parallelTo(const Line other) const {
			return direction() == other.direction();
		}
		
		/** Check this and another line for equality.
		Two lines are considered equals if they coincide. */
		override bool opEquals( Object other) const  {
			auto equals = false;
			const Line l = to!Line(other);
			equals = parallelTo(l);
			// the equation should be the same result for any point (x,y) and in partucular for (1,1)
			equals &= (a +b + c == l.a + l.b + l.c);
			
			return equals;
		} 
		
		/** Retrieve the line slope */
		double direction() const {
			return -a/b;
		}
		
		/** Intersect this line with the given other */
		Point intersect(Line l){
			double x;
			double y;
			if(l.a != 0){	
				y = ((a*l.c/l.a) - c) / (-((a/l.a)*l.b) +b);
				x = -((l.b * y) +l.c) / l.a;
			}
			else if(a != 0){ 
				return l.intersect(this);
			}	  
			else{
				throw new ParallelLineException;
			}
			return new Point(x,y);
		}
		
		/** Get a string rappresentation of the line. */
		override string toString() const{
			string s;
			
			s = to!string(a) ~ "x ";
			if(b>=0){
				s ~= "+";
			}
			s ~=  to!string(b) ~ "y ";
			if(c>=0){
				s ~= "+";
			}
			s ~= to!string(c) ~ " = 0"; 
			   
			return s;
		}
		
}

unittest{
	Line l1 = new Line(new Point(3,3), new Point(4,-1));
	Line l2 = new Line(new Point(4,-1), new Point(3,3));
	
	assertEqual(l1, l2);	
}

unittest{
	Line l1 = new Line(new Point(4,3), new Point(4,-1));
	Line l2 = new Line(new Point(4,-1), new Point(4,3));
	
	assertEqual(l1, l2);	
}

unittest{
	Line l1 = new Line(new Point(4,3), new Point(4,-1));
	Line l2 = new Line(new Point(6,-1), new Point(6,3));
	
	assertFalse(l1 == l2);	
}

unittest{
	Line l1 = new Line(2, 0);
	Line l2 = new Line(0, 1);
	
	assertEqual(l1.intersect(l2), new Point(0.5, 1));
	
}

unittest{
	Line l1 = new Line(new Point(1,1), new Point(1,-1));
	Line l2 = new Line(new Point(0,0), new Point(1,1));
	
	assertEqual(l1.intersect(l2), new Point(1,1)); 
	assertEqual(l2.intersect(l1), new Point(1,1), "intersecting\n" ~ to!string(l2) ~ "\n"~to!string(l1));
}

unittest{
	Line l1 = new Line(new Point(1,1), new Point(2,1));
	Line l2 = new Line(new Point(0,0), new Point(1,1));

	assertEqual(l1.intersect(l2), new Point(1,1));
	assertEqual(l2.intersect(l1), new Point(1,1));
}

unittest{
	Line l1 = new Line(new Point(1,1), new Point(2,1));
	Line l2 = new Line(new Point(0,0), new Point(0,1));
	
	assertEqual(l1.intersect(l2), new Point(0,1));
	assertEqual(l2.intersect(l1), new Point(0,1), "intersecting\n" ~ to!string(l1) ~ "\n"~to!string(l2));
}



unittest{
	Point p1 = new Point(3,4);
	Point p2 = new Point(-1,4);
	Line l1 = new Line(p1, p2 );
	Line l2 = new Line(p2, p1);
	
	assertEqual(l1,l2);
	
	assertEqual(l1, l2);	
}
