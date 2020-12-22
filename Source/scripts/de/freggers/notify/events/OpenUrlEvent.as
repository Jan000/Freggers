package de.freggers.notify.events
{
   public final class OpenUrlEvent extends RequestActionEvent
   {
       
      
      private var _url:String;
      
      private var _targetFrame:String;
      
      public function OpenUrlEvent(param1:String, param2:String, param3:String)
      {
         super(param1);
         this._url = param2;
         this._targetFrame = param3;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get targetFrame() : String
      {
         return this._targetFrame;
      }
   }
}
