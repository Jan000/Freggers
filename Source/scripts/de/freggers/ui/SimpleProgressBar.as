package de.freggers.ui
{
   public class SimpleProgressBar extends AProgressBar
   {
      
      public static const DEFAULT_BG_COLOR:uint = 4278190080;
      
      public static const DEFAULT_FG_COLOR:uint = 4286481911;
      
      public static const DEFAULT_BORDER_COLOR:uint = 4294967295;
      
      public static const DEFAULT_BORDER_WIDTH:Number = 1;
       
      
      private var _foregroundColor:uint = 4.286481911E9;
      
      private var _backgroundColor:uint = 4.27819008E9;
      
      private var _borderColor:uint = 4.294967295E9;
      
      private var _borderWidth:Number = 1;
      
      public function SimpleProgressBar(param1:Number = 0, param2:Number = 1)
      {
         super(param1,param2);
      }
      
      override protected function updateContents() : void
      {
         graphics.clear();
         graphics.beginFill(this._borderColor & 16777215,(this._borderColor >> 24 & 255) / 255);
         graphics.drawRect(0,0,_width,_height);
         graphics.beginFill(this._backgroundColor & 16777215,(this._backgroundColor >> 24 & 255) / 255);
         graphics.drawRect(0 + this._borderWidth,0 + this._borderWidth,_width - 2 * this._borderWidth,_height - 2 * this._borderWidth);
         graphics.beginFill(this._foregroundColor & 16777215,(this._foregroundColor >> 24 & 255) / 255);
         graphics.drawRect(0 + this._borderWidth,0 + this._borderWidth,(_width - 2 * this._borderWidth) * progress,_height - 2 * this._borderWidth);
         graphics.endFill();
      }
      
      public function set forgeroudColor(param1:uint) : void
      {
         this._foregroundColor = param1;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         this._backgroundColor = param1;
      }
      
      public function set borderColor(param1:uint) : void
      {
         this._borderColor = param1;
      }
      
      public function set borderWidth(param1:Number) : void
      {
         this._borderWidth = param1;
      }
   }
}
