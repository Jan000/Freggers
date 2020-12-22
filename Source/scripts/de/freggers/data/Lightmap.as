package de.freggers.data
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Lightmap
   {
      
      public static const LIGHTEN_TRANSFORM:ColorTransform = new ColorTransform(1,1,1,1,-127,-127,-127,0);
       
      
      private const ORIGIN:Point = new Point();
      
      private var _offset:Point;
      
      private var _lightData:BitmapData;
      
      private var _lightenBmd:BitmapData;
      
      private var _direction:uint;
      
      public function Lightmap(param1:BitmapData, param2:uint = 0, param3:Point = null)
      {
         super();
         if(!param1)
         {
            throw new Error("Failed to initialize the lightmap.");
         }
         this._lightData = param1;
         if(!param3)
         {
            param3 = new Point();
         }
         this._direction = param2;
         this._offset = param3;
      }
      
      public function cleanup() : void
      {
         this._lightData.dispose();
         this._lightData = null;
         this._offset = null;
         this.disposeLightRanges();
      }
      
      public function disposeLightRanges() : void
      {
         if(this._lightenBmd)
         {
            this._lightenBmd.dispose();
            this._lightenBmd = null;
         }
      }
      
      public function clone() : Lightmap
      {
         return new Lightmap(this._lightData.clone(),this._direction,this._offset.clone());
      }
      
      public function getLightAt(param1:int, param2:int) : uint
      {
         if(this._lightData.rect.contains(param1,param2))
         {
            return this._lightData.getPixel32(param1,param2);
         }
         return 0;
      }
      
      public function get bounds() : Rectangle
      {
         return this._lightData.rect;
      }
      
      public function get offset() : Point
      {
         return this._offset;
      }
      
      public function get direction() : uint
      {
         return this._direction;
      }
      
      public function get lightData() : BitmapData
      {
         return this._lightData;
      }
      
      public function get lightenBmd() : BitmapData
      {
         if(!this._lightenBmd)
         {
            this._lightenBmd = this._lightData.clone();
            this._lightenBmd.colorTransform(this._lightenBmd.rect,LIGHTEN_TRANSFORM);
         }
         return this._lightenBmd;
      }
      
      public function getBoundsForDirection(param1:int) : Rectangle
      {
         var _loc2_:Rectangle = null;
         if(param1 == this._direction)
         {
            _loc2_ = this.bounds.clone();
            _loc2_.offset(-this._offset.x,-this.offset.y);
            return _loc2_;
         }
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(-this.offset.x,-this.offset.y);
         _loc3_.rotate(Math.PI / 4 * (this._direction - param1));
         var _loc4_:Point = _loc3_.transformPoint(this.bounds.topLeft);
         var _loc5_:Point = _loc3_.transformPoint(new Point(this.bounds.right,this.bounds.top));
         var _loc6_:Point = _loc3_.transformPoint(this.bounds.bottomRight);
         var _loc7_:Point = _loc3_.transformPoint(new Point(this.bounds.x,this.bounds.bottom));
         _loc2_ = new Rectangle();
         _loc2_.x = Math.min(_loc4_.x,_loc5_.x,_loc7_.x,_loc6_.x);
         _loc2_.y = Math.min(_loc4_.y,_loc5_.y,_loc7_.y,_loc6_.y);
         _loc2_.width = Math.max(_loc4_.x,_loc5_.x,_loc7_.x,_loc6_.x) - _loc2_.x;
         _loc2_.height = Math.max(_loc4_.y,_loc5_.y,_loc7_.y,_loc6_.y) - _loc2_.y;
         return _loc2_;
      }
      
      public function lock() : void
      {
         this._lightData.lock();
      }
      
      public function unlock() : void
      {
         this._lightData.unlock();
      }
      
      public function blendWith(param1:Lightmap, param2:Number, param3:Point, param4:int, param5:Rectangle = null) : void
      {
         var _loc10_:uint = 0;
         if(!param1 || !param3)
         {
            return;
         }
         var _loc6_:uint = this._lightData.getPixel32(param3.x,param3.y);
         var _loc7_:Matrix = new Matrix();
         _loc7_.translate(-param1._offset.x,-param1._offset.y);
         _loc7_.rotate(Math.PI / 4 * (param1._direction - param4));
         _loc7_.translate(param3.x,param3.y);
         var _loc8_:Number = param2 / 100;
         var _loc9_:ColorTransform = new ColorTransform(_loc8_,_loc8_,_loc8_);
         this._lightData.draw(param1.lightenBmd,_loc7_,_loc9_,BlendMode.ADD,param5);
         if(param1._lightData.rect.containsPoint(param1._offset))
         {
            _loc10_ = param1._lightData.getPixel32(param1._offset.x,param1._offset.y);
         }
         var _loc11_:* = _loc10_ >> 16 & 255 - 128;
         var _loc12_:* = _loc10_ >> 8 & 255 - 128;
         var _loc13_:* = _loc10_ & 255 - 128;
         var _loc14_:uint = Math.min(_loc11_,_loc12_,_loc13_);
         _loc11_ = int(int((128 + _loc11_ - _loc14_) * _loc8_));
         _loc12_ = int(int((128 + _loc12_ - _loc14_) * _loc8_));
         _loc13_ = int(int((128 + _loc13_ - _loc14_) * _loc8_));
         _loc6_ = 4278190080 | (_loc11_ & 255) << 16 | (_loc12_ & 255) << 8 | _loc13_ & 255;
         this._lightData.setPixel32(param3.x,param3.y,_loc6_);
      }
      
      public function computeAverageBrightness() : Number
      {
         var _loc5_:uint = 0;
         var _loc1_:Vector.<uint> = this._lightData.getVector(this._lightData.rect);
         var _loc2_:int = _loc1_.length;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = _loc1_[_loc4_];
            _loc3_ = _loc3_ + ((_loc5_ >> 16 & 255) + (_loc5_ >> 8 & 255) + (_loc5_ & 255));
            _loc4_++;
         }
         return _loc3_ / 3 / _loc2_ / 255;
      }
      
      public function writeArea(param1:Lightmap, param2:Rectangle, param3:Point) : void
      {
         if(!param1 || !param2 || !param3)
         {
            return;
         }
         this._lightData.copyPixels(param1._lightData,param2,param3);
      }
      
      public function getArea(param1:Rectangle) : Lightmap
      {
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height);
         _loc2_.copyPixels(this._lightData,param1,this.ORIGIN);
         return new Lightmap(_loc2_,this._direction,param1.topLeft);
      }
      
      public function get width() : Number
      {
         if(!this._lightData)
         {
            return -1;
         }
         return this._lightData.width;
      }
      
      public function get height() : Number
      {
         if(!this._lightData)
         {
            return -1;
         }
         return this._lightData.height;
      }
   }
}
