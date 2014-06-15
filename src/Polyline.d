import std.exception;
import std.conv;
import std.algorithm;
import std.stdio;
import Measurable1D;
import Shape ;
import Segment;
import Line;


version (unittest){
	import dunit.toolkit;
	import Point;
}

/** A Polyline is a sequence of contigous segments.
It is modelled as a Shape composed of segments and it is measurable with a norm defined as the sum of the norm of composing segments. */
class Polyline : ShapeComposite!Segment, Measurable1D {
	alias ShapeComposite!Segment.shapes segments;
	
	public:
	
		class ReducingEmptyPolylineException : Exception {
			this(){
				super("Cannot reduce empty polyline, emptyness should be verified first");
			}
		}
		
		/** To define a polyline you need at leas one segment. 
		This overloaded constructor makes possible to construct a minimal polyline given 
		the boundary points of the first of its composing segments. */
		this(Point p1, Point p2){
			segments ~= new Segment(p1, p2);
		}
		
		this(Polyline p){
			segments = p.segments.dup;			
		}
		
		/** Appling this method the polilyne will be reduced by its last segment */
		Segment pop(){
			enforce(segments.length, new ReducingEmptyPolylineException);
			
			Segment s = segments[0];
			segments = segments[1..$];
			return s;
		}
		
		/** Appling this method the polyline will be reduced by its first segment */
		Segment popBack(){
			enforce(segments.length, new ReducingEmptyPolylineException);
			 
			Segment s = segments[$];
			segments = segments[1..$-1];
			return s;
		}
		
		/** Add a component segment to the polyline. The new component segment shall be compatible with the polyline, that is, it must start
		at the end point of the last added component segment. */
		override void add(Segment s){
			enforce(segments.length > 0);
			// this constraint can be enforced only on shape of polyline type.
			enforce(segments[$-1].isCompatible(s), to!string(segments[$-1])  ~ "is not compatible to " ~ to!string(s) ~ " len: " ~ to!string(segments.length)  ~"\n" ~to!string(segments) );
			super.add(s);
		}
		
		/** Get the module of this polyline as the sum of the module of component segment */
		double getModule(){
			double len = 0.0;
			foreach (Segment s ; segments){
				len += s.len();
			}
			return len;
		}
		
		/** As they are Measurable1D, you can get the length of the segment calling len() method.
		This is a convenient name for getModule() method */
		double len(){
			return getModule();
		}
		
		/** Calculate the len of the polyline reduced to the given segment. 
		The len of related segment itself is taken into account */ 
		double len2Segment(Segment s)
		in{
			assert (find(segments, s).length > 0);
		}
		body {
		
			double len = s.len();
			Segment segs[] = segments[0..$];
			while(segs.length > 0 && s != segs[0]){
				len += segs[0].len();
				segs = segs[1..$];
			}
			
			return len;
		}
		
		/** Get the point at given len from the start edge of the polyline */
		Point pointAtLen(double l)
		in {
			assert( l>=0.0);
			assert( l<=1.0 );
		}	
		body{
			Segment s = segmentAtLen(l);
			double len2Seg = len2Segment(s);
			return s.pointAtLen( s.len()-(len2Seg-l) );
		}
		
		/** Get the segment whose the point at given len from the start edge of the polyline belong to*/
		Segment segmentAtLen(double l)
		in {
			assert(l >= 0);
			assert(l<= len());
		}
		body{
			int i=0;			
			while (l > 0){
				l -= segments[i].len();				
				i++;
			}
			i = max(0,i-1);
			return segments[i];
		}
		
		/** Intersect the polyline with the given line returning an array of intersection points. */
		Point[] intersect(Line l){
			Point[] points;
			foreach(Segment s; segments){
				if(s.direction() != l.direction()){
					Line sl = s.getLine();
					points ~= sl.intersect(l);
				}
				
			}
			
			return points;
		}
		
		
		
}


unittest {
	Segment s1 = new Segment(new Point(-3, 3), new Point(4, 4));
	Segment s2 = new Segment(new Point(4,4), new Point(5,-1));
	
	Polyline p = new Polyline(new Point(-3, 3), new Point(4, 4) );
	double s1Len = p.len();
	
	p.add(s2 );
	
	assertEqual(p.segmentAtLen(0.1), s1);
	assertEqual(p.segmentAtLen(p.len()), s2);
	
	assertEqual(p.len2Segment(s1), s1.len());
	assertEqual(p.len2Segment(s2), s1.len() + s2.len());
}

unittest {
	Polyline p = new Polyline(new Point(-3, 3), new Point(4, 4) );
	p.add(new Segment(new Point(4,4), new Point(5,-1)) );
	
	assertEqual(p.pointAtLen(p.len()), new Point(5,-1));
		
}

unittest {
	Polyline p1 = new Polyline(new Point(0, 0), new Point(4, 4) );
	p1.add(new Segment(new Point(4,4), new Point(6, 4.5)) );
	p1.add(new Segment(new Point(6,4.5), new Point(5, 5)) );
	Polyline p2 = new Polyline(new Point(0, 1), new Point(4, 5) );
	p2.add(new Segment(new Point(4,5), new Point(6, 4.50003)) );
	p2.add(new Segment(new Point(6,4.50003), new Point(5, 6)) );
	import std.algorithm; 
	
	auto v1 = p1.vertices();
	auto v2 = p2.vertices();
	
	writeln(p1);
	auto commonVertices = p1.commonVertices(p2);
	writeln(to!string(commonVertices));
	assertTrue(commonVertices.length == 1);
	assertEqual(commonVertices[0], new Point(6.0000015, 4.50001) );
}

