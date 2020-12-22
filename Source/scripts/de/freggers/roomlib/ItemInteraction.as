package de.freggers.roomlib
{
   import de.freggers.net.Client;
   import de.freggers.ui.IGameInteractionProvider;
   
   public final class ItemInteraction
   {
      
      public static const TYPE_PRIMARY:int = 1;
      
      public static const TYPE_SECONDARY:int = 2;
      
      public static const KEY_LABEL:String = "label";
      
      public static const KEY_NAME:String = "name";
      
      public static const KEY_PRODUCES:String = "produces";
       
      
      public var label:String;
      
      public var name:String;
      
      public var produces:String;
      
      public var type:int = 1;
      
      public var callback:Function;
      
      public function ItemInteraction(param1:String, param2:String, param3:int = 1, param4:String = null)
      {
         super();
         this.label = param1;
         this.name = param2;
         this.type = param3;
         this.produces = param4;
      }
      
      public static function createFromData(param1:Object, param2:String) : ItemInteraction
      {
         var _loc3_:String = null;
         if(param1 == null)
         {
            return null;
         }
         if(param1[KEY_LABEL] == null || param1[KEY_NAME] == null)
         {
            return null;
         }
         _loc3_ = param1[KEY_LABEL];
         var _loc4_:int = _loc3_ == param2?int(TYPE_PRIMARY):int(TYPE_SECONDARY);
         return new ItemInteraction(_loc3_,param1[KEY_NAME],_loc4_,param1[KEY_PRODUCES]);
      }
      
      public static function createInteractionsFromDataList(param1:Array, param2:String) : Vector.<ItemInteraction>
      {
         var i:int = 0;
         var interaction:ItemInteraction = null;
         var dataList:Array = param1;
         var primaryInteractionLabel:String = param2;
         if(dataList == null)
         {
            return null;
         }
         var l:int = dataList.length;
         var v:Vector.<ItemInteraction> = new Vector.<ItemInteraction>(l);
         i = 0;
         while(i < l)
         {
            interaction = createFromData(dataList[i],primaryInteractionLabel);
            if(interaction != null)
            {
               interaction.callback = function(param1:Client, param2:IGameInteractionProvider, param3:ItemInteraction, param4:Array = null):void
               {
                  param1.sendItemInteraction(param2.wobId,param3.label,param4);
               };
               v[i] = interaction;
            }
            i++;
         }
         return v;
      }
      
      public function toString() : String
      {
         return "ItemInteraction[label=" + this.label + ", name=" + this.name + "]";
      }
   }
}
