package nagisa.protect.tool.meltdraw.state.interfaces
{
	import flash.events.Event;
	
	import nagisa.controls.NComponent;
	import nagisa.controls.NSimpButton;
	import nagisa.protect.tool.meltdraw.events.ToolEvent;
	import nagisa.protect.tool.meltdraw.events.ToolEventDispatcher;
	import nagisa.protect.tool.meltdraw.interfaces.BaseCtrlState;
	
	public class BaseMeltState extends BaseCtrlState
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const POINT:String		= 'point';
		public static const RECT:String		= 'rect';
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		public var type:String = null;
		
		private var _addMeltButton:NSimpButton;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get x():Number{return 0;}
		public function get y():Number{return 0;}
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function BaseMeltState(
			type:String = null
		):void
		{
			this.type = type;
		}
		protected function _initialize():void
		{
			_addMeltButton		= NComponent.addButton('addMelt!',190,180,60,30,_addMelt);
			_sprite.addChild(_addMeltButton);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		protected function _addMelt(e:Event):void
		{
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.ADD_MELT,{x:x,y:y}));
		}
	}
}