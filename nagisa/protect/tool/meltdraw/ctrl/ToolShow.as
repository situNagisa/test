package nagisa.protect.tool.meltdraw.ctrl
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import nagisa.interfaces.IInstance;
	import nagisa.protect.tool.meltdraw.MainTool;
	import nagisa.protect.tool.meltdraw.ToolConfig;
	import nagisa.util.DisplayUtil;
	
	public class ToolShow extends Sprite implements IInstance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		protected var _destoryed:Boolean = false;
		private var _centerPoint:Point;
		private var _mainDisCenter:Point;
		private var _center:Point;
		private var _mainDisplay:MainDisplayCtrl;
		private var _mousePos:Point;
		private var _mousePosTextField:TextField;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get isActive():Boolean
		{
			return false;
		}
		public function get mainDisplay():MainDisplayCtrl{return _mainDisplay;}
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function ToolShow()
		{
			super();
		}
		public function initialize(size:Point):void
		{
			graphics.beginFill(0x282828);
			graphics.drawRect(0,0,size.x,size.y);
			graphics.endFill();
			_centerPoint = new Point(size.x / 2,size.y/2);
			_center = _centerPoint.clone();
			
			_initMainDisplay();
			
			_mousePos			= new Point(0,0);
			_mousePosTextField	= new TextField();
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.size = 14;
			tf.color = 0xFFFFFF;
			_mousePosTextField.defaultTextFormat = tf;
			this.addChild(_mousePosTextField);
		}
		private function _initMainDisplay():void
		{
			_mainDisplay = new MainDisplayCtrl();
			_mainDisplay.initialize(ToolConfig.show_width,ToolConfig.show_height);
			var bounds:Rectangle = _mainDisplay.display.getBounds(_mainDisplay.display);
			_mainDisCenter = new Point(bounds.x + bounds.width/2,bounds.y + bounds.height/2);
			
			_renderMainDisplay();
			this.addChild(_mainDisplay.display);
		}
		public function destory(dispose:Boolean=true):void
		{
			_destoryed = true;
			_mainDisplay.destory(dispose);
			if(dispose){
				_mainDisplay = null;
			}
		}
		
		public function isDestoryed():Boolean
		{
			return _destoryed;
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		public function render():void
		{
			if(_destoryed)return;
			if(_mainDisplay){
				_mainDisplay.render();
			}
			_renderMousePos();
			//_renderMainDisplay();
		}
		private function _renderMousePos():void
		{
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.size = 14;
			tf.color = 0xFFFFFF;
			if(DisplayUtil.isMouseOver(_mainDisplay.meltBitmap)){
				_mousePos.x = _mainDisplay.meltBitmap.mouseX;
				_mousePos.y = _mainDisplay.meltBitmap.mouseY;
				tf.color = 0x00FF00;
			}else{
				_mousePos.x = MainTool.I.stage.mouseX;
				_mousePos.y = MainTool.I.stage.mouseY;
			}
			_mousePosTextField.defaultTextFormat = tf;
			_mousePosTextField.text = _mousePos.toString();
		}
		private function _renderMainDisplay():void
		{
			_mainDisplay.display.x = -(_mainDisCenter.x * _mainDisplay.display.scaleX - _center.x);
			_mainDisplay.display.y = -(_mainDisCenter.y * _mainDisplay.display.scaleY - _center.y);
			
		}
		public function renderAnimate():void
		{
			if(_destoryed)return;
			if(_mainDisplay){
				_mainDisplay.renderAnimate();
			}
		}
		//--------------------------------------
		// METHODS
		//--------------------------------------
	}
}