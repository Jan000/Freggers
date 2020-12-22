package de.freggers.data
{
   import de.freggers.decoder.Decoder;
   import de.freggers.util.MediaContainerContent;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class LevelBackground extends BinaryLoader
   {
       
      
      private var _version:int;
      
      private var _lightmap:Lightmap;
      
      private var _offset:Point;
      
      private var _avgbrightness:Number = 1;
      
      private var _levelSize:Point;
      
      private var _bitmapData:BitmapData;
      
      private var _roomName:String;
      
      private var _areaName:String;
      
      private var _brightness:uint;
      
      public var loaded:Boolean = false;
      
      public var use_lightmap:Boolean = true;
      
      public function LevelBackground(param1:String, param2:String, param3:uint, param4:Point)
      {
         super();
         this._areaName = param1;
         this._roomName = param2;
         this._brightness = param3;
         this._levelSize = param4;
      }
      
      public function cleanup() : void
      {
         removeCallbacks();
         if(this._bitmapData != null)
         {
            this._bitmapData.dispose();
            this._bitmapData = null;
         }
      }
      
      public function clone() : LevelBackground
      {
         var _loc1_:LevelBackground = new LevelBackground(this._areaName,this._roomName,this._brightness,this._levelSize);
         _loc1_._avgbrightness = this._avgbrightness;
         _loc1_._lightmap = this._lightmap.clone();
         _loc1_._offset = this._offset.clone();
         if(this._bitmapData)
         {
            _loc1_._bitmapData = this._bitmapData.clone();
         }
         _loc1_._version = this._version;
         return _loc1_;
      }
      
      override public function decode(param1:MediaContainerContent) : Boolean
      {
         var _loc2_:Object = Decoder.decodeLevelBackground(param1);
         if(!_loc2_)
         {
            return false;
         }
         this._version = _loc2_[Decoder.VERSION_NUMBER];
         this.init(_loc2_[Decoder.BG_IMAGE] as ByteArray,_loc2_[Decoder.BG_LIGHTMAP] as BitmapData,_loc2_[Decoder.BG_OFFSET] as Point,int(_loc2_[Decoder.BG_WIDTH]),int(_loc2_[Decoder.BG_HEIGHT]));
         param1.cleanup();
         this.loaded = true;
         return true;
      }
      
      public function init(param1:ByteArray, param2:BitmapData, param3:Point, param4:int, param5:int) : void
      {
         if(this._bitmapData != null)
         {
            this._bitmapData.dispose();
         }
         this._bitmapData = new BitmapData(param4,param5,false,0);
         param1.position = 0;
         this._bitmapData.setPixels(this._bitmapData.rect,param1);
         if(this._lightmap)
         {
            this._lightmap.cleanup();
         }
         if(param2)
         {
            if(param2.width != this._levelSize.x || param2.height != this._levelSize.y)
            {
            }
            this._lightmap = new Lightmap(param2);
         }
         else
         {
            this._lightmap = new Lightmap(new BitmapData(this._levelSize.x,this._levelSize.y,false,8421504));
         }
         this._offset = param3;
         this._avgbrightness = this._lightmap.computeAverageBrightness();
      }
      
      public function set pixelData(param1:ByteArray) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(this._bitmapData != null && param1.length != this._bitmapData.width * this._bitmapData.height * 4)
         {
            return;
         }
         param1.position = 0;
         this._bitmapData.setPixels(this._bitmapData.rect,param1);
      }
      
      public function get lightmap() : Lightmap
      {
         return this._lightmap;
      }
      
      public function get version() : int
      {
         return this._version;
      }
      
      public function get offset() : Point
      {
         return this._offset;
      }
      
      public function get width() : int
      {
         if(this._bitmapData == null)
         {
            return 0;
         }
         return this._bitmapData.width;
      }
      
      public function get height() : int
      {
         if(this._bitmapData == null)
         {
            return 0;
         }
         return this._bitmapData.height;
      }
      
      public function get avgbrightness() : Number
      {
         return this._avgbrightness;
      }
      
      public function get rect() : Rectangle
      {
         if(this._bitmapData == null)
         {
            return null;
         }
         return this._bitmapData.rect;
      }
      
      public function getPixels(param1:Rectangle) : ByteArray
      {
         if(this._bitmapData == null)
         {
            return null;
         }
         return this._bitmapData.getPixels(param1);
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      public function drawPixelsInto(param1:BitmapData, param2:Rectangle, param3:Point = null) : void
      {
         if(this._bitmapData == null || param1 == null || param2 == null)
         {
            return;
         }
         if(param3 == null)
         {
            param3 = new Point();
         }
         if(param2.x > this._bitmapData.width || param2.y > this._bitmapData.height)
         {
            return;
         }
         param2.width = int(param2.width);
         param2.height = int(param2.height);
         param2.x = int(param2.x);
         param2.y = int(param2.y);
         param1.copyPixels(this._bitmapData,param2,param3);
      }
      
      public function get identifier() : String
      {
         return this._areaName + "." + this._roomName + "." + this._brightness;
      }
      
      public function get areaName() : String
      {
         return this._areaName;
      }
      
      public function get roomName() : String
      {
         return this._roomName;
      }
      
      public function get brightness() : uint
      {
         return this._brightness;
      }
   }
}
