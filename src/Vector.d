import Point;
import Scalable;
import std.math;
import std.conv;



class Vector : Scalable{
	private:
		Point o;
		Point arrow;
		
	
	public:
		this(Point origin, Point arrowPoint){
			o = origin;
			arrow = arrowPoint;
		}
		
		this(Vector other){
			o = other.o;
			arrow = other.arrow;
		}
		
		Point getOrigin(){
			return o;
		}
			
		Point getArrow(){
			return arrow;
		}
		
		double dx(){
			return arrow.getX() - o.getX();
		}
		
		double dy(){
			return arrow.getY() - o.getY();
		}
		
		
		double getModule(){
			return o.distance(arrow);
		}
		
		Vector getVersor(){
			double mod = getModule();
			return new Vector(o, new Point(arrow.getX()/mod, arrow.getY()/mod)); 
		}
		
		void scale(double factor){
			double x = arrow.getX() * factor;
			double y = arrow.getY() * factor;
			
			arrow = new Point(x, y);
			
			o = new Point( o.getX() * factor, o.getY()*factor);
			
			
		}
		
		Vector opNeg() {
			return new Vector(arrow, o);
			
		}
		
		
		Vector opAdd(Vector other) {
			Point newArrow = new Point(arrow);
		
			newArrow.move(other);
			return new Vector( o, newArrow );
		
		}
		
		Vector opSub(Vector other) {
			Point newArrow = new Point(arrow);
		
			newArrow.move(-other);
			return new Vector( o, newArrow );
		
		}
		
		override bool opEquals(Object other){
			Vector v2 = cast(Vector)(other);
			return v2 && o == v2.getArrow() && arrow == v2.getArrow();
		}
		
		
		override string toString(){
			string s;
			s = std.string.format("%s ---> %s", o.toString(), arrow.toString() );
			return s;
		}
		
}

int main(string[] args){
	return 0;
	
}


unittest{
	/** Check module and scale calculation on vector (0,0)-->(12,0)*/
	import dunit.toolkit;
	import Point;
	Vector v = new Vector(new Point(0,0), new Point (12, 0));
	
	v.dx().assertEqual(12);
	v.dy().assertEqual(0);
	v.getModule().assertEqual(12);
	
	v.scale(1.5);
	v.getModule().assertApprox(12*1.5);
	v.scale(0.6666667);
	v.getModule().assertApprox(12.0, 0.0001);
}

unittest{
	
	/** Check module and scale calculation on vector (10,5)-->(0,0) */
	import dunit.toolkit;
	import Point;
	Vector v = new Vector(new Point(10,5), new Point (0, 0));

	v.dx().assertApprox(-10.0);
	v.dy().assertApprox(-5.0);
	v.getModule().assertApprox(11.1803, 0.0001);
	
	v.scale(1.5);
	v.getModule().assertApprox(11.1803*1.5, 0.0001);
	v.scale(0.6666667);
	v.getModule().assertApprox(11.1803, 0.0001);
}

unittest{
	
	/** Check module and scale calculation on vector (5,1)-->(9,-1) */
	import dunit.toolkit;
	import Point;
	Vector v = new Vector(new Point(5,1), new Point (9, -1));

	v.dx().assertEqual(4.0);
	v.dy().assertEqual(-2.0);
	v.getModule().assertApprox(4.47214, 0.0001);
	
	v.scale(1.5);
	v.getModule().assertApprox(4.47214*1.5, 0.0001);
	v.scale(0.6666667);
	v.getModule().assertApprox(4.47214, 0.0001);
}


unittest{
	
	/** Check sum and difference operator, taken:
		v0 = (5,1)-->(9,-1)
		v2 = (0,0)-->(5,0)
		
	check that v = v0+v2 == (5,1)-->(14-1)
	and than that v-v2 == v0 	*/
	import dunit.toolkit;
	import Point;
	Vector v0 = new Vector(new Point(5,1), new Point (9, -1));
	Vector v = new Vector(new Point(5,1), new Point (9, -1));
	Vector v2 = new Vector(new Point(0,0), new Point (5, 0));
	Vector sum = new Vector(new Point(5,1), new Point (14,-1));
	
			
	v = v0+v2;
	v.dx().assertApprox(sum.dx(), 0.0001);
	v.dy().assertApprox(sum.dy(), 0.0001);
	v.getModule.assertApprox(sum.getModule(), 0.0001);
	
	v = v-v2;
	v.dx().assertApprox(v0.dx(), 0.0001);
	v.dy().assertApprox(v0.dy(), 0.0001);
	v.getModule().assertApprox(v0.getModule(), 0.0001);	
}

