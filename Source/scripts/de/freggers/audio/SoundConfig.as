package de.freggers.audio
{
   import flash.media.Sound;
   
   public class SoundConfig
   {
      
      public static const LOOP_MODE_NORMAL:uint = 0;
      
      public static const LOOP_MODE_RANDOM:uint = 1;
      
      public static const DEFAULT_RANGE:uint = 100;
       
      
      public var loopMode:uint = 0;
      
      public var minDelay:uint = 0;
      
      public var maxDelay:uint = 0;
      
      public var volume:Number = 1;
      
      public var loopCount:int = 1;
      
      public var startPosition:Number = 0;
      
      public var fadeInTime:Number = 0;
      
      public var sound:Sound;
      
      public var range:uint = 100;
      
      public function SoundConfig()
      {
         super();
      }
   }
}
