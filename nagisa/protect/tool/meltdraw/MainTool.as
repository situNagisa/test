package nagisa.protect.tool.meltdraw
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import nagisa.events.NEventDispatcher;
	import nagisa.input.BindSWF;
	import nagisa.protect.tool.meltdraw.ctrl.ToolCtrl;
	import nagisa.protect.tool.meltdraw.ctrl.ToolEventCtrler;
	import nagisa.protect.tool.meltdraw.ctrl.ToolShow;
	
	public class MainTool extends NEventDispatcher
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const VERSON:String = 'v0.1';
		
		private static var _i:MainTool;
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _root:Sprite;
		private var _stage:Stage;
		private var _drawSprite:ToolShow;
		private var _ctrlerSprite:ToolCtrl;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public static function get I():MainTool{return _i;}
		public function get drawSprite():ToolShow{return _drawSprite;}
		public function get ctrlerSprite():ToolCtrl{return _ctrlerSprite;}
		public function get stage():Stage{return _stage;}
		public function get root():Sprite{return _root;}
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function MainTool()
		{
			super();
			_i = this;
		}
		public function initialize(root:Sprite,stage:Stage,initBack:Function = null,initFail:Function = null):void
		{
			var resBack:Function = function():void{
				_root			= root;
				_stage			= stage;
				
				_initDrawSprite();
				_initCtrlerSprite();
				if(initBack != null)initBack();
			}
			_initResource(resBack,initFail);
			ToolEventCtrler.I.initialize();
		}
		private function _initResource(initBack:Function = null,initFail:Function = null):void
		{
			BindSWF.I.initialize();
			BindSWF.I.bind(Resource.I,initBack,initFail);
		}
		private function _initDrawSprite():void
		{
			_drawSprite		= new ToolShow();
			_drawSprite.initialize(ToolConfig.DRAW_SIZE);
			_drawSprite.x = _drawSprite.y = 0;
			_root.addChild(_drawSprite);
		}
		private function _initCtrlerSprite():void
		{
			_ctrlerSprite	= new ToolCtrl();
			_ctrlerSprite.initialize(ToolConfig.CTRL_SIZE);
			_ctrlerSprite.x	= ToolConfig.DRAW_SIZE.x;
			_ctrlerSprite.y	= 0;
			_root.addChild(_ctrlerSprite);
		}
		override public function destory(dispose:Boolean=true):void
		{
			if(_drawSprite){
				_drawSprite.destory(dispose);
			}
			if(_ctrlerSprite){
				_ctrlerSprite.destory(dispose);
			}
			if(dispose){
				_drawSprite = null;
				_ctrlerSprite = null;
			}
			super.destory(dispose);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		override public function render():void
		{
			super.render();
			if(_destoryed)return;
			if(_drawSprite){
				_drawSprite.render();
			}
			if(_ctrlerSprite){
				_ctrlerSprite.render();
			}
		}
		override public function renderAnimate():void
		{
			super.renderAnimate();
			if(_destoryed)return;
			if(_drawSprite){
				_drawSprite.renderAnimate();
			}
			if(_ctrlerSprite){
				_ctrlerSprite.renderAnimate();
			}
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function show(text:String):void
		{
			_ctrlerSprite.dataState.show(text);
		}
	}
}