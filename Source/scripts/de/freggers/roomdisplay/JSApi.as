package de.freggers.roomdisplay
{
   import flash.external.ExternalInterface;
   
   public class JSApi
   {
       
      
      public function JSApi()
      {
         super();
      }
      
      public static function showUser(param1:String) : void
      {
         callJS("showUser",param1);
      }
      
      public static function writeConsole(param1:String, param2:uint, param3:String, param4:int, param5:String, param6:String = "") : void
      {
         callJS("writeConsole",param1,param2,param3,param4,param5,param6);
      }
      
      public static function openGame(param1:String) : void
      {
         callJS("openGame",param1);
      }
      
      public static function logout(param1:String, param2:uint) : void
      {
         callJS("logout",param1,param2);
      }
      
      public static function updateBadge(param1:uint, param2:uint, param3:Boolean) : void
      {
         callJS("updateBadge",param1,param2,param3);
      }
      
      public static function showBadge(param1:uint, param2:uint) : void
      {
         callJS("showBadge",param1,param2);
      }
      
      public static function updateCredits(param1:uint, param2:uint) : void
      {
         callJS("updateCredits",param1,param2);
      }
      
      public static function showCreditsExchange() : void
      {
         callJS("showCreditsExchange");
      }
      
      public static function showCreditsBillsBuy() : void
      {
         callJS("showCreditsBillsBuy");
      }
      
      public static function updateStream() : void
      {
         callJS("updateStream");
      }
      
      public static function updateMails(param1:uint) : void
      {
         callJS("updateMails",param1);
      }
      
      public static function updatePlayer(param1:uint, param2:uint) : void
      {
         callJS("updatePlayer",param1,param2);
      }
      
      public static function onModelUpdate() : void
      {
         callJS("onModelUpdate");
      }
      
      public static function onScreenOpen() : void
      {
         callJS("onScreenOpen");
      }
      
      public static function onScreenClose() : void
      {
         callJS("onScreenClose");
      }
      
      public static function updateStuff(param1:uint) : void
      {
         callJS("updateStuff",param1);
      }
      
      public static function showStuff() : void
      {
         callJS("showStuff");
      }
      
      public static function updateItemInbox() : void
      {
         callJS("updateItemInbox");
      }
      
      public static function showRoomItem(param1:uint) : void
      {
         callJS("showRoomItem",param1);
      }
      
      public static function showShop(param1:uint) : void
      {
         callJS("showShop",param1);
      }
      
      public static function showLocker(param1:uint) : void
      {
         callJS("showLocker",param1);
      }
      
      public static function showBadges() : void
      {
         callJS("showBadges");
      }
      
      public static function showMails(param1:uint) : void
      {
         callJS("showMails",param1);
      }
      
      public static function showApartments(param1:String) : void
      {
         callJS("showApartments",param1);
      }
      
      public static function showCrafting() : void
      {
         callJS("showCrafting");
      }
      
      public static function openCraftRecipeView(param1:uint, param2:int) : void
      {
         callJS("openCraftRecipeView",param1,param2);
      }
      
      public static function openShopScreen() : void
      {
         callJS("openShopScreen");
      }
      
      public static function openHomeScreen() : void
      {
         callJS("openHomeScreen");
      }
      
      public static function openLevelUpInfoScreen() : void
      {
         callJS("openLevelUpInfoScreen");
      }
      
      public static function connectionLost() : void
      {
         callJS("connectionLost");
      }
      
      public static function updateFriendStatus(param1:uint, param2:uint) : void
      {
         callJS("updateFriendStatus",param1,param2);
      }
      
      public static function onSelectTarget(param1:*, param2:String, param3:Object) : void
      {
         callJS("onSelectTarget",param1,param2,param3);
      }
      
      public static function onCancelSelectFrom() : void
      {
         callJS("onCancelSelectFrom");
      }
      
      public static function onRoomUpdate(param1:Boolean) : void
      {
         callJS("onRoomUpdate",param1);
      }
      
      public static function onMouseFocusChanged(param1:Boolean) : void
      {
         callJS("onMouseFocusChanged",param1);
      }
      
      public static function openBuyItemView(param1:uint) : void
      {
         callJS("openBuyItemView",param1);
      }
      
      public static function openListRecipesByIngredientItemView(param1:uint) : void
      {
         callJS("openListRecipesByIngredientItemView",param1);
      }
      
      public static function showHomeConfig(param1:String) : void
      {
         callJS("showHomeConfig",param1);
      }
      
      public static function getBrowserInfo() : Object
      {
         return callJS("getBrowserInfo");
      }
      
      public static function openQuestView(param1:String) : void
      {
         callJS("openQuestView",param1);
      }
      
      public static function openQuestCompletedView(param1:String, param2:String) : void
      {
         callJS("openQuestCompletedView",param1,param2);
      }
      
      public static function openWindow(param1:String, param2:String) : void
      {
         callJS("openWindow",param1,param2);
      }
      
      public static function onRoomLoaded(param1:Boolean) : void
      {
         callJS("onRoomLoaded",param1);
      }
      
      public static function onCleanupRoom() : void
      {
         callJS("onCleanupRoom");
      }
      
      private static function callJS(param1:String, ... rest) : *
      {
         rest.unshift("Freggers." + param1);
         return ExternalInterface.call.apply(null,rest);
      }
   }
}
