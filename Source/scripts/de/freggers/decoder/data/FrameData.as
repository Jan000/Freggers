package de.freggers.decoder.data
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class FrameData
   {
       
      
      public var totalHeight:uint;
      
      public var topHeight:uint;
      
      public var frameOffset:Point;
      
      public var maskOffset:Point;
      
      public var frame:BitmapData;
      
      public var grip:BitmapData;
      
      public var mask:BitmapData;
      
      public function FrameData()
      {
         super();
      }
      
      public function clone() : FrameData
      {
         var _loc1_:FrameData = new FrameData();
         _loc1_.topHeight = this.topHeight;
         _loc1_.totalHeight = this.totalHeight;
         if(this.frameOffset)
         {
            _loc1_.frameOffset = this.frameOffset.clone();
         }
         if(this.maskOffset)
         {
            _loc1_.maskOffset = this.maskOffset.clone();
         }
         if(this.frame)
         {
            _loc1_.frame = this.frame.clone();
         }
         if(this.grip)
         {
            _loc1_.grip = this.grip.clone();
         }
         if(this.mask)
         {
            _loc1_.mask = this.mask.clone();
         }
         return _loc1_;
      }
   }
}
