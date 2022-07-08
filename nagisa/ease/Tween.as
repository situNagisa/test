package nagisa.ease
{
	
	import com.greensock.easing.Linear;
	
	import nagisa.interfaces.Instance;
	
	public class Tween extends Instance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		protected static var _reservedProps:Object = {
			"ease":1,
			"delay":1,
			"overwrite":1,
			"onComplete":1,
			"onCompleteParams":1,
			"useFrames":1,
			"runBackwards":1,
			"startAt":1,
			"onUpdate":1,
			"onUpdateParams":1,
			"onStart":1,
			"onStartParams":1,
			"onInit":1,
			"onInitParams":1,
			"onReverseComplete":1,
			"onReverseCompleteParams":1,
			"onRepeat":1,
			"onRepeatParams":1,
			"proxiedEase":1,
			"easeParams":1,
			"yoyo":1,
			"onCompleteListener":1,
			"onUpdateListener":1,
			"onStartListener":1,
			"onReverseCompleteListener":1,
			"onRepeatListener":1,
			"orientToBezier":1,
			"timeScale":1,
			"immediateRender":1,
			"repeat":1,
			"repeatDelay":1,
			"timeline":1,
			"data":1,
			"paused":1
		};
		public static function from(target:Object, totalFrames:int, vars:Object):Tween
		{
			vars.runBackwards = true;
			return new Tween(target, totalFrames, vars);
		}
		public static function to(target:Object, totalFrames:int, vars:Object):Tween
		{
			return new Tween(target, totalFrames, vars);
		}
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		public var vars:Object;
		
		public var ease:Function = null;
		
		public var onComplete:Function = null;
		public var onCompleteParams:Array;
		
		public var runBackwards:Boolean = false;
		
		public var currentFrame:Number		= 0;
		public var totalFrames:Number		= 0;
		
		private var _target:Object;
		private var _initialTarget:Object;
		
		private var _isComplete:Boolean = false;
		private var _isPlaying:Boolean = true;
		
		private var _speedPlus:Number = 1;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get target():Object{return _target;}
		public function set target(v:Object):void{
			if(!v){
				trace('Tween.set target Error::target can not be null!');
				return;
			}
			_target = v;
		}
		override public function get isActive():Boolean
		{
			return !_isComplete;
		}
		public function get isPlaying():Boolean{
			return _isPlaying;
		}
		public function get speedPuls():Number{return _speedPlus;}
		public function set speedPlus(v:Number):void{_speedPlus = v;}
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function Tween(target:Object, totalFrames:int, vars:Object)
		{
			super();
			_target = target;
			this.totalFrames = totalFrames
			this.vars = vars;
			
			_initialize(vars);
		}
		private function _initialize(params:Object):void
		{
			_initialTarget = {};
			var value:*;
			for(var key:String in params){
				value = params[key];
				if(!(key in _reservedProps)){
					_initialTarget[key] = target[key];
					continue;
				}
				if(key in this)this[key] = value;
				switch(key){
					case 'ease':
						
						break;
					case 'onComplete':
						
						break;
					case 'onCompleteParams':
						
						break;
					case 'runBackwards':
						
						break;
				}
			}
			if(runBackwards){
				for(key in params){
					value = params[key];
					if((key in _reservedProps))continue;
					target[key] = value;
				}
			}
			ease = ease || Linear.easeNone;
		}
		override public function destory(dispose:Boolean=true):void{
			_target = null;
			_initialTarget = null;
			super.destory(dispose);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		override public function renderAnimate():void
		{
			super.renderAnimate();
			if(_destoryed)return;
			if(target is Instance){
				if((target as Instance).isDestoryed())return;
			}
			_renderIsComplete();
			var cf:Number = runBackwards ? totalFrames - currentFrame : currentFrame;
			for(var key:String in vars){
				if(key in _reservedProps)continue;
				target[key] = ease(cf,_initialTarget[key],vars[key] - _initialTarget[key],totalFrames);
			}
			if(_isPlaying && currentFrame < totalFrames)currentFrame += 1 * _speedPlus;
		}
		private function _renderIsComplete():void
		{
			if(_isComplete)return;
			_isComplete = (currentFrame == totalFrames);
			if(_isComplete){
				if(onComplete != null)onComplete.apply(null,onCompleteParams);
				stop();
			}
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function play():void
		{
			_isPlaying = true;
		}
		public function stop():void
		{
			_isPlaying = false;
		}
	}
}