package de.freggers.games
{
   import flash.display.Sprite;
   import flash.events.AsyncErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   
   public class ASinglePlayerGame extends Sprite
   {
      
      public static const FINISHED:String = "stageFinished";
      
      public static const GAMEOVER:String = "gameOver";
      
      public static const QUITGAME:String = "quitGame";
      
      public static const CHANNEL:String = "gameclient";
      
      public static const M_STAGE_ENDED:String = "_lc_stageEnded";
       
      
      private var localConnection:LocalConnection;
      
      public var id:String;
      
      public function ASinglePlayerGame()
      {
         super();
         this.localConnection = new LocalConnection();
         this.localConnection.addEventListener(StatusEvent.STATUS,this.handleStatusEvent,false,0,true);
         this.localConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError,false,0,true);
         this.localConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.handleAsyncError,false,0,true);
      }
      
      public function cleanup() : void
      {
      }
      
      protected function handleSecurityError(param1:SecurityErrorEvent) : void
      {
      }
      
      protected function handleAsyncError(param1:AsyncErrorEvent) : void
      {
      }
      
      protected function handleStatusEvent(param1:StatusEvent) : void
      {
      }
      
      public function get url() : String
      {
         if(!this.loaderInfo || !this.loaderInfo.url)
         {
            return null;
         }
         return this.loaderInfo.url;
      }
      
      protected function notifyStageEnded(param1:String, param2:String, param3:int, param4:Number) : void
      {
         if(!this.localConnection || !this.url)
         {
            return;
         }
         this.localConnection.send(CHANNEL,M_STAGE_ENDED,this.url,param1,param2,param3,param4);
      }
   }
}
