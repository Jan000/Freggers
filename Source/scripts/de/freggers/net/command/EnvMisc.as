package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   import de.freggers.net.data.SoundBlock;
   
   public final class EnvMisc extends Cmd
   {
       
      
      public var sounds:Array;
      
      public function EnvMisc(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         this.sounds = SoundBlock.listFromUtfMessage(param1.get_message_arg(1) as UtfMessage);
      }
   }
}
