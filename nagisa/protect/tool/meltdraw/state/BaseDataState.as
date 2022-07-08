package nagisa.protect.tool.meltdraw.state
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import nagisa.controls.NComponent;
	import nagisa.controls.NSimpButton;
	import nagisa.input.BindSWF;
	import nagisa.protect.tool.meltdraw.Resource;
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.protect.tool.meltdraw.events.ToolEvent;
	import nagisa.protect.tool.meltdraw.events.ToolEventDispatcher;
	import nagisa.protect.tool.meltdraw.interfaces.BaseCtrlState;
	import nagisa.util.DisplayUtil;
	
	public class BaseDataState extends BaseCtrlState
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _widthInput:Object;
		private var _heightInput:Object;
		private var _totalFrameInput:Object;
		private var _reloadButton:NSimpButton;
		private var _playCacheButton:NSimpButton;
		private var _loadPicButton:NSimpButton;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get width():Number{return Number(_widthInput.text)}
		public function get height():Number{return Number(_heightInput.text)}
		public function get totalFrame():int{return int(_totalFrameInput.text);}
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function BaseDataState(parent:DisplayObjectContainer = null)
		{
			super();
			BaseCtrlState.InitializeByResource(this,'baseShowDataState');
			if(parent)parent.addChild(display);
			_initialize();
		}
		private function _initialize():void
		{
			_widthInput			= _sprite.getChildByName('widthInput');
			_heightInput		= _sprite.getChildByName('heightInput');
			_totalFrameInput	= _sprite.getChildByName('totalFrameInput');
			_reloadButton		= NComponent.addButton('reload',30,110,60,30,_reload);
			_playCacheButton	= NComponent.addButton('playCache',110,110,60,30,_playCache);
			_loadPicButton		= NComponent.addButton('loadPic',190,110,60,30,_loadPic);
			_sprite.addChild(_reloadButton);
			_sprite.addChild(_playCacheButton);
			_sprite.addChild(_loadPicButton);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		private function _reload(e:Event):void
		{
			ToolConfig.show_width			= width;
			ToolConfig.show_height			= height;
			ToolConfig.melt_caches_frame	= totalFrame;
			
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.RELOAD,{width:width,height:height}));
		}
		private function _playCache(e:Event):void
		{
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.PLAY_CACHE));
		}
		private function _loadPic(e:Event):void
		{
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.LOAD_PIC));
		}
	}
}