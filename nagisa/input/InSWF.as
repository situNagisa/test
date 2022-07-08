package nagisa.input
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class InSWF
	{
		
		
		private var _swf:Object;
		
		private var _domain:ApplicationDomain;
		
		public var isReady:Boolean;
		
		public var ready:Function;
		
		public var error:Function;
		
		function InSWF(swfClass:Class)
		{
			super();
			_swf = new swfClass();
			var bytes:ByteArray = _swf.movieClipData;
			if(!bytes)
			{
				error("未发现swf的movieClipData!");
				throw new Error("未发现swf的movieClipData!");
			}
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener("complete",loadComplete,false,0,true);
			var lc:LoaderContext;
			((lc = new LoaderContext(false,ApplicationDomain.currentDomain)) as Object).allowCodeImport = true;
			loader.loadBytes(bytes,lc);
		}
		
		public function getClass(name:String):Class
		{
			return _domain.getDefinition(name) as Class;
		}
		
		private function loadComplete(e:Event):void
		{
			var l:LoaderInfo = e.currentTarget as LoaderInfo;
			_domain = l.applicationDomain;
			isReady = true;
			if(ready != null)
			{
				ready(this);
				ready = null;
			}
		}
	}
}