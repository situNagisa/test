package nagisa.protect.tool.meltdraw.events
{
	import flash.events.Event;
	
	import nagisa.events.NEventDispatcher;
	import nagisa.interfaces.Instance;
	
	public class ToolEventDispatcher extends Instance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static var _dispatcher:NEventDispatcher = new NEventDispatcher();
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
		
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function ToolEventDispatcher(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		/**
		 * 侦听
		 * 
		 * @param type 事件类型
		 * @param listener 侦听函数(e:Event):void
		 * 
		 * @return null 
		 */
		public static function listen(type:String, listener:Function):void
		{
			_dispatcher.listen(type,listener);
		}
		/**
		 * 删除侦听函数
		 * 
		 * @param type 事件类型
		 * @param listener 侦听函数(e:Event):void
		 * 
		 * @return null 
		 */
		public static function remove(type:String, listener:Function):void
		{
			_dispatcher.remove(type,listener);
		}
		/**
		 * 删除一类侦听函数
		 * 
		 * @param type 事件类型，不填或为null是删除所有侦听函数
		 * 
		 * @return null 
		 */
		public static function removeAll(type:String = null):void
		{
			_dispatcher.removeAll(type);
		}
		/**
		 * 是否存在某个侦听函数或事件类型
		 * 
		 * @param type 事件类型
		 * @param listener 侦听函数(e:Event):void
		 * 
		 * @return null 
		 */
		public static function has(type:String, listener:Function = null):Boolean
		{
			return _dispatcher.has(type,listener);
		}
		/**
		 * 发送一个事件
		 * 
		 * @param event 事件
		 * @return null 
		 */
		public static function dispatch(event:Event):void
		{
			_dispatcher.dispatch(event);
		}
	}
}