package nagisa.filters.melt
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class Fluid
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ZERO_POINT:Point = new Point(0, 0);
		public static const GRIDSIZE_DEFAULT:Point = new Point(100, 100);
		public static const DECAYSPEED_DEFAULT:int = 20;
		
		public static const BLUR_QUALITY:int = 2;
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _mapBmd:BitmapData;
		private var _blurFilter:BlurFilter;
		private var _edgeMode:String = 'free';
		private var _scale:Point = new Point(1,1);
		private var _size:Point = new Point();
		private var _gridSize:Point = new Point();
		private var _active:Boolean = false;
		private var _destoryed:Boolean = false;
		private var _inited:Boolean = false;
		
		private var _allCellCount:int;
		private var _allCells:Array;
		private var _cellCount:int;
		private var _cells:Array;
		private var _widthCount:int;
		private var _heightCount:int;
		private var _disMinX:Number;
		private var _disMinY:Number;
		private var _cellFuncs:Vector.<Function>;
		private var _useDecay:Boolean = true;
		private var _extendEasiness:Number = 0.1;
		private var _intensity:Number = 0.25;
		
		private var _calculator:FluidCalculator;
		private var _colorAdjust:Number;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get gridSize():Point{return _gridSize;}
		public function get scaleX():Number { return _scale.x; }
		public function set scaleX(v:Number):void { _scale.x = v;}
		public function get scaleY():Number { return _scale.y; }
		public function set scaleY(v:Number):void { _scale.y = v; }
		
		public function get blurFilter():BlurFilter { return _blurFilter; }
		
		public function get isActive():Boolean { return _active; }
		
		public function get intensity():Number { return _intensity; }
		public function set intensity(value:Number):void { _colorAdjust = -128 * (_intensity = value); }
		
		public function get useDecay():Boolean { return _useDecay; }
		public function set useDecay(v:Boolean):void { _useDecay = v; }
		
		public function get mapBmd():BitmapData { return _mapBmd; }
		public function set mapBmd(v:BitmapData):void { _mapBmd = v; }
		
		/**
		 * 能量衰减度
		 * 为0时中心能量不立马衰减
		 * 为负数或大于1时会中心能量会衰减(水波效果),造成的水波效果可能会由于反射作用导致能量无法“平静”
		 * @return 
		 * 
		 */
		public function get extendEasiness():Number{return _extendEasiness;}
		/**
		 * 
		 * @param v 0~1
		 * 
		 */
		public function set extendEasiness(v:Number):void{_extendEasiness = v;}
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * 
		 * 
		 */
		public function Fluid(
		):void{
		}
		/**
		 *  初始化fluid实例
		 * 
		 * @param mapBmd fluid实例所作用的源位图
		 * @param gridSize fluid更改源位图时会将源位图切分为许多小格子，格子越小精细度越高，同样的也越耗性能。最小值为:1像素 x 1像素。默认将源位图切割成100 x 100
		 * 
		 * @return null 
		 */
		public function initialize(mapBmd:BitmapData, gridSize:Point = null):void
		{
			if (_inited) return;
			_inited = true;
			_destoryed = false;
			_mapBmd = mapBmd;
			_size.x = _mapBmd.width;
			_size.y = _mapBmd.height;
			if (gridSize) {
				if (gridSize.x < _size.x) gridSize.x = _size.x;
				if (gridSize.y < _size.y) gridSize.y = _size.y;
				_gridSize = gridSize
			}else {
				_gridSize.x = _size.x / GRIDSIZE_DEFAULT.x;
				_gridSize.y = _size.y / GRIDSIZE_DEFAULT.y;
			}
			trace('Fluid.initialize initGridSize Finish::gridSize: '+_gridSize);
			_initialize();
		}
		private function _initialize():void
		{
			var data:FluidData;
			var i:int;
			var j:int;
			var w:int;
			var h:int;
			
			//division number of grid
			_widthCount  = uint( Math.ceil(_size.x  / _gridSize.x) );
			_heightCount = uint( Math.ceil(_size.y / _gridSize.y) );
			
			//create temporary(暂时的) array to express 2-dimension(尺寸) grid 
			w = _widthCount  + 2;
			h = _heightCount + 2;
			_allCellCount = w * h;
			_allCells = new Array(_allCellCount);
			var p:uint = 0;
			var cells2d:Array = new Array(w);
			for (i = 0; i < w; ++i)
			{
				cells2d[i] = new Array(h);
				for (j = 0; j < h; ++j)
				{
					data = new FluidData(i, j);
					cells2d[i][j] = data;
					_allCells[p] = data;
					
					++p;
				}
			}
			
			//create 1-dimension array to put 2-dimension grid into linear
			_cells = new Array();
			
			//create linked list of each cell
			w = _widthCount  + 1;
			h = _heightCount + 1;
			var pi:uint = 0;
			var pj:uint = 0;
			for (i = 1; i < w; ++i)
			{
				for (j = 1; j < h; ++j)
				{
					//center
					data = cells2d[i][j] as FluidData;
					
					var nt:uint;
					var nb:uint;
					var nl:uint;
					var nr:uint;
					
					//around
					if (_edgeMode == "wrap")
					{
						nt = (j == 1    ) ? (h - 1) : (j - 1);
						nb = (j == h - 1) ? 1       : (j + 1);
						nl = (i == 1    ) ? (w - 1) : (i - 1);
						nr = (i == w - 1) ? 1       : (i + 1);
					}
					/*
					else if (_edgeMode == "reflect")
					{
						nt = (j == 1    ) ? (j + 1) : (j - 1);
						nb = (j == h - 1) ? (j - 1) : (j + 1);
						nl = (i == 1    ) ? (i + 1) : (i - 1);
						nr = (i == w - 1) ? (i - 1) : (i + 1);
					}
					*/
					else
					{
						nt = j - 1;
						nb = j + 1;
						nl = i - 1;
						nr = i + 1;
					}
					
					data.n00 = cells2d[nl][nt] as FluidData;
					data.n10 = cells2d[i ][nt] as FluidData;
					data.n20 = cells2d[nr][nt] as FluidData;
					
					data.n01 = cells2d[nl][j ] as FluidData;
					data.n21 = cells2d[nr][j ] as FluidData;
					
					data.n02 = cells2d[nl][nb] as FluidData;
					data.n12 = cells2d[i ][nb] as FluidData;
					data.n22 = cells2d[nr][nb] as FluidData;
					
					//prev and next to loop cells
					if (pi)
					{
						data.prev = cells2d[pi][pj] as FluidData;
						data.prev.next = data;
					}
					_cells.push(data);
					
					pi = i;
					pj = j;
				}
			}
			intensity = 0.25;
			
			_cellCount = _cells.length;
			
			_calculator = new FluidCalculator();
			
			_blurFilter = new BlurFilter(32, 32, 2);
			
			_disMinX = _gridSize.x;
			_disMinY = _gridSize.y;
			
			_initCellFuncs();
		}
		private function _initCellFuncs():void
		{
			_cellFuncs = new Vector.<Function>();
			_addCellFunc(_renderActiveCell);
		}
		public function isDestoryed():Boolean { return _destoryed; }
		/**
		 *  格式化melt实例
		 * 
		 * @param dispose 是否完全格式化，填true则不可以用initialize进行初始化，并且请在完全格式化后删除对melt实例的引用
		 * 
		 * @return null 
		 */
		public function destory(dispose:Boolean = true):void
		{
			if (dispose) {
				_size = null;
				_gridSize = null;
				_scale = null;
			}
			_allCellCount = 0;
			_allCells = null;
			_cellCount = 0;
			_cells = null;
			_cellFuncs = null;
			_calculator = null;
			_blurFilter = null;
			_destoryed = true;
			_inited = false;
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		/**
		 *  渲染(每帧)
		 * @return null 
		 */
		public function render():void
		{
			if (_destoryed) return;
			var n:uint         = _cellCount;
			var cells:Array    = _cells;
			var map:BitmapData = _mapBmd;
			var cell:FluidData;
			var prvActive:Boolean = _active;
			
			
			map.lock();
			if (_cellFuncs && _cellFuncs.length) {
				for (var i:uint = 0; i < n; ++i){
					cell = cells[i];
					for each(var f:Function in _cellFuncs) {
						f(cell);
						_renderMapBmd(cell);
					}
				}
			}
			map.applyFilter(map, map.rect, ZERO_POINT, _blurFilter);
			map.unlock();
			
			_renderCaculate();
		}
		private function _renderCaculate():void
		{
			_renderPressure();
			_renderVelocity();
			if (_useDecay)_renderDecay();
		}
		private function _renderMapBmd(cell:FluidData):void
		{
			var w:Number	   = _gridSize.x * _scale.x;
			var h:Number	   = _gridSize.y * _scale.y;
			var map:BitmapData = _mapBmd;
			
			map.fillRect(
				new Rectangle(cell.x * w, cell.y * h, w, h),
				_calcMapColor(cell)
			);
		}
		private function _renderActiveCell(cell:FluidData):void
		{
			
		}
		private function _renderDecay():void
		{
			_active = false;
			for each(var cell:FluidData in _allCells) {
				cell.decay();
				if (cell.isActive)_active = true;
			}
		}
		private function _renderPressure():void
		{
			var n:uint = _cellCount;
			var cell:FluidData = _cells[0] as FluidData;
			
			for (var i:uint = 0; i < n; ++i)
			{
				_calcPressure(cell);
				cell = cell.next;
			}
		}
		private function _renderVelocity():void
		{
			var n:uint = _cellCount;
			var cell:FluidData = _cells[0] as FluidData;
			for (var i:uint = 0; i < n; ++i)
			{
				_calcVelocity(cell);
				cell = cell.next;
			}
		}
		/**
		 * 渲染(按指定帧数进行渲染)
		 * @return null 
		 */
		public function renderAnimate():void
		{
			
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		public function cell(x:uint, y:uint):FluidData { return _cells[_heightCount * x + y]; }
		public function clear():void
		{
			var cells:Array	   = _allCells;
			var cell:FluidData;
			var n:uint         = _allCellCount;
			for (var i:uint = 0; i < n; ++i)
			{
				cell = cells[i];
				cell.clear();
			}
		}
		/**
		 * 添加点扭曲
		 * @param x
		 * @param y
		 * @param force 
		 * @param r
		 * @param params
		 * @return null 
		 */
		public function addPointForce(x:Number,y:Number,force:Object,r:Object,params:Object = null):void
		{
			params = params || { };
			if (!force || !r) return;
			var forceX:Number;
			var forceY:Number;
			if (force is Number) forceX = forceY = Number(force);
			else {
				forceX = force.x != undefined ? force.x : 1;
				forceY = force.y != undefined ? force.y : 1;
			}
			var rx:Number;
			var ry:Number;
			if (r is Number) {
				rx = ry = Number(r);
			}else {
				rx = r.x != undefined ? r.x : 1;
				ry = r.y != undefined ? r.y : 1;
			}
			
			var n:uint = _cellCount;
			var cell:FluidData = _cells[0] as FluidData;
			
			for (var i:uint = 0; i < n; ++i)
			{
				_calcPointForce(cell, x, y , forceX, forceY, rx, ry);
				cell.decaySpeed = params.decaySpeed != undefined ? params.decaySpeed : Fluid.DECAYSPEED_DEFAULT;
				cell = cell.next;
			}
			_active = true;
		}
		private function _calcPointForce(data:FluidData, x:Number, y:Number, forceX:Number , forceY:Number ,rx:Number,ry:Number,flowSize:Number = 0.2):void
		{
			var cdx:Number		 = (data.x - 0.5) * _gridSize.x - x;
			var cdy:Number		 = (data.y - 0.5) * _gridSize.y - y;
			var rad:Number	 = Math.atan2(cdy, cdx);
			var cos:Number	 = Math.cos(rad);
			var sin:Number	 = Math.sin(rad);
			var dist2:Number  = cdx * cdx + cdy * cdy;
			var r2:Number	  = rx * cos * rx * cos + ry * sin * ry * sin;
			
			if (dist2 < r2)
			{
				var fx:Number = r2 / dist2;
				var fy:Number = r2 / dist2;
				data.vx += forceX * forceX * forceX * fx * flowSize * cos * rx;
				data.vy += forceY * forceY * forceY * fy * flowSize * sin * ry;
			}
		}
		/**
		 * 
		 * @param x
		 * @param y
		 * @param force
		 * @param rect
		 * @param params
		 * 
		 */
		public function addRectForce(x:Number,y:Number,force:Object,rect:Rectangle,params:Object = null):void
		{
			params = params || { };
			if (!force || !rect) return;
			var forceX:Number;
			var forceY:Number;
			if (force is Number) forceX = forceY = Number(force);
			else {
				forceX = force.x != undefined ? force.x : 1;
				forceY = force.y != undefined ? force.y : 1;
			}
			
			var n:uint = _cellCount;
			var cell:FluidData = _cells[0] as FluidData;
			
			for (var i:uint = 0; i < n; ++i)
			{
				_calcRecttForce(cell, x, y , forceX, forceY, rect);
				cell.decaySpeed = params.decaySpeed != undefined ? params.decaySpeed : Fluid.DECAYSPEED_DEFAULT;
				cell = cell.next;
			}
			_active = true;
		}
		private function _calcRecttForce(data:FluidData, x:Number, y:Number, forceX:Number , forceY:Number ,rect:Rectangle,flowSize:Number = 0.2):void
		{
			var cdx:Number		= (data.x - 0.5) * _gridSize.x - x;
			var cdy:Number		= (data.y - 0.5) * _gridSize.y - y;
			var dist:Number		= cdx * cdx + cdy * cdy;
			
			if (rect.contains(cdx,cdy))
			{
				data.vx += forceX * forceX * forceX * dist * flowSize;
				data.vy += forceY * forceY * forceY * dist * flowSize;
			}
		}
		private function getCellX(x:Number):Number { return x / _gridSize.x; }
		private function getCellY(y:Number):Number { return y / _gridSize.y; }
		private function _calcMapColor(data:FluidData):uint
		{
			var g:int = Math.round( _colorAdjust * data.vx + data.colorX );
			var b:int = Math.round( _colorAdjust * data.vy + data.colorY );
			g = (g < 0) ? 0 : (g > 255) ? 255 : g;
			b = (b < 0) ? 0 : (b > 255) ? 255 : b;
			
			data.colorX = g;
			data.colorY = b;
			
			return data.color = g << 8 | b;
		}
		private function _addCellFunc(...funcs):void
		{
			if (!funcs || !funcs.length) return;
			for each(var f:Function in funcs) {
				_cellFuncs[_cellFuncs.length] = f;
			}
		}
		private function _calcPressure(data:FluidData):void
		{ 
			data.pressure += _calculator.calcPressure(data);
			data.pressure *= _extendEasiness;
		}
		/**
		 * calc velocity of each cell
		 * @param	data
		 */
		private function _calcVelocity(data:FluidData):void
		{
			data.vx += _calculator.calcVelocityX(data);
			data.vy += _calculator.calcVelocityY(data);
			data.vx *= _extendEasiness;
			data.vy *= _extendEasiness;
		}
	}
}