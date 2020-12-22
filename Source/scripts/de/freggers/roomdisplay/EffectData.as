package de.freggers.roomdisplay
{
   import de.freggers.isostar.IsoEffectConfig;
   import de.freggers.isostar.IsoSpriteEffect;
   
   public class EffectData extends de.freggers.net.data.EffectData
   {
       
      
      public var onCompleteCallback:Function;
      
      public var effectId:int;
      
      public var loop:Boolean;
      
      public var userData;
      
      public function EffectData(param1:String, param2:uint, param3:uint, param4:Boolean = false)
      {
         super(null);
         this.gui = param1;
         this.duration = param2;
         this.loop = param4;
         this.updateInterval = param3;
      }
      
      public static function fromNetEffectData(param1:de.freggers.net.data.EffectData) : de.freggers.roomdisplay.EffectData
      {
         if(param1 == null)
         {
            return null;
         }
         return new de.freggers.roomdisplay.EffectData(param1.gui,param1.duration,param1.updateInterval);
      }
      
      public function createConfig() : IsoEffectConfig
      {
         var _loc1_:IsoEffectConfig = new IsoEffectConfig(duration,updateInterval);
         _loc1_.onCompleteCallback = this.onCompleteCallback;
         _loc1_.effectId = this.effectId;
         _loc1_.userData = this.userData;
         if(this.loop)
         {
            _loc1_.loop(IsoSpriteEffect.LOOP_TYPE_NORMAL);
         }
         return _loc1_;
      }
   }
}
