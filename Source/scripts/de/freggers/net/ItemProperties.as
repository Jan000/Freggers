package de.freggers.net
{
   public class ItemProperties
   {
      
      public static const TYPE_NONE:uint = 0;
      
      public static const TYPE_SHOP:uint = 1;
      
      public static const TYPE_DOORBELL:uint = 2;
      
      private static const FLAG_TYPE:uint = 1;
      
      private static const FLAG_NO_SELECT:uint = 2;
       
      
      public var type:uint = 0;
      
      public var selectable:Boolean = true;
      
      public function ItemProperties(param1:Array)
      {
         super();
         if(param1 == null)
         {
            return;
         }
         var _loc2_:uint = param1.shift();
         if((_loc2_ & FLAG_TYPE) != 0)
         {
            this.type = uint(param1.shift());
         }
         if((_loc2_ & FLAG_NO_SELECT) != 0)
         {
            this.selectable = int(param1.shift()) == 0;
         }
      }
   }
}
