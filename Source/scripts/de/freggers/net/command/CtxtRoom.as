package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   import de.freggers.net.data.SoundBlock;
   
   public final class CtxtRoom extends Cmd
   {
       
      
      public var roomContextLabel:String;
      
      public var roomGui:String;
      
      public var desc:String;
      
      public var sounds:Array;
      
      public var brightness:int;
      
      public var wobId:int;
      
      public var topic:String;
      
      public var showAnimation:Boolean;
      
      public var ownerUserId:int;
      
      public var ownerUserName:String;
      
      public var userOwnsRoom:Boolean;
      
      public function CtxtRoom(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         this.roomContextLabel = param1.get_string_arg(1);
         this.roomGui = param1.get_string_arg(2);
         this.desc = param1.get_string_arg(3);
         this.sounds = SoundBlock.listFromUtfMessage(param1.get_message_arg(4) as UtfMessage);
         this.brightness = param1.get_int_list_arg(5)[0];
         this.wobId = param1.get_int_list_arg(5)[1];
         this.topic = param1.get_string_arg(6);
         this.showAnimation = param1.get_boolean_arg(7);
         this.userOwnsRoom = param1.get_boolean_arg(8);
         if(param1.get_arg_count() > 10)
         {
            this.ownerUserId = param1.get_int_arg(9);
            this.ownerUserName = param1.get_string_arg(10);
         }
         else
         {
            this.ownerUserId = 0;
            this.ownerUserName = null;
         }
      }
   }
}
