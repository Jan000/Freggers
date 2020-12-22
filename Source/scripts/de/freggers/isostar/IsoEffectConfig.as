package de.freggers.isostar
{
   public class IsoEffectConfig
   {
       
      
      public var duration:uint;
      
      public var updateInterval:uint;
      
      public var loopMode:uint;
      
      public var loopIntervalMax:uint;
      
      public var loopIntervalMin:uint;
      
      public var onCompleteCallback:Function;
      
      public var effectId:int;
      
      public var userData;
      
      public function IsoEffectConfig(param1:uint, param2:uint)
      {
         super();
         this.duration = param1;
         this.updateInterval = param2;
      }
      
      public function loop(param1:uint, param2:uint = 0, param3:uint = 0) : IsoEffectConfig
      {
         this.loopMode = param1;
         this.loopIntervalMax = param2;
         this.loopIntervalMin = this.loopIntervalMin;
         return this;
      }
   }
}
