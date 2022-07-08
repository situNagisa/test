package nagisa.protect.tool.meltdraw.state
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.protect.tool.meltdraw.interfaces.BaseCtrlState;
	import nagisa.protect.tool.meltdraw.state.interfaces.BaseMeltState;
	import nagisa.protect.tool.meltdraw.state.state.PointState;
	import nagisa.protect.tool.meltdraw.state.state.RectState;
	
	public class MeltDataState extends BaseCtrlState
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _typeComboBox:DisplayObject;
		private var _type:String = null;
		
		private var _curState:BaseMeltState;
		private var _stateObj:Object;
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
		public function MeltDataState(parent:DisplayObjectContainer = null)
		{
			super();
			BaseCtrlState.InitializeByResource(this,'meltDataState');
			if(parent)parent.addChild(display);
			_initialize();
		}
		private function _initialize():void
		{
			_stateObj	= {};
			_typeComboBox			= _sprite.getChildByName('typeComboBox');
			
			_typeComboBox.addEventListener(Event.CHANGE,_changeType);
			
			_initTypeState();
		}
		private function _initTypeState():void{
			_addState(BaseMeltState.POINT);
			_addState(BaseMeltState.RECT);
			
			updateType();
		}
		override public function destory(dispose:Boolean=true):void
		{
			for each(var bmState:BaseMeltState in _stateObj){
				bmState.destory(true);
			}
			_stateObj = null;
			super.destory(dispose);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		override public function render():void
		{
			super.render();
			if(_destoryed)return;
			if(_curState)_renderCurState();
		}
		private function _renderCurState():void
		{
			ToolConfig.melt_type		= _curState.type;
			
			_curState.render();
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		private function _addState(type:String):void
		{
			var state:BaseMeltState;
			switch(type){
				case BaseMeltState.POINT:
					state = _stateObj[BaseMeltState.POINT] = new PointState();
					break;
				case BaseMeltState.RECT:
					state = _stateObj[BaseMeltState.RECT] = new RectState();
					break;
				default:
					return;
					break;
			}
			state.display.x = 20;
			state.display.y = 60;
		}
		private function _changeType(e:Event):void
		{
			updateType();
		}
		public function updateType():void
		{
			try{
				_type = _typeComboBox['value'];
			}catch(e:Error){
				trace('MeltDataState.updateType Error:: '+e);
			}
			if(!_type)return;
			if(_curState){
				_curState.destory(false);
			}
			_curState = _stateObj[_type];
			if(!_curState)return;
			_sprite.addChild(_curState.display);
		}
	}
}