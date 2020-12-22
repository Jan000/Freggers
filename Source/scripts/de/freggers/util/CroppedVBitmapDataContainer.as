package de.freggers.util
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public final class CroppedVBitmapDataContainer implements ICroppedBitmapDataContainer
   {
      
      public static const DEFAULT_MASK:uint = 4278190080;
      
      public static const DEFAULT_COLOR:uint = 0;
       
      
      private var _vector:Vector.<uint>;
      
      private var _rect:Rectangle;
      
      private var _crect:Rectangle;
      
      public function CroppedVBitmapDataContainer(param1:BitmapData = null, param2:uint = 4.27819008E9, param3:uint = 0)
      {
         var _loc5_:BitmapData = null;
         super();
         if(!param1)
         {
            return;
         }
         var _loc4_:Rectangle = param1.getColorBoundsRect(param2,param3,false);
         if(_loc4_.width == 0 || _loc4_.height == 0)
         {
            return;
         }
         if(_loc4_.equals(param1.rect))
         {
            _loc5_ = param1.clone();
         }
         else
         {
            _loc5_ = new BitmapData(_loc4_.width,_loc4_.height,true,0);
            _loc5_.copyPixels(param1,_loc4_,_loc5_.rect.topLeft);
         }
         this.init(_loc5_.getVector(_loc5_.rect),_loc4_,param1.width,param1.height);
         _loc5_.dispose();
         _loc5_ = null;
      }
      
      public function init(param1:Vector.<uint>, param2:Rectangle, param3:int, param4:int) : void
      {
         this._crect = param2;
         this._rect = new Rectangle(0,0,param3,param4);
         this._vector = param1;
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         if(this._crect.width > 0 && param1.width != this._crect.width || this._crect.height > 0 && param1.height != this._crect.height)
         {
            return;
         }
         this._crect.width = param1.width;
         this._crect.height = param1.height;
         this._vector = param1.getVector(param1.rect);
      }
      
      public function get bitmapData() : BitmapData
      {
         if(!this._crect)
         {
            return null;
         }
         var _loc1_:BitmapData = new BitmapData(this._crect.width,this._crect.height,true);
         _loc1_.setVector(_loc1_.rect,this._vector);
         return _loc1_;
      }
      
      public function getPixels() : ByteArray
      {
         var _loc1_:ByteArray = null;
         var _loc2_:int = 0;
         var _loc3_:int = this._vector.length;
         _loc1_.position = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_.writeUnsignedInt(this._vector[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getVector() : Vector.<uint>
      {
         return this._vector;
      }
      
      public function get topLeft() : Point
      {
         return this._crect.topLeft;
      }
      
      public function get width() : int
      {
         return this._rect.width;
      }
      
      public function get height() : int
      {
         return this._rect.height;
      }
      
      public function get rect() : Rectangle
      {
         return this._rect;
      }
      
      public function get crect() : Rectangle
      {
         return this._crect;
      }
      
      public function clone() : ICroppedBitmapDataContainer
      {
         var _loc1_:CroppedVBitmapDataContainer = new CroppedVBitmapDataContainer();
         _loc1_.init(this._vector.slice(),this._crect.clone(),this._rect.width,this._rect.height);
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this._vector = undefined;
         this._crect = this._rect = undefined;
      }
      
      public function hitTest(param1:Point, param2:uint, param3:Point, param4:Boolean = false) : Boolean
      {
         var _loc5_:int = param3.x - param1.x;
         var _loc6_:int = param3.y - param1.y;
         if(!this._crect.contains(_loc5_,_loc6_))
         {
            return false;
         }
         _loc5_ = _loc5_ - this._crect.topLeft.x;
         _loc6_ = _loc6_ - this._crect.topLeft.y;
         var _loc7_:int = _loc6_ * int(this._crect.width) + _loc5_;
         var _loc8_:uint = this._vector[_loc7_];
         var _loc9_:* = false;
         if(param4)
         {
            _loc9_ = Boolean((_loc8_ >> 25 & 255) == 0 && ((_loc8_ >> 16 & 255) != 0 || (_loc8_ >> 8 & 255) != 0 || (_loc8_ & 255) != 0));
         }
         if(!_loc9_)
         {
            _loc9_ = (_loc8_ >> 24 & 255) > param2;
         }
         return _loc9_;
      }
      
      public function toString() : String
      {
         return "CroppedBABitmapDataContainer[" + this._crect + ", " + this._rect + "]";
      }
      
      public function get isvirtual() : Boolean
      {
         return true;
      }
   }
}
