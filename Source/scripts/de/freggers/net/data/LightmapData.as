package de.freggers.net.data
{
   import de.freggers.net.UtfMessage;
   
   public final class LightmapData
   {
       
      
      public var context:String;
      
      public var label:String;
      
      public var durations:Array;
      
      public var intensities:Array;
      
      public var loops:int;
      
      public var mode:uint;
      
      public function LightmapData(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      public static function fromUtfMessage(param1:UtfMessage) : LightmapData
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:LightmapData = new LightmapData(param1);
         return _loc2_;
      }
      
      private function init(param1:UtfMessage) : void
      {
         this.context = param1.get_string_arg(0);
         this.label = param1.get_string_arg(1);
         var _loc2_:Array = param1.get_int_list_arg(2);
         if(_loc2_.length > 1 && _loc2_.length % 2 != 0)
         {
            return;
         }
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         if(_loc2_.length == 1)
         {
            _loc4_.push(_loc2_[0]);
            _loc3_.push(0);
         }
         else
         {
            while(_loc2_.length > 0)
            {
               _loc4_.push(_loc2_.shift());
               _loc3_.push(_loc2_.shift());
            }
         }
         this.durations = _loc3_;
         this.intensities = _loc4_;
         if(param1.get_arg_count() == 4)
         {
            this.loops = param1.get_int_list_arg(3)[0];
            this.mode = param1.get_int_list_arg(3)[1];
         }
         else
         {
            this.loops = 1;
            this.mode = 0;
         }
      }
   }
}
