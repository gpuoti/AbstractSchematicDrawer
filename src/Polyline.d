import std.exception;
import std.conv;
import std.algorithm;
import Measurable1D;
import Shape : Shape;
import Segment;

class Polyline : Shape!Segment, Measurable1D {
	alias Shape!Segment.shapes segments;
	
	protected:
		this(){}
	
	public:
	
		class ReducingEmptyPolylineException : Exception {
			this(){
				super("Cannot reduce empty polyline, emptyness should be verified first");
			}
		}
		
		/** Basic Segment objects construction needs the two points defining the segment. */
		this(Point p1, Point p2){
			add(new Segment(p1, p2));
		}
		
		Segment pop(){
			enforce(segments.length, new ReducingEmptyPolylineException);
			
			Segment s = segments[0];
			segments = segments[1..$];
			return s;
		}
		
		Segment popBack(){
			enforce(segments.length, new ReducingEmptyPolylineException);
			
			Segment s = segments[$];
			segments = segments[1..$-1];
			return s;
		}
		
		
		override void add(Segment s){
			
			// this constraint can be enforced only on shape of polyline type.
			enforce(segments[$].isCompatible(s), to!string(segments[$])  ~ "is not compatible to " ~ to!string(s) );
			super.add(s);
		}
		
		
		/** As they are Measurable1D, you can get the length of the segment calling len() method. */
		double len(){
			return getModule();
		}
		
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
			return segments[i-1];
		}
		
		double getModule(){
			double len = 0.0;
			foreach (Segment s ; segments){
				len += s.len();
			}
			return len;
		}
		
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
		
		
		Point pointAtLen(double l)
		in {
			assert( l>=0);
			assert( l<=len() );
		}	
		body{
			Segment s = segmentAtLen(l);
			double len2Seg = len2Segment(s);
			
			return s.pointAtLen( s.len()-(len2Seg-l) );
		}
		
		
		
		
}



unittest {
	/** Checks that two segments merged in a shape have, as length, the sum of component segments length */
	
}

unittest {
	/** Checks that two segments merged in a shape have, as length, the sum of component segments length */
	
}