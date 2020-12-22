package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   
   public final class MayVote extends ListCmd
   {
       
      
      public var voteCount:int = 0;
      
      public var mayVote:Boolean = false;
      
      public function MayVote(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         this.mayVote = param1.get_boolean_arg(1);
         this.voteCount = param1.get_int_arg(2);
      }
   }
}
