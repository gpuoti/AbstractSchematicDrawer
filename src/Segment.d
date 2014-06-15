import Measurable1D;
import Vector;
import ShapeChangeListener;
import Observable;
import Shape;

import std.stdio;
import std.math;


version (unittest){
	import dunit.toolkit;
	import Point;
}


class Segment : Vector, Measurable1D, Shape {
	
	public:
	
		/** Basic Segment objects construction needs the two points defining the segment. */
		this(Point p1, Point p2){
			super(p1, p2);
		}
		
		/** As they are Measurable1D, you can get the length of the segment calling len() method. */
		double len(){
			return getModule();
		}
		
		
		bool containsPoint(Point p){
			/* special cases for segment bounds */
			if(p == getOrigin() || p == getArrow()){
				return true;
			}
			
			auto v2p = new Vector(getOrigin(), p);			
			return v2p.equalDirection(this) && v2p.getModule <= getModule(); 

		}
		
		bool contains (Point p){
			return contains(p);
		}
		
		/** As Measurable1D you can get the point on the segment given a percentual of it's lenght */
		Point pointAtLen(double l){
			Point p = new Point(getOrigin());
			Vector delta = new Vector( new Point(0,0), new Point(dx(), dy()) );
			delta.scale(normalizedLen(l));
			p.move(delta);
			
			return p;		
		}
		
		bool isConsecutive(Segment s){
			
			return s.pointAt(1.0) == getOrigin(); 
			
		}
		
		bool isCompatible(Segment s){
			return getArrow() == s.pointAt(0.0);
		}
		
		Point[] vertices(){
			return [getOrigin(), getArrow()];
		}
		
		override void scale(double factor){
			super.scale(factor);
		}
		
		override Rectangle bounds(){
			return new Rectangle(getOrigin(), getArrow());
		}
		
		
		mixin(MakeObservable!(ModelChangeListener!Segment, Segment)("segmentListeners"));
} 


unittest {
	/** Checks that the midpoint of segment (0,0)--(12,0) is (6,0) */
	Segment s = new Segment(new Point(0,0), new Point(12,0));
	Point m = s.pointAt(0.5);
	Point p60 = new Point (6,0);
	
	assertEqual(m, p60);
	
}

unittest {
	/** Checks that the first third point of segment (-3,2)--(3,-1) is (-1,1) */
	Segment s = new Segment(new Point(-3,2), new Point(3,-1));
	Point m = s.pointAt(0.33333);
	Point p3th= new Point (-1,1);
	
	m.getX().assertApprox(-1, 0.0001);
	m.getY().assertApprox(1, 0.0001);
	
}

unittest {
	/** Checks that the first third point of segment (-3,2)--(3,-1) is (-1,1) */
	Segment s = new Segment(new Point(-3,2), new Point(3,-1));
	
	assertTrue(s.containsPoint(new Point(-3,2)) );
	assertTrue(s.containsPoint(new Point(3,-1)) );
	assertTrue(s.containsPoint(new Point(0, 0.5)) );
	
}

unittest {
	Segment s = new Segment(new Point(4,4), new Point(5,-1));
	
	assertEqual(new Point(5,-1), s.pointAtLen(s.len()) ) ;
	 
}