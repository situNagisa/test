package nagisa.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import nagisa.interfaces.IInstance;
	import nagisa.interfaces.INEventDispatcher;
	import nagisa.util.ClassUtil;

	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class NEventDispatcher extends EventDispatcher implements IInstance,INEventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		protected var _destoryed:Boolean = false;
		private var _listeners:Object;
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get isActive():Boolean{return false;}
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function NEventDispatcher(
		):void
		{
			_listeners = { };
		}
		public function isDestoryed():Boolean { return _destoryed; }
		/**
		 * 格式化实例
		 * 
		 * @param dispose 是否完全格式化，填true则不可以用initialize进行初始化，并且请在完全格式化后删除对melt实例的引用
		 * 
		 * @return null 
		 */
		public function destory(dispose:Boolean = true):void
		{
			if(dispose){
				removeAll();
				_listeners = null;
			}
			_destoryed = true;
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		/**
		 * 渲染(每帧)
		 * @return null 
		 */
		public function render():void
		{
			
		}
		/**
		 * 渲染(按指定帧数进行渲染)
		 * @return null 
		 */
		public function renderAnimate():void
		{
			
		}
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
		public function listen(type:String, listener:Function):void
		{
			if (!_listeners[type])_listeners[type] = new Vector.<Function>;
			var v_lis:Vector.<Function> = _listeners[type];
			if (v_lis.indexOf(listener) != -1) return;
			v_lis[v_lis.length] = listener;
			super.addEventListener(type, listener);
		}
		/**
		 * 删除侦听函数
		 * 
		 * @param type 事件类型
		 * @param listener 侦听函数(e:Event):void
		 * 
		 * @return null 
		 */
		public function remove(type:String, listener:Function):void
		{
			var index:int = _has(type, listener);
			if (index < 0) return;
			var v_lis:Vector.<Function> = _listeners[type];
			super.removeEventListener(type, listener);
			v_lis.splice(index, 1);
		}
		/**
		 * 删除一类侦听函数
		 * 
		 * @param type 事件类型，不填或为null是删除所有侦听函数
		 * 
		 * @return null 
		 */
		public function removeAll(type:String = null):void
		{
			var v_lis:Vector.<Function>;
			if (!type) {
				if (!has(type)) return;
				v_lis = _listeners[type];
				for each(var listener:Function in v_lis) {
					remove(type, listener);
				}
				//delete _listeners[type];
				return;
			}
			for (type in _listeners) {
				removeAll(type);
			}
		}
		/**
		 * 是否存在某个侦听函数或事件类型
		 * 
		 * @param type 事件类型
		 * @param listener 侦听函数(e:Event):void
		 * 
		 * @return null 
		 */
		public function has(type:String, listener:Function = null):Boolean
		{
			return _has(type, listener) != -1;
		}
		private function _has(type:String, listener:Function = null):int
		{
			var v_lis:Vector.<Function> = _listeners[type];
			if (!v_lis) return -1;
			if (listener != null) {
				return v_lis.indexOf(listener);
			}
			return -2;
		}
		/**
		 * 发送一个事件
		 * 
		 * @param event 事件
		 * @return null 
		 */
		public function dispatch(event:*):void
		{
			switch(ClassUtil.checkTargetType(event,String,Event)){
				case -1:
					throw new TypeError('NEventDispatcher.dispatch Error::param is out of range!');
					break;
				case 0:
					event = new Event(event as String);
					break;
				case 1:
					
					break;
			}
			super.dispatchEvent(event as Event);
		}
	}
}