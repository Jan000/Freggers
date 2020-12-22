package de.freggers.notify.events
{
   public final class WalkToRoomEvent extends RequestActionEvent
   {
       
      
      private var _room_label:String;
      
      public function WalkToRoomEvent(param1:String, param2:String)
      {
         super(param1);
         this._room_label = param2;
      }
      
      public function get room_label() : String
      {
         return this._room_label;
      }
   }
}
