package de.freggers.data
{
   import de.freggers.decoder.Decoder;
   import de.freggers.isostar.IsoGrid;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import de.freggers.util.MediaContainerContent;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class Level extends BinaryLoader
   {
      
      private static const HEIGHT_OFFSET:int = 12;
      
      private static const HEIGHT_MAX:int = 4095;
       
      
      private var _bounds:Rectangle;
      
      private var _maxz:int;
      
      private var _base:int;
      
      private var _map:Vector.<int>;
      
      private var _masks:Vector.<ICroppedBitmapDataContainer>;
      
      private var _version:int;
      
      private var _collisionmap:BitmapData;
      
      private var _soundData:Object;
      
      private var _roomcomponents:Object;
      
      private var _areaName:String;
      
      private var _roomName:String;
      
      public function Level(param1:String, param2:String)
      {
         super();
         this._areaName = param1;
         this._roomName = param2;
      }
      
      public function cleanup() : void
      {
         var _loc1_:ICroppedBitmapDataContainer = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         removeCallbacks();
         if(this._collisionmap)
         {
            this._collisionmap.dispose();
         }
         this._collisionmap = null;
         if(this._masks)
         {
            _loc3_ = this._masks.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this._masks[int(_loc2_)];
               if(_loc1_ != null)
               {
                  _loc1_.dispose();
                  this._masks[int(_loc2_)] = null;
               }
               _loc2_++;
            }
         }
         this._masks = null;
         this._soundData = null;
         this._roomcomponents = null;
      }
      
      public function init(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         this._bounds = new Rectangle(0,0,param1,param2);
         this._base = param3;
         this._version = 1;
         this._map = new Vector.<int>(param1 * param2,true);
         this._maxz = 0;
         var _loc5_:int = this._map.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this._map[int(_loc4_)] = 0;
            _loc4_++;
         }
      }
      
      override public function decode(param1:MediaContainerContent) : Boolean
      {
         var _loc2_:Object = Decoder.decodeLevel(param1);
         var _loc3_:Boolean = this.initFromDecodedData(_loc2_);
         if(param1 != null)
         {
            param1.cleanup();
         }
         return true;
      }
      
      public function initFromDecodedData(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         this._map = param1[Decoder.LVL_MAP];
         this._masks = param1[Decoder.LVL_MASKS];
         this._version = param1[Decoder.VERSION_NUMBER];
         this._bounds = new Rectangle(0,0,param1[Decoder.LVL_UNITS_U],param1[Decoder.LVL_UNITS_V]);
         this._maxz = param1[Decoder.LVL_UNITS_Z];
         this._base = param1[Decoder.TILEBASE];
         this._collisionmap = param1[Decoder.LVL_COLLISIONMAP];
         this._soundData = param1[Decoder.SOUNDS];
         this._roomcomponents = param1[Decoder.LVL_SWFOBJECTS];
         return true;
      }
      
      public function getMask(param1:int, param2:int, param3:int = 1001) : ICroppedBitmapDataContainer
      {
         if(this._masks == null)
         {
            return null;
         }
         if(param3 == IsoGrid.MODE_SUB)
         {
            param1 = Math.floor(Number(param1) / IsoGrid.upt);
            param2 = Math.floor(Number(param2) / IsoGrid.upt);
         }
         if(param1 >= this._bounds.width / IsoGrid.upt || param2 >= this._bounds.height / IsoGrid.upt)
         {
            return null;
         }
         var _loc4_:int = param2 * this._bounds.width / IsoGrid.upt + param1;
         if(_loc4_ < 0 || _loc4_ >= this._masks.length)
         {
            return null;
         }
         return this._masks[param2 * this._bounds.width / IsoGrid.upt + param1];
      }
      
      public function hasMasks() : Boolean
      {
         return this._masks && this._masks.length > 0;
      }
      
      public function getRawMapData(param1:int, param2:int, param3:int = 1001) : int
      {
         if(param3 == IsoGrid.MODE_MAIN)
         {
            param1 = param1 * IsoGrid.upt;
            param2 = param2 * IsoGrid.upt;
         }
         if(param1 >= this._bounds.width || param2 >= this._bounds.height)
         {
            return -1;
         }
         var _loc4_:int = param2 * this._bounds.width + param1;
         if(_loc4_ < 0 || _loc4_ >= this._map.length)
         {
            return -1;
         }
         return this._map[_loc4_];
      }
      
      public function getHeightAt(param1:int, param2:int) : int
      {
         if(param1 >= this._bounds.width || param2 >= this._bounds.height)
         {
            return -1;
         }
         var _loc3_:int = param2 * this._bounds.width + param1;
         if(_loc3_ < 0 || _loc3_ >= this._map.length)
         {
            return -1;
         }
         return this._map[_loc3_] >> HEIGHT_OFFSET & HEIGHT_MAX;
      }
      
      public function getMapData(param1:int, param2:int, param3:int = 1001) : IMapData
      {
         var _loc4_:IMapData = null;
         var _loc5_:int = this.getRawMapData(param1,param2,param3);
         if(_loc5_ == -1)
         {
            return null;
         }
         return new MapDataV1(_loc5_);
      }
      
      public function getAllSoundData() : Object
      {
         return this._soundData;
      }
      
      public function get map() : Vector.<int>
      {
         return this._map;
      }
      
      public function get version() : int
      {
         return this._version;
      }
      
      public function get bounds() : Rectangle
      {
         return this._bounds;
      }
      
      public function get base() : int
      {
         return this._base;
      }
      
      public function get collisionmap() : BitmapData
      {
         return this._collisionmap;
      }
      
      public function get maxz() : int
      {
         return this._maxz;
      }
      
      public function toString() : String
      {
         return "Level[" + this._version + ", " + IsoGrid.upt + ", " + this._base + ", " + this._bounds + ", " + ", " + this._maxz + "]";
      }
      
      public function get hasRoomComponents() : Boolean
      {
         return this._roomcomponents != null;
      }
      
      public function get roomcomponents() : Object
      {
         return this._roomcomponents;
      }
      
      public function discardAdditionalData() : void
      {
         this._soundData = null;
      }
      
      public function get identifier() : String
      {
         return this._areaName + "." + this._roomName;
      }
      
      public function get areaName() : String
      {
         return this._areaName;
      }
      
      public function get roomName() : String
      {
         return this._roomName;
      }
      
      public function clone() : Level
      {
         var _loc3_:ICroppedBitmapDataContainer = null;
         var _loc1_:Level = new Level(this._areaName,this._roomName);
         _loc1_._map = this._map.concat();
         var _loc2_:Vector.<ICroppedBitmapDataContainer> = new Vector.<ICroppedBitmapDataContainer>();
         for each(_loc3_ in this._masks)
         {
            if(_loc3_)
            {
               _loc2_.push(_loc3_.clone());
            }
            else
            {
               _loc2_.push(null);
            }
         }
         _loc1_._masks = _loc2_;
         _loc1_._version = this._version;
         _loc1_._bounds = this._bounds.clone();
         _loc1_._maxz = this._maxz;
         _loc1_._base = this._base;
         _loc1_._collisionmap = this._collisionmap.clone();
         _loc1_._soundData = this._soundData;
         _loc1_._roomcomponents = this._roomcomponents;
         return _loc1_;
      }
   }
}
