package de.freggers.util
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class SoundSwfBuilder
   {
      
      private static const SWF_HEADER_PART_1:Array = [70,87,83,9];
      
      private static const SWF_HEADER_PART_2:Array = [48,10,0,160,0,1,1,0,68,17,8,0,0,0,67,2,255,255,255,191,21,11,0,0,0,1,0,83,122,101,110,101,32,49,0,0,191,20,189,0,0,0,1,0,0,0,0,16,0,46,0,0,0,0,8,0,9,68,121,110,97,83,111,117,110,100,11,102,108,97,115,104,46,109,101,100,105,97,5,83,111,117,110,100,6,79,98,106,101,99,116,12,102,108,97,115,104,46,101,118,101,110,116,115,15,69,118,101,110,116,68,105,115,112,97,116,99,104,101,114,5,22,1,22,3,24,2,22,6,0,5,7,1,2,7,2,4,7,1,5,7,4,7,3,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,8,3,0,1,0,0,0,1,2,1,1,4,1,0,3,0,1,1,5,6,3,208,48,71,0,0,1,1,1,6,7,6,208,48,208,73,0,71,0,0,2,2,1,1,5,23,208,48,101,0,96,3,48,96,4,48,96,2,48,96,2,88,0,29,29,29,104,1,71,0,0,191,3];
      
      private static const SWF_END:Array = [63,19,14,0,0,0,1,0,1,0,68,121,110,97,83,111,117,110,100,0,68,11,38,0,0,0,64,0,0,0];
      
      public static const SOUND_CLASS_NAME:String = "DynaSound";
      
      public static const AUDIO_INFO_DEFAULT_BITS:uint = 34;
      
      public static const AUDIO_INFO_STEREO_BIT:uint = 1;
      
      public static const AUDIO_INFO_SAMLPING_RATE_44K:uint = 12;
      
      public static const SAMPLES_PER_MP3_FRAME:uint = 1152;
      
      private static const MP3_MONO_MASK:uint = 192;
      
      private static const MP3_FRAME_SYNC_BIT_MASK:uint = 65506;
      
      private static const MP3_MPEG_VERSION_MASK:uint = 24;
      
      private static const MP3_BITRATE_MASK:uint = 61440;
      
      private static const MP3_BIT_RATES:Array = [[0,32,40,48,56,64,80,96,112,128,160,192,224,256,320],[0,8,16,24,32,40,48,56,64,80,96,112,128,144,160]];
      
      private static const MP3_SAMPLERATE_MASK:uint = 3072;
      
      private static const MP3_SAMPLE_RATES:Array = [[11025,12000,8000],[0],[22050,24000,16000],[44100,48000,32000]];
      
      private static const MP3_FRAME_PADDING_BIT:uint = 512;
      
      private static const MP3_TAG_PART_1:uint = 21569;
      
      private static const MP3_TAG_PART_2:uint = 71;
       
      
      public function SoundSwfBuilder()
      {
         super();
         throw new Error("don\'t construct SoundSwfBuilder, " + "call static decodeDataBytes()");
      }
      
      public static function create(param1:ByteArray) : ByteArray
      {
         param1.endian = Endian.BIG_ENDIAN;
         var _loc2_:uint = getMp3FrameCount(param1);
         var _loc3_:uint = AUDIO_INFO_DEFAULT_BITS | AUDIO_INFO_SAMLPING_RATE_44K;
         param1.position = 2;
         var _loc4_:* = (param1.readUnsignedShort() & MP3_MONO_MASK) == MP3_MONO_MASK;
         if(!_loc4_)
         {
            _loc3_ = _loc3_ | AUDIO_INFO_STEREO_BIT;
         }
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.endian = Endian.LITTLE_ENDIAN;
         writeBytes(SWF_HEADER_PART_1,_loc5_);
         _loc5_.writeUnsignedInt(SWF_HEADER_PART_1.length + 4 + SWF_HEADER_PART_2.length + 13 + param1.length + SWF_END.length);
         writeBytes(SWF_HEADER_PART_2,_loc5_);
         _loc5_.writeUnsignedInt(param1.length + 9);
         _loc5_.writeShort(1);
         _loc5_.writeByte(_loc3_);
         _loc5_.writeUnsignedInt(_loc2_ * SAMPLES_PER_MP3_FRAME);
         _loc5_.writeShort(0);
         _loc5_.endian = Endian.BIG_ENDIAN;
         param1.position = 0;
         _loc5_.writeBytes(param1);
         writeBytes(SWF_END,_loc5_);
         return _loc5_;
      }
      
      private static function getMp3FrameCount(param1:ByteArray) : uint
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         param1.endian = Endian.BIG_ENDIAN;
         param1.position = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         while(true)
         {
            if(param1.bytesAvailable > 0)
            {
               _loc3_ = param1.readUnsignedShort();
               if((_loc3_ & MP3_FRAME_SYNC_BIT_MASK) != MP3_FRAME_SYNC_BIT_MASK)
               {
                  if(_loc3_ == MP3_TAG_PART_1)
                  {
                     _loc3_ = param1.readUnsignedByte();
                     if(_loc3_ == MP3_TAG_PART_2 && param1.bytesAvailable == 125)
                     {
                     }
                  }
                  throw new Error("Invalid mp3 frame header found at offset " + (param1.position - 2));
               }
               _loc4_ = _loc3_ & MP3_MPEG_VERSION_MASK;
               _loc3_ = param1.readUnsignedShort();
               _loc5_ = _loc3_ & MP3_BITRATE_MASK;
               if(_loc5_ == MP3_BITRATE_MASK || _loc5_ == 0)
               {
                  break;
               }
               _loc5_ = _loc5_ >> 12;
               _loc5_ = MP3_BIT_RATES[_loc4_ == MP3_MPEG_VERSION_MASK?0:1][_loc5_];
               _loc4_ = _loc4_ >> 3;
               if(_loc4_ == 1)
               {
                  throw new Error("Unknown MPEG version - not 1, 2 or 2.5");
               }
               _loc6_ = _loc3_ & MP3_SAMPLERATE_MASK;
               _loc6_ = _loc6_ >> 10;
               _loc7_ = MP3_SAMPLE_RATES[_loc4_][_loc6_];
               _loc8_ = (_loc3_ & MP3_FRAME_PADDING_BIT) == 0?uint(0):uint(1);
               _loc9_ = (_loc4_ == 3?144:72) * _loc5_ * 1000 / _loc7_ + _loc8_ - 4;
               param1.position = param1.position + _loc9_;
               _loc2_++;
               continue;
            }
            return _loc2_;
         }
         throw new Error("Invalid bit rate");
      }
      
      private static function writeBytes(param1:Array, param2:ByteArray) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            param2.writeByte(param1[_loc3_]);
            _loc3_++;
         }
      }
   }
}
