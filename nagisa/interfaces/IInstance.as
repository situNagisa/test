package nagisa.interfaces
{
	public interface IInstance
	{
		function destory(dispose:Boolean = true):void
		function isDestoryed():Boolean
		function render():void
		function renderAnimate():void
		function get isActive():Boolean
	}
}