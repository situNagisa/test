package nagisa.interfaces
{
	import nagisa.util.ObjectUtil;

	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class Instance implements IInstance
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		protected var _destoryed:Boolean = false;
		
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
		public function Instance(
		):void
		{
		}
		public function isDestoryed():Boolean { return _destoryed;}
		public function destory(dispose:Boolean = true):void
		{
			if(dispose)ObjectUtil.destoryObject(this,dispose);
			_destoryed = true;
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		public function render():void
		{
			
		}
		public function renderAnimate():void
		{
			
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
	}
}