package nagisa.protect.tool.meltdraw.state.state
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.protect.tool.meltdraw.events.ToolEvent;
	import nagisa.protect.tool.meltdraw.events.ToolEventDispatcher;
	import nagisa.protect.tool.meltdraw.interfaces.BaseCtrlState;
	import nagisa.protect.tool.meltdraw.state.interfaces.BaseMeltState;
	
	public class PointState extends BaseMeltState
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
		private var _rangeXInput:DisplayObject;
		private var _rangeYInput:DisplayObject;
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		override public function get x():Number{return Number(_xInput['text']);}
		override public function get y():Number{return Number(_yInput['text']);}
		public function get force():Object{return {x:Number(_forceXInput['text']),y:Number(_forceYInput['text'])};}
		public function get range():Object{return {x:Number(_rangeXInput['text']),y:Number(_rangeYInput['text'])};}
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function PointState(
		):void
		{
			super(BaseMeltState.POINT);
			BaseCtrlState.InitializeByResource(this,'pointState');
			_initialize();
		}
		override protected function _initialize():void
		{
			super._initialize();
			_xInput				= _sprite.getChildByName('xInput');
			_yInput				= _sprite.getChildByName('yInput');
			_forceXInput		= _sprite.getChildByName('forceXInput');
			_forceYInput		= _sprite.getChildByName('forceYInput');
			_rangeXInput		= _sprite.getChildByName('rangeXInput');
			_rangeYInput		= _sprite.getChildByName('rangeYInput');
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		override public function render():void
		{
			ToolConfig.melt_params = {force:force,r:range};
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
	}
}