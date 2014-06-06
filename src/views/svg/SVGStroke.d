import std.conv; 
import std.string;

class SVGStroke {
	private{
		double width = 1;
		uint r, g, b;
		
	}
	
	public {
		
		void setColor(uint r, uint g, uint b){
			this.r = r ;
			this.g = g ;
			this.b = b ;
		}
		
		void setWidth(double w){
			width = w;
		}
		
		/** Make a readable representation of the vector */ 
		override string toString(){
			string s;
			s = " stroke-width=\"" ~ to!string(width) ~ "\" " ~ "stroke-color=\"" ~ format("#%02X%02X%02X", r,g,b) ~ "\" ";
			return s;
		}
		
		string[string] attributes(){
			return ["stroke-width" : to!string(width), "stroke-color" : format("#%02X%02X%02X", r,g,b)];
		}
		
	}
}

unittest {
	import dunit.toolkit;
	
	SVGStroke stroke = new SVGStroke;
	
	to!string(stroke).assertEqual(" stroke-width=\"1\" stroke-color=\"#000000\" ");

	
	stroke.setWidth(1.32);
	stroke.setColor(125, 10, 90);
	
	to!string(stroke).assertEqual(" stroke-width=\"1.32\" stroke-color=\"#7D0A5A\" ");
}

unittest {
	import dunit.toolkit;
	
	
	SVGStroke stroke = new SVGStroke;
	auto expectedDefaultAttributes = ["stroke-width": "1", "stroke-color" : "#000000"];
	auto expectedAttributes = ["stroke-width": "1.32", "stroke-color" : "#7D0A5A"];
	
	to!string(stroke).assertEqual(" stroke-width=\"1\" stroke-color=\"#000000\" ");
	stroke.attributes().assertEqual(expectedDefaultAttributes);
	
	stroke.setWidth(1.32);
	stroke.setColor(125, 10, 90);
	
	to!string(stroke).assertEqual(" stroke-width=\"1.32\" stroke-color=\"#7D0A5A\" ");
	stroke.attributes().assertEqual(expectedAttributes);
}
