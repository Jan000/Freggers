package de.freggers.roomdisplay
{
   import de.freggers.util.TextRenderer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.text.StyleSheet;
   
   public class MenuItem extends AMenuItem
   {
      
      private static const FOLDER_FILTER:BitmapFilter = new GlowFilter(65280);
      
      private static const ITEM_FILTER:BitmapFilter = new ColorMatrixFilter([1,0,0,0,255 / 6,0,1,0,0,255 / 6,0,0,1,0,255 / 6,0,0,0,1,0]);
      
      private static const MARGIN_TOP:int = 4;
      
      private static const MARGIN_LEFT:int = 7;
      
      private static const MARGIN_BOTTOM:int = 4;
      
      private static const MARGIN_RIGHT:int = 25;
       
      
      private var _icon:BitmapData;
      
      private var _text:String;
      
      private var _textbm:Bitmap;
      
      private var _textbmd:BitmapData;
      
      private var _style:StyleSheet;
      
      private var _bg:Sprite;
      
      private var _flag_skipshortcut:Boolean = false;
      
      private var _itemIndex:int;
      
      public var action:String;
      
      public var args:Object;
      
      public function MenuItem(param1:String, param2:int, param3:Function = null, param4:Array = null, param5:Boolean = false)
      {
         super(param3,param4);
         this._itemIndex = param2;
         this._text = param1;
         this._flag_skipshortcut = param5;
         this._style = new StyleSheet();
         this.slot = -1;
         this._style.setStyle(".foo",{
            "fontSize":10,
            "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif"
         });
         this._style.setStyle(".t",{});
         this.init();
      }
      
      private function init() : void
      {
         this._bg = new MyMenuItemBg();
         this._bg.alpha = 0.75;
         this._bg.mouseEnabled = this._bg.mouseChildren = false;
         this.addChildAt(this._bg,0);
         this._textbmd = TextRenderer.renderToBitmap("<span class=\'foo\'><span class=\'t\'>" + this._text + "</span></body>",this._style,this._bg.width - MARGIN_LEFT - MARGIN_RIGHT,false,0,true);
         this._textbm = new Bitmap(this._textbmd);
         addChild(this._textbm);
         if(this._bg.height < MARGIN_TOP + this._textbm.height + MARGIN_BOTTOM)
         {
            this._bg.height = MARGIN_TOP + this._textbm.height + MARGIN_BOTTOM;
         }
         this._textbm.x = MARGIN_LEFT + (this._bg.width - MARGIN_RIGHT - MARGIN_LEFT - this._textbm.width) / 2;
         this._textbm.y = (this._bg.height - this._textbm.height) / 2;
      }
      
      public function get itemIndex() : int
      {
         return this._itemIndex;
      }
      
      override public function toString() : String
      {
         return "MenuItem[" + "\"" + this._text + "\"]";
      }
      
      override public function set slot(param1:int) : void
      {
         super.slot = param1;
         if(this._bg)
         {
            if(!this._flag_skipshortcut)
            {
               this._bg["num"].text = param1 + 1;
            }
            else
            {
               this._bg["num"].text = "";
            }
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         if(param1)
         {
            filters = [ITEM_FILTER];
         }
         else
         {
            filters = [];
         }
      }
      
      public function get skipshortcut() : Boolean
      {
         return this._flag_skipshortcut;
      }
      
      public function get text() : String
      {
         return this._text;
      }
   }
}
