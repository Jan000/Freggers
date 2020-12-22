package de.freggers.roomlib
{
   import de.freggers.animation.ITarget;
   import de.freggers.content.IIsoSpriteContent;
   import de.freggers.isostar.IsoGrid;
   import de.freggers.isostar.IsoSprite;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class AnimationSprite extends IsoSprite implements ITarget
   {
       
      
      public function AnimationSprite(param1:IIsoSpriteContent, param2:uint, param3:uint, param4:uint, param5:Function = null, param6:Function = null)
      {
         super(param1,param5,param6);
         this.init(param1,param2,param3,param4);
      }
      
      private function init(param1:IIsoSpriteContent, param2:uint, param3:uint, param4:uint) : void
      {
         bounds = new Rectangle(0,0,param1.width,param1.height);
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.beginFill(0);
         _loc5_.graphics.drawCircle(param2 / 2,param3 / 2,Math.min(param2,param3) / 2);
         _loc5_.graphics.endFill();
         var _loc6_:BitmapData = new BitmapData(param2,param3,true,0);
         _loc6_.draw(_loc5_);
         this.grip = _loc6_;
      }
      
      public function getFrameCount(param1:String, param2:uint) : int
      {
         return 0;
      }
      
      public function get animation() : String
      {
         return null;
      }
      
      public function set animation(param1:String) : void
      {
      }
      
      public function get frame() : int
      {
         return 0;
      }
      
      public function set frame(param1:int) : void
      {
      }
      
      public function get uvz() : Vector3D
      {
         return super.getIsoPosition();
      }
      
      public function set uvz(param1:Vector3D) : void
      {
         super.setIsoPosition(param1.x,param1.y,param1.z);
      }
      
      public function showDefaults() : void
      {
      }
      
      public function hasAnimation(param1:String) : Boolean
      {
         return false;
      }
      
      public function get valid() : Boolean
      {
         return content != null;
      }
      
      private function updatePosition() : void
      {
         var _loc1_:Point = IsoGrid.xy(isoU,isoV,isoZ);
         bounds.x = _loc1_.x - bounds.width / 2;
         bounds.y = _loc1_.y - bounds.height / 2;
         if(this.x != bounds.x)
         {
            this.x = bounds.x;
         }
         if(this.y != bounds.y)
         {
            this.y = bounds.y;
         }
      }
   }
}
