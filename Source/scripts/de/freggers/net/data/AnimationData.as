package de.freggers.net.data
{
   import de.freggers.net.UtfMessage;
   
   public final class AnimationData
   {
      
      private static const ANIM_KEYVAL_PLAY:int = 1;
      
      private static const ANIM_KEYVAL_MODE:int = 2;
      
      private static const ANIM_KEYVAL_MILLIS:int = 3;
      
      public static const ANIM_KEY_PLAY:String = "play";
      
      public static const ANIM_KEY_MODE:String = "mode";
      
      public static const ANIM_KEY_MILLIS:String = "millis";
       
      
      public var name:String;
      
      public var keys:Array;
      
      public var datapack:String;
      
      public function AnimationData(param1:UtfMessage)
      {
         super();
         this.init(param1);
      }
      
      public static function fromUtfMessage(param1:UtfMessage) : AnimationData
      {
         if(param1 == null)
         {
            return null;
         }
         return new AnimationData(param1);
      }
      
      private function init(param1:UtfMessage) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc2_:Object = new Object();
         this.name = param1.get_string_arg(0);
         this.datapack = param1.get_string_arg(1);
         var _loc3_:int = (param1.get_arg_count() - 2) / 2;
         var _loc4_:Array = new Array();
         var _loc7_:int = 0;
         for(; _loc7_ < _loc3_; _loc7_++)
         {
            _loc5_ = param1.get_int_list_arg(_loc7_ * 2 + 2);
            if(_loc5_)
            {
               _loc6_ = new Object();
               switch(_loc5_[0])
               {
                  case ANIM_KEYVAL_PLAY:
                     _loc6_["name"] = ANIM_KEY_PLAY;
                     _loc6_["data"] = param1.get_int_list_arg(_loc7_ * 2 + 3);
                     break;
                  case ANIM_KEYVAL_MODE:
                     _loc6_["name"] = ANIM_KEY_MODE;
                     _loc6_["modifier"] = _loc5_[1];
                     _loc6_["data"] = param1.get_int_arg(_loc7_ * 2 + 3);
                     break;
                  case ANIM_KEYVAL_MILLIS:
                     _loc6_["name"] = ANIM_KEY_MILLIS;
                     _loc6_["data"] = param1.get_int_arg(_loc7_ * 2 + 3);
                     break;
                  default:
                     continue;
               }
               _loc4_.push(_loc6_);
            }
         }
         this.keys = _loc4_;
      }
   }
}
