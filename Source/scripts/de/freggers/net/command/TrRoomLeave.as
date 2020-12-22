package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   
   public final class TrRoomLeave extends Cmd
   {
       
      
      public var wobId:int;
      
      public var userId:int;
      
      public function TrRoomLeave(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         this.wobId = param1.get_int_list_arg(1)[0];
         this.userId = param1.get_int_list_arg(1)[1];
      }
   }
}
