package nagisa.interfaces
{
	import flash.events.Event;

	public interface INEventDispatcher
	{
		function listen(type:String, listener:Function):void
		function remove(type:String, listener:Function):void
		function removeAll(type:String = null):void
		function has(type:String, listener:Function = null):Boolean
		function dispatch(event:*):void
	}
}