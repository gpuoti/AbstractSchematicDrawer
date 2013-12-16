import MathConsts;

interface Rotable {
	 
	/** Apply a rotation the the Rotable object. The given angle is in radiants */
	void rotate(double rad);
	
	/** A convenience method to let the rotate method be callable with angle given in degrees */
	final void rotateDeg(double deg){
		double rad = 180.0/MathConsts.pi*deg;
		rotate(rad);
	}
}