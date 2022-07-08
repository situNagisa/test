package nagisa.filters.melt
{
	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class FluidData
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const POINT_NUM:int = 2;
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		/**
		 * x index of grid
		 */
		public function get x():uint { return _x; }
		public function set x(value:uint):void { _x = value; }
		private var _x:uint;
		
		/**
		 * y index of grid
		 */
		public function get y():uint { return _y; }
		public function set y(value:uint):void { _y = value; }
		private var _y:uint;
		
		/**
		 * x velocity
		 */
		public function get vx():Number {return int(_vx * POINT_NUM) / POINT_NUM;}
		public function set vx(value:Number):void { _vx = value; }
		private var _vx:Number;
		
		/**
		 * y velocity
		 */
		public function get vy():Number { return int(_vy * POINT_NUM) / POINT_NUM; }
		public function set vy(value:Number):void { _vy = value; }
		private var _vy:Number;
		
		/**
		 * pressure
		 */
		public function get pressure():Number { return int(_pressure * POINT_NUM) / POINT_NUM; }
		public function set pressure(value:Number):void { _pressure = value; }
		private var _pressure:Number;
		
		/**
		 * compound color for DisplacementMapFilter
		 */
		public function get color():uint { return _color; }
		public function set color(value:uint):void { _color = value; }
		private var _color:uint;
		
		/**
		 * x color for DisplacementMapFilter
		 */
		public function get colorX():uint { return _colorX; }
		public function set colorX(value:uint):void { _colorX = value; }
		private var _colorX:uint;
		
		/**
		 * y color for DisplacementMapFilter
		 */
		public function get colorY():uint { return _colorY; }
		public function set colorY(value:uint):void { _colorY = value; }
		private var _colorY:uint;
		
		/**
		 * cell for linked list (to loop grid)
		 */
		public function get next():FluidData { return _next; }
		public function set next(value:FluidData):void { _next = value; }
		private var _next:FluidData;
		
		public function get prev():FluidData { return _prev; }
		public function set prev(value:FluidData):void { _prev = value; }
		private var _prev:FluidData;
		
		public function get decaySpeed():Number { return _decaySpeed; }
		public function set decaySpeed(value:Number):void { _decaySpeed = value; }
		private var _decaySpeed:Number = Fluid.DECAYSPEED_DEFAULT;
		
		/**
		 * cell for linked list (to search around grid)
		 */
		private var _n00:FluidData;
		private var _n01:FluidData;
		private var _n02:FluidData;
		private var _n10:FluidData;
		private var _n12:FluidData;
		private var _n20:FluidData;
		private var _n21:FluidData;
		private var _n22:FluidData;
		
		public function get n00():FluidData { return _n00; }
		public function get n01():FluidData { return _n01; }
		public function get n02():FluidData { return _n02; }
		public function get n10():FluidData { return _n10; }
		public function get n12():FluidData { return _n12; }
		public function get n20():FluidData { return _n20; }
		public function get n21():FluidData { return _n21; }
		public function get n22():FluidData { return _n22; }
		
		public function set n00(value:FluidData):void { _n00 = value; }
		public function set n01(value:FluidData):void { _n01 = value; }
		public function set n02(value:FluidData):void { _n02 = value; }
		public function set n10(value:FluidData):void { _n10 = value; }
		public function set n12(value:FluidData):void { _n12 = value; }
		public function set n20(value:FluidData):void { _n20 = value; }
		public function set n21(value:FluidData):void { _n21 = value; }
		public function set n22(value:FluidData):void { _n22 = value; }
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get isActive():Boolean {
			return (_colorX != 128 || _colorY != 128 || vx != 0 || vy != 0 || pressure != 0);
		}
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 */
		public function FluidData(x:uint, y:uint):void
		{
			_x        = x;
			_y        = y;
			clear();
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function clear():void
		{
			_vx       = 0;
			_vy       = 0;
			_pressure = 0;
			_color    = 0x008080;
			_colorX   = 128;
			_colorY   = 128;
		}
		public function decay():void
		{
			var g:Number = colorX;
			var b:Number = colorY;
			if (g != 128) {
				colorX += (_decaySpeed * ((g < 128) ? 1 : -1));
				if ((g < 128 && colorX > 128)  || (g > 128 && colorX < 128)) colorX = 128;
			}
			if (b != 128) {
				colorY += (_decaySpeed * ((b < 128) ? 1 : -1));
				if ((b < 128 && colorY > 128)  || (b > 128 && colorY < 128)) colorY = 128;
			}
		}
	}
}