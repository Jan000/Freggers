package de.freggers.roomdisplay
{
   import flash.events.Event;
   
   public class ControlsEvent extends Event
   {
      
      public static const COMPOSING_START:String = "composingStart";
      
      public static const COMPOSING_IDLE:String = "composingIdle";
      
      public static const COMPOSING_STOP:String = "composingStop";
      
      public static const INPUT_COMPLETE:String = "inputComplete";
      
      public static const EFFECTS_ACTIVATE:String = "effectsActivate";
      
      public static const EFFECTS_DEACTIVATE:String = "effectsDeactivate";
      
      public static const SOUND_ACTIVATE:String = "soundActivate";
      
      public static const SOUND_DEACTIVATE:String = "soundDectivate";
      
      public static const OPTIONS_SHOW:String = "optionsShow";
      
      public static const OPTIONS_HIDE:String = "optionsHide";
      
      public static const INV_CLICK:String = "invOpen";
      
      public static const HOME_CLICK:String = "homeOpen";
      
      public static const METROPLAN_CLICK:String = "metroplanOpen";
      
      public static const CRAFTING_ICON_CLICK:String = "craftingIconClick";
      
      public static const HELPER_ICON_CLICK:String = "helperIconClick";
      
      public static const SHOPPING_CLICK:String = "shoppingIconClick";
       
      
      public function ControlsEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
