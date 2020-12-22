package de.freggers.util
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public final class BABitmapDataContainer
   {
       
      
      protected var _bytes:ByteArray;
      
      protected var _rect:Rectangle;
      
      public function BABitmapDataContainer(param1:BitmapData = null)
      {
         super();
         if(!param1)
         {
            return;
         }
         this.init(param1.getPixels(param1.rect),param1.width,param1.height);
      }
      
      public function init(param1:ByteArray, param2:int, param3:int) : void
      {
         this._rect = new Rectangle(0,0,param2,param3);
         this._bytes = param1;
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         if(this._rect.width > 0 && param1.width != this._rect.width || this._rect.height > 0 && param1.height != this._rect.height)
         {
            return;
         }
         this._bytes = param1.getPixels(param1.rect);
      }
      
      public function get bitmapData() : BitmapData
      {
         var _loc1_:BitmapData = new BitmapData(this._rect.width,this._rect.height,true);
         this._bytes.position = 0;
         _loc1_.setPixels(_loc1_.rect,this._bytes);
         return _loc1_;
      }
      
      public function getPixels() : ByteArray
      {
         this._bytes.position = 0;
         return this._bytes;
      }
      
      public function get topLeft() : Point
      {
         return this._rect.topLeft;
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
      
      public function clone() : BABitmapDataContainer
      {
         var _loc1_:BABitmapDataContainer = new BABitmapDataContainer();
         var _loc2_:ByteArray = new ByteArray();
         this._bytes.position = _loc2_.position = 0;
         _loc2_.writeBytes(this._bytes,0,this._bytes.length);
         _loc1_.init(_loc2_,this._rect.width,this._rect.height);
         return _loc1_;
      }
      
      public function dispose() : void
      {
         if(this._bytes)
         {
            this._bytes.position = this._bytes.length = 0;
         }
         this._bytes = undefined;
         this._rect = undefined;
      }
      
      public function hitTest(param1:Point, param2:uint, param3:Point) : Boolean
      {
         var _loc4_:int = param3.x - param1.x;
         var _loc5_:int = param3.y - param1.y;
         if(!this._rect.contains(_loc4_,_loc5_))
         {
            return false;
         }
         var _loc6_:int = (_loc5_ * int(this._rect.width) + _loc4_) * 4;
         this._bytes.position = _loc6_;
         var _loc7_:uint = this._bytes.readUnsignedInt();
         if((_loc7_ >> 24 & 255) > param2)
         {
            return true;
         }
         return false;
      }
      
      public function toString() : String
      {
         return "BABitmapDataContainer[" + this._rect + "]";
      }
   }
}
