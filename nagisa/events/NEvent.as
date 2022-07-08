package nagisa.events
{
	import flash.events.Event;
	
	public class NEvent extends Event
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		public var params:Object
		
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
		public function NEvent(type:String, params:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			params = params;
			super(type, bubbles, cancelable);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		//--------------------------------------
		// EVENTS
		//--------------------------------------
	}
}