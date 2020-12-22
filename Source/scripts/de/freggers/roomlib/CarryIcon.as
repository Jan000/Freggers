package de.freggers.roomlib
{
   import de.freggers.isostar.IsoGrid;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   
   public class CarryIcon extends Sprite
   {
      
      private static const SIZE:uint = 30;
      
      private static const YOFFSET:int = -6;
      
      private static const PROJECTIONS:Array = [new Matrix(Math.sqrt(1 / 2) / Math.cos(Math.PI / 6) * Math.cos(Math.asin(Math.sqrt(1 / 5))),-Math.tan(Math.asin(Math.sqrt(1 / 5))) * (Math.sqrt(1 / 2) / Math.cos(Math.PI / 6)) * Math.cos(Math.asin(Math.sqrt(1 / 5))),0,Math.sqrt(1 / 2)),new Matrix(0.01,0,0,Math.cos(Math.PI / 6) * Math.cos(Math.asin(Math.sqrt(1 / 5)))),new Matrix(Math.sqrt(1 / 2) / Math.cos(Math.PI / 6) * Math.cos(Math.asin(Math.sqrt(1 / 5))),Math.tan(Math.asin(Math.sqrt(1 / 5))) * (Math.sqrt(1 / 2) / Math.cos(Math.PI / 6)) * Math.cos(Math.asin(Math.sqrt(1 / 5))),0,Math.sqrt(1 / 2)),new Matrix(Math.cos(Math.asin(Math.sqrt(1 / 5))),0,0,Math.cos(Math.PI / 6) * Math.cos(Math.asin(Math.sqrt(1 / 5)))),new Matrix(Math.sqrt(1 / 2) / Math.cos(Math.PI / 6) * Math.cos(Math.asin(Math.sqrt(1 / 5))),-Math.tan(Math.asin(Math.sqrt(1 / 5))) * (Math.sqrt(1 / 2) / Math.cos(Math.PI / 6)) * Math.cos(Math.asin(Math.sqrt(1 / 5))),0,Math.sqrt(1 / 2)),new Matrix(0.01,0,0,Math.cos(Math.PI / 6) * Math.cos(Math.asin(Math.sqrt(1 / 5)))),new Matrix(Math.sqrt(1 / 2) / Math.cos(Math.PI / 6) * Math.cos(Math.asin(Math.sqrt(1 / 5))),Math.tan(Math.asin(Math.sqrt(1 / 5))) * (Math.sqrt(1 / 2) / Math.cos(Math.PI / 6)) * Math.cos(Math.asin(Math.sqrt(1 / 5))),0,Math.sqrt(1 / 2)),new Matrix(Math.cos(Math.asin(Math.sqrt(1 / 5))),0,0,Math.cos(Math.PI / 6) * Math.cos(Math.asin(Math.sqrt(1 / 5))))];
       
      
      private var _direction:uint = 7;
      
      private var _cbmd:ICroppedBitmapDataContainer;
      
      private var _content:Sprite;
      
      public function CarryIcon(param1:ICroppedBitmapDataContainer)
      {
         super();
         this._cbmd = param1;
         this.create();
      }
      
      public function set direction(param1:uint) : void
      {
         if(this._direction == param1 || param1 < 0 || param1 > 7)
         {
            return;
         }
         this._direction = param1;
         var _loc2_:Matrix = PROJECTIONS[this._direction] as Matrix;
         if(_loc2_)
         {
            this._content.transform.matrix = _loc2_;
         }
      }
      
      public function get direction() : uint
      {
         return this._direction;
      }
      
      private function create() : void
      {
         var _loc1_:Bitmap = null;
         this._content = new Sprite();
         if(!this._cbmd)
         {
            _loc1_ = new Bitmap();
         }
         else
         {
            _loc1_ = new Bitmap(this._cbmd.bitmapData,"auto",true);
         }
         var _loc2_:Number = Math.max(SIZE / this._cbmd.crect.width,SIZE / this._cbmd.crect.height);
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         if(_loc1_.width < IsoGrid.tile_width)
         {
            _loc1_.x = (IsoGrid.tile_width - _loc1_.width) / 2;
         }
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.lineStyle(2,16777215,0.75);
         _loc3_.graphics.beginFill(16777215,0.25);
         _loc4_.graphics.drawCircle(0,0,SIZE);
         _loc3_.graphics.drawCircle(0,0,SIZE);
         _loc3_.graphics.endFill();
         _loc3_.addChild(_loc4_);
         _loc4_.filters = [new GlowFilter(16556037,1,4,4)];
         _loc3_.y = YOFFSET;
         _loc1_.x = -_loc1_.width / 2;
         if(_loc3_.height >= _loc1_.height - 5)
         {
            _loc1_.y = _loc3_.y - _loc1_.height / 2;
         }
         else
         {
            _loc1_.y = _loc3_.y - _loc1_.height + _loc3_.height / 2 - 5;
         }
         var _loc5_:Sprite = new Sprite();
         this._content.addChild(_loc3_);
         this._content.addChild(_loc1_);
         _loc5_.addChild(this._content);
         _loc5_.x = IsoGrid.tile_width / 2;
         addChild(_loc5_);
      }
   }
}
