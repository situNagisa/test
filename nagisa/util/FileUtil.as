package nagisa.util
{
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import nagisa.protect.tool.meltdraw.MainTool;

	public class FileUtil
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static var defaultPath:String				= null;//file:///F:/NAGISA/Application/MeltDraw/MeltDraw/melt.png
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public static function get defaultFolder():String
		{
			if(!defaultPath)return null;
			return NagisaUtil.str_getFolder(defaultPath);
		}
		public static function get defaultName():String
		{
			if(!defaultPath)return null;
			return NagisaUtil.str_getName(defaultPath);
		}
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function FileUtil(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function saveBitmapData(bitmapData:*):void
		{
			if(!bitmapData)return;
			var i:int = 0;
			var bitmapDatas:*;
			var pngs:Vector.<ByteArray> = new Vector.<ByteArray>();
			switch(ClassUtil.checkTargetType(bitmapData,BitmapData,Array,Vector.<*>)){
				case -1:
					return;
				case 0:
					bitmapDatas = [bitmapData];
					break;
				case 1:
				case 2:
					bitmapDatas = bitmapData;
					if(!bitmapDatas.length)return;
					break;
			}
			while(i < bitmapDatas.length){
				pngs[pngs.length] = PNGEncoder.encode(bitmapDatas[i]);
				i++;
			}
			save(pngs,'png');
		}
		public static function save(byte:*,fix:String = null):void
		{
			if(!byte)return;
			var file:File = new File(defaultPath);
			var bytes:*;
			var saveComplete:Function;
			
			switch(ClassUtil.checkTargetType(byte,ByteArray,Array,Vector.<*>)){
				case -1:
					return;
				case 0:
					bytes = [byte];
					break;
				case 1:
				case 2:
					bytes = byte;
					if(!bytes.length)return;
					break;
			}
			
			saveComplete = function(e:Event):void
			{
				var newFile:File = e.target as File;
				var name:String = newFile.name;
				var b:ByteArray;
				var i:int = 0;
				
				defaultPath = newFile.url;
				var fileStream:FileStream = new FileStream();
				while(i < bytes.length)
				{
					b = bytes[i];
					if(!b)continue;
					file = new File(NagisaUtil.str_getPath(defaultFolder,name+'_'+i,fix));
					fileStream.open(file,"write");
					fileStream.writeBytes(b,0,b.length);
					fileStream.close();
					i++;
				}
			};
			file.addEventListener(Event.SELECT,saveComplete);
			file.browseForSave('Save Data');
		}
		public static function browse(loadComplete:Function,...fileFilters) : void
		{
			var file:File = new File(defaultPath);
			var onLoadComplete:Function = function(e:Event):void{
				var loader:Loader = new Loader();
				
				defaultPath = file.url;
				
				loader.loadBytes(file.data);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
				
			};
			
			file.addEventListener(Event.SELECT,_selectHandler);
			file.addEventListener(Event.COMPLETE,onLoadComplete);
			file.browse(fileFilters);
		}
		private static function _selectHandler(e:Event):void
		{
			var file:File = e.target as File;
			file.load();
		}
	}
}