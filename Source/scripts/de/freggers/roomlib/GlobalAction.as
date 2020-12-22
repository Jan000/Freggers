package de.freggers.roomlib
{
   public final class GlobalAction
   {
      
      public static const SHOW_DOORBELLS:String = "SHOW_DOORBELLS";
      
      public static const OPEN_SHOP:String = "OPEN_SHOP";
      
      public static const USE_EXIT:String = "USE_EXIT";
      
      public static const USE_HAND_CONTENT_WITH:String = "USE_HAND_CONTENT_WITH";
      
      public static const THROW_HAND_CONTENT_AT:String = "THROW_HAND_CONTENT_AT";
      
      public static const TRASH_HAND_CONTENT:String = "TRASH_HAND_CONTENT";
      
      public static const USE:String = "USE";
      
      public static const SHOW_PROFILE:String = "SHOW_PROFILE";
      
      public static const SHOW_MENU:String = "SHOW_MENU";
      
      public static const WALK:String = "WALK";
       
      
      public function GlobalAction()
      {
         super();
      }
      
      public static function interactionVector(... rest) : Vector.<ItemInteraction>
      {
         var _loc2_:int = 0;
         if(rest == null || rest.length == 0)
         {
            return null;
         }
         var _loc3_:int = rest.length;
         var _loc4_:Vector.<ItemInteraction> = new Vector.<ItemInteraction>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_[_loc2_] = new ItemInteraction(rest[_loc2_],null);
            _loc2_++;
         }
         return _loc4_;
      }
   }
}
