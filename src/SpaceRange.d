import Point;
import Rectangle;
import std.algorithm;

import std.stdio;
import std.conv;
import std.traits;


interface SpaceRange(ElementType){
	
	bool contains(ElementType p);
	bool collides(ElementType p);
	SpaceRange!ElementType join(SpaceRange!ElementType other);
} 


class CollisionDetector(RangeType, ElementType){
	RangeType 	node;
	CollisionDetector[] childs;
	ElementType[] elements;
	
	string toString(int tabs){
		string s;
		
		string stab;
		
		for(int i=0; i<tabs; i++){
			stab ~="\t"; 
		} 
		s = stab ~ "Range " ~ to!string(node) ~ "   Elements {" ~ to!string(elements)~"}";
		s ~= "\n" ~ stab ~ "Childs\n";
		if(childs.length == 0){
			s ~= stab ~"None";
		}
		foreach(CollisionDetector subDetector; childs){
			s~= subDetector.toString(tabs+1);
		}
		
		return s ~ "\n";
	}
	
	override string toString(){
		return toString(0);
	}
	
	this(){}
	
	this(RangeType r){
		node = r;
	}
	
	this(ElementType e, RangeType r){
		this(r);
		elements ~= e;
	}
	
	this( CollisionDetector!(RangeType, ElementType) other ){
		node = new RangeType(other.node);
		childs = other.childs.dup;
		elements = other.elements.dup;
	}
	
	bool isLeaf(){
		return childs.length == 0;
	}
	
	bool isEmpty(){
		return !node;
	}
	
	void removeChild(CollisionDetector child){
		auto c = childs.find(child);
		childs = childs[0..childs.length-c.length] ~ c[1..$];
	}
	
	
	void addObject(ElementType e, RangeType r){
		if(isEmpty() ){
			node = r;
			elements ~= e;
		}
		else{
			
			if(node.contains(r)){
				if(!isLeaf()){
					childs[0].addObject(e, r);
				}
				
			}	
			else{	

				SpaceRange!RangeType range = r;		// QUESTO PASSAGGIO È NECESSARIO PER 
													// EVITARE MULTIPLE METHODS MACH IN CASO DI SPACERANGE VALIDI PER DIVERSI ELEMENTTYPE
													// BISOGNA EVITARLO 
				
				
				auto subtree_a = new CollisionDetector!(RangeType, ElementType)(this);
				auto subtree_b = new CollisionDetector!(RangeType, ElementType)(e, r);
				node = node.join(range);
				elements ~= e; 
				childs ~= subtree_a;
				childs ~= subtree_b;
			}
			
			
		}
		
	}
	
	bool collides (RangeType range){
		if(isLeaf()){
			return node.collides(range);
		}
		else if(node.collides(range)){
			bool collisionDetected = false;
			foreach(CollisionDetector subDetector; childs){	
				return collisionDetected || subDetector.collides(range);
			}
		} 
		return false;
		
	}
	
	ElementType[] collisions(RangeType range){
		ElementType elems[];
		
		if(node.collides(range)){
			if(isLeaf()){
				elems ~= elements;
			}
			foreach(CollisionDetector cd; childs){
				elems ~= cd.collisions(range);
			}
		}
		
		return elems;
	}
	
	
	ElementType[] inclusions (RangeType range){
		ElementType elems[];
		
		if(node.contains(range)){
			if(isLeaf()){
				elems ~= elements;
			}
			foreach(CollisionDetector cd; childs){
				elems ~= cd.inclusions(range);
			}
		}
		
		return elems;
	}
}



class Rectangular2DSpace : Rectangle, SpaceRange!Point, SpaceRange!Rectangular2DSpace{
	
	static const  Rectangular2DSpace universe = new Rectangular2DSpace(new Point(-float.max, float.max), new Point(float.max, -float.max));
	
	this(const Rectangular2DSpace other){
		const Rectangle o = other;
		super(o);
	}
	
	this(Point p){
		super(p, p);
	}
	
	this(Point p, Point q){
		super(p, q);
	}
	
	this(Point[] v){
		bool minimalX(Point p1, Point p2){
			return p1.minX(p2) == p1;
		}
		
		bool minimalY(Point p1, Point p2){
			return p1.minY(p2) == p1;
		}
		
		bool maximalX(Point p1, Point p2){
			return p1.maxX(p2) == p1;
		}
		
		bool maximalY(Point p1, Point p2){
			return p1.maxY(p2) == p1;
		}
		
		auto minxPoint =minPos!minimalX(v);
		auto maxyPoint =minPos!minimalY(v);
		auto maxxPoint =minPos!maximalX(v);
		auto minyPoint =minPos!maximalY(v);

		super (new Point(minxPoint[0].getX(), maxyPoint[0].getY()), new Point(maxxPoint[0].getX(), minyPoint[0].getY()));
	}
	
