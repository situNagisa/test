package nagisa.util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class NagisaUtil
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
		public function NagisaUtil(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function str_removePrefix(str:String) : String
		{
			if(!str)return null;
			var index:int = str.indexOf(".");
			if(index == -1)return str;
			return str.substr(0,index);
		}
		
		public static function str_getFolder(str:String) : String
		{
			if(!str)return null;
			var index:int = str.lastIndexOf("/");
			if(index == -1)return str;
			return str.substr(0,index);
		}
		
		public static function str_getName(url:String):String
		{
			if(!url)return null;
			var folder_length:int	= str_getFolder(url).length + 1;
			var name:String			= NagisaUtil.str_removePrefix(url);
			return name.substr(folder_length,name.length - folder_length);
		}
		
		public static function str_getPath(folder:String,name:String,fix:String = null):String
		{
			folder	= folder ? folder + '/' : '';
			name	= name || '';
			fix		= fix ? '.'+fix : '';
			return folder + name + fix;
		}
		
		public static function rect_zoom(rect:Rectangle,scaleX:Number = 1,scaleY:Number = 1):Rectangle
		{
			var new_rect:Rectangle = rect.clone();
			var sgnX:int = MathUtil.sgn(scaleX);
			var sgnY:int = MathUtil.sgn(scaleY);
			
			if(!sgnX)new_rect.width = 0;
			else{
				if(sgnX == -1)new_rect.x = -rect.right; 
				new_rect.x *= (scaleX * sgnX);
				new_rect.width *= (scaleX * sgnX);
			}
			if(!sgnY)new_rect.height = 0;
			else{
				if(sgnY == -1)new_rect.y = -rect.bottom; 
				new_rect.y *= (scaleY * sgnY);
				new_rect.height *= (scaleY * sgnY);
			}
			return new_rect;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function func_getCurrentStack():String
		{
			var stack:String = (new Error()).getStackTrace();
			
			return stack;
		}
	}
}