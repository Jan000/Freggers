package de.freggers.roomdisplay.ui.controlbar
{
   import caurina.transitions.Tweener;
   import de.freggers.roomdisplay.ControlsEvent;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import de.schulterklopfer.interaction.manager.InteractionManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public final class IconsDelegate
   {
      
      private static const REQUIRED_ICONS:Array = ["map","home","crafting","helper","bag","shopping"];
      
      private static const ICONS_GROUP:String = "icons_delegate_icons";
       
      
      private var _iconsView:MovieClip;
      
      private var _icons:Vector.<InteractiveObject>;
      
      private var _helperDelegate:UniversalHelperDelegate;
      
      public function IconsDelegate(param1:MovieClip)
      {
         super();
         this.init(param1);
      }
      
      public static function showHover(param1:Object, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Number = !!param2?Number(1.1):Number(1);
         var _loc5_:Number = !!param3?Number(0.3):Number(0);
         Tweener.addTween(param1,{
            "_scale":_loc4_,
            "time":_loc5_
         });
      }
      
      private function init(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc4_:MovieClip = null;
         param1.mouseEnabled = false;
         this._iconsView = param1;
         this._icons = new Vector.<InteractiveObject>(REQUIRED_ICONS.length,true);
         var _loc3_:int = REQUIRED_ICONS.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[REQUIRED_ICONS[_loc2_]];
            if(_loc4_ == null)
            {
               throw new Error("IconsDelegate: icons view failed structure test. \'" + REQUIRED_ICONS[_loc2_] + "\' is missing");
            }
            if(_loc4_ is DisplayObjectContainer)
            {
               (_loc4_ as DisplayObjectContainer).mouseChildren = false;
            }
            if(_loc4_ is Sprite)
            {
               (_loc4_ as Sprite).buttonMode = true;
            }
            this._icons[_loc2_] = _loc4_;
            if(_loc4_.name == "helper")
            {
               this._helperDelegate = new UniversalHelperDelegate(_loc4_);
            }
            InteractionManager.registerForMouse(_loc4_,this.handleMouseManagerData,ICONS_GROUP);
            _loc2_++;
         }
      }
      
      private function handleMouseManagerData(param1:MouseManagerData) : void
      {
         var _loc2_:String = null;
         if(param1.type == MouseManagerData.MOUSE_MOVE)
         {
            return;
         }
         if(!(param1.currentTarget is DisplayObject))
         {
            return;
         }
         if(param1.type == MouseManagerData.CLICK)
         {
            _loc2_ = (param1.currentTarget as DisplayObject).name;
            if(_loc2_ == "helper")
            {
               (param1.currentTarget as DisplayObject).dispatchEvent(new ControlsEvent(ControlsEvent.HELPER_ICON_CLICK));
            }
            else if(_loc2_ == "crafting")
            {
               (param1.currentTarget as DisplayObject).dispatchEvent(new ControlsEvent(ControlsEvent.CRAFTING_ICON_CLICK));
            }
            else if(_loc2_ == "map")
            {
               (param1.currentTarget as DisplayObject).dispatchEvent(new ControlsEvent(ControlsEvent.METROPLAN_CLICK));
            }
            else if(_loc2_ == "home")
            {
               (param1.currentTarget as DisplayObject).dispatchEvent(new ControlsEvent(ControlsEvent.HOME_CLICK));
            }
            else if(_loc2_ == "bag")
            {
               (param1.currentTarget as DisplayObject).dispatchEvent(new ControlsEvent(ControlsEvent.INV_CLICK));
            }
            else if(_loc2_ == "shopping")
            {
               (param1.currentTarget as DisplayObject).dispatchEvent(new ControlsEvent(ControlsEvent.SHOPPING_CLICK));
            }
            showHover(param1.currentTarget,false,false);
         }
         else if(param1.type == MouseManagerData.MOUSE_OVER)
         {
            showHover(param1.currentTarget,true,true);
         }
         else if(param1.type == MouseManagerData.MOUSE_OUT)
         {
            showHover(param1.currentTarget,false,true);
         }
      }
      
      public function get universalHelperDelegate() : UniversalHelperDelegate
      {
         return this._helperDelegate;
      }
   }
}
