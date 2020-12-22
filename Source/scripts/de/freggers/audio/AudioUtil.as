package de.freggers.audio
{
   import flash.geom.Vector3D;
   
   public final class AudioUtil
   {
      
      public static const MAX_CHANNELS:uint = 32;
       
      
      public function AudioUtil()
      {
         super();
      }
      
      public static function clampVolume(param1:Number) : Number
      {
         if(param1 < 0)
         {
            return 0;
         }
         if(param1 > 1)
         {
            return 1;
         }
         return param1;
      }
      
      public static function clampPanning(param1:Number) : Number
      {
         if(param1 < -1)
         {
            return -1;
         }
         if(param1 > 1)
         {
            return 1;
         }
         return param1;
      }
      
      public static function updatePositionalConfig(param1:Vector3D, param2:Vector3D, param3:PositionalConfig) : void
      {
         param3.distance = param1.subtract(param2).length;
         param3.panDistance = (param1.x - param1.y) / 2 - (param2.x - param2.y) / 2;
      }
   }
}
