package nagisa.display
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import nagisa.ease.TweenManager;
	import nagisa.events.NEventDispatcher;
	import nagisa.util.DisplayUtil;
	import nagisa.util.MathUtil;
	
	public class NDisplayObject extends NEventDispatcher
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		protected var _display:DisplayObject;
		protected var _tweenManager:TweenManager;
		
		protected var _directX:int				= 1;
		protected var _directY:int				= 1;
		protected var _x: Number				= 0;
		protected var _y: Number				= 0;
		protected var _scaleX:Number			= 1;
		protected var _scaleY:Number			= 1;
		protected var _rotation:Number			= 0;
		
		private var _velocity:Point;
		private var _damping:Point;
		private var _speedPlus:Number = 1;
		private var _dampingRate:Number = 1;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get rotation():Number{return _rotation;}
		public function set rotation(v:Number):void{_rotation = v;}
		public function get radian():Number{return MathUtil.asRadian(_rotation);}
		public function set radian(v:Number):void{_rotation = MathUtil.asRotation(v);}
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function NDisplayObject()
		{
			super();
		}
		public function initialize():void
		{
			_tweenManager = new TweenManager();
			_velocity = new Point();
			_damping = new Point();
		}
		override public function destory(dispose:Boolean=true):void
		{
			if(_display){
				DisplayUtil.removeChild(_display);
				try{
					if('destory' in _display){
						(_display as Object).destory(dispose);
					}else if('stopAllMovieClips' in _display){
						(_display as Object).stopAllMovieClips();
					}
				}catch(e:Error){
					trace('NDisplayObject.destory Error:: '+e);
				}
			}
			if(_tweenManager){
				_tweenManager.destory(dispose);
			}
			if(dispose){
				_display = null;
				_velocity = null;
				_damping = null;
				_tweenManager = null;
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
			if(_tweenManager)_tweenManager.render();
			_renderVelocity();
			_renderDisplay();
		}
		private function _renderDisplay():void
		{
			with(_display){
				x			= _x;
				y			= _y;
				rotation	= _rotation;
				scaleX		= _scaleX * _directX;
				scaleY		= _scaleY * _directY;
			}
		}
		private function _renderVelocity():void{
			var resultX:Number = 0;
			var resultY:Number = 0;
			if (_velocity.x) {
				resultX += _velocity.x;
				if (_damping.x > 0)_velocity.x = MathUtil.near(0,_velocity.x, (_damping.x * _dampingRate));
			}
			if (_velocity.y) {
				resultY += _velocity.y;
				if (_damping.y > 0)_velocity.y = MathUtil.near(0,_velocity.y, (_damping.y * _dampingRate));
			}
			if (resultX || resultY) move(resultX, resultY);
		}
		override public function renderAnimate():void
		{
			super.renderAnimate();
			if(_destoryed)return;
			if(_tweenManager)_tweenManager.renderAnimate();
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function move(x:Number = 0, y:Number = 0):void{
			if (x)_x += x * _speedPlus;
			if (y) _y += y * _speedPlus;
		}
		public function setVelocity(speedX:Number = 0, speedY:Number = 0):void{
			_velocity.x = speedX;
			_velocity.y = speedY;
		}
		public function setDamping(damX:Number = 0, damY:Number = 0):void{
			_damping.x = (damX * NagisaConfig.SPEED_PLUS_DEFAULT * 2);
			_damping.y = (damY * NagisaConfig.SPEED_PLUS_DEFAULT * 2);
		}
		public function setSpeedRate(v:Number):void{
			_speedPlus = v;
			_dampingRate = (v / NagisaConfig.SPEED_PLUS_DEFAULT);
		}
	}
}