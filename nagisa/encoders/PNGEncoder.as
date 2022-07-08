package nagisa.encoders
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class PNGEncoder
	{
		private static var crcTable:Array;
		
		private static var crcTableComputed:Boolean = false;
		
		
		public function PNGEncoder()
		{
			super();
		}
		
		public static function encode(param1:BitmapData):ByteArray
		{
			var color:uint = 0;
			var i:int = 0;
			var j:int = 0;
			var byte0:ByteArray = new ByteArray();
			byte0.writeUnsignedInt(2303741511);
			byte0.writeUnsignedInt(218765834);
			var byte1:ByteArray = new ByteArray();
			byte1.writeInt(param1.width);
			byte1.writeInt(param1.height);
			byte1.writeUnsignedInt(134610944);
			byte1.writeByte(0);
			writeChunk(byte0,1229472850,byte1);
			var byte2:ByteArray = new ByteArray();
			while(i < param1.height)
			{
				byte2.writeByte(0);
				if(!param1.transparent)
				{
					j = 0;
					while(j < param1.width)
					{
						color = param1.getPixel(j,i);
						byte2.writeUnsignedInt(uint((color & 0xFFFFFF) << 8 | 255));
						j++;
					}
				}
				else
				{
					j = 0;
					while(j < param1.width)
					{
						color = param1.getPixel32(j,i);
						byte2.writeUnsignedInt(uint((color & 0xFFFFFF) << 8 | color >>> 24));
						j++;
					}
				}
				i++;
			}
			byte2.compress();
			writeChunk(byte0,1229209940,byte2);
			writeChunk(byte0,1229278788,null);
			return byte0;
		}
		
		private static function writeChunk(param1:ByteArray, param2:uint, param3:ByteArray) : void
		{
			var _loc8_:uint = 0;
			var _loc9_:uint = 0;
			var _loc10_:uint = 0;
			if(!crcTableComputed)
			{
				crcTableComputed = true;
				crcTable = [];
				_loc9_ = 0;
				while(_loc9_ < 256)
				{
					_loc8_ = _loc9_;
					_loc10_ = 0;
					while(_loc10_ < 8)
					{
						if(_loc8_ & 1)
						{
							_loc8_ = uint(uint(3988292384) ^ uint(_loc8_ >>> 1));
						}
						else
						{
							_loc8_ = uint(_loc8_ >>> 1);
						}
						_loc10_++;
					}
					crcTable[_loc9_] = _loc8_;
					_loc9_++;
				}
			}
			var _loc4_:uint = 0;
			if(param3 != null)
			{
				_loc4_ = param3.length;
			}
			param1.writeUnsignedInt(_loc4_);
			var _loc5_:uint = param1.position;
			param1.writeUnsignedInt(param2);
			if(param3 != null)
			{
				param1.writeBytes(param3);
			}
			var _loc6_:uint = param1.position;
			param1.position = _loc5_;
			_loc8_ = 4294967295;
			var _loc7_:int = 0;
			while(_loc7_ < _loc6_ - _loc5_)
			{
				_loc8_ = uint(crcTable[(_loc8_ ^ param1.readUnsignedByte()) & uint(255)] ^ uint(_loc8_ >>> 8));
				_loc7_++;
			}
			_loc8_ = uint(_loc8_ ^ uint(4294967295));
			param1.position = _loc6_;
			param1.writeUnsignedInt(_loc8_);
		}
	}
}