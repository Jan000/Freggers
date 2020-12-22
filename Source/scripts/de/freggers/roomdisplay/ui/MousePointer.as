package de.freggers.roomdisplay.ui
{
   import caurina.transitions.Equations;
   import de.freggers.roomdisplay.JSApi;
   import de.freggers.roomdisplay.ui.mousepointer.HandContentIcon;
   import de.freggers.roomlib.GlobalAction;
   import de.freggers.roomlib.ItemInteraction;
   import de.freggers.roomlib.util.InstanceFactory;
   import de.freggers.roomlib.util.ResourceManager;
   import de.freggers.roomlib.util.ResourceRequest;
   import de.freggers.roomlib.util.StyleSheetBuilder;
   import de.freggers.ui.IGameInteractionProvider;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import flash.utils.Timer;
   
   public final class MousePointer extends Sprite
   {
      
      private static const ACTION_ICON_LIB_FILE:String = "mousepointer_action_icons.swf";
      
      private static const ACTION_ICON_LIB_NAME:String = "mousepointer_action_icons";
      
      private static const ACTION_ICON_PACKAGE:String = "de.freggers.mousepointer.actions";
      
      private static const NAME_STYLE:StyleSheet = new StyleSheetBuilder(".name").add("fontSize",10).add("color","#000000").add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").build();
      
      private static const ICON_SHADOW:DropShadowFilter = new DropShadowFilter(2,90,0,0.75);
      
      public static const MODE_NO_INTERACTION_DATA:int = 0;
      
      public static const MODE_MULTIPLE_INTERACTIONS:int = 1;
      
      public static const MODE_EMPTY_HAND:int = 10;
      
      public static const MODE_EMPTY_HAND_WITH_CONTENT:int = 11;
      
      public static const MODE_USE_CONTENT_ON:int = 12;
      
      public static const MODE_THROW_CONTENT_AT:int = 13;
      
      public static const MODE_TRASH_CONTENT:int = 14;
       
      
      public var onContentChange:Function;
      
      private var _timer:Timer;
      
      private var _glowFilter:GlowFilter;
      
      private var _scrollMode:Boolean;
      
      private var _actionIconLabel:String;
      
      private var _actionIcon:DisplayObject;
      
      private var _clickAndHoldForMenuHint:ClickAndHoldForMenuHintGfx;
      
      private var _handContentIcon:HandContentIcon;
      
      private var _systemPointerHidden:Boolean = false;
      
      private var _actionDataProvider:IGameInteractionProvider;
      
      private var _mode:int = 0;
      
      private var _mouseOnStage:Boolean;
      
      private var _clickAndHoldTimer:Timer;
      
      public function MousePointer()
      {
         this._glowFilter = new GlowFilter(15264062,0,30,30,1);
         this._clickAndHoldTimer = new Timer(1500,1);
         super();
         this.mouseEnabled = this.mouseChildren = false;
         this.init();
      }
      
      private static function loadMousePointerLibrary() : void
      {
         ResourceManager.instance.requestSwfLibrary(ACTION_ICON_LIB_FILE,ACTION_ICON_LIB_NAME,function(param1:String, param2:DisplayObject, param3:ResourceRequest):void
         {
         },function(param1:String, param2:DisplayObject, param3:ResourceRequest):void
         {
         },true);
      }
      
      private static function createMousePointerActionIcon(param1:String) : DisplayObject
      {
         return InstanceFactory.createInstanceOf(ACTION_ICON_PACKAGE + "::" + param1,DisplayObject) as DisplayObject;
      }
      
      private static function hideMouse() : void
      {
         var _loc1_:Object = JSApi.getBrowserInfo();
         if(_loc1_ == null || !(_loc1_.browser == "Safari" && _loc1_.version == "5.1" && _loc1_.OS == "Mac"))
         {
            Mouse.hide();
         }
      }
      
      private function init() : void
      {
         this._handContentIcon = new HandContentIcon();
         this._clickAndHoldForMenuHint = new ClickAndHoldForMenuHintGfx();
         this._timer = new Timer(50,15);
         this._timer.removeEventListener(TimerEvent.TIMER,this.notifyTimer);
         this._handContentIcon.onSizeChanged = this.onHandContentIconSizeChanged;
         this._handContentIcon.filters = [ICON_SHADOW];
         addChild(this._handContentIcon);
         this.positionHandContentIcon();
         if(!ResourceManager.instance.isLibraryLoaded(ACTION_ICON_LIB_NAME))
         {
            MousePointer.loadMousePointerLibrary();
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            if(this._systemPointerHidden)
            {
               hideMouse();
            }
         }
         else
         {
            Mouse.show();
         }
      }
      
      public function set actionDataProvider(param1:IGameInteractionProvider) : void
      {
         this._actionDataProvider = param1;
         if(this._actionDataProvider == null)
         {
            Mouse.show();
            this._systemPointerHidden = false;
         }
         this.updateActionIcon();
      }
      
      public function get actionDataProvider() : IGameInteractionProvider
      {
         return this._actionDataProvider;
      }
      
      public function get handContentCount() : int
      {
         if(this._handContentIcon == null)
         {
            return 0;
         }
         return this._handContentIcon.handContentCount;
      }
      
      private function getPrimaryInteraction(param1:Vector.<ItemInteraction>) : ItemInteraction
      {
         var _loc2_:ItemInteraction = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.type == ItemInteraction.TYPE_PRIMARY)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function updateActionIcon() : void
      {
         var primaryInteraction:ItemInteraction = null;
         var secondaryInteractions:Vector.<ItemInteraction> = null;
         if(this._actionDataProvider == null)
         {
            this.setActionIcon(null,MODE_NO_INTERACTION_DATA,false);
            return;
         }
         var interactions:Vector.<ItemInteraction> = this._actionDataProvider.interactions;
         var actionIconLabel:String = null;
         var mode:int = MODE_NO_INTERACTION_DATA;
         var showClickAndHoldHint:Boolean = false;
         if(this.throwHandContentAt())
         {
            actionIconLabel = GlobalAction.THROW_HAND_CONTENT_AT;
            mode = MODE_THROW_CONTENT_AT;
         }
         else if(this.useHandContentOn())
         {
            actionIconLabel = GlobalAction.USE_HAND_CONTENT_WITH;
            mode = MODE_USE_CONTENT_ON;
         }
         else if(this.trashHandContent())
         {
            actionIconLabel = GlobalAction.TRASH_HAND_CONTENT;
            mode = MODE_TRASH_CONTENT;
         }
         else if(interactions != null)
         {
            primaryInteraction = this.getPrimaryInteraction(interactions);
            secondaryInteractions = interactions.filter(function(param1:ItemInteraction, param2:int, param3:Vector.<ItemInteraction>):Boolean
            {
               return param1.type == ItemInteraction.TYPE_SECONDARY;
            });
            mode = MODE_EMPTY_HAND;
            if(primaryInteraction != null)
            {
               actionIconLabel = primaryInteraction.label;
               showClickAndHoldHint = secondaryInteractions.length > 1;
               if(this.handContentMatchesProducedContent(primaryInteraction))
               {
                  mode = MODE_EMPTY_HAND_WITH_CONTENT;
               }
            }
            else if(secondaryInteractions.length > 1)
            {
               actionIconLabel = GlobalAction.SHOW_MENU;
               mode = MODE_MULTIPLE_INTERACTIONS;
            }
            else if(secondaryInteractions.length == 1)
            {
               actionIconLabel = secondaryInteractions[0].label;
            }
         }
         this.setActionIcon(actionIconLabel,mode,showClickAndHoldHint);
      }
      
      private function throwHandContentAt() : Boolean
      {
         return this._handContentIcon.isThrowable && this._actionDataProvider.isThrowTarget;
      }
      
      private function useHandContentOn() : Boolean
      {
         return this._handContentIcon.handContentCount > 0 && this._handContentIcon.consumedBy(this._actionDataProvider.wobId);
      }
      
      private function trashHandContent() : Boolean
      {
         return !this._handContentIcon.isThrowable && this._actionDataProvider.isTrash && this._handContentIcon.handContentCount > 0;
      }
      
      private function handContentMatchesProducedContent(param1:ItemInteraction) : Boolean
      {
         return this._handContentIcon.handContentCount > 0 && param1.produces == this._handContentIcon.handContentGui;
      }
      
      private function resetActionIcon() : void
      {
         if(this._clickAndHoldForMenuHint.parent != null)
         {
            this._clickAndHoldForMenuHint.visible = false;
            this._clickAndHoldForMenuHint.parent.removeChild(this._clickAndHoldForMenuHint);
         }
         if(this._actionIcon != null)
         {
            if(this._actionIcon.parent != null)
            {
               this._actionIcon.parent.removeChild(this._actionIcon);
            }
            this._actionIcon = null;
         }
      }
      
      private function setActionIcon(param1:String, param2:int, param3:Boolean) : void
      {
         var _loc4_:Rectangle = null;
         if(this._mode != param2)
         {
            this._mode = param2;
            this.toggleHandContentIconVisibility();
         }
         this.resetActionIcon();
         this._actionIconLabel = param1;
         if(this._actionIconLabel == null)
         {
            Mouse.show();
            this._systemPointerHidden = false;
            return;
         }
         this._actionIcon = MousePointer.createMousePointerActionIcon(this._actionIconLabel);
         if(this._actionIcon == null)
         {
            this._actionIcon = MousePointer.createMousePointerActionIcon(GlobalAction.USE);
         }
         if(this._actionIcon != null)
         {
            this._actionIcon.filters = [ICON_SHADOW];
            addChild(this._actionIcon);
            if(param3)
            {
               _loc4_ = this._actionIcon.getBounds(this);
               this._clickAndHoldForMenuHint.y = _loc4_.bottom;
               this._clickAndHoldForMenuHint.x = _loc4_.left + _loc4_.width / 2;
               this._clickAndHoldForMenuHint.visible = false;
               addChild(this._clickAndHoldForMenuHint);
               this._clickAndHoldTimer.addEventListener(TimerEvent.TIMER,this.displayClickAndHoldHint);
               this._clickAndHoldTimer.reset();
               this._clickAndHoldTimer.start();
            }
            hideMouse();
            this._systemPointerHidden = true;
         }
      }
      
      private function displayClickAndHoldHint(param1:TimerEvent) : void
      {
         if(this._actionIcon != null)
         {
            this._clickAndHoldForMenuHint.visible = true;
            this._clickAndHoldTimer.removeEventListener(TimerEvent.TIMER,this.displayClickAndHoldHint);
         }
      }
      
      private function positionHandContentIcon() : void
      {
         var _loc1_:Rectangle = this._handContentIcon.getBounds(this._handContentIcon);
         this._handContentIcon.x = -_loc1_.x + 4;
         this._handContentIcon.y = -_loc1_.y - this._handContentIcon.height;
      }
      
      private function onHandContentIconSizeChanged() : void
      {
         this.positionHandContentIcon();
      }
      
      public function setHandContent(param1:String, param2:int = 1, param3:Array = null, param4:Boolean = false) : void
      {
         var handContentGui:String = param1;
         var handContentCount:int = param2;
         var consumerWobids:Array = param3;
         var isThrowable:Boolean = param4;
         if(this._handContentIcon.setHandContent(handContentGui,handContentCount,consumerWobids,isThrowable))
         {
            this.updateActionIcon();
            this.cancelNotifyHandContentChange();
            if(!isThrowable)
            {
               this.notifyHandContentChange();
            }
            try
            {
               this.onContentChange(handContentGui,handContentCount,consumerWobids,isThrowable);
               return;
            }
            catch(e:ArgumentError)
            {
               return;
            }
         }
      }
      
      private function notifyHandContentChange() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this.notifyTimer);
         this._timer.reset();
         this._timer.start();
      }
      
      private function notifyTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = this._timer.repeatCount;
         var _loc3_:int = _loc2_ / 2;
         var _loc4_:int = this._timer.currentCount;
         var _loc5_:Number = 0;
         if(_loc4_ < _loc3_)
         {
            _loc5_ = Equations.easeOutCubic(_loc4_,0,1,_loc3_);
         }
         else
         {
            _loc5_ = Equations.easeInCubic(_loc4_ - _loc3_,1,-1,_loc3_);
         }
         this._glowFilter.alpha = _loc5_;
         this._handContentIcon.scaleX = this._handContentIcon.scaleY = 1 + _loc5_ / 5;
         this._handContentIcon.filters = [this._glowFilter];
         if(_loc4_ == _loc2_)
         {
            this.cancelNotifyHandContentChange();
         }
      }
      
      private function cancelNotifyHandContentChange() : void
      {
         if(this._timer.running)
         {
            this._timer.reset();
         }
         this._handContentIcon.scaleX = this._handContentIcon.scaleY = this._handContentIcon.alpha = 1;
         this._handContentIcon.filters = [ICON_SHADOW];
      }
      
      private function isHandContentIconVisible() : Boolean
      {
         switch(this._mode)
         {
            case MODE_NO_INTERACTION_DATA:
            case MODE_THROW_CONTENT_AT:
            case MODE_TRASH_CONTENT:
            case MODE_USE_CONTENT_ON:
            case MODE_EMPTY_HAND_WITH_CONTENT:
               return true;
            default:
               return false;
         }
      }
      
      private function toggleHandContentIconVisibility() : void
      {
         if(this.isHandContentIconVisible())
         {
            if(!this._handContentIcon.visible)
            {
               this._handContentIcon.visible = true;
            }
         }
         else if(this._handContentIcon.visible)
         {
            this._handContentIcon.visible = false;
         }
      }
      
      public function removeHandContent() : void
      {
         this._handContentIcon.removeHandContent();
         this.updateActionIcon();
         try
         {
            this.onContentChange(null,0,null,false);
            return;
         }
         catch(e:ArgumentError)
         {
            return;
         }
      }
      
      private function showEmptyHandActionIcon() : void
      {
         if(this._actionIcon == null || this._actionIcon.visible)
         {
            return;
         }
         this._actionIcon.visible = true;
      }
      
      private function hideEmptyHandActionIcon() : void
      {
         if(this._actionIcon == null || !this._actionIcon.visible)
         {
            return;
         }
         this._actionIcon.visible = false;
      }
      
      public function reset(param1:Boolean = false) : void
      {
         this.scrollMode = false;
         this.actionDataProvider = null;
         if(param1)
         {
            this.removeHandContent();
         }
      }
      
      public function backupHandContent() : void
      {
         this._handContentIcon.backup();
      }
      
      public function restoreHandContent() : void
      {
         this._handContentIcon.restore();
         try
         {
            this.onContentChange(this._handContentIcon.handContentGui,this._handContentIcon.handContentCount,this._handContentIcon.consumers,this._handContentIcon.isThrowable);
         }
         catch(e:ArgumentError)
         {
         }
         this.updateActionIcon();
      }
      
      public function set scrollMode(param1:Boolean) : void
      {
         this._scrollMode = param1;
         if(this._scrollMode)
         {
            Mouse.cursor = MouseCursor.HAND;
            Mouse.show();
            this.hideEmptyHandActionIcon();
         }
         else
         {
            Mouse.cursor = MouseCursor.AUTO;
            if(this._systemPointerHidden)
            {
               hideMouse();
            }
            this.showEmptyHandActionIcon();
         }
      }
      
      public function set mouseOnStage(param1:Boolean) : void
      {
         if(this._mouseOnStage == param1)
         {
            return;
         }
         this._mouseOnStage = param1;
      }
      
      public function get mouseOnStage() : Boolean
      {
         return this._mouseOnStage;
      }
      
      public function get scrollMode() : Boolean
      {
         return this._scrollMode;
      }
      
      public function get actionMode() : int
      {
         return this._mode;
      }
   }
}
