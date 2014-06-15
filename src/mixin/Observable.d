
string MakeObservable (ObserverI, ObservedT) (string listenersName){
	return  "
private {
	" ~ ObserverI.stringof ~ listenersName ~ "[];
}

public {

	void registerListener( " ~ ObserverI.stringof ~" listener){
		"~ listenersName ~ " ~= listener;
	}
	
	void unregisterListener("~ ObserverI.stringof ~ listenersName ~ "){
		
	}

	void signalObservers(){
		foreach(" ~ ObserverI.stringof ~ "l ; "~ listenersName ~" ){
			l.update(this);
		}
	}
}
";

}