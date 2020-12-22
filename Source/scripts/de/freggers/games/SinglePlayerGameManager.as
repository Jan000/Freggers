package de.freggers.games
{
   import flash.net.LocalConnection;
   
   public class SinglePlayerGameManager
   {
       
      
      private var _localConnection:LocalConnection;
      
      private var _gameClient:IGameClient;
      
      private var _listening:Boolean;
      
      public function SinglePlayerGameManager(param1:IGameClient)
      {
         super();
         this._gameClient = param1;
         this.init();
      }
      
      public static function genId(param1:String) : String
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:int = param1.lastIndexOf("/");
         var _loc3_:int = param1.lastIndexOf(".");
         return param1.substring(_loc2_ + 1,_loc3_);
      }
      
      private function init() : void
      {
         this._localConnection = new LocalConnection();
         this._localConnection.client = this;
         this._localConnection.allowDomain(this._localConnection.domain);
         try
         {
            this._localConnection.connect(ASinglePlayerGame.CHANNEL);
            this._listening = true;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      public function _lc_stageEnded(param1:String, param2:String, param3:String, param4:int, param5:Number) : void
      {
         var _loc6_:String = genId(param1);
         if(this._gameClient)
         {
            this._gameClient.stageEnded(_loc6_,param2,param3,param4,param5);
         }
      }
   }
}
