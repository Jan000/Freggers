package de.freggers.roomdisplay
{
   import de.freggers.isostar.AIsoFlatThing;
   import de.freggers.isostar.IIsoContainer;
   import de.freggers.isostar.IsoGrid;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class MyWalkDest extends AIsoFlatThing
   {
       
      
      private var walkdest:WalkDest;
      
      public function MyWalkDest(param1:IIsoContainer)
      {
         super(param1);
         this.mouseEnabled = this.mouseChildren = false;
         this.walkdest = new WalkDest();
         content = this.walkdest;
      }
      
      override protected function recalc() : void
      {
         var _loc1_:Point = IsoGrid.xy(isoU,isoV,isoZ);
         var _loc2_:DisplayObject = content;
         if(_loc2_ != null)
         {
            _loc1_.x = _loc1_.x - _loc2_.width / 2;
            _loc1_.y = _loc1_.y - _loc2_.height / 2;
         }
         x = _loc1_.x;
         y = _loc1_.y;
         super.recalc();
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
      }
      
      public function playGoto() : void
      {
         this.walkdest.gotoAndPlay("goto");
      }
   }
}
