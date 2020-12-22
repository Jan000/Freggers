package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   
   public final class CtxtServer extends Cmd
   {
       
      
      public var port:int;
      
      public var host:String;
      
      public function CtxtServer(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      public static function getHost(param1:Array) : String
      {
         var _loc3_:int = 0;
         if(!param1 || param1.length != 4 && param1.length != 8)
         {
            return null;
         }
         if(param1.length == 4)
         {
            return param1.join(".");
         }
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc2_ = _loc2_ + (_loc3_.toString(16) + ":");
         }
         return _loc2_.substring(0,_loc2_.length - 1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         this.port = param1.get_int_arg(1);
         var _loc2_:Array = param1.get_int_list_arg(1);
         _loc2_ = _loc2_.slice(1,_loc2_.length);
         this.host = getHost(_loc2_);
      }
   }
}
