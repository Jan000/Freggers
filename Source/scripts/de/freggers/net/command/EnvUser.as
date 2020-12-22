package de.freggers.net.command
{
   import de.freggers.net.UtfMessage;
   import de.freggers.net.data.AvatarData;
   
   public final class EnvUser extends ListCmd
   {
      
      private static const START_LIST:int = 2;
       
      
      private var _avatarList:Array;
      
      private var _complete:Boolean;
      
      public function EnvUser()
      {
         super();
         this._avatarList = new Array();
         this._complete = false;
      }
      
      override public function feed(param1:UtfMessage) : void
      {
         var _loc4_:UtfMessage = null;
         var _loc2_:int = param1.get_int_list_arg(0)[2];
         if((_loc2_ & 1) != 0)
         {
            this._avatarList = new Array();
         }
         var _loc3_:int = START_LIST;
         while(_loc3_ < param1.get_arg_count())
         {
            _loc4_ = param1.get_message_arg(_loc3_) as UtfMessage;
            this._avatarList.push(new AvatarData(_loc4_));
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
         return this._avatarList;
      }
   }
}
