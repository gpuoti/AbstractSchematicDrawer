import std.stdio;
import Point;
import Vector;
import Segment;
import std.string;
import std.container;
import std.conv;
import std.exception;

import std.traits;

version(unittest){
	import dunit.toolkit;
}

/** Shape objects are represents objects that can be checked for inclusion of other shapes. 

	Inclusion relationship is implemented as a final method (containsShape) of the shape interface using the following definition:
		A shape is included within another one if all its vertices are included within the other shape. 

	To let the definition applicable:
		any shape must define a set of vertices describing its boundary polygon. 
		any shape must be checkable for point inclusion in its area.

	In addition any shape must be checkable for point inclusion in its perimeter. */

interface Shape {
		
		Point[] vertices();
		bool contains(Point p);
		bool containsPoint(Point p);
		
		final bool containsShape(AnyShapeT : Shape)(AnyShapeT s){
			int i = 0;
			auto vertices = s.vertices(); 
			for(i=0; i<vertices.length && contains(vertices[i]); ++i ) {}
			
			return i==vertices.length;
		}
}



class ShapeComposite(ShapeT : Shape) :  Scalable, Movable, Shape
if (__traits(hasMember, ShapeT, "vertices") ) {
	
	protected:
		ShapeT shapes[];
		
	public:

		this(){
		}
		
		void add(ShapeT s){
			shapes ~= s;
		}
		
		long countComponents(){
			return shapes.length;
		}
		
		Point[] vertices(){
			Point[] v;
			
			foreach(ShapeT s; shapes){
				v ~= s.vertices();
			}
			return v;
		}
		
		void move(Vector v){
			foreach (ShapeT s ; shapes){
				s.move(v);
			}			
		}
		
		void scale(double factor){
			foreach (ShapeT s ; shapes){
				s.scale(factor);
			}
		}
		
		bool contains(Point p){
			return containsPoint(p);
		}
		
		final bool containsPoint(Point p){
			auto i= 0;
			for(i=0; i<shapes.length && !shapes[i].containsPoint(p); ++i ){}
			return i<shapes.length;
		}
		
		final bool containsShape(AnyShapeT : Shape)(AnyShapeT s){
			int i = 0;
			auto vertices = s.vertices(); 
			for(i=0; i<vertices.length && contains(vertices[i]); ++i ) {}
			
			return i==vertices.length;
		}	
		
		int opApply(int delegate(ref ShapeT) f){
			foreach(ShapeT s; shapes){
				f(s);
			}
			return 0;
		}
		
}



unittest{
	import Segment;
	
	Segment s1 = new Segment(new Point(10, 0), new Point (200, 110));
	Segment s2 = new Segment(new Point(10, 10), new Point (200, 120));
	ShapeComposite!Segment s = new ShapeComposite!Segment();
	s.add(s1);
	s.add(s2);	
	
	foreach(Segment seg; s){
		writeln(to!string(s));
	}
}

