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
	private double m;
	private double c;
	
	public:
		
		/** Construct a line given its slope and the projection of its intersection point with the y axis. 
		@param mx the line slope
		@param c0 the projection of the intersection point of the line with the y axis  */
		this(double mx, double c0){
			m = mx;
			c = c0;
		}
		
		/** Construct a line passing by the two given points */
		this(Point p1, Point p2){
			m = (p2.getY() - p1.getY()) / (p2.getX() - p1.getX());
			if(isInfinity(m)){
				c = p1.getX();
			}
			else{
				c = p1.getY()/(m * p1.getX());
				if(isNaN(c)|| isInfinity(c)){
					c = p1.getY();
				}
			}
		}
		
		/** Check this and another line for equality.
		Two lines are considered equals if they coincide. */
		override bool opEquals( Object other) {
			Line l = cast(Line)(other);
			if(isInfinity(m) && isInfinity(l.m) ){
				return c == l.c;
			}
				
			return m == l.m && c == l.c;
		} 
		
		/** Retrieve the line slope */
		double direction(){
			return m;
		}
		
		/** Intersect this line with the given other */
		Point intersect(Line l){
			double x;
			double y;
			
			if(m == l.m){
				throw new ParallelLineException();
			}
			
			if(isInfinity(m)){
				x = (c - l.c) / l.m;
				y = c;	
				if(isInfinity(x)){
					x = c;
					y = l.c;
				}
			}			
			else if(isInfinity(l.m)){
				return l.intersect(this);	
			}
			else{
				x = (l.c-c) / (m-l.m);
				y = m*x + c;
			} 
			return new Point(x,y);
		}
		
		/** Get a string rappresentation of the line. */
		override string toString(){
			string s;
			s = std.string.format( "y = (%.1fx + %.1f)", m, c );
			return s;
		}
		
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
	assertEqual(l2.intersect(l1), new Point(1,1));
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
	assertEqual(l2.intersect(l1), new Point(0,1));
}

unittest{
	Line l1 = new Line(new Point(4,3), new Point(4,-1));
	Line l2 = new Line(new Point(4,-1), new Point(4,3));
	
	assertEqual(l1, l2);	
}

unittest{
	Point p1 = new Point(3,4);
	Point p2 = new Point(-1,4);
	Line l1 = new Line(p1, p2 );
	Line l2 = new Line(p2, p1);
	
	assertEqual(l1,l2);
	
	assertEqual(l1, l2);	
}
