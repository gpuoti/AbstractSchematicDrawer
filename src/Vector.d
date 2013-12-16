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


unittest {
	import std.stdio;
	import Point;
	import Vector;
	
	writeln("\nVector unittest");
	writeln("--------------\n");

	Vector v2 = new Vector(new Point(0,0), new Point(5,0));
	Vector v[] = [	new Vector(new Point(0,0), new Point (12, 0)), 
					new Vector(new Point(0,0), new Point (10, 5)),
					new Vector(new Point(10,5), new Point (0, 0)),
					new Vector(new Point(5,1), new Point (9, -1)) ];
	
	double modules[] = [12, 11.1803, 11.1803, 4.47214];
	double dxs[] = [12, 10, -10, 4];
	double dys[] = [0, 5, -5, -2];
	
	foreach (int i, Vector x; v ){
		writeln("Testing vector", x);
		writeln("--------------\n");
		
		write("Testing dx() and dy()...");
		assert(abs(x.dx() - dxs[i]) < 0.0001);
		assert(abs(x.dy() - dys[i]) < 0.0001);
		writeln("Ok");
		
		write("module...");
		assert(abs(x.getModule() - modules[i]) < 0.0001, "calculated module " ~ to!string( x.getModule()) ~ " expected " ~ to!string(modules[i]));
		writeln("Ok");
		
		write("scale X1.5...");
		x.scale(1.5);
		writeln("resulting vector", x);
		write("Testing dx() and dy()...");
		assert(abs(x.dx() - dxs[i]*1.5) < 0.0001, "dx() result is " ~ to!string(x.dx()) ~ " expected " ~ to!string(dxs[i]*1.5));
		assert(abs(x.dy() - dys[i]*1.5) < 0.0001, "dy() result is " ~ to!string(x.dy()) );
		writeln("Ok");
		
		write("module...");
		assert(abs(x.getModule() - modules[i]*1.5) < 0.0002, "getModule() result is " ~ to!string(x.getModule()));
		writeln("Ok");
		
		x.scale(0.66667);
		write("Testing dx() and dy()...");
		assert(abs(x.dx() - dxs[i]) < 0.0001, "dx() result is " ~ to!string(x.dx()));
		assert(abs(x.dy() - dys[i]) < 0.0001, "dy() result is " ~ to!string(x.dy()));
		writeln("Ok");
		
		write("module...");
		assert(abs(x.getModule() - modules[i]) < 0.0001);
		writeln("Ok");
		
		
		write("summing with ", v2, " result is... ");
		x = x+v2;
		writeln(x);
		
		write("subtracting with ", v2, " result is... ");
		x = x-v2;
		writeln(x);
		
		Point p = x.getArrow();
		p.move(x);
		writeln("moving vector arrow by itself... ", x);
		
		p = x.getOrigin();
		p.move(x);
		writeln("moving vector origin by itself... ", x);
		
		writeln();
	}

	
	
	
	
	
}