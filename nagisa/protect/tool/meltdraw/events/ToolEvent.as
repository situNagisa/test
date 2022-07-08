package nagisa.protect.tool.meltdraw.events
{
	import flash.events.Event;
	
	public class ToolEvent extends Event
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const RELOAD:String			= 'reload';
		public static const PLAY:String			= 'play';
		public static const RECORD:String			= 'record';
		public static const ADD_MELT:String		= 'addMelt';
		public static const SHOW_MELT:String		= 'showMelt';
		public static const PLAY_CACHE:String		= 'playCache';
		public static const CLEAR:String			= 'clear';
		public static const NEXT_FRAME:String		= 'nextFrame';
		public static const BREAK:String			= 'break';
		public static const SAVE:String			= 'save';
		public static const LOAD_PIC:String		= 'loadPic';
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		public var params:Object;
		
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
		public function ToolEvent(type:String,params:Object = null)
		{
			super(type);
			this.params = params;
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
	}
}