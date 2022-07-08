package nagisa.filters
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	import nagisa.interfaces.Instance;
	
	/**
	 * 
	 * @author Nagisa
	 * 
	 */
	public class DisplayFilters extends Instance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		public var display:DisplayObject;
		private var _filters:Array = [];
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
		public function DisplayFilters(display:DisplayObject)
		{
			this.display = display;
			super();
		}
		override public function destory(dispose:Boolean=true):void{
			_filters = null;
			display = null;
			super.destory(dispose);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function update():void
		{
			display.filters = _filters;
		}
		public function add(filter:BitmapFilter):void
		{
			if(!hasFilter(filter))_filters[_filters.length] = filter;
			update();
		}
		public function remove(filter:BitmapFilter):void
		{
			var index:int = hasFilterIndex(filter);
			if(index == -1)return;
			_filters.splice(index,1);
			update();
		}
		private function hasFilterIndex(filter:BitmapFilter):int
		{
			return _filters.indexOf(filter);
		}
		private function hasFilter(filter:BitmapFilter):Boolean
		{
			return _filters.indexOf(filter) != -1;
		}
	}
}