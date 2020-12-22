package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   
   public class ListCmd extends Cmd
   {
       
      
      public function ListCmd()
      {
         super();
      }
      
      public function feed(param1:UtfMessage) : void
      {
      }
      
      public function isComplete() : Boolean
      {
         return false;
      }
      
      public function getData() : Array
      {
         return null;
      }
   }
}
