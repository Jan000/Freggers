package de.freggers.decoder
{
   import de.freggers.decoder.data.AnimationData;
   import de.freggers.decoder.data.FrameData;
   import de.freggers.decoder.data.IsoObjectData;
   import de.freggers.decoder.data.LightmapData;
   import de.freggers.decoder.data.SoundData;
   import de.freggers.decoder.data.TriggerData;
   import de.freggers.isostar.IsoGrid;
   import de.freggers.util.CroppedBitmapDataContainer;
   import de.freggers.util.CroppedVBitmapDataContainer;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import de.freggers.util.MediaContainerContent;
   import de.freggers.util.MediaContainerDecoder;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class Decoder
   {
      
      public static const VERSION_NUMBER:String = "Version";
      
      public static const TILEBASE:String = "Tilebase";
      
      public static const SOUNDS:String = "Sounds";
      
      public static const TRIGGER:String = "Trigger";
      
      public static const TRIGGERS:String = "Triggers";
      
      public static const LIGHTMAP:String = "Lightmap";
      
      public static const LIGHTMAPS:String = "Lightmaps";
      
      public static const IMAGES:String = "Images";
      
      public static const OFFSET_X:String = "OffsetX";
      
      public static const OFFSET_Y:String = "OffsetY";
      
      public static const POLYGON:String = "Polygon";
      
      public static const LABEL:String = "Label";
      
      public static const LVL_AREA_NAME:String = "AreaName";
      
      public static const LVL_ROOM_NAME:String = "RoomName";
      
      public static const LVL_UNITS_U:String = "Units-U";
      
      public static const LVL_UNITS_V:String = "Units-V";
      
      public static const LVL_UNITS_Z:String = "Units-Z";
      
      public static const LVL_MAP:String = "LevelMap";
      
      public static const LVL_COLLISIONMAP:String = "CollisionMap";
      
      public static const LVL_OPTIONALS_COUNT:String = "OptDataBlockCount";
      
      public static const LVL_MASKS:String = "Masks";
      
      public static const LVL_SWFOBJECTS:String = "SWFObjects";
      
      public static const SOUND_LENGTH:String = "Length";
      
      public static const SOUND_OBJ:String = "Sound";
      
      public static const SWF_BOUNDS:String = "SwfBounds";
      
      public static const SWF_DIRECTION:String = "SwfDirection";
      
      public static const SWF_DATA:String = "SwfData";
      
      private static const BLOCK_TYPE_SOUND:String = "SND";
      
      private static const BLOCK_TYPE_SWF:String = "SWF";
      
      private static const BLOCK_TYPE_LIGHTMAP:String = "LMP";
      
      private static const BLOCK_TYPE_TRIGGER:String = "TRG";
      
      private static const BLOCK_TYPE_IMAGE:String = "IMG";
      
      public static const TYPE_LEVEL:String = "LVL";
      
      public static const TYPE_LEVELBG:String = "BG";
      
      public static const TYPE_ISOOBJ:String = "OBJ";
      
      public static const TYPE_MEDIAPACK:String = "MED";
      
      public static const OBJ_DEFAULT_DIRECTION:String = "DefaultDirection";
      
      public static const OBJ_DEFAULT_ANIMATION:String = "DefaultAnimation";
      
      public static const OBJ_DEFAULT_FRAME:String = "DefaultFrame";
      
      public static const OBJ_ANIMATIONS:String = "Animations";
      
      public static const OBJ_ANIM_DIRECTIONS:String = "Directions";
      
      public static const OBJ_ANIM_MIRRORING:String = "Mirroring";
      
      public static const OBJ_ANIM_ISOCOMPONENTBOUNDS:String = "Bounds";
      
      public static const OBJ_ANIM_ORIGINAL_GRIP:String = "OriginalGrip";
      
      public static const OBJ_ANIM_GRIPIMAGES:String = "GripImages";
      
      public static const OBJ_ANIM_FRAMES:String = "Frames";
      
      public static const OBJ_ISOCOMPONENT:String = "IsoComponent";
      
      public static const OBJ_TOP_HEIGHT:String = "TopHeight";
      
      public static const OBJ_TOTAL_HEIGHT:String = "TotalHeight";
      
      public static const OBJ_ANIM_MASKS:String = "AnimationMasks";
      
      public static const OBJ_SIT_BOUNDS:String = "SitBounds";
      
      public static const OBJ_SIT_DIRECTIONS:String = "SitDirections";
      
      public static const OBJ_GRIP_DIRECTION:String = "GripDirection";
      
      public static const OBJ_SIZE_U:String = "sizeU";
      
      public static const OBJ_SIZE_V:String = "sizeV";
      
      private static const MIRROR_MASK:int = 1;
      
      private static const BOUNDS_MASK:int = 2;
      
      private static const IFF_TOTAL_HEIGHT:int = 1;
      
      private static const IFF_TOP_HEIGHT:int = 2;
      
      private static const IFF_GRIP_OFF_U:int = 4;
      
      private static const IFF_GRIP_OFF_V:int = 8;
      
      private static const IFF_GRIP_DATA:int = 15;
      
      private static const IFD_FRAME_OFF_X:int = 1;
      
      private static const IFD_FRAME_OFF_Y:int = 2;
      
      private static const IFD_FRAME_DATA:int = 4;
      
      private static const IFD_MASK_OFF_X:int = 8;
      
      private static const IFD_MASK_OFF_Y:int = 15;
      
      private static const IFD_MASK_DATA:int = 32;
      
      private static const GRIP_MIRROR_MATRIX:Matrix = new Matrix(-6.12303176911189e-17,1,1,6.12303176911189e-17);
      
      public static const BG_IMAGE:String = "BgImage";
      
      public static const BG_HEIGHT:String = "BgHeight";
      
      public static const BG_WIDTH:String = "BgWidth";
      
      public static const BG_LIGHTMAP:String = "BgLightmap";
      
      public static const BG_OFFSET:String = "BgOffset";
       
      
      public function Decoder()
      {
         super();
      }
      
      public static function checkContainerType(param1:MediaContainerContent, param2:String) : Boolean
      {
         if(param1.getTypeAt(0) == MediaContainerDecoder.TYPE_STRING)
         {
            if(param1.getStringAt(0) != param2)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      private static function decodeLevelV2(param1:MediaContainerContent, param2:Object, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc15_:* = 0;
         var _loc22_:String = null;
         var _loc23_:int = 0;
         var _loc24_:Object = null;
         var _loc25_:* = undefined;
         var _loc26_:Object = null;
         var _loc27_:int = 0;
         var _loc28_:Rectangle = null;
         _loc4_ = 2;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
         {
            throw new Error("Failed to read the area name");
         }
         param2[LVL_AREA_NAME] = param1.getStringAt(_loc4_);
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
         {
            throw new Error("Failed to read the room name");
         }
         param2[LVL_ROOM_NAME] = param1.getStringAt(_loc4_);
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the Unit-U value");
         }
         var _loc7_:int = param1.getIntAt(_loc4_);
         param2[LVL_UNITS_U] = _loc7_;
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the Unit-V value");
         }
         var _loc8_:int = param1.getIntAt(_loc4_);
         param2[LVL_UNITS_V] = _loc8_;
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the Unit-Z value");
         }
         param2[LVL_UNITS_Z] = param1.getIntAt(_loc4_);
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the Tilebase");
         }
         _loc6_ = param1.getByteAt(_loc4_);
         if(_loc6_ % 16 != 0)
         {
            throw new Error("Tile base has a  invalid value " + _loc6_);
         }
         param2[TILEBASE] = _loc6_;
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_RAWBYTES)
         {
            throw new Error("Failed to read the map");
         }
         var _loc9_:ByteArray = param1.getByteArrayAt(_loc4_);
         if(_loc9_.length != _loc7_ * _loc8_ * 4)
         {
            throw new Error("The map has an invalid size. Should be " + _loc7_ * _loc8_ * 4 + " bytes (" + _loc7_ + ", " + _loc8_ + ") but is " + _loc9_.length + " bytes");
         }
         var _loc10_:Vector.<int> = new Vector.<int>(_loc8_ * _loc7_,true);
         _loc9_.position = 0;
         _loc11_ = 0;
         while(_loc11_ < _loc8_)
         {
            _loc12_ = 0;
            while(_loc12_ < _loc7_)
            {
               _loc10_[int(_loc11_ * _loc7_ + _loc12_)] = _loc9_.readInt();
               _loc12_++;
            }
            _loc11_++;
         }
         param2[LVL_MAP] = _loc10_;
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_RAWBYTES)
         {
            throw new Error("Failed to read the collision map");
         }
         param2[LVL_COLLISIONMAP] = createBitmapData(param1.getByteArrayAt(_loc4_),_loc7_);
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_RAWBYTES)
         {
            throw new Error("Failed to read the mask positioning map.");
         }
         var _loc13_:ByteArray = param1.getByteArrayAt(_loc4_);
         _loc4_++;
         var _loc14_:int = _loc7_ / IsoGrid.upt * _loc8_ / IsoGrid.upt;
         if(_loc13_.length * 8 < _loc14_)
         {
            throw new Error("The size of the MaskMap is too small");
         }
         var _loc16_:* = 0;
         var _loc17_:Vector.<ICroppedBitmapDataContainer> = new Vector.<ICroppedBitmapDataContainer>(_loc14_,true);
         _loc13_.position = 0;
         var _loc18_:int = 0;
         while(_loc18_ < _loc14_)
         {
            if(_loc18_ % 8 == 0)
            {
               _loc16_ = int(_loc13_.readUnsignedByte());
            }
            _loc15_ = _loc16_ & 128;
            if(_loc15_ != 0)
            {
               if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BITMAP)
               {
                  throw new Error("Failed to read mask at index " + _loc4_);
               }
               _loc17_[_loc18_] = param1.getCroppedBitmapDataAt(_loc4_,4294967295,0,param3);
               _loc4_++;
            }
            _loc16_ = _loc16_ << 1;
            _loc18_++;
         }
         param2[LVL_MASKS] = _loc17_;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the optional blocks count");
         }
         var _loc19_:int = param1.getIntAt(_loc4_);
         _loc4_++;
         var _loc20_:Object = new Object();
         var _loc21_:Object = new Object();
         param2[SOUNDS] = _loc20_;
         param2[LVL_SWFOBJECTS] = _loc21_;
         _loc18_ = 0;
         loop3:
         while(true)
         {
            if(_loc18_ >= _loc19_)
            {
               if(_loc4_ != param1.length)
               {
               }
               return;
            }
            if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
            {
               throw new Error("Failed to read optional block type (not a string) at index " + _loc4_);
            }
            _loc22_ = param1.getStringAt(_loc4_);
            _loc4_++;
            switch(_loc22_)
            {
               case BLOCK_TYPE_SOUND:
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
                  {
                     throw new Error("Failed to read sound label (not a string) at index " + _loc4_);
                  }
                  _loc5_ = param1.getStringAt(_loc4_);
                  _loc4_++;
                  if(_loc20_.hasOwnProperty(_loc5_))
                  {
                     throw new Error("Duplicate sound label at index " + _loc18_);
                  }
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the sound length (not an int) at index " + _loc4_);
                  }
                  _loc23_ = param1.getIntAt(_loc4_);
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_MP3)
                  {
                     throw new Error("Failed to read sound at index (not mp3) " + _loc4_);
                  }
                  _loc24_ = new Object();
                  _loc25_ = param1.getSoundAt(_loc4_);
                  _loc24_[SOUND_LENGTH] = _loc23_;
                  _loc24_[SOUND_OBJ] = _loc25_;
                  _loc20_[_loc5_] = _loc24_;
                  break;
               case BLOCK_TYPE_SWF:
                  _loc26_ = new Object();
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
                  {
                     throw new Error("Failed to read SWF label (not a string) at index " + _loc4_);
                  }
                  _loc5_ = param1.getStringAt(_loc4_);
                  _loc4_++;
                  if(_loc21_.hasOwnProperty(_loc5_))
                  {
                     throw new Error("Duplicate SWF label at index " + _loc4_);
                  }
                  _loc21_[_loc5_] = _loc26_;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
                  {
                     throw new Error("Failed to read swf direction at index " + _loc4_);
                  }
                  _loc16_ = int(param1.getByteAt(_loc4_));
                  if(_loc16_ == 0)
                  {
                     throw new Error("The SWF directions cannot be zero.");
                  }
                  _loc27_ = -1;
                  _loc15_ = 0;
                  while(_loc16_ > 0)
                  {
                     _loc27_++;
                     _loc15_ = _loc16_ & 1;
                     _loc16_ = _loc16_ >> 1;
                     if(_loc15_ > 0)
                     {
                        break;
                     }
                  }
                  if(_loc16_ > 0)
                  {
                     throw new Error("The SWF direction has more than one bit set: " + param1.getByteAt(_loc4_));
                  }
                  _loc26_[SWF_DIRECTION] = _loc27_;
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_RAWBYTES)
                  {
                     throw new Error("Failed to read the SWF bounds at index " + _loc4_);
                  }
                  _loc9_ = param1.getByteArrayAt(_loc4_);
                  if(_loc9_.length != 16)
                  {
                     throw new Error("The size of the SWF bounds chunk at index " + _loc4_ + " is incorrect: " + _loc9_.bytesAvailable);
                  }
                  _loc9_.position = 0;
                  _loc28_ = new Rectangle();
                  _loc28_.x = _loc9_.readInt();
                  _loc28_.y = _loc9_.readInt();
                  _loc28_.width = _loc9_.readInt();
                  _loc28_.height = _loc9_.readInt();
                  _loc26_[SWF_BOUNDS] = _loc28_;
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_ROOMCOMP)
                  {
                     throw new Error("Failed to read the SWF data at index " + _loc4_);
                  }
                  _loc26_[SWF_DATA] = param1.getRoomCompAt(_loc4_);
                  break;
               default:
                  break loop3;
            }
            _loc4_++;
            _loc18_++;
         }
         throw new Error("Unrecognized block type at index " + _loc4_);
      }
      
      public static function decodeLevel(param1:MediaContainerContent, param2:Boolean = false) : Object
      {
         var _loc5_:String = null;
         var _loc3_:Object = new Object();
         var _loc4_:int = 0;
         if(!checkContainerType(param1,TYPE_LEVEL))
         {
            throw new Error("The media content does not hold level data");
         }
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read level format version");
         }
         var _loc6_:int = param1.getByteAt(_loc4_);
         _loc3_[VERSION_NUMBER] = _loc6_;
         switch(_loc6_)
         {
            case 2:
               decodeLevelV2(param1,_loc3_,param2);
               return _loc3_;
            default:
               throw new Error("Unsupported level format version: " + _loc6_);
         }
      }
      
      private static function isPowerOfTwo(param1:int) : Boolean
      {
         if(param1 <= 0)
         {
            return false;
         }
         var _loc2_:* = 0;
         var _loc3_:int = 1;
         while(_loc2_ == 0)
         {
            _loc2_ = param1 & _loc3_;
            param1 = param1 >> 1;
         }
         if(param1 > 0)
         {
            return false;
         }
         return true;
      }
      
      public static function createBitmapData(param1:ByteArray, param2:int) : BitmapData
      {
         var _loc5_:uint = 0;
         var _loc8_:Boolean = false;
         var _loc3_:int = param1.bytesAvailable * 8;
         var _loc4_:BitmapData = new BitmapData(param2,int(_loc3_ / param2),true,0);
         var _loc6_:Vector.<uint> = new Vector.<uint>(_loc3_,true);
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_)
         {
            _loc8_ = true;
            if(_loc7_ % 8 == 0)
            {
               _loc5_ = param1.readUnsignedByte();
               if(_loc5_ == 0)
               {
                  _loc7_ = _loc7_ + 7;
                  _loc8_ = false;
               }
               else if(_loc5_ == 255)
               {
                  _loc6_[_loc7_] = uint(4278190080);
                  _loc6_[++_loc7_] = uint(4278190080);
                  _loc6_[++_loc7_] = uint(4278190080);
                  _loc6_[++_loc7_] = uint(4278190080);
                  _loc6_[++_loc7_] = uint(4278190080);
                  _loc6_[++_loc7_] = uint(4278190080);
                  _loc6_[++_loc7_] = uint(4278190080);
                  _loc6_[++_loc7_] = uint(4278190080);
                  _loc8_ = false;
               }
            }
            if(_loc8_)
            {
               if((_loc5_ & 128) != 0)
               {
                  _loc6_[_loc7_] = uint(4278190080);
               }
               _loc5_ = _loc5_ << 1;
            }
            _loc7_++;
         }
         _loc4_.setVector(_loc4_.rect,_loc6_);
         return _loc4_;
      }
      
      public static function createCroppedVBitmapDataContainer(param1:ByteArray, param2:int, param3:uint = 4.294967295E9, param4:uint = 4.294967295E9) : ICroppedBitmapDataContainer
      {
         var _loc5_:BitmapData = createBitmapData(param1,param2);
         var _loc6_:ICroppedBitmapDataContainer = new CroppedVBitmapDataContainer(_loc5_,param3,param4);
         _loc5_.dispose();
         _loc5_ = null;
         return _loc6_;
      }
      
      public static function getMirrorDir(param1:int) : int
      {
         if(param1 == 3 || param1 == 7)
         {
            return -1;
         }
         return 6 - param1;
      }
      
      public static function createMirroredBitmapData(param1:BitmapData) : BitmapData
      {
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,param1.transparent,0);
         var _loc3_:Matrix = new Matrix();
         _loc3_.scale(-1,1);
         _loc3_.tx = param1.width;
         _loc2_.draw(param1,_loc3_);
         return _loc2_;
      }
      
      public static function createMirroredCroppedBitmapDataContainer(param1:ICroppedBitmapDataContainer) : ICroppedBitmapDataContainer
      {
         var _loc2_:ICroppedBitmapDataContainer = param1.clone();
         _loc2_.bitmapData = createMirroredBitmapData(param1.bitmapData);
         _loc2_.crect.x = _loc2_.width - _loc2_.bitmapData.width - _loc2_.crect.x;
         return _loc2_;
      }
      
      private static function decodeIsoObjectV1(param1:MediaContainerContent, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc20_:String = null;
         var _loc21_:Object = null;
         var _loc22_:Array = null;
         var _loc23_:* = false;
         var _loc24_:Boolean = false;
         var _loc25_:Array = null;
         var _loc26_:Array = null;
         var _loc27_:int = 0;
         var _loc28_:Array = null;
         var _loc29_:BitmapData = null;
         var _loc30_:Rectangle = null;
         var _loc31_:Sprite = null;
         var _loc32_:BitmapData = null;
         var _loc33_:BitmapData = null;
         var _loc34_:Array = null;
         var _loc35_:int = 0;
         var _loc36_:int = 0;
         var _loc37_:ICroppedBitmapDataContainer = null;
         var _loc38_:Array = null;
         var _loc39_:int = 0;
         var _loc40_:Array = null;
         var _loc41_:ByteArray = null;
         var _loc42_:Rectangle = null;
         var _loc43_:Object = null;
         var _loc3_:int = 2;
         var _loc5_:* = int(param1.getByteAt(_loc3_));
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the Tilebase");
         }
         var _loc6_:int = param1.getByteAt(_loc3_);
         if(_loc6_ % 16 != 0)
         {
            throw new Error("Tile base has a  invalid value " + _loc6_);
         }
         param2[TILEBASE] = _loc6_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the total height");
         }
         param2[OBJ_TOTAL_HEIGHT] = param1.getIntAt(_loc3_);
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the TopHeight value");
         }
         param2[OBJ_TOP_HEIGHT] = param1.getIntAt(_loc3_);
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the default direction");
         }
         _loc5_ = int(param1.getByteAt(_loc3_));
         if(_loc5_ == 0)
         {
            throw new Error("No default direction set");
         }
         var _loc7_:int = -1;
         var _loc8_:* = 0;
         while(_loc5_ > 0)
         {
            _loc7_++;
            _loc8_ = _loc5_ & 1;
            _loc5_ = _loc5_ >> 1;
            if(_loc8_ > 0)
            {
               break;
            }
         }
         if(_loc5_ > 0)
         {
            throw new Error("DefaultDirection has more than one bit set: " + param1.getByteAt(_loc3_));
         }
         param2[OBJ_DEFAULT_DIRECTION] = _loc7_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_STRING)
         {
            throw new Error("Failed to read DefaultAnimation");
         }
         var _loc9_:String = param1.getStringAt(_loc3_);
         param2[OBJ_DEFAULT_ANIMATION] = _loc9_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read DefaultFrame");
         }
         var _loc10_:int = param1.getByteAt(_loc3_);
         param2[OBJ_DEFAULT_FRAME] = _loc10_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read AnimationCount");
         }
         var _loc11_:int = param1.getByteAt(_loc3_);
         if(_loc11_ == 0)
         {
            throw new Error("AnimationCount cannot be zero");
         }
         _loc3_++;
         var _loc12_:Boolean = false;
         var _loc13_:Object = new Object();
         param2[OBJ_ANIMATIONS] = _loc13_;
         var _loc17_:Boolean = false;
         _loc14_ = 0;
         while(_loc14_ < _loc11_)
         {
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_STRING)
            {
               throw new Error("Failed to read the animation label at chunk index " + _loc3_);
            }
            _loc20_ = param1.getStringAt(_loc3_);
            if(_loc13_[_loc20_] != null)
            {
               throw new Error("Duplicate animation at index " + _loc3_ + ": " + _loc20_);
            }
            _loc21_ = new Object();
            _loc13_[_loc20_] = _loc21_;
            _loc3_++;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
            {
               throw new Error("Failed to read the animation directions at index " + _loc3_);
            }
            _loc5_ = int(param1.getByteAt(_loc3_));
            if(_loc5_ == 0)
            {
               throw new Error("There are no directions set for the animation " + _loc20_);
            }
            _loc22_ = new Array();
            _loc8_ = 0;
            _loc7_ = -1;
            while(_loc5_ > 0)
            {
               _loc8_ = _loc5_ & 1;
               _loc7_++;
               _loc5_ = _loc5_ >> 1;
               if(_loc8_ != 0)
               {
                  _loc22_.push(_loc7_);
               }
            }
            _loc21_[OBJ_ANIM_DIRECTIONS] = _loc22_;
            _loc3_++;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
            {
               throw new Error("Failed to read the info flags at index " + _loc3_);
            }
            _loc5_ = int(param1.getByteAt(_loc3_));
            _loc23_ = (_loc5_ & MIRROR_MASK) != 0;
            _loc21_[OBJ_ANIM_MIRRORING] = _loc23_;
            _loc24_ = false;
            if((_loc5_ & BOUNDS_MASK) != 0)
            {
               _loc24_ = true;
            }
            _loc12_ = _loc12_ || _loc24_;
            _loc3_++;
            _loc25_ = new Array();
            _loc15_ = 0;
            while(_loc15_ < _loc22_.length)
            {
               if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
               {
                  throw new Error("Failed to read the grip image width at index " + _loc3_);
               }
               _loc5_ = int(param1.getIntAt(_loc3_));
               _loc3_++;
               if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_RAWBYTES)
               {
                  throw new Error("Failed to read the grip image at index " + _loc3_);
               }
               _loc29_ = createBitmapData(param1.getByteArrayAt(_loc3_),_loc5_);
               _loc30_ = _loc29_.getColorBoundsRect(4294967295,4278190080);
               if(_loc30_.width == 0 || _loc30_.height == 0)
               {
                  _loc31_ = new Sprite();
                  _loc31_.graphics.beginFill(0);
                  _loc31_.graphics.drawEllipse((_loc29_.width - 6) / 2,(_loc29_.height - 6) / 2,6,6);
                  _loc31_.graphics.endFill();
                  _loc29_.fillRect(_loc29_.rect,0);
                  _loc29_.draw(_loc31_);
                  _loc29_.threshold(_loc29_,_loc29_.rect,_loc29_.rect.topLeft,"!=",0,4278190080,4278190080);
               }
               _loc25_[_loc22_[_loc15_]] = _loc29_;
               _loc3_++;
               _loc5_ = int(getMirrorDir(_loc22_[_loc15_]));
               if(_loc23_ && _loc5_ >= 0)
               {
                  _loc32_ = new BitmapData(_loc29_.height,_loc29_.width,true,0);
                  _loc32_.draw(_loc29_,GRIP_MIRROR_MATRIX);
                  _loc25_[_loc5_] = _loc32_;
               }
               _loc15_++;
            }
            _loc21_[OBJ_ANIM_GRIPIMAGES] = _loc25_;
            _loc26_ = new Array();
            _loc15_ = 0;
            while(_loc15_ < _loc22_.length)
            {
               if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
               {
                  throw new Error("Failed to read the mask width at index " + _loc3_);
               }
               _loc5_ = int(param1.getIntAt(_loc3_));
               _loc3_++;
               if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_RAWBYTES)
               {
                  throw new Error("Failed to read mask at index " + _loc3_);
               }
               _loc26_[_loc22_[_loc15_]] = createCroppedVBitmapDataContainer(param1.getByteArrayAt(_loc3_),_loc5_);
               _loc3_++;
               _loc5_ = int(getMirrorDir(_loc22_[_loc15_]));
               if(_loc23_ && _loc5_ >= 0)
               {
                  _loc26_[_loc5_] = createMirroredCroppedBitmapDataContainer(_loc26_[_loc22_[_loc15_]]);
               }
               _loc15_++;
            }
            _loc21_[OBJ_ANIM_MASKS] = _loc26_;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
            {
               throw new Error("Failed to read the frame count at index " + _loc3_);
            }
            _loc27_ = param1.getByteAt(_loc3_);
            if(_loc27_ == 0)
            {
               throw new Error("The frame count cannot be zero (" + _loc20_ + ")");
            }
            if(_loc20_ == _loc9_ && _loc27_ >= _loc10_)
            {
               _loc17_ = true;
            }
            _loc3_++;
            _loc28_ = new Array();
            _loc15_ = 0;
            while(_loc15_ < _loc22_.length)
            {
               _loc33_ = _loc25_[_loc22_[_loc15_]];
               _loc34_ = new Array();
               _loc35_ = (_loc33_.width + _loc33_.height) / IsoGrid.upt * _loc6_ / 2;
               _loc36_ = 0;
               _loc16_ = 0;
               while(_loc16_ < _loc27_)
               {
                  _loc5_ = int(param1.getTypeAt(_loc3_));
                  if(_loc5_ != MediaContainerDecoder.TYPE_BITMAP && _loc5_ != MediaContainerDecoder.TYPE_ARGB32)
                  {
                     throw new Error("Failed to read animation frame at index " + _loc3_);
                  }
                  _loc37_ = param1.getCroppedBitmapDataAt(_loc3_,CroppedBitmapDataContainer.DEFAULT_MASK,CroppedBitmapDataContainer.DEFAULT_COLOR);
                  if(_loc36_ == 0)
                  {
                     _loc36_ = _loc37_.height;
                  }
                  else if(_loc37_.height != _loc36_)
                  {
                     throw new Error("Frames with incorrect height found within the animation " + _loc20_ + "(direction " + _loc22_[_loc15_] + " frame number: " + _loc16_ + "): " + _loc37_.height + " instead of " + _loc36_);
                  }
                  if(_loc35_ != _loc37_.width)
                  {
                     throw new Error("Frames with incorrect width found within the animation " + _loc20_ + "(direction " + _loc22_[_loc15_] + " frame number: " + _loc16_ + "): " + _loc37_.width + " instead of " + _loc35_);
                  }
                  _loc34_.push(_loc37_);
                  _loc3_++;
                  _loc16_++;
               }
               _loc28_[_loc22_[_loc15_]] = _loc34_;
               if(_loc23_)
               {
                  _loc38_ = new Array(_loc34_.length);
                  _loc39_ = getMirrorDir(_loc22_[_loc15_]);
                  if(_loc39_ >= 0)
                  {
                     _loc16_ = 0;
                     while(_loc16_ < _loc34_.length)
                     {
                        if(_loc34_[_loc16_] != null)
                        {
                           _loc38_[_loc16_] = createMirroredCroppedBitmapDataContainer(_loc34_[_loc16_]);
                        }
                        _loc16_++;
                     }
                     _loc28_[_loc39_] = _loc38_;
                  }
               }
               _loc15_++;
            }
            _loc21_[OBJ_ANIM_FRAMES] = _loc28_;
            if(_loc24_)
            {
               _loc40_ = new Array();
               _loc15_ = 0;
               while(_loc15_ < _loc22_.length)
               {
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_RAWBYTES)
                  {
                     throw new Error("Failed to read the bounds at index " + _loc3_);
                  }
                  _loc41_ = param1.getByteArrayAt(_loc3_);
                  _loc3_++;
                  if(_loc41_.length != 16)
                  {
                     throw new Error("The size of the bounds chunk at index " + _loc3_ + " is incorrect: " + _loc41_.bytesAvailable);
                  }
                  _loc41_.position = 0;
                  _loc42_ = new Rectangle();
                  _loc42_.x = _loc41_.readInt();
                  _loc42_.y = _loc41_.readInt();
                  _loc42_.width = _loc41_.readInt();
                  _loc42_.height = _loc41_.readInt();
                  _loc40_[_loc22_[_loc15_]] = _loc42_;
                  _loc15_++;
               }
               _loc21_[OBJ_ANIM_ISOCOMPONENTBOUNDS] = _loc40_;
            }
            if(_loc23_)
            {
               _loc5_ = int(_loc22_.length);
               _loc16_ = 0;
               while(_loc16_ < _loc5_)
               {
                  _loc39_ = getMirrorDir(_loc22_[_loc16_]);
                  if(_loc39_ != -1)
                  {
                     _loc22_.push(_loc39_);
                  }
                  _loc16_++;
               }
            }
            _loc22_.sort(Array.NUMERIC);
            _loc14_++;
         }
         if(!_loc17_)
         {
            throw new Error("The default animation and frame could not be found.");
         }
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read SoundCount");
         }
         var _loc18_:int = param1.getByteAt(_loc3_);
         _loc3_++;
         var _loc19_:Object = new Object();
         _loc14_ = 0;
         while(_loc14_ < _loc18_)
         {
            _loc43_ = new Object();
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_STRING)
            {
               throw new Error("Failed to read sound label at index " + _loc3_);
            }
            _loc4_ = param1.getStringAt(_loc3_);
            if(_loc19_[_loc4_] != null)
            {
               throw new Error("Duplicate sound at index " + _loc3_);
            }
            _loc3_++;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
            {
               throw new Error("Failed to read the sound length at index " + _loc3_);
            }
            _loc43_[SOUND_LENGTH] = param1.getIntAt(_loc3_);
            _loc3_++;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_MP3)
            {
               throw new Error("Failed to read sound data at index " + _loc3_);
            }
            _loc43_[SOUND_OBJ] = param1.getSoundAt(_loc3_);
            _loc19_[_loc4_] = _loc43_;
            _loc3_++;
            _loc14_++;
         }
         param2[SOUNDS] = _loc19_;
         if(_loc12_)
         {
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_ISOCOMP)
            {
               throw new Error("Failed to read iso component at index " + _loc3_);
            }
            param2[OBJ_ISOCOMPONENT] = param1.getIsoComponentAt(_loc3_);
            _loc3_++;
         }
         else
         {
            param2[OBJ_ISOCOMPONENT] = null;
         }
         if(_loc3_ != param1.length)
         {
         }
      }
      
      private static function decodeIsoObjectV3(param1:MediaContainerContent, param2:Object) : void
      {
         var _loc4_:* = 0;
         var _loc5_:String = null;
         var _loc7_:ByteArray = null;
         var _loc11_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc24_:Object = null;
         var _loc26_:String = null;
         var _loc27_:Object = null;
         var _loc28_:* = false;
         var _loc29_:Boolean = false;
         var _loc30_:BitmapData = null;
         var _loc31_:Array = null;
         var _loc32_:Array = null;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:Array = null;
         var _loc36_:Array = null;
         var _loc37_:int = 0;
         var _loc38_:ICroppedBitmapDataContainer = null;
         var _loc39_:int = 0;
         var _loc40_:Array = null;
         var _loc41_:Array = null;
         var _loc42_:Object = null;
         var _loc43_:Array = null;
         var _loc44_:int = 0;
         var _loc45_:Object = null;
         var _loc46_:Point = null;
         var _loc3_:int = 2;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the Tilebase");
         }
         var _loc6_:int = param1.getByteAt(_loc3_);
         if(_loc6_ % 16 != 0)
         {
            throw new Error("Tile base has a  invalid value " + _loc6_);
         }
         param2[TILEBASE] = _loc6_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the total height");
         }
         param2[OBJ_TOTAL_HEIGHT] = param1.getIntAt(_loc3_);
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the TopHeight value");
         }
         param2[OBJ_TOP_HEIGHT] = param1.getIntAt(_loc3_);
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_RAWBYTES)
         {
            throw new Error("Failed to read the sit bounds at index " + _loc3_);
         }
         _loc7_ = param1.getByteArrayAt(_loc3_);
         if(_loc7_.length != 16)
         {
            throw new Error("The size of the sit bounds chunk at index " + _loc3_ + " is incorrect: " + _loc7_.bytesAvailable);
         }
         _loc7_.position = 0;
         var _loc8_:Rectangle = new Rectangle();
         _loc8_.x = _loc7_.readInt();
         _loc8_.y = _loc7_.readInt();
         _loc8_.width = _loc7_.readInt();
         _loc8_.height = _loc7_.readInt();
         param2[OBJ_SIT_BOUNDS] = _loc8_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the sit directions at index " + _loc3_);
         }
         _loc4_ = int(param1.getByteAt(_loc3_));
         var _loc9_:Array = new Array();
         var _loc10_:* = 0;
         _loc11_ = -1;
         while(_loc11_ < 7)
         {
            _loc10_ = _loc4_ & 128;
            _loc11_++;
            _loc4_ = _loc4_ << 1;
            if(_loc10_ != 0)
            {
               _loc9_.push(_loc11_);
            }
         }
         param2[OBJ_SIT_DIRECTIONS] = _loc9_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the default direction");
         }
         _loc4_ = int(param1.getByteAt(_loc3_));
         if(_loc4_ == 0)
         {
            throw new Error("No default direction set");
         }
         _loc11_ = -1;
         _loc10_ = 0;
         while(_loc4_ > 0)
         {
            _loc11_++;
            _loc10_ = _loc4_ & 1;
            _loc4_ = _loc4_ >> 1;
            if(_loc10_ > 0)
            {
               break;
            }
         }
         if(_loc4_ > 0)
         {
            throw new Error("DefaultDirection has more than one bit set: " + param1.getByteAt(_loc3_));
         }
         param2[OBJ_DEFAULT_DIRECTION] = _loc11_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the grip image direction");
         }
         _loc4_ = int(param1.getByteAt(_loc3_));
         var _loc12_:int = -1;
         while(_loc4_ > 0)
         {
            _loc12_++;
            _loc10_ = _loc4_ & 1;
            _loc4_ = _loc4_ >> 1;
            if(_loc10_ > 0)
            {
               break;
            }
         }
         if(_loc4_ > 0)
         {
            throw new Error("GripDirection has more than one bit set: " + param1.getByteAt(_loc3_));
         }
         if(_loc12_ != 0 && _loc12_ != 2 && _loc12_ != 4 && _loc12_ != 6)
         {
            throw new Error("Grip dierction has an invalid value: " + _loc12_);
         }
         param2[OBJ_GRIP_DIRECTION] = _loc12_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_STRING)
         {
            throw new Error("Failed to read DefaultAnimation");
         }
         var _loc13_:String = param1.getStringAt(_loc3_);
         param2[OBJ_DEFAULT_ANIMATION] = _loc13_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read DefaultFrame");
         }
         var _loc14_:int = param1.getByteAt(_loc3_);
         param2[OBJ_DEFAULT_FRAME] = _loc14_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read AnimationCount");
         }
         var _loc15_:int = param1.getByteAt(_loc3_);
         if(_loc15_ == 0)
         {
            throw new Error("AnimationCount cannot be zero");
         }
         _loc3_++;
         var _loc16_:Boolean = false;
         var _loc17_:Object = new Object();
         param2[OBJ_ANIMATIONS] = _loc17_;
         var _loc21_:Boolean = false;
         _loc18_ = 0;
         while(_loc18_ < _loc15_)
         {
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_STRING)
            {
               throw new Error("Failed to read the animation label at chunk index " + _loc3_);
            }
            _loc26_ = param1.getStringAt(_loc3_);
            if(_loc17_[_loc26_] != null)
            {
               throw new Error("Duplicate animation at index " + _loc3_ + ": " + _loc26_);
            }
            _loc27_ = new Object();
            _loc17_[_loc26_] = _loc27_;
            _loc3_++;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
            {
               throw new Error("Failed to read the animation directions at index " + _loc3_);
            }
            _loc4_ = int(param1.getByteAt(_loc3_));
            if(_loc4_ == 0)
            {
               throw new Error("There are no directions set for the animation " + _loc26_);
            }
            _loc9_ = new Array();
            _loc10_ = 0;
            _loc11_ = -1;
            while(_loc4_ > 0)
            {
               _loc10_ = _loc4_ & 1;
               _loc11_++;
               _loc4_ = _loc4_ >> 1;
               if(_loc10_ != 0)
               {
                  _loc9_.push(_loc11_);
               }
            }
            _loc27_[OBJ_ANIM_DIRECTIONS] = _loc9_;
            _loc3_++;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
            {
               throw new Error("Failed to read the info flags at index " + _loc3_);
            }
            _loc4_ = int(param1.getByteAt(_loc3_));
            _loc28_ = (_loc4_ & MIRROR_MASK) != 0;
            _loc27_[OBJ_ANIM_MIRRORING] = _loc28_;
            _loc29_ = false;
            if((_loc4_ & BOUNDS_MASK) != 0)
            {
               _loc29_ = true;
            }
            _loc16_ = _loc16_ || _loc29_;
            _loc3_++;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
            {
               throw new Error("Failed to read the grip image width at index " + _loc3_);
            }
            _loc4_ = int(param1.getIntAt(_loc3_));
            _loc3_++;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_RAWBYTES)
            {
               throw new Error("Failed to read the grip image at index " + _loc3_);
            }
            _loc30_ = createBitmapData(param1.getByteArrayAt(_loc3_),_loc4_);
            _loc3_++;
            _loc27_[OBJ_ANIM_ORIGINAL_GRIP] = _loc30_;
            _loc31_ = generateGrips(_loc30_,_loc12_,_loc9_,_loc28_);
            _loc27_[OBJ_ANIM_GRIPIMAGES] = _loc31_;
            _loc32_ = new Array();
            _loc19_ = 0;
            while(_loc19_ < _loc9_.length)
            {
               if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
               {
                  throw new Error("Failed to read the mask width at index " + _loc3_);
               }
               _loc4_ = int(param1.getIntAt(_loc3_));
               _loc3_++;
               if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_RAWBYTES)
               {
                  throw new Error("Failed to read mask at index " + _loc3_);
               }
               _loc32_[_loc9_[_loc19_]] = createCroppedVBitmapDataContainer(param1.getByteArrayAt(_loc3_),_loc4_);
               _loc3_++;
               _loc4_ = int(getMirrorDir(_loc9_[_loc19_]));
               if(_loc28_ && _loc4_ >= 0)
               {
                  _loc32_[_loc4_] = createMirroredCroppedBitmapDataContainer(_loc32_[_loc9_[_loc19_]]);
               }
               _loc19_++;
            }
            _loc27_[OBJ_ANIM_MASKS] = _loc32_;
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
            {
               throw new Error("Failed to read the frame count at index " + _loc3_);
            }
            _loc33_ = param1.getByteAt(_loc3_);
            if(_loc33_ == 0)
            {
               throw new Error("The frame count cannot be zero (" + _loc26_ + ")");
            }
            if(_loc26_ == _loc13_ && _loc33_ >= _loc14_)
            {
               _loc21_ = true;
            }
            _loc3_++;
            _loc34_ = Math.floor((_loc31_[_loc12_].width + _loc31_[_loc12_].height) / IsoGrid.upt) * _loc6_ / 2;
            _loc35_ = new Array();
            _loc19_ = 0;
            while(_loc19_ < _loc9_.length)
            {
               _loc36_ = new Array();
               _loc37_ = 0;
               _loc20_ = 0;
               while(_loc20_ < _loc33_)
               {
                  _loc4_ = int(param1.getTypeAt(_loc3_));
                  if(_loc4_ != MediaContainerDecoder.TYPE_BITMAP && _loc4_ != MediaContainerDecoder.TYPE_ARGB32)
                  {
                     throw new Error("Failed to read animation frame at index " + _loc3_);
                  }
                  _loc38_ = param1.getCroppedBitmapDataAt(_loc3_,CroppedBitmapDataContainer.DEFAULT_MASK,CroppedBitmapDataContainer.DEFAULT_COLOR);
                  if(_loc37_ == 0)
                  {
                     _loc37_ = _loc38_.height;
                  }
                  else if(_loc38_.height != _loc37_)
                  {
                     throw new Error("Frames with incorrect height found within the animation " + _loc26_ + "(direction " + _loc9_[_loc19_] + " frame number: " + _loc20_ + "): " + _loc38_.height + " instead of " + _loc37_);
                  }
                  if(_loc38_.width <= _loc34_)
                  {
                     _loc38_.crect.x = _loc38_.crect.x + (_loc34_ - _loc38_.rect.width) / 2;
                     _loc38_.rect.width = _loc34_;
                     _loc36_.push(_loc38_);
                     _loc3_++;
                     _loc20_++;
                     continue;
                  }
                  throw new Error("Frame " + _loc20_ + " in animation " + _loc26_ + " is too big: " + _loc38_.width);
               }
               _loc35_[_loc9_[_loc19_]] = _loc36_;
               if(_loc28_)
               {
                  _loc39_ = getMirrorDir(_loc9_[_loc19_]);
                  if(_loc39_ >= 0 && _loc9_.indexOf(_loc39_) < 0)
                  {
                     _loc40_ = new Array(_loc36_.length);
                     if(_loc39_ >= 0)
                     {
                        _loc20_ = 0;
                        while(_loc20_ < _loc36_.length)
                        {
                           if(_loc36_[_loc20_] != null)
                           {
                              _loc40_[_loc20_] = createMirroredCroppedBitmapDataContainer(_loc36_[_loc20_]);
                           }
                           _loc20_++;
                        }
                        _loc35_[_loc39_] = _loc40_;
                     }
                  }
               }
               _loc19_++;
            }
            _loc27_[OBJ_ANIM_FRAMES] = _loc35_;
            if(_loc29_)
            {
               _loc41_ = new Array();
               _loc19_ = 0;
               while(_loc19_ < _loc9_.length)
               {
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_RAWBYTES)
                  {
                     throw new Error("Failed to read the bounds at index " + _loc3_);
                  }
                  _loc7_ = param1.getByteArrayAt(_loc3_);
                  _loc3_++;
                  if(_loc7_.length != 16)
                  {
                     throw new Error("The size of the bounds chunk at index " + _loc3_ + " is incorrect: " + _loc7_.bytesAvailable);
                  }
                  _loc7_.position = 0;
                  _loc8_ = new Rectangle();
                  _loc8_.x = _loc7_.readInt();
                  _loc8_.y = _loc7_.readInt();
                  _loc8_.width = _loc7_.readInt();
                  _loc8_.height = _loc7_.readInt();
                  _loc41_[_loc9_[_loc19_]] = _loc8_;
                  _loc19_++;
               }
               _loc27_[OBJ_ANIM_ISOCOMPONENTBOUNDS] = _loc41_;
            }
            if(_loc28_)
            {
               _loc4_ = int(_loc9_.length);
               _loc20_ = 0;
               while(_loc20_ < _loc4_)
               {
                  _loc39_ = getMirrorDir(_loc9_[_loc20_]);
                  if(_loc39_ != -1)
                  {
                     _loc9_.push(_loc39_);
                  }
                  _loc20_++;
               }
            }
            _loc9_.sort(Array.NUMERIC);
            _loc18_++;
         }
         if(!_loc21_)
         {
            throw new Error("The default animation and frame could not be found.");
         }
         if(_loc16_)
         {
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_ISOCOMP)
            {
               throw new Error("Failed to read iso component at index " + _loc3_);
            }
            param2[OBJ_ISOCOMPONENT] = param1.getIsoComponentAt(_loc3_);
            _loc3_++;
         }
         else
         {
            param2[OBJ_ISOCOMPONENT] = null;
         }
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read number of optional blocks.");
         }
         var _loc22_:int = param1.getIntAt(_loc3_);
         _loc3_++;
         var _loc23_:Object = new Object();
         var _loc25_:Object = new Object();
         _loc18_ = 0;
         loop11:
         while(true)
         {
            if(_loc18_ >= _loc22_)
            {
               param2[SOUNDS] = _loc23_;
               param2[TRIGGER] = _loc24_;
               param2[LIGHTMAPS] = _loc25_;
               if(_loc3_ != param1.length)
               {
               }
               return;
            }
            if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_STRING)
            {
               throw new Error("Failed to read the block type at index: " + _loc3_);
            }
            _loc5_ = param1.getStringAt(_loc3_);
            _loc3_++;
            switch(_loc5_)
            {
               case BLOCK_TYPE_SOUND:
                  _loc42_ = new Object();
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_STRING)
                  {
                     throw new Error("Failed to read sound label at index " + _loc3_);
                  }
                  _loc5_ = param1.getStringAt(_loc3_);
                  if(_loc23_[_loc5_] != null)
                  {
                     throw new Error("Duplicate sound at index " + _loc3_);
                  }
                  _loc3_++;
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the sound length at index " + _loc3_);
                  }
                  _loc42_[SOUND_LENGTH] = param1.getIntAt(_loc3_);
                  _loc3_++;
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_MP3)
                  {
                     throw new Error("Failed to read sound data at index " + _loc3_);
                  }
                  _loc42_[SOUND_OBJ] = param1.getSoundAt(_loc3_);
                  _loc23_[_loc5_] = _loc42_;
                  _loc3_++;
                  break;
               case BLOCK_TYPE_TRIGGER:
                  if(_loc24_)
                  {
                     throw new Error("Duplicate trigger at index " + _loc3_);
                  }
                  _loc24_ = new Object();
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_STRING)
                  {
                     throw new Error("Failed to read trigger label at index " + _loc3_);
                  }
                  _loc5_ = param1.getStringAt(_loc3_);
                  _loc24_[LABEL] = _loc5_;
                  _loc3_++;
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the x offset of the trigger: " + _loc3_);
                  }
                  _loc24_[OFFSET_X] = param1.getIntAt(_loc3_);
                  _loc3_++;
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the y offset of the trigger: " + _loc3_);
                  }
                  _loc24_[OFFSET_Y] = param1.getIntAt(_loc3_);
                  _loc3_++;
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_RAWBYTES)
                  {
                     throw new Error("Failed to read the polygon data at index " + _loc3_);
                  }
                  _loc7_ = param1.getByteArrayAt(_loc3_);
                  if(_loc7_.length % 8 != 0)
                  {
                     throw new Error("The size of the polygon chunk at index " + _loc3_ + " is incorrect " + _loc7_.length);
                  }
                  _loc43_ = new Array();
                  _loc7_.position = 0;
                  _loc44_ = _loc7_.length / 8;
                  _loc19_ = 0;
                  while(_loc19_ < _loc44_)
                  {
                     _loc46_ = new Point();
                     _loc46_.x = _loc7_.readInt();
                     _loc46_.y = _loc7_.readInt();
                     _loc43_.push(_loc46_);
                     _loc19_++;
                  }
                  _loc24_[POLYGON] = _loc43_;
                  _loc3_++;
                  break;
               case BLOCK_TYPE_LIGHTMAP:
                  _loc45_ = new Object();
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_STRING)
                  {
                     throw new Error("Failed to read lightmap label at index " + _loc3_);
                  }
                  _loc5_ = param1.getStringAt(_loc3_);
                  if(_loc25_[_loc5_] != null)
                  {
                     throw new Error("Duplicate lightmap at index " + _loc3_);
                  }
                  _loc3_++;
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the x offset of the lighmap: " + _loc3_);
                  }
                  _loc45_[OFFSET_X] = param1.getIntAt(_loc3_);
                  _loc3_++;
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the y offset of the lighmap: " + _loc3_);
                  }
                  _loc45_[OFFSET_Y] = param1.getIntAt(_loc3_);
                  _loc3_++;
                  if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_ARGB32 && param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BITMAP)
                  {
                     throw new Error("Failed to read the lightmap at index " + _loc3_);
                  }
                  _loc45_[LIGHTMAP] = param1.getBitmapDataAt(_loc3_);
                  _loc3_++;
                  _loc25_[_loc5_] = _loc45_;
                  break;
               default:
                  break loop11;
            }
            _loc18_++;
         }
         throw new Error("Unrecognized block type at index " + _loc3_);
      }
      
      private static function decodeIsoObjectV4(param1:MediaContainerContent, param2:Object) : IsoObjectData
      {
         var _loc9_:ByteArray = null;
         var _loc23_:TriggerData = null;
         var _loc25_:AnimationData = null;
         var _loc26_:String = null;
         var _loc27_:* = false;
         var _loc28_:FrameData = null;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:Array = null;
         var _loc33_:Array = null;
         var _loc34_:int = 0;
         var _loc35_:int = 0;
         var _loc36_:int = 0;
         var _loc37_:int = 0;
         var _loc38_:ByteArray = null;
         var _loc39_:int = 0;
         var _loc40_:int = 0;
         var _loc41_:BitmapData = null;
         var _loc42_:int = 0;
         var _loc43_:int = 0;
         var _loc44_:ByteArray = null;
         var _loc45_:BitmapData = null;
         var _loc46_:BitmapData = null;
         var _loc47_:Array = null;
         var _loc48_:int = 0;
         var _loc49_:Array = null;
         var _loc50_:FrameData = null;
         var _loc51_:Array = null;
         var _loc52_:int = 0;
         var _loc53_:String = null;
         var _loc54_:SoundData = null;
         var _loc55_:Array = null;
         var _loc56_:int = 0;
         var _loc57_:LightmapData = null;
         var _loc58_:Point = null;
         var _loc3_:IsoObjectData = new IsoObjectData();
         _loc3_.version = param2[VERSION_NUMBER];
         var _loc4_:int = 2;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read tilebase at index " + _loc4_);
         }
         var _loc5_:int = param1.getByteAt(_loc4_);
         if(_loc5_ % 16 != 0)
         {
            throw new Error("Tile base has an invalid value " + _loc5_);
         }
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read size_u at index " + _loc4_);
         }
         var _loc6_:int = param1.getIntAt(_loc4_);
         _loc3_.sizeU = _loc6_;
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read size_v at index " + _loc4_);
         }
         var _loc7_:int = param1.getIntAt(_loc4_);
         _loc3_.sizeV = _loc7_;
         _loc4_++;
         var _loc8_:int = _loc6_ / 16 * _loc5_ / 2 + _loc7_ / 16 * _loc5_ / 2;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_RAWBYTES)
         {
            throw new Error("Failed to read the sit bounds at index " + _loc4_);
         }
         _loc9_ = param1.getByteArrayAt(_loc4_);
         if(_loc9_.length != 16)
         {
            throw new Error("The size of the sit bounds chunk at index " + _loc4_ + " is incorrect: " + _loc9_.bytesAvailable);
         }
         _loc9_.position = 0;
         var _loc10_:Rectangle = new Rectangle();
         _loc10_.x = _loc9_.readInt();
         _loc10_.y = _loc9_.readInt();
         _loc10_.width = _loc9_.readInt();
         _loc10_.height = _loc9_.readInt();
         _loc3_.sitBounds = _loc10_;
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the sit directions at index " + _loc4_);
         }
         var _loc11_:* = int(param1.getByteAt(_loc4_));
         var _loc12_:Array = new Array();
         var _loc13_:* = 0;
         var _loc14_:int = -1;
         while(_loc14_ < 7)
         {
            _loc13_ = _loc11_ & 128;
            _loc14_++;
            _loc11_ = _loc11_ << 1;
            if(_loc13_ != 0)
            {
               _loc12_.push(_loc14_);
            }
         }
         _loc3_.sitDirections = _loc12_;
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the default direction");
         }
         _loc11_ = int(param1.getByteAt(_loc4_));
         if(_loc11_ == 0)
         {
            throw new Error("No default direction set");
         }
         _loc14_ = -1;
         _loc13_ = 0;
         while(_loc11_ > 0)
         {
            _loc14_++;
            _loc13_ = _loc11_ & 1;
            _loc11_ = _loc11_ >> 1;
            if(_loc13_ > 0)
            {
               break;
            }
         }
         if(_loc11_ > 0)
         {
            throw new Error("DefaultDirection has more than one bit set: " + param1.getByteAt(_loc4_));
         }
         _loc3_.defaultDirection = _loc14_;
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read the grip image direction");
         }
         _loc11_ = int(param1.getByteAt(_loc4_));
         var _loc15_:int = -1;
         while(_loc11_ > 0)
         {
            _loc15_++;
            _loc13_ = _loc11_ & 1;
            _loc11_ = _loc11_ >> 1;
            if(_loc13_ > 0)
            {
               break;
            }
         }
         if(_loc11_ > 0)
         {
            throw new Error("GripDirection has more than one bit set: " + param1.getByteAt(_loc4_));
         }
         if(_loc15_ != 0 && _loc15_ != 2 && _loc15_ != 4 && _loc15_ != 6)
         {
            throw new Error("Grip dierction has an invalid value: " + _loc15_);
         }
         _loc3_.gripDirection = _loc15_;
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
         {
            throw new Error("Failed to read DefaultAnimation");
         }
         _loc3_.defaultAnimation = param1.getStringAt(_loc4_);
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read DefaultFrame");
         }
         _loc3_.defaultFrame = param1.getByteAt(_loc4_);
         _loc4_++;
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read AnimationCount");
         }
         var _loc16_:int = param1.getByteAt(_loc4_);
         if(_loc16_ == 0)
         {
            throw new Error("AnimationCount cannot be zero");
         }
         _loc4_++;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Object = new Object();
         _loc3_.animations = _loc19_;
         var _loc20_:int = 0;
         while(_loc20_ < _loc16_)
         {
            _loc25_ = new AnimationData();
            _loc25_.frameWidth = _loc8_;
            if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
            {
               throw new Error("Failed to read the animation label at chunk index " + _loc4_);
            }
            _loc26_ = param1.getStringAt(_loc4_);
            if(_loc19_[_loc26_] != null)
            {
               throw new Error("Duplicate animation at index " + _loc4_ + ": " + _loc26_);
            }
            _loc25_.label = _loc26_;
            _loc19_[_loc26_] = _loc25_;
            _loc4_++;
            if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
            {
               throw new Error("Failed to read the animation directions at index " + _loc4_);
            }
            _loc11_ = int(param1.getByteAt(_loc4_));
            if(_loc11_ == 0)
            {
               throw new Error("There are no directions set for the animation " + _loc26_);
            }
            _loc12_ = new Array();
            _loc13_ = 0;
            _loc14_ = -1;
            while(_loc11_ > 0)
            {
               _loc13_ = _loc11_ & 1;
               _loc14_++;
               _loc11_ = _loc11_ >> 1;
               if(_loc13_ != 0)
               {
                  _loc12_.push(_loc14_);
               }
            }
            _loc25_.directions = _loc12_;
            _loc4_++;
            if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
            {
               throw new Error("Failed to read the info flags at index " + _loc4_);
            }
            _loc11_ = int(param1.getByteAt(_loc4_));
            _loc27_ = (_loc11_ & MIRROR_MASK) != 0;
            if((_loc11_ & BOUNDS_MASK) != 0)
            {
               _loc25_.hasBounds = true;
            }
            _loc18_ = _loc18_ || _loc25_.hasBounds;
            _loc4_++;
            if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
            {
               throw new Error("Failed to read the frame count at index " + _loc4_);
            }
            _loc29_ = param1.getByteAt(_loc4_);
            if(_loc29_ == 0)
            {
               throw new Error("The frame count cannot be zero. (" + _loc26_ + ")");
            }
            _loc25_.frameCount = _loc29_;
            _loc4_++;
            if(_loc26_ == _loc3_.defaultAnimation && _loc3_.defaultFrame < _loc29_)
            {
               _loc17_ = true;
            }
            _loc32_ = new Array();
            _loc33_ = new Array();
            _loc30_ = 0;
            while(_loc30_ < _loc29_)
            {
               if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
               {
                  throw new Error("Failed to read the IFF at index " + _loc4_);
               }
               _loc11_ = int(param1.getByteAt(_loc4_));
               _loc4_++;
               if((_loc11_ & IFF_TOTAL_HEIGHT) == IFF_TOTAL_HEIGHT)
               {
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the total height at index " + _loc4_);
                  }
                  _loc35_ = param1.getIntAt(_loc4_);
                  _loc4_++;
               }
               if((_loc11_ & IFF_TOP_HEIGHT) == IFF_TOP_HEIGHT)
               {
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the top height at index " + _loc4_);
                  }
                  _loc34_ = param1.getIntAt(_loc4_);
                  _loc4_++;
               }
               if((_loc11_ & IFF_GRIP_OFF_U) == IFF_GRIP_OFF_U)
               {
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read grip offset U at index " + _loc4_);
                  }
                  _loc36_ = param1.getIntAt(_loc4_);
                  _loc4_++;
               }
               if((_loc11_ & IFF_GRIP_OFF_V) == IFF_GRIP_OFF_V)
               {
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read grip offset V at index " + _loc4_);
                  }
                  _loc37_ = param1.getIntAt(_loc4_);
                  _loc4_++;
               }
               if((_loc11_ & IFF_GRIP_DATA) == IFF_GRIP_DATA)
               {
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_RAWBYTES)
                  {
                     throw new Error("Failed to read the grip data at index " + _loc4_);
                  }
                  _loc38_ = param1.getByteArrayAt(_loc4_);
                  _loc4_++;
               }
               _loc28_ = new FrameData();
               _loc28_.totalHeight = _loc35_;
               _loc28_.topHeight = _loc34_;
               _loc38_.position = 0;
               _loc45_ = createBitmapData(_loc38_,_loc38_.readInt());
               _loc46_ = new BitmapData(_loc36_ + _loc45_.width,_loc37_ + _loc45_.height);
               _loc46_.copyPixels(_loc45_,_loc45_.rect,new Point(_loc36_,_loc37_));
               _loc33_.push(_loc46_);
               _loc32_.push(_loc28_);
               _loc30_++;
            }
            _loc25_.frames = new Array();
            _loc30_ = 0;
            while(_loc30_ < _loc12_.length)
            {
               _loc47_ = new Array();
               _loc25_.frames[_loc12_[_loc30_]] = _loc47_;
               _loc31_ = 0;
               while(_loc31_ < _loc29_)
               {
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BYTE)
                  {
                     throw new Error("Failed to read IFD at index " + _loc4_);
                  }
                  _loc11_ = int(param1.getByteAt(_loc4_));
                  _loc4_++;
                  if((_loc11_ & IFD_FRAME_OFF_X) == IFD_FRAME_OFF_X)
                  {
                     if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                     {
                        throw new Error("Failed to read the frame offset x at index " + _loc4_);
                     }
                     _loc39_ = param1.getIntAt(_loc4_);
                     _loc4_++;
                  }
                  if((_loc11_ & IFD_FRAME_OFF_Y) == IFD_FRAME_OFF_Y)
                  {
                     if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                     {
                        throw new Error("Failed to read the frame offset y at index " + _loc4_);
                     }
                     _loc40_ = param1.getIntAt(_loc4_);
                     _loc4_++;
                  }
                  if((_loc11_ & IFD_FRAME_DATA) == IFD_FRAME_DATA)
                  {
                     if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_ARGB32 && param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BITMAP)
                     {
                        throw new Error("Failed to read frame data at index " + _loc4_);
                     }
                     _loc41_ = param1.getBitmapDataAt(_loc4_);
                     _loc4_++;
                  }
                  if((_loc11_ & IFD_MASK_OFF_X) == IFD_MASK_OFF_X)
                  {
                     if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                     {
                        throw new Error("Failed to read the mask offset x at index " + _loc4_);
                     }
                     _loc42_ = param1.getIntAt(_loc4_);
                     _loc4_++;
                  }
                  if((_loc11_ & IFD_MASK_OFF_Y) == IFD_MASK_OFF_Y)
                  {
                     if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                     {
                        throw new Error("Failed to read the mask offset y at index " + _loc4_);
                     }
                     _loc43_ = param1.getIntAt(_loc4_);
                     _loc4_++;
                  }
                  if((_loc11_ & IFD_MASK_DATA) == IFD_MASK_DATA)
                  {
                     if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_RAWBYTES)
                     {
                        throw new Error("Failed to read the mask data at index " + _loc4_);
                     }
                     _loc44_ = param1.getByteArrayAt(_loc4_);
                     _loc4_++;
                  }
                  _loc28_ = (_loc32_[_loc31_] as FrameData).clone();
                  _loc28_.frameOffset = new Point(_loc39_,_loc40_);
                  _loc28_.frame = _loc41_;
                  _loc28_.maskOffset = new Point(_loc42_,_loc43_);
                  _loc44_.position = 0;
                  _loc28_.mask = createBitmapData(_loc44_,_loc44_.readInt());
                  _loc28_.grip = generateSingleGrip(_loc33_[_loc31_] as BitmapData,_loc15_,_loc12_[_loc30_]);
                  _loc47_.push(_loc28_);
                  _loc31_++;
               }
               if(_loc27_)
               {
                  _loc48_ = getMirrorDir(_loc12_[_loc30_]);
                  if(_loc48_ >= 0)
                  {
                     _loc49_ = new Array(_loc29_);
                     _loc25_.frames[_loc48_] = _loc49_;
                     _loc31_ = 0;
                     while(_loc31_ < _loc29_)
                     {
                        _loc28_ = _loc47_[_loc31_] as FrameData;
                        _loc50_ = new FrameData();
                        _loc50_.totalHeight = _loc28_.totalHeight;
                        _loc50_.topHeight = _loc28_.topHeight;
                        _loc50_.frameOffset = new Point(_loc8_ - (_loc28_.frame.width + _loc28_.frameOffset.x),_loc28_.frameOffset.y);
                        _loc50_.frame = createMirroredBitmapData(_loc28_.frame);
                        _loc50_.maskOffset = new Point(_loc8_ - (_loc28_.mask.width + _loc28_.maskOffset.x),_loc28_.maskOffset.y);
                        _loc50_.mask = createMirroredBitmapData(_loc28_.mask);
                        _loc50_.grip = generateSingleGrip(_loc33_[_loc31_] as BitmapData,_loc15_,_loc48_);
                        _loc49_[_loc31_] = _loc50_;
                        _loc31_++;
                     }
                  }
               }
               if(_loc25_.hasBounds)
               {
                  _loc51_ = new Array();
                  _loc30_ = 0;
                  while(_loc30_ < _loc12_.length)
                  {
                     if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_RAWBYTES)
                     {
                        throw new Error("Failed to read the bounds at index " + _loc4_);
                     }
                     _loc9_ = param1.getByteArrayAt(_loc4_);
                     _loc4_++;
                     if(_loc9_.length != 16)
                     {
                        throw new Error("The size of the bounds chunk at index " + _loc4_ + " is incorrect: " + _loc9_.bytesAvailable);
                     }
                     _loc9_.position = 0;
                     _loc10_ = new Rectangle();
                     _loc10_.x = _loc9_.readInt();
                     _loc10_.y = _loc9_.readInt();
                     _loc10_.width = _loc9_.readInt();
                     _loc10_.height = _loc9_.readInt();
                     _loc51_[_loc12_[_loc30_]] = _loc10_;
                     _loc30_++;
                  }
                  _loc25_.bounds = _loc51_;
               }
               _loc30_++;
            }
            if(_loc27_)
            {
               _loc11_ = int(_loc12_.length);
               _loc31_ = 0;
               while(_loc31_ < _loc11_)
               {
                  _loc52_ = getMirrorDir(_loc12_[_loc31_]);
                  if(_loc52_ != -1)
                  {
                     _loc12_.push(_loc52_);
                  }
                  _loc31_++;
               }
            }
            _loc12_.sort(Array.NUMERIC);
            _loc20_++;
         }
         if(!_loc17_)
         {
            throw new Error("The default animation and frame could not be found.");
         }
         if(_loc18_)
         {
            if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_ISOCOMP)
            {
               throw new Error("Failed to read iso component at index " + _loc4_);
            }
            _loc3_.isoComponent = param1.getIsoComponentAt(_loc4_);
            _loc4_++;
         }
         if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read number of optional blocks.");
         }
         var _loc21_:int = param1.getIntAt(_loc4_);
         _loc4_++;
         var _loc22_:Object = new Object();
         var _loc24_:Object = new Object();
         _loc20_ = 0;
         loop11:
         while(true)
         {
            if(_loc20_ >= _loc21_)
            {
               _loc3_.sounds = _loc22_;
               _loc3_.trigger = _loc23_;
               _loc3_.lightmaps = _loc24_;
               return _loc3_;
            }
            if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
            {
               throw new Error("Failed to read the block type at index: " + _loc4_);
            }
            _loc53_ = param1.getStringAt(_loc4_);
            _loc4_++;
            switch(_loc53_)
            {
               case BLOCK_TYPE_SOUND:
                  _loc54_ = new SoundData();
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
                  {
                     throw new Error("Failed to read sound label at index " + _loc4_);
                  }
                  _loc53_ = param1.getStringAt(_loc4_);
                  if(_loc22_[_loc53_] != null)
                  {
                     throw new Error("Duplicate sound at index " + _loc4_);
                  }
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the sound length at index " + _loc4_);
                  }
                  _loc54_.length = param1.getIntAt(_loc4_);
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_MP3)
                  {
                     throw new Error("Failed to read sound data at index " + _loc4_);
                  }
                  _loc54_.sound = param1.getSoundAt(_loc4_);
                  _loc22_[_loc53_] = _loc54_;
                  _loc4_++;
                  break;
               case BLOCK_TYPE_TRIGGER:
                  if(_loc23_)
                  {
                     throw new Error("Duplicate trigger at index " + _loc4_);
                  }
                  _loc23_ = new TriggerData();
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
                  {
                     throw new Error("Failed to read trigger label at index " + _loc4_);
                  }
                  _loc53_ = param1.getStringAt(_loc4_);
                  _loc23_.label = _loc53_;
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the x offset of the trigger: " + _loc4_);
                  }
                  _loc23_.offsetX = param1.getIntAt(_loc4_);
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the y offset of the trigger: " + _loc4_);
                  }
                  _loc23_.offsetY = param1.getIntAt(_loc4_);
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_RAWBYTES)
                  {
                     throw new Error("Failed to read the polygon data at index " + _loc4_);
                  }
                  _loc9_ = param1.getByteArrayAt(_loc4_);
                  if(_loc9_.length % 8 != 0)
                  {
                     throw new Error("The size of the polygon chunk at index " + _loc4_ + " is incorrect " + _loc9_.length);
                  }
                  _loc55_ = new Array();
                  _loc9_.position = 0;
                  _loc56_ = _loc9_.length / 8;
                  _loc30_ = 0;
                  while(_loc30_ < _loc56_)
                  {
                     _loc58_ = new Point();
                     _loc58_.x = _loc9_.readInt();
                     _loc58_.y = _loc9_.readInt();
                     _loc55_.push(_loc58_);
                     _loc30_++;
                  }
                  _loc23_.vertices = _loc55_;
                  _loc4_++;
                  break;
               case BLOCK_TYPE_LIGHTMAP:
                  _loc57_ = new LightmapData();
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_STRING)
                  {
                     throw new Error("Failed to read lightmap label at index " + _loc4_);
                  }
                  _loc53_ = param1.getStringAt(_loc4_);
                  if(_loc24_[_loc53_] != null)
                  {
                     throw new Error("Duplicate lightmap at index " + _loc4_);
                  }
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the x offset of the lighmap: " + _loc4_);
                  }
                  _loc57_.offsetX = param1.getIntAt(_loc4_);
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the y offset of the lighmap: " + _loc4_);
                  }
                  _loc57_.offsetY = param1.getIntAt(_loc4_);
                  _loc4_++;
                  if(param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_ARGB32 && param1.getTypeAt(_loc4_) != MediaContainerDecoder.TYPE_BITMAP)
                  {
                     throw new Error("Failed to read the lightmap at index " + _loc4_);
                  }
                  _loc57_.lightData = param1.getBitmapDataAt(_loc4_);
                  _loc4_++;
                  _loc24_[_loc53_] = _loc57_;
                  break;
               default:
                  break loop11;
            }
            _loc20_++;
         }
         throw new Error("Unrecognized block type at index " + _loc4_);
      }
      
      private static function generateGrips(param1:BitmapData, param2:int, param3:Array, param4:Boolean) : Array
      {
         var _loc7_:BitmapData = null;
         var _loc8_:BitmapData = null;
         var _loc9_:Rectangle = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc14_:Matrix = null;
         var _loc5_:Array = new Array();
         var _loc6_:Bitmap = new Bitmap(param1,PixelSnapping.AUTO,true);
         var _loc12_:Sprite = new Sprite();
         _loc12_.addChild(_loc6_);
         var _loc13_:Sprite = new Sprite();
         _loc13_.addChild(_loc12_);
         _loc10_ = 0;
         while(_loc10_ < param3.length)
         {
            if(param3[_loc10_] != undefined)
            {
               _loc7_ = null;
               if(param3[_loc10_] != param2)
               {
                  _loc6_.x = 0;
                  _loc6_.y = 0;
                  _loc14_ = new Matrix();
                  _loc6_.rotation = (param2 - param3[_loc10_]) * 45;
                  _loc9_ = _loc12_.getRect(_loc13_);
                  _loc7_ = new BitmapData(Math.ceil(_loc9_.width),Math.ceil(_loc9_.height),true,0);
                  _loc6_.x = -_loc9_.x;
                  _loc6_.y = -_loc9_.y;
                  _loc7_.lock();
                  _loc7_.draw(param1,_loc6_.transform.matrix);
                  _loc7_.unlock();
                  _loc5_[param3[_loc10_]] = _loc7_;
               }
               else
               {
                  _loc5_[param2] = param1;
                  _loc7_ = param1;
               }
               if(param4)
               {
                  _loc11_ = getMirrorDir(param3[_loc10_]);
                  if(_loc11_ >= 0 && param3.indexOf(_loc11_) < 0)
                  {
                     _loc8_ = new BitmapData(_loc7_.height,_loc7_.width,true,0);
                     _loc8_.draw(_loc7_,GRIP_MIRROR_MATRIX);
                     _loc5_[_loc11_] = _loc8_;
                  }
               }
            }
            _loc10_++;
         }
         if(!_loc5_[param2])
         {
            _loc5_[param2] = param1;
         }
         return _loc5_;
      }
      
      private static function generateSingleGrip(param1:BitmapData, param2:int, param3:int) : BitmapData
      {
         var _loc4_:BitmapData = null;
         var _loc5_:BitmapData = null;
         var _loc6_:Sprite = null;
         var _loc7_:Bitmap = null;
         var _loc8_:Rectangle = null;
         if(param3 != param2)
         {
            _loc6_ = new Sprite();
            _loc6_.addChild(_loc7_);
            _loc7_ = new Bitmap(param1,PixelSnapping.AUTO,true);
            _loc7_.rotation = (param2 - param3) * 45;
            _loc8_ = _loc7_.getRect(_loc6_);
            _loc7_.x = -_loc8_.x;
            _loc7_.y = -_loc8_.y;
            _loc4_ = new BitmapData(Math.ceil(_loc8_.width),Math.ceil(_loc8_.height),true,0);
            _loc4_.lock();
            _loc4_.draw(_loc7_,_loc7_.transform.matrix);
            _loc4_.unlock();
         }
         else
         {
            _loc4_ = param1;
         }
         return _loc4_;
      }
      
      public static function decodeIsoObject(param1:MediaContainerContent) : Object
      {
         var _loc4_:String = null;
         var _loc2_:Object = new Object();
         var _loc3_:int = 0;
         if(!checkContainerType(param1,TYPE_ISOOBJ))
         {
            throw new Error("The media content does not hold iso object data");
         }
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read iso object format version");
         }
         var _loc5_:int = param1.getByteAt(_loc3_);
         _loc2_[VERSION_NUMBER] = _loc5_;
         switch(_loc5_)
         {
            case 1:
               decodeIsoObjectV1(param1,_loc2_);
               break;
            case 3:
               decodeIsoObjectV3(param1,_loc2_);
               break;
            case 4:
               return decodeIsoObjectV4(param1,_loc2_);
            default:
               throw new Error("Unsupported iso object format version: " + _loc5_);
         }
         return _loc2_;
      }
      
      private static function decodeLevelBackgroundV2(param1:MediaContainerContent, param2:Object) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = 2;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read x offset of background");
         }
         var _loc5_:Point = new Point(param1.getByteAt(_loc3_),0);
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read y offset of background");
         }
         _loc5_.y = param1.getByteAt(_loc3_);
         param2[BG_OFFSET] = _loc5_;
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the width at index " + _loc3_);
         }
         var _loc6_:int = param1.getIntAt(_loc3_);
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read the height at index " + _loc3_);
         }
         var _loc7_:int = param1.getIntAt(_loc3_);
         _loc3_++;
         _loc4_ = param1.getTypeAt(_loc3_);
         if(_loc4_ != MediaContainerDecoder.TYPE_BITMAP && _loc4_ != MediaContainerDecoder.TYPE_ARGB32)
         {
            throw new Error("Failed to read background image");
         }
         var _loc8_:BitmapData = param1.getBitmapDataAt(_loc3_);
         var _loc9_:Matrix = new Matrix(_loc6_ / _loc8_.width,0,0,_loc7_ / _loc8_.height);
         var _loc10_:BitmapData = new BitmapData(_loc6_,_loc7_,false,4294901760);
         _loc10_.draw(_loc8_,_loc9_);
         _loc8_.dispose();
         param2[BG_IMAGE] = _loc10_.getPixels(_loc10_.rect);
         param2[BG_WIDTH] = _loc6_;
         param2[BG_HEIGHT] = _loc7_;
         _loc10_.dispose();
         _loc3_++;
         if(_loc3_ < param1.length)
         {
            _loc4_ = param1.getTypeAt(_loc3_);
            if(_loc4_ == MediaContainerDecoder.TYPE_BITMAP || _loc4_ == MediaContainerDecoder.TYPE_ARGB32)
            {
               param2[BG_LIGHTMAP] = param1.getBitmapDataAt(_loc3_);
            }
            else
            {
               throw new Error("Invalid lightmap data at index " + _loc3_);
            }
         }
      }
      
      public static function decodeLevelBackground(param1:MediaContainerContent) : Object
      {
         var _loc4_:int = 0;
         var _loc2_:Object = new Object();
         var _loc3_:int = 0;
         if(!checkContainerType(param1,TYPE_LEVELBG))
         {
            throw new Error("The media content does not contain background data");
         }
         _loc3_++;
         if(param1.getTypeAt(_loc3_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read background version");
         }
         _loc4_ = param1.getByteAt(_loc3_);
         _loc2_[VERSION_NUMBER] = _loc4_;
         _loc3_++;
         switch(_loc4_)
         {
            case 2:
               decodeLevelBackgroundV2(param1,_loc2_);
               return _loc2_;
            default:
               throw new Error("Unsupported level background version: " + _loc4_);
         }
      }
      
      public static function decodeMediapackContainer(param1:MediaContainerContent) : Object
      {
         var _loc2_:uint = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc13_:Object = null;
         var _loc14_:ByteArray = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Point = null;
         _loc2_ = 0;
         if(!checkContainerType(param1,TYPE_MEDIAPACK))
         {
            throw new Error("The container does not contain mediapack data.");
         }
         _loc2_++;
         var _loc3_:Object = new Object();
         if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_BYTE)
         {
            throw new Error("Failed to read mediapack version");
         }
         var _loc4_:uint = param1.getByteAt(_loc2_);
         _loc3_[VERSION_NUMBER] = _loc4_;
         _loc2_++;
         if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_INT)
         {
            throw new Error("Failed to read mediapack block count");
         }
         var _loc5_:int = param1.getIntAt(_loc2_);
         if(_loc5_ <= 0)
         {
            throw new Error("Invalid block count in mediapack container: " + _loc5_);
         }
         _loc2_++;
         var _loc12_:int = 0;
         loop0:
         while(true)
         {
            if(_loc12_ >= _loc5_)
            {
               if(_loc6_)
               {
                  _loc3_[SOUNDS] = _loc6_;
               }
               if(_loc7_)
               {
                  _loc3_[TRIGGERS] = _loc7_;
               }
               if(_loc8_)
               {
                  _loc3_[LIGHTMAPS] = _loc8_;
               }
               if(_loc9_)
               {
                  _loc3_[IMAGES] = _loc9_;
               }
               return _loc3_;
            }
            if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_STRING)
            {
               throw new Error("Failed to read mediapack block type at index " + _loc2_);
            }
            _loc10_ = param1.getStringAt(_loc2_);
            _loc2_++;
            if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_STRING)
            {
               throw new Error("Failed to read mediapack block label at index " + _loc2_);
            }
            _loc11_ = param1.getStringAt(_loc2_);
            _loc2_++;
            _loc13_ = new Object();
            switch(_loc10_)
            {
               case BLOCK_TYPE_SOUND:
                  if(!_loc6_)
                  {
                     _loc6_ = new Object();
                  }
                  if(_loc6_[_loc11_])
                  {
                     throw new Error("Duplicate sound label(" + _loc11_ + ") found at index " + _loc2_);
                  }
                  _loc6_[_loc11_] = _loc13_;
                  if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the sound length at index " + _loc2_);
                  }
                  _loc13_[SOUND_LENGTH] = param1.getIntAt(_loc2_);
                  _loc2_++;
                  if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_MP3)
                  {
                     throw new Error("Failed to read sound at index " + _loc2_);
                  }
                  _loc13_[SOUND_OBJ] = param1.getSoundAt(_loc2_);
                  _loc2_++;
                  break;
               case BLOCK_TYPE_LIGHTMAP:
                  if(!_loc8_)
                  {
                     _loc8_ = new Object();
                  }
                  if(_loc8_[_loc11_])
                  {
                     throw new Error("Duplicate lightmap label(" + _loc11_ + ") found at index " + _loc2_);
                  }
                  _loc8_[_loc11_] = _loc13_;
                  if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the x offset of the lighmap: " + _loc2_);
                  }
                  _loc13_[OFFSET_X] = param1.getIntAt(_loc2_);
                  _loc2_++;
                  if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the y offset of the lighmap: " + _loc2_);
                  }
                  _loc13_[OFFSET_Y] = param1.getIntAt(_loc2_);
                  _loc2_++;
                  if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_ARGB32 && param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_BITMAP)
                  {
                     throw new Error("Failed to read the lightmap at index " + _loc2_);
                  }
                  _loc13_[LIGHTMAP] = param1.getBitmapDataAt(_loc2_);
                  _loc2_++;
                  break;
               case BLOCK_TYPE_TRIGGER:
                  if(!_loc7_)
                  {
                     _loc7_ = new Object();
                  }
                  if(_loc7_[_loc11_])
                  {
                     throw new Error("Duplicate trigger label(" + _loc11_ + ") found at index " + _loc2_);
                  }
                  _loc7_[_loc11_] = _loc13_;
                  if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the x offset of the trigger: " + _loc2_);
                  }
                  _loc13_[OFFSET_X] = param1.getIntAt(_loc2_);
                  _loc2_++;
                  if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_INT)
                  {
                     throw new Error("Failed to read the y offset of the trigger: " + _loc2_);
                  }
                  _loc13_[OFFSET_Y] = param1.getIntAt(_loc2_);
                  _loc2_++;
                  if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_RAWBYTES)
                  {
                     throw new Error("Failed to read the polygon data at index " + _loc2_);
                  }
                  _loc14_ = param1.getByteArrayAt(_loc2_);
                  if(_loc14_.length % 8 != 0)
                  {
                     throw new Error("The size of the polygon chunk at index " + _loc2_ + " is incorrect " + _loc14_.length);
                  }
                  _loc15_ = new Array();
                  _loc14_.position = 0;
                  _loc16_ = _loc14_.length / 8;
                  _loc17_ = 0;
                  while(_loc17_ < _loc16_)
                  {
                     _loc18_ = new Point();
                     _loc18_.x = _loc14_.readInt();
                     _loc18_.y = _loc14_.readInt();
                     _loc15_.push(_loc18_);
                     _loc17_++;
                  }
                  _loc13_[POLYGON] = _loc15_;
                  _loc2_++;
                  break;
               case BLOCK_TYPE_IMAGE:
                  if(!_loc9_)
                  {
                     _loc9_ = new Object();
                  }
                  if(_loc9_[_loc11_])
                  {
                     throw new Error("Duplicate image label(" + _loc11_ + ") found at index " + _loc2_);
                  }
                  if(param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_ARGB32 && param1.getTypeAt(_loc2_) != MediaContainerDecoder.TYPE_BITMAP)
                  {
                     throw new Error("Failed to read the lightmap at index " + _loc2_);
                  }
                  _loc9_[_loc11_] = param1.getBitmapDataAt(_loc2_);
                  _loc2_++;
                  break;
               default:
                  break loop0;
            }
            _loc12_++;
         }
         throw new Error("Unrecognized block type at index " + _loc2_ + " :" + _loc10_);
      }
      
      public static function gripToASCII(param1:BitmapData) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:* = "--------------------------------------------------\n";
         if(param1)
         {
            _loc3_ = param1.width;
            _loc4_ = param1.height;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc3_)
               {
                  if((param1.getPixel32(_loc6_,_loc5_) & 4278190080) != 0)
                  {
                     _loc2_ = _loc2_ + "1";
                  }
                  else
                  {
                     _loc2_ = _loc2_ + "0";
                  }
                  _loc6_++;
               }
               _loc2_ = _loc2_ + "\n";
               _loc5_++;
            }
         }
         else
         {
            _loc2_ = _loc2_ + "*** grip data is null ***\n";
         }
         _loc2_ = _loc2_ + "--------------------------------------------------";
         return _loc2_;
      }
   }
}
