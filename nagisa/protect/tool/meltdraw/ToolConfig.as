package nagisa.protect.tool.meltdraw
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class ToolConfig
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		//public static const FILE_PATH:String = 
		public static const DRAW_SIZE:Point = new Point(1300,900);
		public static const CTRL_SIZE:Point = new Point(300,900);
		public static const SHOW_SIZE_DEFAULT:Point = new Point(650,450);
		
		public static var show_width:Number = SHOW_SIZE_DEFAULT.x;
		public static var show_height:Number = SHOW_SIZE_DEFAULT.y;
		
		public static var melt_type:String = null;
		public static var melt_params:Object = null;
		public static var melt_caches:Vector.<BitmapData>;
		public static var melt_caches_frame:int = -1;
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
		public function ToolConfig()
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
	}
}