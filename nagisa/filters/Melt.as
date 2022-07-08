package nagisa.filters
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	
	import nagisa.events.NEventDispatcher;
	import nagisa.filters.melt.Fluid;
	import nagisa.util.ClassUtil;

	/**
	 * 实现图像扭曲。
	 * 若想要绘制新的扭曲，可通过initializ(width,height);startRecord();绘制函数;绘制好的位图数据将会储存在caches属性里
	 * 
	 * 
	 * 若想播放已有的位图数据数组,可通过initialize(Vector.<BitmapData>);start();实现
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class Melt extends NEventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static const ZERO_POINT:Point = new Point(0, 0);
		
		public static const SCALE_RATE:Number = 8;
		/**
		 *事件
		 * 在melt对象绘制结束时发出 
		 */
		public static const END:String		= 'end';
		
		public static const NONE:int = 0;
		public static const FLUID:int = 1;
		public static const CACHES:int = 2;
		//config param
		/**
		 * 缓存扭曲位图
		 * @param width 位图宽
		 * @param height 位图高
		 * @param buildMelt 构建函数,函数格式必须满足function(melt:Melt):Boolean,此函数一般调用melt对象中的addPointForce等扭曲方法,来达到修改扭曲样式的目的,返回的布尔值表示是否立刻终止绘制
		 * @param holdFrame buildMelt的调用帧数,为负数时每帧都调用.为正数n时调用n + 1次.默认为0.此时只调用一次
		 * @param edgeMode 边缘模式
		 * @return 缓存后的扭曲位图数组,其最后一个元素为无扭曲状态下的bitmapData
		 * @throws Error buildMelt函数调用错误,可能是buildMelt函数内部出错,也可能是buildMelt没有提供参数和返回值
		 */
		public static function PRESTORE(width:int,height:int,buildMelt:Function,holdFrame:int = 0,edgeMode:String = 'free'):Vector.<BitmapData>
		{
			var melt:Melt = new Melt();
			var doFunc:Function = function():void{
				try{
					buildMelt(melt);
				}catch(error:Error){
					throw new Error('Static Melt.PRESTORE Error:: '+error);
				}
			}
			var caches:Vector.<BitmapData>;
			melt.initialize(width,height,edgeMode);
			melt.startRecord();
			doFunc(melt);
			while(melt.useFluid && melt.isActive){
				melt.render();
				melt.renderAnimate();
				if(holdFrame < 0 || (holdFrame > 0 && holdFrame--)){
					if(doFunc(melt))break;
				}
			}
			caches = melt.caches;
			trace('Static Melt.PRESTORE Finish::length: '+caches.length);
			
			melt.destory(true);
			melt = null;
			doFunc = null;
			return caches;
		}
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var _scale:Point = new Point(1,1);
		private var _size:Point = new Point();
		
		private var _mapBmd:BitmapData;
		private var _updateMapBmd:Boolean = false;
		
		private var _inited:Boolean = false;
		private var _type:int = FLUID;
		
		private var _isRecord:Boolean = false;
		private var _isPlaying:Boolean = false;
		private var _frame:int = 0;
		private var _totalFrames:int;
		
		private var _width:int = 0;
		private var _height:int = 0;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		private var _fluid:Fluid;
		private var _mapFilter:DisplacementMapFilter;
		
		private var _bmdCaches:Vector.<BitmapData>;
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get scaleX():Number { return _scale.x; }
		public function set scaleX(v:Number):void {
			if (v != _scale.x)_updateMapBmd = true;
			_fluid.scaleX = _scale.x = v;
		}
		public function get scaleY():Number { return _scale.y; }
		public function set scaleY(v:Number):void {
			if (v != _scale.y)_updateMapBmd = true;
			_fluid.scaleY = _scale.y = v;
		}
		/**
		 * 滤镜
		 */
		public function get mapFilter():DisplacementMapFilter { return _mapFilter; }
		
		/**
		 * 是否正在扭曲
		 */
		override public function get isActive():Boolean {
			switch(_type) {
				case Melt.FLUID:
					return _fluid.isActive; 
					break;
				case Melt.CACHES:
					return _frame + 1 < _totalFrames;
					break;
			}
			return false;
		}
		
		/**
		 * 
		 * @return 扭曲计算
		 * 
		 */
		public function get fluid():Fluid { return _fluid; }
		
		public function get width():Number { return _size.x; }
		public function get height():Number { return _size.y; }
		
		/**
		 * 当前模式是使用的扭曲源位图是自构还是缓存
		 */
		public function get type():int { return _type;}
		public function get useRecord():Boolean { return _type == Melt.CACHES; }
		public function get useFluid():Boolean { return _type == Melt.FLUID;}
		public function get isPlaying():Boolean { return _isPlaying; }
		/**
		 * 是否开启缓存
		 */
		public function get isRecord():Boolean { return _isRecord; }
		/**
		 * 此melt对象中的缓存位图
		 */
		public function get caches():Vector.<BitmapData> { return _bmdCaches; }
		public function get frame():int { return _frame + 1;}
		/**
		 *总帧数（缓存后）
		 * 若未曾缓存过则返回0
		 * @return 
		 * 
		 */
		public function get totalFrames():int{
			if(!_bmdCaches)return 0;
			return _bmdCaches.length;
		}
		public function get mapBmd():BitmapData{return _mapFilter.mapBitmap;}
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * 事件:在绘制结束时会发送END事件
		 * @param	
		 */
		public function Melt(
		):void
		{
			_initialize();
		}
		private function _initialize():void
		{
			if (_inited) return;
			_inited = true;
			_bmdCaches = new Vector.<BitmapData>();
			_fluid = new Fluid();
			_mapFilter = new DisplacementMapFilter();
			
			_mapFilter.mapPoint   = ZERO_POINT;
			_mapFilter.componentX = BitmapDataChannel.GREEN;
			_mapFilter.componentY = BitmapDataChannel.BLUE;
		}
		private function _initFluid(fluidWidth:int, fluidHeight:int, edgeMode:String = 'free'):void
		{
			_destoryed = false;
			_type = Melt.FLUID;
			_initialize();
			
			_width = Math.abs(fluidWidth);
			_height = Math.abs(fluidHeight);
			
			if (!_width || !_height) throw new Error('MeltCtrler.MeltCtrler Error::size can not be zero!');
			
			_mapFilter.mode       = (edgeMode == "wrap") ? DisplacementMapFilterMode.WRAP : DisplacementMapFilterMode.CLAMP;
			
			_renderMapBmd();
			_fluid.initialize(_mapBmd);
			
			_mapFilter.scaleX     = _fluid.gridSize.x * SCALE_RATE;
			_mapFilter.scaleY     = _fluid.gridSize.y * SCALE_RATE;
			super.listen(Melt.END, _end);
			play();
		}
		private function _initCaches(caches:Vector.<BitmapData>):void
		{
			_type = Melt.CACHES;
			_bmdCaches = caches;
			_totalFrames = _bmdCaches.length;
			stop();
		}
		/**
		 * 初始化扭曲实例
		 * 
		 * @param params 泛型 当使用Vector.<BitmapData>时为载入已缓存好的扭曲位图数据；当使用int时为创建新的扭曲效果，并将此值作为扭曲宽度传递。此时第二项参数为必填
		 * @param fluidHeight 扭曲高度
		 * @param edgeMode 边缘处理，默认为用边缘像素填充。可选'wrap'，用相对的边缘进行填充
		 * 
		 * @return null 
		 */
		public function initialize(params:Object,fluidHeight:int = -1,edgeMode:String = 'free'):void
		{
			if (!_destoryed) destory(false);
			switch(ClassUtil.checkTargetType(params, int, Vector.<BitmapData>)) {
				case 0:
					if (fluidHeight == -1) throw new Error('Melt.initialize Error:: fluidHeight not be setted!');
					_initFluid(params as int, fluidHeight, edgeMode);
					break;
				case 1:
					_initCaches(params as Vector.<BitmapData>);
					break;
				default:
					throw new Error('Melt.initialize Error:: '+params+' s type is not Vector.<BitmapData> or int!');
					break;
			}
		}
		/**
		 * 格式化melt实例
		 * 
		 * @param dispose 是否完全格式化，填true则不可以用initialize进行初始化，并且请在完全格式化后删除对melt实例的引用
		 * 
		 * @return null 
		 */
		override public function destory(dispose:Boolean = true):void
		{
			_destoryFluid(dispose);
			_destoryCaches(dispose);
			if (dispose) {
				_mapFilter = null;
			}
			_type = Melt.NONE;
			_mapBmd = null;
			_isPlaying = false;
			
			_inited = false;
			super.destory(dispose);
		}
		private function _destoryCaches(dispose:Boolean = true):void
		{
			if (_bmdCaches) {
				_bmdCaches = null;
			}
			_frame = 0;
		}
		private function _destoryFluid(dispose:Boolean = true):void
		{
			if (_fluid) {
				_fluid.destory(dispose);
			}
			if (dispose) {
				_fluid = null;
			}
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		/**
		 * 渲染
		 * 
		 * @return null 
		 */
		override public function render():void
		{
			var active:Boolean = isActive;
			if(_isPlaying)nextFrame();
			renderDraw();
			_renderMapFilter();
			if (active && !isActive) {
				dispatch(new Event(Melt.END));
			}
		}
		/**
		 *立刻刷新fluid的扭曲图像 
		 * 
		 */
		public function renderDraw():void
		{
			switch(_type){
				case Melt.CACHES:
					
					break;
				case Melt.FLUID:
					if (_updateMapBmd)_renderMapBmd();
					if (_fluid && _fluid.isActive)_fluid.render();
					if (_isRecord)_record();
					break;
			}
		}
		private function _renderMapFilter():void
		{
			if(_mapBmd)_mapFilter.mapBitmap = _mapBmd;
			_mapFilter.scaleX     = _mapBmd.width / Fluid.GRIDSIZE_DEFAULT.x * SCALE_RATE;
			_mapFilter.scaleY     = _mapBmd.height / Fluid.GRIDSIZE_DEFAULT.y * SCALE_RATE;
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
		/**
		 * 扭曲后的位图应用的模糊滤镜
		 * @param bf
		 * 
		 */
		public function setBlurFilter(bf:BlurFilter):void
		{
			if(!useFluid)return;
			if(!bf)return;
			_fluid.blurFilter.blurX	 = bf.blurX;
			_fluid.blurFilter.blurY	 = bf.blurY;
			_fluid.blurFilter.quality= bf.quality;
		}
		public function setDispalcementMapFilter(dmf:DisplacementMapFilter):void
		{
			if(dmf)return;
			_mapFilter.alpha	= dmf.alpha;
			_mapFilter.scaleX	= dmf.scaleX;
			_mapFilter.scaleY	= dmf.scaleY;
			_mapFilter.mapPoint	= dmf.mapPoint;
		}
		/**
		 * 清除所有的扭曲效果
		 * @return null 
		 */
		public function clear():void
		{
			switch(_type) {
				case Melt.CACHES:
					gotoAndStop(_bmdCaches.length - 1);
					break;
				case Melt.FLUID:
					_fluid.clear();
					break;
			}
		}
		/**
		 * 开始进行缓存，缓存后的位图可以通过caches属性获取
		 * @return null 
		 */
		public function startRecord():void
		{
			_isRecord = true;
		}
		/**
		 * 结束缓存
		 */
		public function endRecord():void
		{
			_isRecord = false;
		}
		/**
		 * 添加一个点扭曲
		 * 
		 * @param px 
		 * @param py
		 * @param params force:{x:Number,y:Number} || int,r:{x:Number,y:Number} || int;
		 * 
		 */
		public function addPointForce(px:Number,py:Number,params:Object):void
		{
			params = params || {};
			_fluid.addPointForce(px, py,params.force,params.r,params);
		}
		/**
		 * 
		 * @param px
		 * @param py
		 * @param params
		 * 
		 */
		public function addRectForce(px:Number,py:Number,params:Object):void
		{
			params = params || {};
			_fluid.addRectForce(px, py,params.force,params.rect,params);
		}
		/**
		 * 将播放头调制为第一帧，并开始播放
		 * 
		 * @return null 
		 */
		public function start():void
		{
			play();
			_frame = -1;
		}
		/**
		 * 开始播放
		 * 
		 * @return null 
		 */
		public function play():void
		{
			_isPlaying = true;
		}
		/**
		 * 暂停播放
		 * 
		 * @return null 
		 */
		public function stop():void
		{
			_isPlaying = false;
		}
		/**
		 * 跳帧并播放
		 * 
		 * @return null 
		 */
		public function gotoAndPlay(frame:int):void
		{
			play();
			_goto(frame);
		}
		/**
		 * 跳帧并暂停播放
		 * 
		 * @return null 
		 */
		public function gotoAndStop(frame:int):void
		{
			stop();
			_goto(frame);
		}
		private function _goto(frame:int):void
		{
			if (_type != Melt.CACHES) return;
			if (frame >= _bmdCaches.length) throw new Error('Melt.gotoAndPlay Error:: frame: ' + frame + ' is out of range -- ' + _bmdCaches.length + ' !');
			_frame = frame;
			applyRecord();
			if (_frame >= _bmdCaches.length) stop();
		}
		/**
		 * 下一帧
		 * 
		 * @return null 
		 */
		public function nextFrame():void
		{
			if (!isActive) return;
			switch(_type) {
				case Melt.CACHES:
					var nf:int = _frame + 1;
					if (nf < _bmdCaches.length)_goto(nf);
					if(frame == totalFrames)stop();
					break;
				case Melt.FLUID:
					_frame ++;
					break;
			}
		}
		private function _renderMapBmd():void
		{
			_mapFilter.mapBitmap = _mapBmd = new BitmapData(_width * _scale.x, _height * _scale.y,false,0x008080);
			_updateMapBmd = false;
		}
		private function _end(e:Event = null):void {
			remove(Melt.END,_end);
			_isRecord = false;
			var clearBmd:BitmapData = new BitmapData(_mapBmd.width, _mapBmd.height, false, 0x008080);
			if(clearBmd.compare(_bmdCaches[_bmdCaches.length - 1])){
				_bmdCaches[_bmdCaches.length] = clearBmd;
			}
		}
		private function _record():void
		{
			if(_bmdCaches && _bmdCaches.length && !_bmdCaches[_bmdCaches.length - 1].compare(_mapBmd)){
				_bmdCaches[_bmdCaches.length] = null;
				return;
			}
			_bmdCaches[_bmdCaches.length] = _mapBmd.clone();
		}
		private function applyRecord():void
		{
			_mapBmd = _bmdCaches[_frame];
		}
	}
}