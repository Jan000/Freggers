package de.freggers.roomdisplay
{
   import de.freggers.util.TextRenderer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.text.StyleSheet;
   
   public class MenuTitle extends Sprite
   {
       
      
      private var _text:String;
      
      private var _textbm:Bitmap;
      
      private var _textbmd:BitmapData;
      
      private var _style:StyleSheet;
      
      private var _width:int;
      
      public function MenuTitle(param1:String, param2:int = 150)
      {
         super();
         this._style = new StyleSheet();
         this._text = param1;
         this._width = param2;
         this._style.setStyle(".foo",{
            "fontSize":11,
            "fontWeight":"bold",
            "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif"
         });
         this._style.setStyle(".t",{});
         this.init();
      }
      
      private function init() : void
      {
         this._textbm = new Bitmap();
         this._textbmd = TextRenderer.renderToBitmap("<span class=\'foo\'><span class=\'t\'>" + this._text + "</span></body>",this._style,this._width,true,0,false);
         this._textbm.bitmapData = this._textbmd;
         addChild(this._textbm);
      }
      
      public function cleanup() : void
      {
         if(this._textbmd)
         {
            this._textbmd.dispose();
         }
      }
      
      override public function toString() : String
      {
         return "MenuTitle[" + "\"" + this._text + "\"]";
      }
   }
}
