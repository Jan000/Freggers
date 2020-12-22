package de.freggers.net.command
{
   import de.freggers.net.Client;
   import de.freggers.net.UtfMessage;
   
   public final class ChatUsr extends Cmd
   {
      
      public static const COMMAND:Array = [Client.COM_CHAT,Client.CHAT_USR];
       
      
      public var wobId:int;
      
      public var message:String;
      
      public var type:int;
      
      public var mode:int;
      
      public var overheard:Boolean;
      
      public function ChatUsr(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      public function init(param1:UtfMessage) : void
      {
         this.wobId = param1.get_int_arg(1);
         this.message = param1.get_string_arg(2);
         this.type = param1.get_int_list_arg(0)[2];
         this.mode = param1.get_arg_count() > 3?int(param1.get_int_arg(3)):int(null);
         this.overheard = param1.get_arg_count() > 4?Boolean(param1.get_boolean_arg(4)):false;
      }
   }
}
