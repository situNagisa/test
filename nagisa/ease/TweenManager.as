package nagisa.ease
{
	import nagisa.events.NEventDispatcher;
	
	public class TweenManager extends NEventDispatcher
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _tweens:Vector.<Tween>;
		
		private var _isRenderAnimate:Boolean = false;
		private var _isPlaying:Boolean = true;
		private var _speedPlus:Number = 1;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get isPlaying():Boolean{
			return _isPlaying;
		}
		public function get tweens():Vector.<Tween>{return _tweens;}
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function TweenManager()
		{
			super();
			_tweens = new Vector.<Tween>();
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		override public function render():void
		{
			super.render();
			if(_destoryed)return;
			var i:int = 0;
			var tween:Tween;
			if(_tweens && _tweens.length){
				while(i < _tweens.length){
					tween = _tweens[i];
					tween.speedPlus = _speedPlus;
					_isPlaying ? tween.play() : tween.stop();
					tween.render();
					if(_isRenderAnimate)tween.renderAnimate();
					if(!tween.isActive){
						tween.destory(true);
						_tweens.splice(i,1);
						continue;
					}
					i++;
				}
			}
			_isRenderAnimate = false;
		}
		override public function renderAnimate():void
		{
			super.renderAnimate();
			if(_destoryed)return;
			_isRenderAnimate = true;
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function setSpeedPlus(v:Number):void
		{
			_speedPlus = v;
		}
		public function play():void
		{
			_isPlaying = true;
		}
		public function stop():void
		{
			_isPlaying = false;
		}
		public function from(target:Object,totalFrames:int,vars:Object):void
		{
			var tween:Tween = Tween.from(target,totalFrames,vars);
			_tweens[_tweens.length] = tween;
		}
		public function to(target:Object,totalFrames:int,vars:Object):void
		{
			var tween:Tween = Tween.to(target,totalFrames,vars);
			_tweens[_tweens.length] = tween;
		}
	}
}