package de.freggers.roomdisplay.ui
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class LayerManager extends Sprite
   {
      
      public static const LAYER_CLICKTHROUGHT:String = "clickthrough";
      
      public static const LAYER_ISO_ENGINE:String = "iso engine";
      
      public static const LAYER_ROOM_BANNER:String = "room banner";
      
      public static const LAYER_MESSAGES:String = "messages";
      
      public static const LAYER_LEVEL_PROGRESS:String = "level progress";
      
      public static const LAYER_CONTROLS:String = "controls";
      
      public static const LAYER_ITEM_MENU:String = "item menu";
      
      public static const LAYER_POPUPS:String = "popups";
      
      public static const LAYER_CENTERED_MESSAGES:String = "centered messages";
      
      public static const LAYER_TOOLTIPS:String = "tooltips";
      
      public static const LAYER_METRO_MAP:String = "metro map";
      
      public static const LAYER_METRO_ANIM:String = "metro anim";
      
      public static const LAYER_ROOM_HOP_MAP:String = "room hop map";
      
      public static const LAYER_MESSAGE_DIALOG:String = "message dialog";
      
      public static const LAYER_DEBUGGER:String = "debugger";
      
      public static const LAYER_MOUSE_POINTER:String = "mouse pointer";
      
      public static const LAYER_LOADER_SCREEN:String = "loader screen";
      
      public static const LAYER_ICON_DROP:String = "icon drop";
      
      private static const LAYERS:Array = [LAYER_CLICKTHROUGHT,LAYER_ISO_ENGINE,LAYER_ROOM_BANNER,LAYER_LEVEL_PROGRESS,LAYER_MESSAGES,LAYER_ITEM_MENU,LAYER_TOOLTIPS,LAYER_CONTROLS,LAYER_ICON_DROP,LAYER_POPUPS,LAYER_CENTERED_MESSAGES,LAYER_METRO_MAP,LAYER_ROOM_HOP_MAP,LAYER_DEBUGGER,LAYER_MOUSE_POINTER,LAYER_LOADER_SCREEN,LAYER_METRO_ANIM,LAYER_MESSAGE_DIALOG];
       
      
      public function LayerManager()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc2_:Sprite = null;
         this.mouseEnabled = false;
         var _loc1_:int = 0;
         while(_loc1_ < LAYERS.length)
         {
            _loc2_ = new Sprite();
            _loc2_.mouseEnabled = false;
            _loc2_.name = LAYERS[_loc1_];
            super.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      public function addLayerContent(param1:String, param2:DisplayObject) : void
      {
         var _loc3_:Sprite = null;
         if(LAYERS.indexOf(param1) >= 0)
         {
            _loc3_ = getChildByName(param1) as Sprite;
            _loc3_.addChild(param2);
         }
      }
      
      public function removeLayerContent(param1:String, param2:DisplayObject) : void
      {
         var _loc3_:Sprite = null;
         if(LAYERS.indexOf(param1) >= 0)
         {
            _loc3_ = getChildByName(param1) as Sprite;
            if(param2.parent == _loc3_)
            {
               _loc3_.removeChild(param2);
            }
         }
      }
      
      public function getLayer(param1:String) : Sprite
      {
         if(LAYERS.indexOf(param1) >= 0)
         {
            return getChildByName(param1) as Sprite;
         }
         return null;
      }
      
      public function clearLayer(param1:String) : void
      {
         var _loc2_:Sprite = null;
         if(LAYERS.indexOf(param1) >= 0)
         {
            _loc2_ = getChildByName(param1) as Sprite;
            while(_loc2_.numChildren > 0)
            {
               _loc2_.removeChildAt(0);
            }
         }
      }
   }
}
