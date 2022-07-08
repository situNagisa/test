package nagisa.protect.tool.meltdraw.interfaces
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import nagisa.input.BindSWF;
	import nagisa.protect.tool.meltdraw.Resource;
	import nagisa.protect.tool.meltdraw.interfaces.BaseCtrlState;
	import nagisa.interfaces.Instance;
	import nagisa.util.DisplayUtil;
	
	public class BaseCtrlState extends Instance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static function InitializeByResource(baseState:BaseCtrlState,clsName:String):void
		{
			var bsdState:MovieClip = BindSWF.I.createDisplayObject(Resource.I.source,clsName) as MovieClip;
			baseState.initialize(DisplayUtil.MovieClipToSprite(bsdState));
			if('init' in bsdState)bsdState.init();
		}
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		protected var _sprite:Sprite;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get display():DisplayObject{return _sprite;}
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function BaseCtrlState()
		{
			super();
		}
		public function initialize(sprite:Sprite = null):void
		{
			_sprite = sprite || new Sprite();
		}
		override public function destory(dispose:Boolean=true):void
		{
			if(_sprite){
				DisplayUtil.removeChild(_sprite);
			}
			if(dispose){
				_sprite = null;
			}
			super.destory(dispose);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
	}
}