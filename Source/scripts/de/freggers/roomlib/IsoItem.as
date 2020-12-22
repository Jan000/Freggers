package de.freggers.roomlib
{
   import de.freggers.net.ItemProperties;
   import de.freggers.net.data.InteractionData;
   import de.freggers.net.data.ItemData;
   
   public class IsoItem extends IsoObjectContainer
   {
       
      
      public function IsoItem(param1:int, param2:ItemProperties)
      {
         super(param1);
         this.init(param2);
      }
      
      public static function createFromData(param1:ItemData) : IsoItem
      {
         if(!param1 || !param1.wobId || !param1.gui)
         {
            return null;
         }
         var _loc2_:IsoItem = new IsoItem(param1.wobId,param1.properties);
         _loc2_.gui = param1.gui;
         _loc2_.name = param1.name;
         if(param1.interactions.getData() != null)
         {
            createInteractionMenu(_loc2_,param1.interactions,param1.primaryInteractionLabel);
         }
         return _loc2_;
      }
      
      public static function createInteractionMenu(param1:IsoItem, param2:InteractionData, param3:String) : void
      {
         param1._interactions = ItemInteraction.createInteractionsFromDataList(param2.getData(),param3);
      }
      
      public static function createFromMapData(param1:Object) : IsoItem
      {
         if(!param1 || !param1["wobid"] || !param1["gui"])
         {
            return null;
         }
         var _loc2_:IsoItem = new IsoItem(param1["wobid"],param1["props"]);
         _loc2_.gui = param1["gui"];
         _loc2_.name = param1["name"];
         if(param1["interactions"])
         {
            _loc2_._interactions = ItemInteraction.createInteractionsFromDataList(param1["interactions"],param1.primaryInteractionLabel);
         }
         return _loc2_;
      }
      
      private function init(param1:ItemProperties) : void
      {
         if(param1 == null)
         {
            return;
         }
         isoobj.type = param1.type;
         interactive = param1.selectable;
      }
   }
}
