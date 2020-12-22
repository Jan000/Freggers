package de.freggers.roomdisplay
{
   import flash.events.NetStatusEvent;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import flash.net.Responder;
   
   public class AmfApi
   {
      
      public static const SEND_STATS:String = "LiveStats.log";
      
      public static const GET_RENDER_PARTS:String = "Core.get_renderparts";
      
      public static const GET_DAILY_OFFER:String = "Core.get_today_offered_items";
      
      public static const GET_STICKY_COUNT:String = "Core.get_stickycount";
      
      public static const LOG:String = "Core.log";
      
      public static const HANDLE_GAME_ENDED:String = "Games.stage_ended";
      
      public static const GET_PRIMARY_ROOM_LABEL:String = "Core.get_primary_room_label";
       
      
      private var _url:String;
      
      private var _connection:NetConnection;
      
      public function AmfApi(param1:String)
      {
         super();
         this._url = param1;
         this._connection = new NetConnection();
         this._connection.objectEncoding = ObjectEncoding.AMF0;
         this._connection.addEventListener(NetStatusEvent.NET_STATUS,this.handleConnectionStatus);
      }
      
      public function connect() : void
      {
         this._connection.connect(this._url);
      }
      
      private function handleConnectionStatus(param1:NetStatusEvent) : void
      {
      }
      
      public function call(param1:String, param2:Function = null, param3:Function = null, param4:Array = null) : void
      {
         var _loc5_:Responder = null;
         if(param2 != null || param3 != null)
         {
            _loc5_ = new Responder(param2,param3);
         }
         this._connection.call.apply(this,[param1,_loc5_].concat(param4));
      }
   }
}
