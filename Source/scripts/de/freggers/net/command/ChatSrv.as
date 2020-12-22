package de.freggers.net.command
{
   import de.freggers.net.Client;
   import de.freggers.net.UtfMessage;
   
   public final class ChatSrv extends Cmd
   {
      
      public static const COMMAND:Array = [Client.COM_CHAT,Client.CHAT_SRV];
       
      
      public var message:String;
      
      public function ChatSrv(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      public function init(param1:UtfMessage) : void
      {
         this.message = param1.get_string_arg(1);
      }
   }
}
