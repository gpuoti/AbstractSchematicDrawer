import std.stdio;
import Point;
import Vector;
import Segment;
import std.string;
import std.container;
import std.conv;
import std.exception;

version(unittest){
	import dunit.toolkit;
}

class Shape(ShapeT) :  Scalable, Movable{
	
	protected:
		ShapeT shapes[];
		
		abstract bool hasPoint(Point p);
	public:

		this(){
		}
		
		void add(ShapeT s){
			shapes ~= s;
		}
		
		long countComponents(){
			return shapes.length;
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
		
		final bool containsPoint(Point p){
			auto i= 0;
			for(i=0; i<shapes.length && !shapes[i].containsPoint(p); ++i ){}
			
			return i<shapes.length;
		}
		
		
		
}



unittest{
	
}

