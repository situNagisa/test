package nagisa.protect.tool.meltdraw.state.state
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.protect.tool.meltdraw.events.ToolEvent;
	import nagisa.protect.tool.meltdraw.events.ToolEventDispatcher;
	import nagisa.protect.tool.meltdraw.interfaces.BaseCtrlState;
	import nagisa.protect.tool.meltdraw.state.interfaces.BaseMeltState;
	
	public class RectState extends BaseMeltState
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _xInput:DisplayObject;
		private var _yInput:DisplayObject;
		private var _forceXInput:DisplayObject;
		private var _forceYInput:DisplayObject;
		private var _widthInput:DisplayObject;
		private var _heightInput:DisplayObject;
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		override public function get x():Number{return Number(_xInput['text']);}
		override public function get y():Number{return Number(_yInput['text']);}
		public function get force():Object{return {x:Number(_forceXInput['text']),y:Number(_forceYInput['text'])};}
		public function get rect():Rectangle{return new Rectangle(x,y,Number(_widthInput['text']),Number(_heightInput['text']));}
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function RectState(
		):void
		{
			super(BaseMeltState.RECT);
			BaseCtrlState.InitializeByResource(this,'rectState');
			_initialize();
		}
		override protected function _initialize():void
		{
			super._initialize();
			_xInput				= _sprite.getChildByName('xInput');
			_yInput				= _sprite.getChildByName('yInput');
			_forceXInput		= _sprite.getChildByName('forceXInput');
			_forceYInput		= _sprite.getChildByName('forceYInput');
			_widthInput			= _sprite.getChildByName('widthInput');
			_heightInput		= _sprite.getChildByName('heightInput');
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		override public function render():void
		{
			ToolConfig.melt_params = {force:force,rect:rect};
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		override protected function _addMelt(e:Event):void
		{
			
		}
	}
}