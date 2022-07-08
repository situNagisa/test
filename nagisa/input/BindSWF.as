package nagisa.input
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import nagisa.NagisaConfig;

	public class BindSWF
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static var _i:BindSWF;
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		
		private var _swfPool:Dictionary;
		
		private var _initBack:Function;
		
		private var _initError:Function;
		
		private var _inited:Boolean;
		
		private var _initing:Boolean;
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public static function get I():BindSWF{return (_i = _i || new BindSWF());}
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function BindSWF()
		{
		}
		public function initialize() : void
		{
			if(_initing)throw new Error("正在初始化过程中，不能再次初始化！");
			if(_inited)return;
			_inited = true;
			_initing = true;
			_swfPool = new Dictionary();
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function bind(source:Object,back:Function = null, error:Function = null) : void
		{
			var k:* = null;
			var cls:Class = null;
			var swf:InSWF = null;
			var xml:XML;
			
			_initBack = back;
			_initError = error;
			xml = describeType(source);
			for each(var j:* in xml.variable)
			{
				k = j.@name;
				if(!(source[k] is Class))continue;
				cls = source[k];
				(swf = new InSWF(cls)).ready = _swfReadyBack;
				swf.error = _swfErrorBack;
				_swfPool[cls] = swf;
			}
		}
		private function _swfReadyBack(target:InSWF) : void
		{
			for each(var i:InSWF in _swfPool)
			{
				if(!i.isReady)return;
			}
			_finish();
		}
		private function _swfErrorBack(msg:String) : void
		{
			if(_initError != null)_initError();
		}
		private function _finish() : void
		{
			_initing = false;
			if(_initBack != null)
			{
				_initBack();
				_initBack = null;
			}
		}
		public function createDisplayObject(embedSwf:Class, itemName:String):DisplayObject
		{
			var d:* = undefined;
			var mc:Sprite = null;
			var st:SoundTransform = null;
			var cls:Class = getItemClass(embedSwf,itemName);
			if(cls)
			{
				d = new cls();
				if(d is Sprite)
				{
					(st = (mc = d as Sprite).soundTransform).volume = NagisaConfig.SOUND_VOLUME;
					mc.soundTransform = st;
					return mc;
				}
			}
			return d;
		}
		
		public function createBitmapData(embedSwf:Class, itemName:String, width:int, height:int):BitmapData
		{
			var cls:Class;
			if(!(cls = getItemClass(embedSwf,itemName)))return null;
			return new cls(width,height);
		}
		
		public function getItemClass(embedSwf:Class, itemName:String) : Class
		{
			if(!_swfPool)throw new Error("未进行初始化！");
			var swf:InSWF = _swfPool[embedSwf];
			if(!swf)throw new Error("swf is undefined!");
			return swf.getClass(itemName);
		}
	}
}