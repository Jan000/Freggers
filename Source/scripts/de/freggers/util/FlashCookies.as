package de.freggers.util
{
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   
   public class FlashCookies
   {
      
      public static const COOKIE_STORE_ID:String = "freggers.cookie";
      
      public static const KEY_KICKED:String = "kick";
      
      public static const KEY_ITEMS_SEEN:String = "itemsSeen";
      
      public static const KEY_ITEMS_SEEN_KEY:String = "itemsSeenKey";
      
      public static const KEY_ENABLE_MUSIC:String = "enableMusic";
      
      public static const KEY_ENABLE_EFFECTS:String = "enableEffects";
      
      public static const KEY_OPTIONS_VISIBLE:String = "optionsVisible";
      
      public static const KICK_EXPIRE:Number = 3600000;
       
      
      private var pendingStoreids:Array;
      
      private var storeid:String;
      
      public var onFlushError:Function;
      
      public var onFlushPending:Function;
      
      public var onFlush:Function;
      
      public var onFlushDenied:Function;
      
      public function FlashCookies(param1:String = "freggers.cookie")
      {
         super();
         this.storeid = param1;
         this.pendingStoreids = new Array();
      }
      
      public function setCookie(param1:String, param2:Object, param3:Number = 0, param4:Boolean = false) : void
      {
         var _loc5_:SharedObject = SharedObject.getLocal(this.storeid,"/");
         if(param2 != null)
         {
            _loc5_.data[param1 + "_c"] = param2;
            if(param3 > 0)
            {
               _loc5_.data[param1 + "_e"] = param3;
            }
         }
         else
         {
            delete _loc5_.data[param1 + "_c"];
            delete _loc5_.data[param1 + "_e"];
         }
         if(param4)
         {
            this.flush(param1);
         }
      }
      
      public function flush(param1:String = null) : Boolean
      {
         var cookieID:String = param1;
         var store:SharedObject = SharedObject.getLocal(this.storeid,"/");
         var flushStatus:String = null;
         try
         {
            flushStatus = store.flush(10000);
         }
         catch(error:Error)
         {
            if(onFlushError != null)
            {
               try
               {
                  onFlushError(cookieID);
               }
               catch(e:ArgumentError)
               {
               }
            }
         }
         if(flushStatus != null)
         {
            switch(flushStatus)
            {
               case SharedObjectFlushStatus.PENDING:
                  this.pendingStoreids.push(cookieID);
                  store.addEventListener(NetStatusEvent.NET_STATUS,this.handleFlushStatus);
                  if(this.onFlushPending != null)
                  {
                     try
                     {
                        this.onFlushPending(cookieID);
                     }
                     catch(e:ArgumentError)
                     {
                     }
                  }
                  break;
               case SharedObjectFlushStatus.FLUSHED:
                  if(this.onFlush != null)
                  {
                     try
                     {
                        this.onFlush(cookieID);
                     }
                     catch(e:ArgumentError)
                     {
                     }
                  }
            }
            return true;
         }
         return false;
      }
      
      public function removeCookie(param1:String) : void
      {
         this.setCookie(param1,null);
      }
      
      public function getCookie(param1:String) : Object
      {
         var _loc2_:SharedObject = SharedObject.getLocal(this.storeid,"/");
         if(_loc2_.data[param1 + "_c"] != null)
         {
            if(_loc2_.data[param1 + "_e"] && Number(_loc2_.data[param1 + "_e"]) <= new Date().valueOf())
            {
               this.removeCookie(param1);
               return null;
            }
            return _loc2_.data[param1 + "_c"];
         }
         return null;
      }
      
      public function getCookieWithDefault(param1:String, param2:Object) : Object
      {
         var _loc3_:Object = this.getCookie(param1);
         if(_loc3_ == null)
         {
            return param2;
         }
         return _loc3_;
      }
      
      private function handleFlushStatus(param1:NetStatusEvent) : void
      {
         var callback:Function = null;
         var pendingStoreid:String = null;
         var event:NetStatusEvent = param1;
         var arr:Array = this.pendingStoreids.concat();
         this.pendingStoreids.length = 0;
         var store:SharedObject = event.currentTarget as SharedObject;
         switch(event.info.code)
         {
            case "SharedObject.Flush.Success":
               callback = this.onFlush;
               break;
            case "SharedObject.Flush.Failed":
               callback = this.onFlushDenied;
         }
         var i:uint = 0;
         while(i < arr.length)
         {
            pendingStoreid = arr[i] as String;
            if(callback != null)
            {
               try
               {
                  callback(pendingStoreid);
               }
               catch(e:ArgumentError)
               {
               }
            }
            i++;
         }
         store.removeEventListener(NetStatusEvent.NET_STATUS,this.handleFlushStatus);
      }
   }
}
