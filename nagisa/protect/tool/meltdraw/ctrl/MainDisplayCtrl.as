package nagisa.protect.tool.meltdraw.ctrl
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import nagisa.events.NEventDispatcher;
	import nagisa.filters.Melt;
	import nagisa.input.BindSWF;
	import nagisa.protect.tool.meltdraw.MainTool;
	import nagisa.protect.tool.meltdraw.Resource;
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.protect.tool.meltdraw.events.ToolEvent;
	import nagisa.protect.tool.meltdraw.events.ToolEventDispatcher;
	import nagisa.util.ClassUtil;
	import nagisa.util.DisplayUtil;
	
	public class MainDisplayCtrl extends NEventDispatcher
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _sprite:Sprite;
		private var _meltBitmap:Bitmap;
		private var _showMeltSprite:Sprite;
		private var _showMeltBitmap:Bitmap;
		private var _source:BitmapData;
		private var _melt:Melt;
		private var _isRenderMelt:Boolean = true;
		private var _mouseDown:Boolean = false;
		private var _mapFilter:DisplacementMapFilter;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get display():DisplayObject{return _sprite;}
		public function get meltBitmap():Bitmap{return _meltBitmap;}
		public function get showMeltSprite():Sprite{return _showMeltSprite;}
		public function get showMeltBitmap():Bitmap{return _showMeltBitmap;}
		public function get isRenderMelt():Boolean{return _isRenderMelt;}
		public function set isRenderMelt(v:Boolean):void{_isRenderMelt = v;}
		public function get isRecord():Boolean{return _melt.isRecord;}
		public function get melt():Melt{return _melt;}
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function MainDisplayCtrl()
		{
			super();
			_initialize();
		}
		private function _initialize():void
		{
			_sprite				= new Sprite();
			_meltBitmap			= new Bitmap();
			_showMeltSprite		= new Sprite();
			_showMeltBitmap		= new Bitmap();
			_sprite.addChild(_meltBitmap);
			_sprite.addChild(_showMeltSprite);
			_showMeltSprite.addChild(_showMeltBitmap);
			_melt = new Melt();
			
			display.addEventListener(MouseEvent.MOUSE_WHEEL,_onMouseWheel);
			display.addEventListener(MouseEvent.MOUSE_DOWN,_onMouseUpDown);
			display.addEventListener(MouseEvent.MOUSE_UP,_onMouseUpDown);
		}
		public function initialize(w:Object,h:int = 0):void
		{
			if(!w)return;
			
			switch(ClassUtil.checkTargetType(w,int,Vector.<BitmapData>,Bitmap,BitmapData)){
				case -1:
					return;
				case 0:
					if(!h)return;
					_initDisplay(int(w),h);
					_initMelt(int(w),h);
					
					break;
				case 1:
					_melt.initialize(w);
					_melt.start();
					break;
				case 2:
					var bp:Bitmap = w as Bitmap;
					_source = bp.bitmapData;
					_initMelt(bp.width,bp.height);
					break;
				case 3:
					var bd:BitmapData = w as BitmapData;
					_source = bd;
					_initMelt(bd.width,bd.height);
					break;
			}
		}
		private function _initDisplay(w:int,h:int):void
		{
			var sp:Sprite			= new Sprite();
			var bd:BitmapData		= BindSWF.I.createBitmapData(Resource.I.source,'cell',20,20);
			var bm:Bitmap;
			var xx:Number = 0;
			var yy:Number = 0;
			while(xx <= w){
				bm = new Bitmap(bd);
				bm.x = xx;
				bm.y = yy;
				sp.addChild(bm);
				xx += bm.width;
				if(xx > w){
					xx = 0;
					yy += bm.height;
				}
				if(yy > h)break;
			}
			_source = _showMeltBitmap.bitmapData = DisplayUtil.drawDisplay(sp,1,{clipRect:new Rectangle(0,0,w,h)}).bd;
			sp = null;
			bm = null;
		}
		private function _initMelt(w:int,h:int):void
		{
			_melt.initialize(w,h);
			_melt.addEventListener(Melt.END,_endMelt);
			_sprite.addEventListener(MouseEvent.CLICK,_addMeltByMouse);
		}
		override public function destory(dispose:Boolean=true):void
		{
			if(_melt){
				_melt.endRecord();
				_melt.destory(dispose);
			}
			if(dispose){
				_meltBitmap = null;
				if(_sprite){
					_sprite.removeEventListener(MouseEvent.CLICK,_addMeltByMouse);
					display.removeEventListener(MouseEvent.MOUSE_WHEEL,_onMouseWheel);
					display.removeEventListener(MouseEvent.MOUSE_DOWN,_onMouseUpDown);
					display.removeEventListener(MouseEvent.MOUSE_UP,_onMouseUpDown);
					DisplayUtil.removeChild(_sprite);
					_sprite = null;
				}
				_melt = null;
			}
			super.destory(dispose);
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		override public function render():void
		{
			super.render();
			if(_destoryed)return;
			if(_isRenderMelt)_renderMelt();
			_renderContainer();
			_renderShowMelt();
			if(_mouseDown)_renderFollowMouse();
		}
		private function _renderShowMelt():void
		{
			var source:BitmapData = _source;
			
			_mapFilter = _melt.mapFilter.clone() as DisplacementMapFilter;
			_mapFilter.mapBitmap = DisplayUtil.setBitmapDataScale(_mapFilter.mapBitmap,display.scaleX);
			_mapFilter.scaleX *= display.scaleX;
			_mapFilter.scaleY *= display.scaleY;
			_showMeltSprite.filters = [_mapFilter];
			_showMeltBitmap.bitmapData = source;
		}
		public function renderMelt():void
		{
			_renderMelt();
		}
		private function _renderMelt():void
		{
			_melt.render();
			_melt.renderAnimate();
		}
		private function _renderFollowMouse():void
		{
			
		}
		private function _renderContainer():void
		{
			_meltBitmap.bitmapData = _melt.mapBmd;
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		private function _addMeltByMouse(e:MouseEvent):void
		{
			var display:DisplayObject = e.target as DisplayObject;
			ToolEventDispatcher.dispatch(new ToolEvent(ToolEvent.ADD_MELT,{x:display.mouseX,y:display.mouseY}));
		}
		public function startRecord():void
		{
			_melt.startRecord();
		}
		public function endRecord():void
		{
			_melt.endRecord();
		}
		private function _endMelt(e:Event):void
		{
			ToolConfig.melt_caches = _melt.caches;
			_melt.endRecord();
		}
		private function _onMouseWheel(e:MouseEvent):void
		{
			if(!DisplayUtil.isMouseOver(display))return;
			var rate:Number = 0.1;
			var scale:Number = display.scaleX;
			
			scale += e.delta * rate;
			if(scale < 0.01)scale = 0.01;
			display.scaleY = display.scaleX = scale;
		}
		private function _onMouseUpDown(e:MouseEvent):void
		{
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					_mouseDown = true;
					break;
				case MouseEvent.MOUSE_UP:
					_mouseDown = false;
					break;
			}
		}
	}
}