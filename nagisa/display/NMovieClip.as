package nagisa.display
{
	import flash.display.MovieClip;
	
	import nagisa.events.NEvent;
	import nagisa.events.NEventDispatcher;
	import nagisa.interfaces.IInstance;

	public class NMovieClip extends MovieClip implements IInstance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const GOTO_AND_PLAY:String			= 'gotoAndPlay';
		public static const GOTO_AND_STOP:String			= 'gotoAndStop';
		public static const PLAY:String					= 'play';
		public static const STOP:String					= 'stop';
		public static const NEXT_FRAME:String				= 'nextFrame';
		public static const PREV_FRAME:String				= 'prevFrame';
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		protected var _dispatcher:NEventDispatcher;
		
		protected var _destoryed:Boolean = false;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get isActive():Boolean{return Boolean(_dispatcher);}
		public function get dispatcher():NEventDispatcher
		{
			return _dispatcher;
		}
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function NMovieClip()
		{
			super();
			_initialize();
		}
		private function _initialize():void
		{
			_dispatcher = new NEventDispatcher();
		}
		public function destory(dispose:Boolean = true):void
		{
			if(_dispatcher){
				_dispatcher.destory(dispose);
			}
			_destoryed = true;
		}
		public function isDestoryed():Boolean{return _destoryed;}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		public function render():void
		{
			
		}
		public function renderAnimate():void
		{
			
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		override public function gotoAndPlay(frame:Object, scene:String=null):void
		{
			var params:Array = [frame,scene];
			if(_dispatcher)_dispatcher.dispatch(new NEvent(NMovieClip.GOTO_AND_PLAY,params));
			super.gotoAndPlay.apply(null,params);
		}
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			var params:Array = [frame,scene];
			if(_dispatcher)_dispatcher.dispatch(new NEvent(NMovieClip.GOTO_AND_STOP,params));
			super.gotoAndStop.apply(null,params);
		}
		override public function play():void
		{
			if(_dispatcher)_dispatcher.dispatch(new NEvent(NMovieClip.PLAY));
			super.play();
		}
		override public function stop():void
		{
			if(_dispatcher)_dispatcher.dispatch(new NEvent(NMovieClip.STOP));
			super.stop();
		}
		override public function nextFrame():void
		{
			if(_dispatcher)_dispatcher.dispatch(new NEvent(NMovieClip.NEXT_FRAME));
			super.nextFrame();
		}
		override public function prevFrame():void
		{
			if(_dispatcher)_dispatcher.dispatch(new NEvent(NMovieClip.PREV_FRAME));
			super.prevFrame();
		}
		//--------------------------------------
		// EVENTS
		//--------------------------------------
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if(_dispatcher)_dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if(_dispatcher)_dispatcher.removeEventListener(type,listener,useCapture);
		}
	}
}