import Segment;
import Shape;
import ShapeChangeListener;
import SVGStroke;
import std.xml;
import std.stdio;
import std.conv;
import dunit.toolkit; 
import std.string;



class SVGBuilderComponent : ModelChangeListener!Segment{
	
	static bool isManaged(Type)() {
		return is(Type : Segment);
	}
	
	SVGStroke stroke = new SVGStroke;
	
	/** by default, this builder does nothing.
		That is it ignore call with unsupported object type (template specialization not available) */
	Element build(ObjectType) (ObjectType obj) if (!isManaged!ObjectType()) {
		return new Element("desc", "undefined rendering" ); 
	}

	Element build(ObjectType) (ObjectType obj) if (is (ObjectType : Segment)) {
	
		Element segment = new Element("line");
		
		auto p = obj.getOrigin();
		auto q = obj.getArrow();
		
		foreach (string k, string v ; stroke.attributes() ){
			segment.tag.attr[k] = v;
		}
		
		segment.tag.attr["x1"] = to!string(p.getX());
		segment.tag.attr["y1"] = to!string(p.getY());
		
		segment.tag.attr["x2"] = to!string(q.getX());
		segment.tag.attr["y2"] = to!string(q.getY());
		
		return segment; 
	
	}
	
	void update(Segment s){
		
	}

}
  
unittest {
	Segment s = new Segment(new Point(10, 0), new Point (200, 110));
	SVGBuilderComponent svgBuilder = new SVGBuilderComponent();
	
	Element elem = svgBuilder.build(s);
	
	elem.tag.attr.assertHasKey("stroke-width");
	elem.tag.attr["stroke-width"].assertEqual("1");
	elem.tag.attr.assertHasKey("stroke-color");
	elem.tag.attr["stroke-color"].assertEqual("#000000");
	elem.tag.attr.assertHasKey("x1");
	elem.tag.attr["x1"].assertEqual("10");
	elem.tag.attr.assertHasKey("y1");
	elem.tag.attr["y1"].assertEqual("0");
	elem.tag.attr.assertHasKey("x2");
	elem.tag.attr["x2"].assertEqual("200");
	elem.tag.attr.assertHasKey("y2");
	elem.tag.attr["y2"].assertEqual("110");
	
}

unittest {
	Segment s1 = new Segment(new Point(10, 0), new Point (200, 110));
	Segment s2 = new Segment(new Point(10, 10), new Point (200, 120));
	ShapeComposite!Segment s = new ShapeComposite!Segment();
	s.add(s1);
	s.add(s2);
	
	SVGBuilderComponent svgBuilder = new SVGBuilderComponent();

}



class SVGBuilder(ShapeT) : ModelChangeListener!(ShapeComposite!ShapeT){
	private {
	
	 	static immutable svgHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>";
	 	
	 	SVGBuilderComponent componentBuilder = new SVGBuilderComponent;
	 	
	 	string prettyPrint(Document doc){
	 		string[] strings = doc.pretty(4);
	 		string s;
	 		
	 		foreach(string line ; strings){
	 			s ~= "\n" ~ line;
	 		}
	 		return strip(s);
	 	}
	}
	
	
	public {
		string build(ShapeT : Shape)(ShapeComposite!ShapeT obj){
			auto svg = new Document(new Tag("svg"));
			 
			foreach(ShapeT s; obj){
				svg ~= componentBuilder.build(s);
			}
			
			return svgHeader ~ "\n" ~ prettyPrint(svg);
		}	
		
		string build(ShapeT) (ShapeT obj){
			auto svg = new Document(new Tag("svg"));
			
			svg ~= componentBuilder.build(obj);
			
			return svgHeader ~ "\n" ~ prettyPrint(svg);
		}
	}
	
}

	



