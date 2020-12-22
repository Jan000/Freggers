package de.freggers.roomdisplay.metroplan
{
   import de.freggers.util.TextRenderer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.text.StyleSheet;
   
   public class ItemCount extends Sprite
   {
       
      
      private var _size:uint;
      
      private var _bgColor:uint;
      
      private var _areaCount:uint;
      
      private var _borderSize:uint = 4;
      
      private var _userCount:uint;
      
      private var _style:StyleSheet;
      
      private var _countbm:Bitmap;
      
      public function ItemCount(param1:int, param2:int, param3:int)
      {
         super();
         this._size = param3;
         this._bgColor = param1;
         this._style = new StyleSheet();
         this._style.setStyle(".foo",{
            "fontSize":param3 / 2,
            "fontWeight":"bold",
            "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif",
            "color":"#" + param2.toString(16)
         });
         this._countbm = new Bitmap(null,"auto",true);
         addChild(this._countbm);
         this.render(0,1);
      }
      
      public function set areaCount(param1:uint) : void
      {
         if(this._areaCount == param1)
         {
            return;
         }
         this._areaCount = param1;
         this.render(this._userCount,this._areaCount);
      }
      
      public function set userCount(param1:uint) : void
      {
         if(this._userCount == param1)
         {
            return;
         }
         this._userCount = param1;
         this.render(this._userCount,this._areaCount);
      }
      
      private function render(param1:uint, param2:uint) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:BitmapData = null;
         graphics.clear();
         graphics.beginFill(16777215);
         graphics.drawCircle(0,0,this._size / 2);
         graphics.endFill();
         graphics.beginFill(this._bgColor);
         graphics.drawCircle(0,0,this._size / 2 - this._borderSize);
         graphics.endFill();
         if(param2 > 1)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
            _loc8_ = param2;
            if(_loc8_ > 12)
            {
               _loc8_ = 12;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc4_ = Math.cos(-Math.PI / 2 + _loc9_ * Math.PI / 6) * (this._size / 2 - this._borderSize);
               _loc5_ = Math.sin(-Math.PI / 2 + _loc9_ * Math.PI / 6) * (this._size / 2 - this._borderSize);
               _loc6_ = Math.cos(-Math.PI / 2 + _loc9_ * Math.PI / 6) * (this._size / 2 - this._borderSize + 3);
               _loc7_ = Math.sin(-Math.PI / 2 + _loc9_ * Math.PI / 6) * (this._size / 2 - this._borderSize + 3);
               graphics.lineStyle(5,this._bgColor,1,false,LineScaleMode.NORMAL,CapsStyle.NONE);
               graphics.moveTo(_loc4_,_loc5_);
               graphics.lineTo(_loc6_,_loc7_);
               _loc9_++;
            }
         }
         var _loc3_:BitmapData = TextRenderer.renderToBitmap("<span class=\'foo\'>" + param1 + "</span>",this._style,this._size,false,0,true);
         if(this._countbm.bitmapData)
         {
            _loc10_ = this._countbm.bitmapData;
            this._countbm.bitmapData = null;
            _loc10_.dispose();
         }
         this._countbm.bitmapData = _loc3_;
         this._countbm.x = -_loc3_.width / 2;
         this._countbm.y = -_loc3_.height / 2;
      }
      
      public function clenaup() : void
      {
         var _loc1_:BitmapData = null;
         if(this._countbm.bitmapData)
         {
            _loc1_ = this._countbm.bitmapData;
            this._countbm.bitmapData = null;
            _loc1_.dispose();
         }
      }
   }
}
