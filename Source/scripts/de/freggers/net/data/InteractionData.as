package de.freggers.net.data
{
   import de.freggers.net.IUtfMessage;
   import de.freggers.net.UtfMessage;
   
   public final class InteractionData
   {
       
      
      public var _data:Array;
      
      public function InteractionData(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      public static function fromUtfMessage(param1:UtfMessage) : InteractionData
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1.get_arg_count() == 0)
         {
         }
         return new InteractionData(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         var _loc3_:int = 0;
         var _loc4_:IUtfMessage = null;
         this._data = null;
         var _loc2_:int = param1.get_arg_count();
         if(_loc2_ == 0)
         {
            return;
         }
         var _loc5_:Array = new Array(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.get_message_arg(_loc3_);
            _loc5_[_loc3_] = {
               "label":_loc4_.get_string_arg(0),
               "name":_loc4_.get_string_arg(1),
               "produces":_loc4_.get_string_arg(2)
            };
            _loc3_++;
         }
         if(_loc5_.length == 0)
         {
            return;
         }
         this._data = _loc5_;
      }
      
      public function getData() : Array
      {
         return this._data;
      }
   }
}
