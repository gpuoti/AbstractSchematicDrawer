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

class Shape(ShapeT) :  Scalable, Movable
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
		
		abstract bool contains(Point p);
		
		bool containsPoint(Point p){
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
		
		
		
}



unittest{
	
}

