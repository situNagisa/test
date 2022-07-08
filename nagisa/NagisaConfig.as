package nagisa
{
	import flash.filesystem.File;

	public class NagisaConfig
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static var FPS:int					= 30;
		public static const FPS_Animate:int		= 30;
		public static var SPEED_PLUS:Number		= SPEED_PLUS_DEFAULT;
		public static var SOUND_VOLUME:Number		= 1;
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
		public function NagisaConfig()
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function setGameFps(v:int) : void
		{
			FPS = v;
			SPEED_PLUS = SPEED_PLUS_DEFAULT;
		}
		
		public static function get SPEED_PLUS_DEFAULT() : Number
		{
			return 30 / FPS;
		}
	}
}