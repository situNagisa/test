package nagisa.util
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class ObjectUtil
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
		public function ObjectUtil(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public static function getObjValue(obj:Object,key:String,defaultValue:*):*
		{
			if(!obj)return defaultValue;
			if(!key){
				
				return defaultValue;
			}
			if(obj[key] == undefined)return defaultValue;
			return obj[key];
		}
		public static function getTargetProperties(target:Object):Vector.<String>
		{
			var ba:ByteArray;
			var obj: Object;
			var p:String;
			var properties:Vector.<String>;

			ba = new ByteArray();
			properties = new Vector.<String>();
			ba.writeObject(target);
			ba.position = 0;
			obj = ba.readObject();
			for (p in obj)
			{
				properties.push(p);
			}

			return properties;
		}
		public static function checkTargetProperties(target:*, ...properties):Boolean
		{
			if (!properties || !properties.length) return true;
			for each(var property:String in properties) {
				if (!(property in target)) return false;
			}
			return true;
		}
		public static function setValueByObject(setter:*, obj:Object):void
		{
			var key: String	= null;
			var value:*		= null;
			if (!obj) return;
			for (key in obj) {
				if (!(key in setter)) continue;
				setter[key] = obj[key];
			}
		}
		public static function itemToObject(item: * ): Object
		{
			/*var j: XML = null;
			var k: String = null;
			var xml: XML = describeType(item);
			var o: Object = {};
			for each(j in xml.variable)
			{
				k = j.@name;
				o[k] = item[k];
			}
			return o;*/
			return null;
		}
		public static function cloneObject(source:Object):*{
			var type:Class = ClassUtil.getTargetClass(source);
			registerClassAlias(ClassUtil.getRegisterClassName(source), type);
			
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return copier.readObject();
		}
		public static function destoryObject(target:Object,dispose:Boolean = true,avoidKey:Array = null):void
		{
			var value:*;
			for(var key:String in target){
				value = target[key];
				if(ClassUtil.isValueType(value))continue;
				if(avoidKey && avoidKey.indexOf(key) != -1)continue;
				target[key] = null;
			}
		}
	}
}