package de.freggers.net.data
{
   import de.freggers.net.UtfMessage;
   
   public class EffectData
   {
       
      
      public var gui:String;
      
      public var duration:uint;
      
      public var updateInterval:uint;
      
      public function EffectData(param1:UtfMessage)
      {
         super();
         if(param1 == null)
         {
            return;
         }
         this.init(param1);
      }
      
      public static function fromUtfMessage(param1:UtfMessage) : EffectData
      {
         if(param1 == null)
         {
            return null;
         }
         return new EffectData(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         this.gui = param1.get_string_arg(0);
         var _loc2_:Array = param1.get_int_list_arg(1);
         this.duration = _loc2_[0];
         if(_loc2_.length == 2)
         {
            this.updateInterval = _loc2_[1];
         }
         else
         {
            this.updateInterval = 30;
         }
      }
   }
}
