package nagisa.util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class MathUtil
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const radianToRotation:Number = 180 / Math.PI;
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function MathUtil(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function getDistance(A:Point, B:Point = null):Number{
			if (!B) B = new Point();
			return Math.pow((Math.pow(A.x - B.x, 2) + Math.pow(A.x - B.x, 2)), 0.5);
		}
		public static function getRadianByPoint(base:*,target:*):Number{return getRadianByXY(target.x - base.x,target.y - base.y);}
		public static function getRadianByXY(x:Number, y:Number):Number{return Math.atan2(y, x);}
		public static function getRotationByXY(x:Number, y:Number):Number{return asRotation(getRadianByXY(x, y));}
		public static function asRadian(rota:Number):Number{return rota/radianToRotation;}
		public static function asRotation(radian:Number):Number{return radian * radianToRotation;}
		public static function getRandomPointByRect(rect:Rectangle):Point
		{
			return new Point(rect.x + rect.width * Math.random(), rect.y + rect.height * Math.random());
		}
		public static function getRandomPointByCircle(x:Number,y:Number,r:Number):Point
		{
			var radian:Number = 2 * 3.14 * Math.random();
			r *= Math.random();
			return new Point(x + r * Math.cos(radian), y + r * Math.sin(radian));
		}
		public static function sgn(num:Number):int
		{
			if(!num)return 0;
			return num > 0 ? 1 : -1;
		}
		public static function near(aim:Number,num:Number,speed:Number):Number
		{
			speed = Math.abs(speed);
			var sign:int = sgn(aim - num);
			if(!sign || Math.abs(aim - num) < speed)return aim;
			return num + speed * sign;
		}
		public static function away(aim:Number,num:Number,speed:Number):Number
		{
			speed = Math.abs(speed);
			var sign:int = sgn(num - aim);
			return num + speed * sign;
		}
	}
}