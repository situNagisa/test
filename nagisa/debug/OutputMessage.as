package nagisa.debug
{
	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class OutputMessage
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
		public function OutputMessage(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function TRACE(cla:String,method:String,type:String,...params):void
		{
			var stack:String = cla + '.' + method + ' ' + type + ' :: ';
			params.unshift(stack);
			trace.call(null,params);
		}
		
		public static function ERROR(cla:String,method:String,message:String,error:Error = null):void
		{
			error = error || new Error();
			var stack:String = cla + '.' + method + ' ' + error.name + ' :: ' + message;
			trace(stack,'\n Error Message : [ ' + error.message + ' ] ');
		}
		//--------------------------------------
		// EVENTS
		//--------------------------------------
	}
}