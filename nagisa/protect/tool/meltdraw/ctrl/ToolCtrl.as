package nagisa.protect.tool.meltdraw.ctrl
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import nagisa.input.BindSWF;
	import nagisa.interfaces.IInstance;
	import nagisa.protect.tool.meltdraw.Resource;
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.protect.tool.meltdraw.state.BaseDataState;
	import nagisa.protect.tool.meltdraw.state.ButtonState;
	import nagisa.protect.tool.meltdraw.state.DataState;
	import nagisa.protect.tool.meltdraw.state.MeltDataState;
	import nagisa.util.DisplayUtil;
	
	public class ToolCtrl extends Sprite implements IInstance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		protected var _destoryed:Boolean = false;
		
		private var _baseData:BaseDataState;
		private var _buttonState:ButtonState;
		private var _meltData:MeltDataState;
		private var _dataState:DataState;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get isActive():Boolean
		{
			return false;
		}
		public function get baseData():BaseDataState{return _baseData;}
		public function get buttonState():ButtonState{return _buttonState;}
		public function get meltData():MeltDataState{return _meltData;}
		public function get dataState():DataState{return _dataState;}
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function ToolCtrl()
		{
			super();
		}
		public function initialize(size:Point):void
		{
			graphics.beginFill(0x282828);
			graphics.drawRect(0,0,size.x,size.y);
			graphics.endFill();
			_initDefualtCtrl();
		}
		private function _initDefualtCtrl():void
		{
			_baseData			= new BaseDataState(this);
			_buttonState		= new ButtonState(this);
			_meltData			= new MeltDataState(this);
			_dataState			= new DataState(this);
			
			_baseData.display.y		= 0;
			_buttonState.display.y	= 700;
			_meltData.display.y		= 150;
			_dataState.display.y	= 450;
		}
		public function destory(dispose:Boolean=true):void
		{
			_destoryed = true;
		}
		
		public function isDestoryed():Boolean
		{
			return _destoryed;
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		public function render():void
		{
			if(_destoryed)return;
			_baseData.render();
			_buttonState.render();
			_meltData.render();
			_dataState.render();
		}
		
		public function renderAnimate():void
		{
			if(_destoryed)return;
			_baseData.renderAnimate();
			_buttonState.renderAnimate();
			_meltData.renderAnimate();
			_dataState.renderAnimate();
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
	}
}