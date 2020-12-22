package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   import de.freggers.net.data.ItemData;
   
   public final class EnvItem extends ListCmd
   {
      
      private static const START_LIST:int = 1;
       
      
      public var add:Boolean;
      
      private var _itemList:Array;
      
      private var _complete:Boolean;
      
      public function EnvItem()
      {
         super();
         this._itemList = new Array();
         this._complete = false;
      }
      
      override public function feed(param1:UtfMessage) : void
      {
         var _loc4_:UtfMessage = null;
         this.add = param1.get_int_list_arg(0)[3] == 0;
         var _loc2_:int = param1.get_int_list_arg(0)[2];
         if((_loc2_ & 1) != 0)
         {
            this._itemList = new Array();
         }
         var _loc3_:int = START_LIST;
         while(_loc3_ < param1.get_arg_count())
         {
            _loc4_ = param1.get_message_arg(_loc3_) as UtfMessage;
            this._itemList.push(new ItemData(_loc4_));
            _loc3_++;
         }
         this._complete = (_loc2_ & 2) != 0;
      }
      
      override public function isComplete() : Boolean
      {
         return this._complete;
      }
      
      override public function getData() : Array
      {
         return this._itemList;
      }
   }
}
