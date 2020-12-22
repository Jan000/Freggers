package de.freggers.util
{
   import flash.display.Sprite;
   
   public class RectangleSprite extends Sprite
   {
       
      
      private var _handleMouseCallback:Function;
      
      private var _color:uint;
      
      private var _alpha:Number;
      
      public function RectangleSprite(param1:Number, param2:Number, param3:uint = 16777215, param4:Number = 1)
      {
         super();
         this._color = param3;
         this._alpha = param4;
         this.repaint(param1,param2);
      }
      
      private function repaint(param1:Number, param2:Number) : void
      {
         this.graphics.clear();
         this.graphics.beginFill(this._color,this._alpha);
         this.graphics.drawRect(0,0,param1,param2);
         this.graphics.endFill();
      }
      
      public function handleResize(param1:Number, param2:Number) : void
      {
         this.repaint(param1,param2);
      }
   }
}
