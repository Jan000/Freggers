package de.freggers.util
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public final class CroppedBitmapDataContainer implements ICroppedBitmapDataContainer
   {
      
      public static const DEFAULT_MASK:uint = 4278190080;
      
      public static const DEFAULT_COLOR:uint = 0;
       
      
      private var _bitmapData:BitmapData;
      
      private var _rect:Rectangle;
      
      private var _crect:Rectangle;
      
      public function CroppedBitmapDataContainer(param1:BitmapData = null, param2:uint = 4.27819008E9, param3:uint = 0)
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
            _loc4_.width = 1;
            _loc4_.height = 1;
            _loc4_.x = param1.width / 2;
            _loc4_.y = param1.height / 2;
         }
         if(_loc4_.equals(param1.rect))
         {
            _loc5_ = param1.clone();
         }
         else
         {
            _loc5_ = new BitmapData(_loc4_.width,_loc4_.height,param1.transparent,0);
            _loc5_.copyPixels(param1,_loc4_,_loc5_.rect.topLeft);
         }
         this.init(_loc5_,_loc4_,param1.width,param1.height);
      }
      
      public function init(param1:BitmapData, param2:Rectangle, param3:int, param4:int) : void
      {
         this._crect = param2;
         this._rect = new Rectangle(0,0,param3,param4);
         this.bitmapData = param1;
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         if(this._bitmapData)
         {
            if(param1.width != this._bitmapData.width || param1.height != this._bitmapData.height)
            {
               return;
            }
            this._bitmapData.dispose();
         }
         this._bitmapData = param1;
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
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
      
      public function clone() : ICroppedBitmapDataContainer
      {
         var _loc1_:CroppedBitmapDataContainer = new CroppedBitmapDataContainer();
         _loc1_.init(this.bitmapData.clone(),this._crect.clone(),this._rect.width,this._rect.height);
         return _loc1_;
      }
      
      public function dispose() : void
      {
         if(this._bitmapData)
         {
            this._bitmapData.dispose();
         }
         this._rect = this._crect = undefined;
      }
      
      public function hitTest(param1:Point, param2:uint, param3:Point, param4:Boolean = false) : Boolean
      {
         if(!this._bitmapData)
         {
            return false;
         }
         return this._bitmapData.hitTest(param1.add(this._crect.topLeft),param2,param3);
      }
      
      public function getPixels() : ByteArray
      {
         if(!this._bitmapData)
         {
            return null;
         }
         return this._bitmapData.getPixels(this._bitmapData.rect);
      }
      
      public function getVector() : Vector.<uint>
      {
         if(!this._bitmapData)
         {
            return null;
         }
         return this._bitmapData.getVector(this._bitmapData.rect);
      }
      
      public function get rect() : Rectangle
      {
         return this._rect;
      }
      
      public function get crect() : Rectangle
      {
         return this._crect;
      }
      
      public function toString() : String
      {
         return "CroppedBitmapDataContainer[" + this._bitmapData + ", " + this._crect + ", " + this._rect + "]";
      }
      
      public function get isvirtual() : Boolean
      {
         return false;
      }
   }
}