	override bool contains(Point p){
		return super.contains(p);
	}
	
	override bool contains(Rectangular2DSpace s){
		return super.containsShape(s);
	}
	
	override bool collides(Point p){
		return super.contains(p);
	}
	
	override bool collides(Rectangular2DSpace p){
		return super.collides(p);
	}

	Rectangular2DSpace join(SpaceRange!Point other){
		static if (isAssignable!(typeof(other), Rectangular2DSpace)){
			Rectangular2DSpace otherSpace = cast(Rectangular2DSpace) other;
			Point[] allVertices = vertices();
			allVertices ~= otherSpace.vertices();
			
			return new Rectangular2DSpace(allVertices);
		}
		else{
			return new Rectangular2DSpace(universe);
		}
	}
	
	Rectangular2DSpace join(SpaceRange!Rectangular2DSpace other){
		static if (isAssignable!(typeof(other), Rectangular2DSpace)){
			Rectangular2DSpace otherSpace = cast(Rectangular2DSpace) other;
			Point[] allVertices = vertices();
			allVertices ~= otherSpace.vertices();
			
			return new Rectangular2DSpace(allVertices);
		}
		else
			return new Rectangular2DSpace(universe);
	}
	
	override string toString() const {
		return "Space " ~ super.toString();
	}
	
	string toString(int tabs) const {
		string s;
		
		for(auto i=0; i<tabs; i++){
			s ~= " ";
		}
		
		return s ~ toString();
	}
}


unittest {
	import dunit.toolkit;
	
	SpaceRange!Point space = new Rectangular2DSpace(new Point(0,0), new Point(1,1));
	space.contains(new Point(0.5, 0.5)).assertTrue;
}

unittest {
	import dunit.toolkit;
	
	SpaceRange!Point space1 = new Rectangular2DSpace(new Point(0,0), new Point(1,1));
	SpaceRange!Point space2 = new Rectangular2DSpace(new Point(0,2), new Point(1,3));
	space1.contains(new Point(0.5, 0.5)).assertTrue;
	space1.contains(new Point(0, 0)).assertTrue;
	space2.contains(new Point(0.5, 2.1)).assertTrue;
	space2.contains(new Point(1, 3)).assertTrue;
	space1.contains(new Point(0.5, 2.1)).assertFalse;
	space1.contains(new Point(1, 3)).assertFalse;
	
	
	auto space = space1.join(space2);
	
	space.contains(new Point(0.5, 0.5)).assertTrue;
	space.contains(new Point(0, 0)).assertTrue;
	space.contains(new Point(0.5, 2.1)).assertTrue;
	space.contains(new Point(1, 3)).assertTrue;

}


unittest {
	import dunit.toolkit;
	
	auto detector = new CollisionDetector!(Rectangular2DSpace, string);
	
	detector.addObject( "pippo", new Rectangular2DSpace(new Point(0,0), new Point(1,1)) );
	detector.addObject( "pluto", new Rectangular2DSpace(new Point(0.1, 0.7), new Point(1.5, 2)) );
	
	auto lastRange = new Rectangular2DSpace(new Point(3, 3), new Point(4, 3.1));
	detector.addObject( "paperino",  lastRange);
	
	auto collidingRegion = new Rectangular2DSpace(new Point(0, 0), new Point(0.1, 0.9) );
	auto notCollidingRegion = new Rectangular2DSpace(new Point(-2, -2), new Point(-1, -1) );
	
	detector.collides(collidingRegion).assertTrue;
	detector.collides(notCollidingRegion).assertFalse;
	
	
	detector.collisions(collidingRegion).assertHasValue("pippo");
	detector.collisions(collidingRegion).assertHasValue("pluto");
	
	detector.collides(notCollidingRegion).assertFalse;
	detector.collisions(collidingRegion).find("paperino").assertEqual([]);
	
}

unittest {
	import dunit.toolkit;
	import std.stdio;
	
	auto a = [1,2,3,4,5,6];
	auto x = 3;
	auto c = a.find(x);
	a = a[0..a.length-c.length] ~ c[1..$];
	
	a.assertEqual([1,2,4,5,6]);
}
	