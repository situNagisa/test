package nagisa.protect.tool.meltdraw
{
	public class Resource
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static var _i:Resource;
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source="/../libs_swf/source.swf")]
		public var source:Class;
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public static function get I():Resource{return (_i = _i || new Resource())};
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function Resource()
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