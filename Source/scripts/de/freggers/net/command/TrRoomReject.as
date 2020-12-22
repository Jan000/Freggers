package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   
   public final class TrRoomReject extends Cmd
   {
       
      
      public var reason:int;
      
      public function TrRoomReject(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      public function init(param1:UtfMessage) : void
      {
         this.reason = param1.get_int_arg(1);
      }
   }
}
