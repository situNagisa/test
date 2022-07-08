package nagisa.util
{

	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class ArrayUtil
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
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
		public function ArrayUtil(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function contain(parent:Object,child:Object):Boolean
		{
			if(ClassUtil.checkTargetType(parent,Array,Vector.<*>) == -1 || ClassUtil.checkTargetType(child,Array,Vector.<*>) == -1){
				throw new TypeError('Static ArrayUtil.contain Error::param is not Vector or Array!');
			}
			for each(var value:Object in child){
				if(parent.indexOf(value) == -1)return false;
			}
			return true;
		}
		public static function getRandomInArray(array: Object, deleteSelect: Boolean = false): *
		{
			if (array == null || array.length < 1)return null;
			var r: int = Math.round(Math.random() * (array.length - 1));
			var item: * = array[r];
			if (deleteSelect)array.splice(r, 1);
			return item;
		}
		public static function getInArray(num:Number, min:Number, max:Number):Number
		{
			if (num < min) num = min;
			if (num > max) num = max;
			return num;
		}
		public static function clone(target:*):*
		{
			if (!target || !target.length) return null;
			var type:Class = ClassUtil.getTargetClass(target);
			var new_array:* = new type();
			for (var i:int = 0; i < target.length; i ++) {
				new_array[i] = target[i];
			}
			return new_array;
		}
	}
}