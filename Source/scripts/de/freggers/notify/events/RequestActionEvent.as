package de.freggers.notify.events
{
   import de.freggers.notify.NotifyElement;
   import flash.events.Event;
   
   public class RequestActionEvent extends Event
   {
      
      public static const EXECUTE:String = "executeRequestedAction";
       
      
      public var notifyElement:NotifyElement;
      
      public function RequestActionEvent(param1:String)
      {
         super(param1,true,true);
      }
   }
}
