package nagisa.protect.tool.meltdraw.state
{
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import nagisa.NagisaConfig;
	import nagisa.controls.NComponent;
	import nagisa.controls.NSimpButton;
	import nagisa.protect.tool.meltdraw.MainTool;
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.protect.tool.meltdraw.events.ToolEvent;
	import nagisa.protect.tool.meltdraw.events.ToolEventDispatcher;
	import nagisa.protect.tool.meltdraw.interfaces.BaseCtrlState;
	import nagisa.util.FileUtil;
	
	public class ButtonState extends BaseCtrlState
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _saveButton:NSimpButton;
		private var _playButton:NSimpButton;
		private var _clearButton:NSimpButton;
		private var _breakButton:NSimpButton;
		private var _nextFrameButton:NSimpButton;
		private var _recordButton:NSimpButton;
		private var _showMeltButton:NSimpButton;
		private var _playByCacheButton:NSimpButton;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function ButtonState(parent:DisplayObjectContainer = null)
		{
			super();
			BaseCtrlState.InitializeByResource(this,'bottonState');
			if(parent)parent.addChild(display);
			_initialize();
		}
		private function _initialize():void
		{
			var gapX:Number		= 20;
			var gapY:Number		= 20;
			var startX:Number	= 40;
			var startY:Number	= 30;
			var xx:Number		= startX;
			var yy:Number		= startY;
			var ww:Number		= 60;
			var hh:Number		= 30;
			var addButton:Function = function(label:String,onClick:Function = null):NSimpButton{
				var button:NSimpButton = NComponent.addButton(label,xx,yy,ww,hh,onClick);
				if(xx + ww + ww < ToolConfig.CTRL_SIZE.x - startX){
					xx += ww + gapX;
				}else{
					xx = startX;
					yy += hh + gapY;
				}
				_sprite.addChild(button);
				return button;
			};
			
			_saveButton			= addButton('save',_save);
			_playButton			= addButton('stop',_play);
			_clearButton		= addButton('clear',_clear);
			_breakButton		= addButton('break',_break);
			_nextFrameButton	= addButton('nextFrame',_nextFrame);
			_recordButton		= addButton('startRecord',_record);
			_showMeltButton		= addButton('showMelt',_showMelt);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		private function _save(e:Event):void
		{
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.SAVE));
		}
		private function _play(e:Event):void
		{
			_playButton.text = _playButton.text == 'play' ? 'stop' : 'play';
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.PLAY));
		}
		private function _clear(e:Event):void
		{
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.CLEAR));
		}
		private function _break(e:Event):void
		{
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.BREAK));
		}
		private function _nextFrame(e:Event):void
		{
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.NEXT_FRAME));
		}
		private function _record(e:Event):void
		{
			_recordButton.text = _recordButton.text == 'recording' ? 'startRecord' : 'recording';
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.RECORD));
		}
		private function _showMelt(e:Event):void
		{
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.SHOW_MELT));
		}
	}
}