package de.schulterklopfer.interaction.manager
{
   import flash.display.InteractiveObject;
   
   public final class WidgetManager
   {
      
      public static var clickThroughTarget:InteractiveObject;
      
      private static var _inited:Boolean;
      
      private static var _clickThroughTargetHandlerBackup:Function;
      
      private static var _clickThroughCallback:Function;
      
      private static var _widget:InteractiveObject;
       
      
      public function WidgetManager()
      {
         super();
      }
      
      private static function init() : void
      {
         _inited = true;
      }
      
      public static function setWidget(param1:InteractiveObject) : void
      {
         if(!_inited)
         {
            init();
         }
         _widget = param1;
         InteractionManager.disableMouseForAll(true);
         InteractionManager.enableMouseFor(_widget);
      }
      
      public static function remove() : void
      {
         InteractionManager.enableMouseForAll(true);
         if(_widget != null)
         {
            InteractionManager.disableMouseFor(_widget);
            _widget = null;
         }
      }
      
      public static function hasClickThroughCallback() : Boolean
      {
         return _clickThroughCallback != null;
      }
      
      public static function activateClickthrough(param1:Function) : void
      {
         _clickThroughCallback = param1;
         if(clickThroughTarget != null)
         {
            _clickThroughTargetHandlerBackup = InteractionManager.getMouseHandlerCallbackFor(clickThroughTarget);
            InteractionManager.setMouseHandlerCallbackFor(clickThroughTarget,_clickThroughCallback);
            InteractionManager.enableMouseFor(clickThroughTarget);
         }
      }
      
      public static function deactivateClickthrough() : void
      {
         _clickThroughCallback = null;
         if(clickThroughTarget != null)
         {
            InteractionManager.setMouseHandlerCallbackFor(clickThroughTarget,_clickThroughTargetHandlerBackup);
            _clickThroughTargetHandlerBackup = null;
         }
      }
   }
}
