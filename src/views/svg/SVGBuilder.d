import Segment;
import Shape;
import ViewBuilder;
import std.xml;
import std.stdio;
import std.conv;
import dunit.toolkit;
import std.string;


class SVGBuilder : IViewBuilder!string{
	private:
	
	 	static immutable svgHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>";
	 	
	
	 	
 		/** by default, this builder does nothing.
 		That is it ignore call with unsupported object type (template specialization not available) */
 		Element buildComponent(ObjectType) (ObjectType obj){
 			string s = "unsupported element type\n";
 			s ~= "object description\n";
 			s ~= "\t" ~ to!string(obj);
 			return new Element("desc", s);
 		}
 		
 		Element buildComponent(ShapeT : Shape) (ShapeComposite!ShapeT shapeComposite){
 			Element group = new Element(new Tag("g"));
 			
 			foreach(ShapeT s; shapeComposite){
 				group ~= buildComponent(s);
 			}
 			
 			return group;
 		} 
 		
 		
 		Element buildComponent(Segment s){
 			Element segment = new Element("line");
 			
 			auto p = s.getOrigin();
 			auto q = s.getArrow();
 			
 			segment.tag.attr["x1"] = to!string(p.getX());
 			segment.tag.attr["y1"] = to!string(p.getY());
 			
 			segment.tag.attr["x2"] = to!string(q.getX());
 			segment.tag.attr["y2"] = to!string(q.getY());
 			
 			return segment;
 		}

	 	string prettyPrint(Document doc){
	 		string[] strings = doc.pretty(4);
	 		string s;
	 		
	 		foreach(string line ; strings){
	 			s ~= "\n" ~ line;
	 		}
	 		return strip(s);
	 	}
	 
	public:
		string build(ObjectType) (ObjectType obj){
			auto svg = new Document(new Tag("svg"));
			
			svg ~= buildComponent(obj);
			return svgHeader ~ "\n" ~ prettyPrint(svg);
		}	
	
	
}


unittest {
	Segment s = new Segment(new Point(10, 0), new Point (200, 110));
	SVGBuilder svgBuilder = new SVGBuilder();
	
	string expectedString = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<svg>
    <line y1=\"0\" x1=\"10\" y2=\"110\" x2=\"200\" />
</svg>";

	assertEqual(svgBuilder.build(s), expectedString );

}	

unittest {
	Segment s1 = new Segment(new Point(10, 0), new Point (200, 110));
	Segment s2 = new Segment(new Point(10, 10), new Point (200, 120));
	ShapeComposite!Segment s = new ShapeComposite!Segment();
	s.add(s1);
	s.add(s2);
	
	SVGBuilder svgBuilder = new SVGBuilder();
	
	string expectedString = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<svg>
    <g>
        <line y1=\"0\" x1=\"10\" y2=\"110\" x2=\"200\" />
        <line y1=\"10\" x1=\"10\" y2=\"120\" x2=\"200\" />
    </g>
</svg>";

	assertEqual(svgBuilder.build(s), expectedString );

}	



