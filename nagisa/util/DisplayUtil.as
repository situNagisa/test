package nagisa.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import nagisa.filters.DisplayFilters;

	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class DisplayUtil
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		//config param
		private static const DISPLAY_FILTERS:Vector.<DisplayFilters> = new Vector.<DisplayFilters>();
		
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
		public function DisplayUtil(
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
		 *访问一个容器对象的所有子对象(不包括容器自身),并对每个所访问的子对象调用func函数
		 * @param target 被访问的容器对象
		 * @param func function(child:DisplayObject):Boolean child为target的子对象,boolean为true时立刻结束对接下来的子对象的访问(跳出递归)
		 * 
		 */
		public static function funcAllChildren(target:DisplayObjectContainer,func:Function):void{
			var len:int = target.numChildren;
			var child:DisplayObject;
			for (var i:int; i < len ;i ++) {
				child = target.getChildAt(i);
				if (!child) continue;
				if(func(child))break;
				if (child is DisplayObjectContainer) funcAllChildren(child as DisplayObjectContainer, func);
			}
		}
		public static function isParent(child:DisplayObject, parent:DisplayObjectContainer):Boolean
		{
			while (child.parent) {
				if (child.parent == parent) return true;
				child = child.parent;
			}
			return false;
		}
		/**
		 *获取一个显示对象左上角的点相对于它自身(0,0)的偏移量 
		 * @param display
		 * @return 
		 * 
		 */
		public static function getBoundsOff(display:DisplayObject):Point
		{
			var bounds:Rectangle = display.getBounds(display);
			return new Point(bounds.x, bounds.y);
		}
		public static function setDisplayLighterShade(target:DisplayObject, value:Number):ColorMatrixFilter{
			return null;
			/*var matrix:ColorMatrix = new ColorMatrix();
			var filter:ColorMatrixFilter = new ColorMatrixFilter();
			matrix.SetBrightnessMatrix(value);
			filter.matrix = matrix.GetFlatArray();
			if(target)target.filters = [filter];
			return filter;*/
		}
		public static function setDisplayRotaByVelocity(target:DisplayObject,x:Number,y:Number):void{
			target.rotation = getDisplayRotaByVelocity(target,x,y);
		}
		public static function getDisplayRotaByVelocity(target:DisplayObject,x:Number,y:Number):Number
		{
			var rota:Number;
			var v:Number = target.scaleX * target.scaleY;
			rota = MathUtil.getRotationByXY(x * v, y * v);
			return rota;
		}
		public static function getPointByRadians(point: Point, radians: Number, scale: Number = 1):Point{
			var rp: Point = new Point();
			rp.x = (point.x * Math.cos(radians) - point.y * Math.sin(radians)) * scale;
			rp.y = (point.x * Math.sin(radians) + point.y * Math.cos(radians)) * scale;
			return rp;
		}
		public static function setDisplayIndex(display:DisplayObject,v:*):void{
			if (!display.parent) return;
			var index:int;
			if (v is Number) {
				try {
					display.parent.setChildIndex(display, v);
				}catch (e:Error) {
					trace(e);
				}
			}else if (v is String) {
				switch(v) {
					case 'top':
						index = display.parent.numChildren - 1;
						display.parent.setChildIndex(display, index);
						break;
					case 'bottom':
						index = 0
						display.parent.setChildIndex(display, index);
						break;
					default:
						trace('EffectView.setIndex Error::' + v + ' type out of range!');
						break;
				}
			}else if (v is DisplayObject) {
				if ((v as DisplayObject).parent != display.parent) {
					trace('EffectView.setIndex Error::the display: ' + v.name+" 's parent not is effectView 's parent " );
					return;
				}
				index = display.parent.getChildIndex((v as DisplayObject));
				if (--index < 0) index = 0;
				display.parent.setChildIndex(display, index);
			}
		}
		public static function setDisplayFilter(display:DisplayObject, filter:*,add:Boolean):void
		{
			var index:int = -1;
			var filters:Array;
			
			if (display.filters && display.filters.length) {
				var keys:Vector.<String> = ObjectUtil.getTargetProperties(filter);
				var same:Boolean;
				var f:*;
				for (var i:int = 0; i < display.filters.length; i++ ) {
					f = display.filters[i];
					same = false;
					if (ClassUtil.getTargetClass(f) == ClassUtil.getTargetClass(filter)) {
						same = true;
						/*for each(var key:String in keys) {
							if (f[key] != filter[key]) {
								same = false;
								break;
							}
						}*/
					}
					if (same) {
						index = i;
						f = null;
						keys = null;
						break;
					}
				}
			}
			if (add) {
				if (index != -1) return;
				filters = ArrayUtil.clone(display.filters) || [];
				filters[filters.length] = filter;
				display.filters = filters;
				return;
			}
			if (index == -1) return;
			filters = ArrayUtil.clone(display.filters) || [];
			filters.splice(index, 1);
			display.filters = filters;
			return;
		}
		public static function removeChild(child:DisplayObject):void
		{
			if (child.parent) {
				try {
					child.parent.removeChild(child);
				}catch(e:Error){}
			}
		}
		public static function isMouseOver(display: DisplayObject): Boolean
		{
			var bounds:Rectangle = display.getBounds(display);
			return (display.mouseX >= bounds.left &&
				display.mouseX <= bounds.right &&
				display.mouseY >= bounds.top &&
				display.mouseY <= bounds.bottom);
		}
		public static function setBitmapDataScale(bitmapData:BitmapData,scale:Number):BitmapData
		{
			var container:Bitmap = new Bitmap(bitmapData);
			return drawDisplay(container,scale).bd as BitmapData;
		}
		/**
		 *绘制显示对象 
		 * @param display 被绘制的显示对象
		 * @param quality 所绘制出来的质量(精细度)
		 * @param params clipRect:Rectangle 裁剪矩形,zeroPoint:Point ,
		 * @return {bd:BitmapData,offset:Point getBoundOff的返回值}
		 * 
		 */
		public static function drawDisplay(display:DisplayObject,quality:Number = 0,params:Object = null):Object
		{
			params = params || new Object();
			
			var bd:BitmapData
			var bounds:Rectangle;
			var sprite:Sprite;
			var parent:DisplayObjectContainer;
			var o_scale:Point;
			var clipRect:Rectangle;
			var sign:Point = new Point(1,1);
			
			if (display.width < 1 || display.height < 1) return {bd:null, offset:null, scale:1 };
			bounds = display.getBounds(display);
			if (quality) {
				o_scale = new Point();
				o_scale.x = display.scaleX;
				o_scale.y = display.scaleY;
				sign.x = MathUtil.sgn(display.scaleX);
				sign.y = MathUtil.sgn(display.scaleY);
				parent = display.parent;
				sprite = new Sprite();
				sprite.addChild(display);
				display.scaleX = display.scaleY = quality;
				display.scaleX *= sign.x;
				display.scaleY *= sign.y;
				bounds = sprite.getBounds(sprite);
			}
			
			if (params.clipRect != undefined) clipRect = params.clipRect;
			else {
				clipRect = new Rectangle(0, 0, bounds.width, bounds.height);
			}
			if (params.zeroPoint) {
				bounds.x = 0;
				bounds.y = 0;
			}
			bd = new BitmapData(clipRect.width,clipRect.height, true, 0);
			bd.draw((sprite || display), new Matrix(1, 0, 0, 1, -(bounds.x + clipRect.x), -(bounds.y + clipRect.y)),null,null,(new Rectangle(0,0,clipRect.width,clipRect.height)));
			
			if (parent) parent.addChild(display);
			if (o_scale) {
				display.scaleX = o_scale.x;
				display.scaleY = o_scale.y;
			}
			sprite = null;
			display = null;
			parent = null;
			
			return {bd:bd,offset:new Point( (bounds.x + clipRect.x), (bounds.y + clipRect.y))};
		}
		public static function drawDisplayBitmap(d:DisplayObject, fixPosition:Boolean = true, transparent:Boolean = true, fillColor:uint = 0, colorTransform:ColorTransform = null) : Bitmap
		{
			var matrix:Matrix = null;
			var bds:Rectangle = null;
			if(!d || d.width <= 0 || d.height <= 0)
			{
				return null;
			}
			var bp:Bitmap = new Bitmap(new BitmapData(d.width,d.height,transparent,fillColor));
			if(fixPosition)
			{
				bds = d.getBounds(d);
				matrix = new Matrix(1,0,0,1,-bds.x,-bds.y);
			}
			bp.bitmapData.draw(d,matrix,colorTransform);
			return bp;
		}
		public static function MovieClipToBitmapDatas(mc:MovieClip,bitmapDatas:Vector.<BitmapData> = null):Vector.<BitmapData>
		{
			bitmapDatas = bitmapDatas || new Vector.<BitmapData>();
			var out:Boolean = false;
			
			var bd:BitmapData = null;
			var mc_nextFrame:Function = function():void{
				if(!mc)return;
				mc.nextFrame();
			}
			mc.gotoAndStop(1);
			
			while (mc.currentFrame)
			{
				if (mc.width < 1 || mc.height < 1)
				{
					bitmapDatas.length ? bitmapDatas.push(bitmapDatas[bitmapDatas.length - 1]) : bitmapDatas[bitmapDatas.length] = null;
					mc_nextFrame();
				}else{
					var obj:Object = DisplayUtil.drawDisplay(mc);
					
					if (bd && obj.bd && obj.bd.compare(bd) == 0)
					{
						obj.bd.dispose();
						bitmapDatas[bitmapDatas.length] = bd;
						mc_nextFrame();
					}else {
						bd = obj.bd;
						bitmapDatas[bitmapDatas.length] = bd;
						mc_nextFrame();
					}
					
				}
				if (out) break;
				else out = (mc.currentFrame == mc.totalFrames);
			}
			mc_nextFrame = null;
			mc = null;
			obj = null;
			
			return bitmapDatas;
		}
		public static function BitmapDataColorFilter(bitmapData:BitmapData,filterColor:uint,tra:Boolean = false):BitmapData
		{
			var aimBitmapData:BitmapData = new BitmapData(bitmapData.width,bitmapData.height,true,0x00000000);
			var i:int = 0;
			var j:int = 0;
			var color:uint;
			var aimColor:uint;
			while(i < bitmapData.width){
				j = 0;
				while(j < bitmapData.height){
					color = bitmapData.getPixel32(i,j);
					aimColor = ColorUtil.filterRGB(color,filterColor);
					aimBitmapData.setPixel32(i,j,aimColor);
					j ++;
				}
				i ++;
			}
			return aimBitmapData;
		}
		public static function BitmapDataGetPixels(bitmapData:BitmapData,rect:Rectangle):Vector.<Vector.<uint>>
		{
			rect = rect.intersection(bitmapData.rect);
			var v2d:Vector.<Vector.<uint>>;
			var v:Vector.<uint>;
			
			if(!rect || rect.isEmpty())return null;
			v2d = new Vector.<Vector.<uint>>();
			var i:int = rect.x;
			var j:int = rect.y;
			while(i < rect.right){
				j = 0;
				v = v2d[v2d.length] = new Vector.<uint>();
				while(j < rect.bottom){
					v[v2d.length] = bitmapData.getPixel32(i,j);
					j ++;
				}
				i ++;
			}
			return v2d;
		}
		public static function MovieClipToSprite(mc:MovieClip,sp:Sprite = null):Sprite
		{
			sp = sp || new Sprite();
			var child:DisplayObject
			while(!!mc.numChildren){
				child = mc.getChildAt(0);
				sp.addChild(child);
			}
			return sp;
		}
	}
}