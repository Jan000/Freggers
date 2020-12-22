package de.freggers.roomdisplay.shop
{
   public class ShopItem
   {
      
      public static const KEY_NAME:String = "name";
      
      public static const KEY_DESCRIPTON:String = "description";
      
      public static const KEY_ICON_URL:String = "icon_url";
      
      public static const KEY_PRICE:String = "price";
      
      public static const KEY_BASE_PRICE:String = "base_price";
      
      public static const KEY_ROOM_LABEL:String = "room_label";
      
      public static const KEY_SHOP_NAME:String = "shop_name";
      
      public static const REQUIRED_KEYS:Array = [KEY_NAME,KEY_DESCRIPTON,KEY_ICON_URL,KEY_BASE_PRICE,KEY_PRICE,KEY_SHOP_NAME];
       
      
      public var label:String;
      
      public var name:String;
      
      public var description:String;
      
      public var iconUrl:String;
      
      public var price:uint;
      
      public var base_price:uint;
      
      public var room_label:String;
      
      public var shop_name:String;
      
      public function ShopItem(param1:String, param2:String, param3:String, param4:String, param5:uint, param6:uint, param7:String, param8:String = null)
      {
         super();
         this.label = param1;
         this.name = param2;
         this.description = param3;
         this.iconUrl = param4;
         this.price = param6;
         this.base_price = param5;
         this.room_label = param8;
         this.shop_name = param7;
      }
      
      public static function createFromData(param1:String, param2:Object) : ShopItem
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < REQUIRED_KEYS.length)
         {
            if(param2[REQUIRED_KEYS[_loc3_]] == null)
            {
               throw new Error("Required shop item info at position " + _loc3_ + " is missing!");
            }
            _loc3_++;
         }
         return new ShopItem(param1,param2[KEY_NAME],param2[KEY_DESCRIPTON],param2[KEY_ICON_URL],param2[KEY_BASE_PRICE],param2[KEY_PRICE],param2[KEY_SHOP_NAME],param2[KEY_ROOM_LABEL]);
      }
   }
}
