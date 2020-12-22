package de.freggers.net.data
{
   import de.freggers.net.UtfMessage;
   
   public final class GhosttrailData
   {
       
      
      public var updateInterval:uint;
      
      public var duration:uint;
      
      public var steps:uint;
      
      public var mode:uint;
      
      public var color:uint;
      
      public var blur:Number;
      
      public var startAlpha:Number;
      
      public var endAlpha:Number;
      
      public function GhosttrailData(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      public static function fromUtfMessage(param1:UtfMessage) : GhosttrailData
      {
         if(param1 == null)
         {
            return null;
         }
         return new GhosttrailData(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         var _loc2_:Array = param1.get_int_list_arg(0);
         this.updateInterval = _loc2_[0];
         this.duration = _loc2_[1];
         this.steps = _loc2_[2];
         _loc2_ = param1.get_int_list_arg(1);
         this.mode = _loc2_[0];
         this.color = _loc2_[1];
         this.blur = _loc2_[2];
         _loc2_ = param1.get_int_list_arg(2);
         this.startAlpha = _loc2_[0] / 100;
         this.endAlpha = _loc2_[1] / 100;
      }
   }
}
