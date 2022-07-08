package nagisa.protect.tool.meltdraw.ctrl
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.FileFilter;
	
	import nagisa.interfaces.Instance;
	import nagisa.protect.tool.meltdraw.MainTool;
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.protect.tool.meltdraw.events.ToolEvent;
	import nagisa.protect.tool.meltdraw.events.ToolEventDispatcher;
	import nagisa.protect.tool.meltdraw.state.interfaces.BaseMeltState;
	import nagisa.util.DisplayUtil;
	import nagisa.util.FileUtil;
	
	public class ToolEventCtrler extends Instance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static var _i:ToolEventCtrler;
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _pic:BitmapData;
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public static function get I():ToolEventCtrler{return (_i = _i || new ToolEventCtrler())}
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function ToolEventCtrler(
		):void
		{
		}
		public function initialize():void
		{
			ToolEventDispatcher.listen(ToolEvent.SAVE,_save);
			ToolEventDispatcher.listen(ToolEvent.RELOAD,_reload);
			ToolEventDispatcher.listen(ToolEvent.PLAY,_play);
			ToolEventDispatcher.listen(ToolEvent.RECORD,_record);
			ToolEventDispatcher.listen(ToolEvent.ADD_MELT,_addMelt);
			ToolEventDispatcher.listen(ToolEvent.SHOW_MELT,_showMelt);
			ToolEventDispatcher.listen(ToolEvent.PLAY_CACHE,_playCache);
			ToolEventDispatcher.listen(ToolEvent.CLEAR,_clear);
			ToolEventDispatcher.listen(ToolEvent.BREAK,_break);
			ToolEventDispatcher.listen(ToolEvent.NEXT_FRAME,_nextFrame);
			ToolEventDispatcher.listen(ToolEvent.LOAD_PIC,_loadPic);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		private function _save(e:ToolEvent):void
		{
			if(!ToolConfig.melt_caches || !ToolConfig.melt_caches.length)return;
			if(ToolConfig.melt_caches_frame != -1 && ToolConfig.melt_caches.length > ToolConfig.melt_caches_frame){
				var saveData:Vector.<BitmapData> = ToolConfig.melt_caches.concat();
				saveData.splice(ToolConfig.melt_caches_frame,4294967295);
			}else{
				saveData = ToolConfig.melt_caches;
			}
			/*var bd:BitmapData;
			var i:int = 0;
			for(i = 0;i < saveData.length;i++){
				bd = saveData[i];
				saveData[i] = DisplayUtil.BitmapDataColorFilter(bd,0xFF008080,i == 0);
			}*/
			FileUtil.saveBitmapData(saveData);
		}
		private function _reload(e:ToolEvent):void
		{
			if(_pic){
				MainTool.I.drawSprite.mainDisplay.initialize(_pic);
				MainTool.I.drawSprite.mainDisplay.endRecord();
				ToolConfig.melt_caches = null;
				return;
			}
			var w:Number = e.params.width;
			var h:Number = e.params.height;
			MainTool.I.drawSprite.mainDisplay.initialize(w,h);
			MainTool.I.drawSprite.mainDisplay.endRecord();
			ToolConfig.melt_caches = null;
		}
		private function _play(e:ToolEvent):void
		{
			MainTool.I.drawSprite.mainDisplay.isRenderMelt = !MainTool.I.drawSprite.mainDisplay.isRenderMelt;
		}
		private function _record(e:ToolEvent):void
		{
			MainTool.I.drawSprite.mainDisplay.isRecord ? MainTool.I.drawSprite.mainDisplay.endRecord() : MainTool.I.drawSprite.mainDisplay.startRecord();
		}
		private function _addMelt(e:ToolEvent):void
		{
			if(MainTool.I.drawSprite.mainDisplay.melt.useRecord){
				_playCache(e);
				return;
			}
			switch(ToolConfig.melt_type){
				case BaseMeltState.POINT:
					MainTool.I.drawSprite.mainDisplay.melt.addPointForce.apply(null,[e.params.x,e.params.y,ToolConfig.melt_params]);
					break;
				case BaseMeltState.RECT:
					MainTool.I.drawSprite.mainDisplay.melt.addRectForce.apply(null,[e.params.x,e.params.y,ToolConfig.melt_params]);
					break;
				default:
					return;
			}
			MainTool.I.drawSprite.mainDisplay.startRecord();
			
		}
		private function _showMelt(e:ToolEvent):void
		{
			MainTool.I.drawSprite.mainDisplay.showMeltBitmap.visible = !MainTool.I.drawSprite.mainDisplay.showMeltBitmap.visible;
		}
		private function _playCache(e:ToolEvent):void
		{
			if(MainTool.I.drawSprite.mainDisplay.melt.useRecord){
				MainTool.I.drawSprite.mainDisplay.melt.start();
				return;
			}
			MainTool.I.drawSprite.mainDisplay.initialize(ToolConfig.melt_caches);
		}
		private function _clear(e:ToolEvent):void
		{
			var w:Number = e.params.width;
			var h:Number = e.params.height;
			MainTool.I.drawSprite.mainDisplay.initialize(w,h);
		}
		private function _break(e:ToolEvent):void
		{
			
		}
		private function _nextFrame(e:ToolEvent):void
		{
			if(!MainTool.I.drawSprite.mainDisplay.melt.isPlaying){
				MainTool.I.drawSprite.mainDisplay.melt.start();
				return;
			}
			MainTool.I.drawSprite.mainDisplay.renderMelt();
		}
		private function _loadPic(e:ToolEvent):void
		{
			FileUtil.browse(_loadComplete,new FileFilter("JPG;GIF;PNG","*.jpg;*.gif;*.png"));
		}
		private function _loadComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo	= e.target as LoaderInfo;
			var loader:Loader			= loaderInfo.loader;
			var bp:Bitmap				= loader.content as Bitmap;
			
			MainTool.I.show(loader.content.toString());
			_pic = bp.bitmapData;
			_reload(null);
		}
	}
}