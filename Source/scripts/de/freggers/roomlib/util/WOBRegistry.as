package de.freggers.roomlib.util
{
   import de.freggers.roomlib.IsoItem;
   import de.freggers.roomlib.IsoObject;
   import de.freggers.roomlib.IsoObjectContainer;
   import de.freggers.roomlib.Player;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class WOBRegistry
   {
      
      private static var _instance:WOBRegistry = null;
       
      
      private var worldObjects:Dictionary;
      
      private var players:Dictionary;
      
      private var playersByUId:Dictionary;
      
      private var isoItems:Array;
      
      private var playerIds:Array;
      
      public function WOBRegistry(param1:SingletonEnforcer#23)
      {
         super();
         if(getQualifiedClassName(this) != "de.freggers.roomlib.util::WOBRegistry")
         {
            throw new Error("Invalid singleton access. Use WOBRegistry.getInstance() instead");
         }
         this.clear();
      }
      
      public static function get instance() : WOBRegistry
      {
         if(_instance == null)
         {
            _instance = new WOBRegistry(new SingletonEnforcer#23());
         }
         return _instance;
      }
      
      private static function addToArray(param1:Array, param2:Object) : void
      {
         var _loc3_:int = 0;
         if(!param1 || !param2)
         {
            return;
         }
         if(param1.indexOf(param2) < 0)
         {
            _loc3_ = param1.indexOf(null);
            if(_loc3_ < 0)
            {
               param1.push(param2);
            }
            else
            {
               param1[_loc3_] = param2;
            }
         }
      }
      
      private static function removeFromArray(param1:Array, param2:Object) : void
      {
         var _loc3_:int = param1.indexOf(param2);
         if(_loc3_ >= 0)
         {
            param1[_loc3_] = null;
         }
      }
      
      private static function filterNullEntries(param1:*, param2:int, param3:Array) : Boolean
      {
         return param1 != null;
      }
      
      public function add(param1:IsoObjectContainer) : void
      {
         var _loc2_:int = 0;
         this.worldObjects[param1.wobId] = param1;
         if(param1 is Player)
         {
            this.players[(param1 as Player).name] = param1;
            this.playersByUId[(param1 as Player).userid] = param1;
            addToArray(this.playerIds,param1.wobId);
         }
         else if(param1 is IsoItem)
         {
            addToArray(this.isoItems,param1);
         }
      }
      
      public function remove(param1:IsoObjectContainer) : void
      {
         delete this.worldObjects[param1.wobId];
         if(param1 is Player)
         {
            delete this.players[(param1 as Player).name];
            delete this.playersByUId[(param1 as Player).userid];
            removeFromArray(this.playerIds,param1.wobId);
         }
         else if(param1 is IsoItem)
         {
            removeFromArray(this.isoItems,param1);
         }
      }
      
      public function getObjectByWobID(param1:int) : IsoObjectContainer
      {
         return this.worldObjects[param1];
      }
      
      public function getPlayerByWobId(param1:int) : Player
      {
         var _loc2_:IsoObjectContainer = this.getObjectByWobID(param1);
         if(!_loc2_ || !_loc2_ is Player)
         {
            return null;
         }
         return _loc2_ as Player;
      }
      
      public function getIsoItemByWobId(param1:int) : IsoItem
      {
         var _loc2_:IsoObjectContainer = this.getObjectByWobID(param1);
         if(!_loc2_ || !_loc2_ is IsoItem)
         {
            return null;
         }
         return _loc2_ as IsoItem;
      }
      
      public function getPlayerByName(param1:String) : Player
      {
         return this.players[param1];
      }
      
      public function getPlayerByUId(param1:uint) : Player
      {
         return this.playersByUId[param1];
      }
      
      public function getByIsoObject(param1:IsoObject) : IsoObjectContainer
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.worldObjects)
         {
            if((this.worldObjects[_loc2_] as IsoObjectContainer).isoobj == param1)
            {
               return this.worldObjects[_loc2_];
            }
         }
         return null;
      }
      
      public function getIsoItems() : Array
      {
         return this.isoItems.filter(filterNullEntries);
      }
      
      public function getPlayerIds() : Array
      {
         return this.playerIds.filter(filterNullEntries);
      }
      
      public function getWobIds() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for(_loc2_ in this.worldObjects)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function clear() : void
      {
         this.worldObjects = new Dictionary();
         this.players = new Dictionary();
         this.playersByUId = new Dictionary();
         this.isoItems = new Array();
         this.playerIds = new Array();
      }
   }
}

class SingletonEnforcer#23
{
    
   
   function SingletonEnforcer#23()
   {
      super();
   }
}
