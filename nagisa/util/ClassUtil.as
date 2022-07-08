package nagisa.util
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class ClassUtil
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const VALUE_TYPE:Array = [
													Boolean,
													int,
													uint,
													Number,
													String,
													XML
												]
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
		public function ClassUtil(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function getRegisterClassName(target:*):String
		{
			return getQualifiedClassName(target) + '_NagisaRegister';
		}
		public static function getTargetClass(target:*):Class
		{
			return target.constructor as Class;
		}
		public static function abstructClass(target:*, cla:Class):void
		{
			if (getTargetClass(target) == cla) {
				throw new Error('The Class ' + cla + ' is abstructClass,can not be instance!');
			}
		}
		public static function getInstance(target:*):*
		{
			if (target is Class) return new target();
			return target;
		}
		public static function checkTargetType(target:Object, ...types):int
		{
			if (!target) return -1;
			if (!types || !types.length) return -1;
			for each(var type:* in types) {
				if (target is type || target === type) return types.indexOf(type);
			}
			return -1;
		}
		public static function checkTargetTypeNoSuper(target:Object, ...types):int
		{
			if (!target) return -1;
			if (!types || !types.length) return -1;
			var targetType:Class = getTargetClass(target);
			for each(var type:* in types) {
				if (targetType === type) return types.indexOf(type);
			}
			return -1;
		}
		public static function isValueType(target:Object):Boolean
		{
			var type:Class = getTargetClass(target);
			return VALUE_TYPE.indexOf(type) != -1;
		}
	}
}