package nagisa.controls
{
	import flash.display.DisplayObjectContainer;

	public class NComponent
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
		public function NComponent(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function addButton(label: String, x: Number, y: Number, w: Number = 100, h: Number = 50, click: Function = null):NSimpButton
		{
			var btn:NSimpButton = new NSimpButton(label,w,h);
			btn.x = x;
			btn.y = y;
			if (click != null) btn.onClick(click);
			return btn;
		}
	}
}