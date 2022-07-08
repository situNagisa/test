package nagisa.protect.tool.meltdraw.state
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	import nagisa.protect.tool.meltdraw.MainTool;
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.protect.tool.meltdraw.interfaces.BaseCtrlState;
	
	public class DataState extends BaseCtrlState
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _txt:TextField;
		private var _showText:TextField;
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
		public function DataState(
			parent:DisplayObjectContainer
		):void
		{
			BaseCtrlState.InitializeByResource(this,'dataState');
			if(parent)parent.addChild(display);
			_initialize();
		}
		private function _initialize():void
		{
			_txt			= _sprite.getChildByName('txt') as TextField;
			_showText		= _sprite.getChildByName('show_txt') as TextField;
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		override public function render():void
		{
			try{
				_txt.text = 
					'frames: ' + String(ToolConfig.melt_caches ? ToolConfig.melt_caches.length : 0) + '\n' +
					'frame: '+ MainTool.I.drawSprite.mainDisplay.melt.frame + '\n' +
					'scale: '+ MainTool.I.drawSprite.mainDisplay.display.scaleX + '\n' +
					'filterScaleX: '+ MainTool.I.drawSprite.mainDisplay.melt.mapFilter.scaleX + '\n' +
					'filterScaleY: '+ MainTool.I.drawSprite.mainDisplay.melt.mapFilter.scaleY + '\n' +
					'isPlaying: '+ MainTool.I.drawSprite.mainDisplay.melt.isPlaying + '\n' +
					'isRender: '+ MainTool.I.drawSprite.mainDisplay.isRenderMelt + '\n' +
					'active: ' + MainTool.I.drawSprite.mainDisplay.melt.isActive + '\n' ;
			}catch(e:Error){
				trace('DataState.render Error::'+e.message);
			}
			
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function show(text:String):void
		{
			_showText.text = text;
		}
	}
}