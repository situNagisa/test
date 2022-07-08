package nagisa.controls
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import nagisa.interfaces.IInstance;
	
	public class NSimpButton extends Sprite implements IInstance
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		public var btnWidth:Number;
		
		public var btnHeight:Number;
		
		private var _active:Boolean = true;
		private var _text:TextField;
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function get isActive():Boolean{return _active;}
		public function set isActive(v:Boolean):void{super.buttonMode = _active = v;}
		public function get text():String{return _text.text;}
		public function set text(v:String):void{_text.text = v;}
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function NSimpButton(label:String, width:Number = 50, height:Number = 20)
		{
			super();
			super.buttonMode = _active;
			this.btnWidth = width;
			this.btnHeight = height;
			this.drawBg([16777215,13421772]);
			var txt:TextField = _text = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.size = 12;
			txt.defaultTextFormat = tf;
			txt.text = label;
			txt.width = width;
			txt.height = txt.textHeight + 5;
			txt.y = (height - txt.height) / 2;
			addChild(txt);
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
			addEventListener(MouseEvent.MOUSE_OUT,this.overHandler);
		}
		
		public function destory(dispose:Boolean=true):void
		{
		}
		
		public function isDestoryed():Boolean
		{
			return false;
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
		
		public function onClick(fun:Function) : void
		{
			addEventListener(MouseEvent.CLICK,fun);
		}
		private function overHandler(e:MouseEvent) : void
		{
			if(e.type == MouseEvent.MOUSE_OVER)
			{
				this.drawBg([16777215,15921906]);
			}
			else
			{
				this.drawBg([16777215,13421772]);
			}
		}
		
		private function drawBg(color:Array) : void
		{
			graphics.lineStyle(1,6710886);
			var mtx:Matrix = new Matrix();
			mtx.createGradientBox(this.btnWidth,this.btnHeight,180 * 180 / 3.14,0,0);
			graphics.beginGradientFill(GradientType.LINEAR,color,[1,1],[0,255],mtx);
			graphics.drawRect(0,0,this.btnWidth,this.btnHeight);
			graphics.endFill();
		}
		
		
		
	}
}