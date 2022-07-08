package nagisa.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nagisa.interfaces.Instance;
	
	public class NRender extends Instance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static var _i:NRender;
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _isRender:Boolean = true;
		
		private var _renderFuncs:Vector.<Function>;
		private var _animateFuncs:Vector.<Function>
		
		private var _sprite:Sprite;
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public static function get I():NRender{
			return _i = _i || new NRender();
		}
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function NRender()
		{
			super();
		}
		public function initialize():void
		{
			_renderFuncs = new Vector.<Function>();
			_animateFuncs = new Vector.<Function>();
			_sprite = new Sprite();
			_sprite.addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		override public function destory(dispose:Boolean = true):void
		{
			_renderFuncs = null;
			if(_sprite){
				_sprite.removeEventListener(Event.ENTER_FRAME, frameHandler);
				_sprite = null;
			}
			super.destory(dispose);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		private function _render():void
		{
			if (!_isRender || !_renderFuncs || !_renderFuncs.length) return;
			activeFuncs(_renderFuncs);
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function addRender(renderFunc:Function):Boolean
		{
			var index:int;
			var funcs:Vector.<Function> = _renderFuncs;
			
			index = funcs.indexOf(renderFunc);
			if(index != -1)return false;
			funcs.push(renderFunc);
			return true;
		}
		public function removeRender(renderFunc:Function):Boolean
		{
			var index:int;
			var funcs:Vector.<Function> = _renderFuncs;
			
			index = funcs.indexOf(renderFunc);
			if(index == -1)return false;
			funcs.splice(index, 1);
			return true;
		}
		public function frameHandler(e:Event):void
		{
			_render();
		}
		private function activeFuncs(funcs:Vector.<Function>):void
		{
			var len:int = funcs.length;
			var i:int = 0;
			var func:Function;
			var func_arr:Array = [];
			if (len <= 0) return;
			while (i < len) {
				func_arr.push(funcs[i]);
				i ++;
			}
			for each(func in func_arr) {
				try {
					func();
				}catch (e:Error) {
					throw e;
				}
				
			}
		}
		public function stopRender():void
		{
			_isRender = false;
		}
		public function startRender():void
		{
			_isRender = true;
		}
	}
}