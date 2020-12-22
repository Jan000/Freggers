package de.freggers.roomdisplay.ui.tooltip
{
   import flash.display.Sprite;
   
   public class ATooltip extends Sprite
   {
      
      protected static const MAX_WIDTH:int = 200;
      
      protected static const MIN_WIDTH:int = 50;
      
      protected static const SPACING:Number = 3;
      
      protected static const MARGIN_TOP:Number = 6;
      
      protected static const MARGIN_BOTTOM:Number = 7;
      
      protected static const MARGIN_LEFT:Number = 6;
      
      protected static const MARGIN_RIGHT:Number = 6;
       
      
      public function ATooltip()
      {
         super();
      }
      
      public function get showDelay() : int
      {
         return 0;
      }
      
      public function show() : void
      {
      }
      
      public function hide() : void
      {
      }
      
      public function get isShowing() : Boolean
      {
         return false;
      }
      
      public function createContents() : void
      {
      }
      
      public function update(param1:int) : void
      {
         this.updatePosition();
      }
      
      public function updatePosition() : void
      {
      }
      
      public function cleanup() : void
      {
      }
   }
}
