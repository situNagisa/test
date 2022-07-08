package nagisa.util
{
	public class ColorUtil
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
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
		public function ColorUtil(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function alphaFilterPercent(alpha:Number,filterAlpha:Number):Number
		{
			return ((alpha - 1)/(1 - filterAlpha) + 1);
		}
		public static function alphaFilter(alpha:int,filterAlpha:int):int
		{
			return 256 * alphaFilterPercent(alpha/256,filterAlpha/256);
		}
		public static function alphaBlendPercent(a1:Number,a2:Number):Number
		{
			return a1 + a2 - a1 * a2;
		}
		public static function alphaBlend(a1:int,a2:int):int
		{
			return 256 * alphaBlendPercent(a1/256,a2/256);
		}
		public static function colorBlend(baseColor:int,baseAlpha:int,frontColor:int,frontAlpha:int):int
		{
			var frontAP:Number = frontAlpha/255;
			var baseAP:Number = baseAlpha/255;
			var blendAlpha:Number = alphaBlendPercent(frontAP,baseAP);
			return (frontColor * frontAP + baseColor * baseAlpha * (1 - frontAP))/blendAlpha;
		}
		public static function blendRGB(baseColor:uint,frontColor:uint):uint
		{
			var a:int = alphaBlend(getAlpha(baseColor),getAlpha(frontColor));
			var r:int = colorBlend(getRed(baseColor),getAlpha(baseColor),getRed(frontColor),getAlpha(frontColor));
			var g:int = colorBlend(getGreen(baseColor),getAlpha(baseColor),getGreen(frontColor),getAlpha(frontColor));
			var b:int = colorBlend(getBlue(baseColor),getAlpha(baseColor),getBlue(frontColor),getAlpha(frontColor));
			return getColor(a,r,g,b);
		}
		public static function getColor(a:int,r:int,g:int,b:int):uint
		{
			return (a << 24 | r << 16 | g << 8 | b );
		}
		public static function getAlpha(color:uint):int
		{
			var a:int = color >> 24;
			if(a < 0)a += 256;
			if(a > 255) a -= 256;
			return a;
		}
		public static function getRed(color:uint):int
		{
			return (color >> 16 & 0x000000FF);
		}
		public static function getGreen(color:uint):int
		{
			return (color >> 8 & 0x000000FF);
		}
		public static function getBlue(color:uint):int
		{
			return (color & 0x000000FF);
		}
		public static function colorFilter(color:int,alpha:int,filterColor:int,filterAlpha:int):int
		{
			var aP:Number			= alpha/255;
			var fAP:Number			= filterAlpha/255;
			var frontAlpha:Number	= alphaFilterPercent(aP,fAP);
			return (color * aP - filterColor * fAP * (1 - frontAlpha))/frontAlpha;
		}
		public static function filterRGB(color:uint,filterColor:uint):uint
		{
			var a:int = alphaFilter(getAlpha(color),getAlpha(filterColor));
			var r:int = colorFilter(getRed(color),getAlpha(color),getRed(filterColor),getAlpha(filterColor));
			var g:int = colorFilter(getGreen(color),getAlpha(color),getGreen(filterColor),getAlpha(filterColor));
			var b:int = colorFilter(getBlue(color),getAlpha(color),getBlue(filterColor),getAlpha(filterColor));
			return getColor(a,r,g,b);
		}
	}
}