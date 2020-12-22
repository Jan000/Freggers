package de.freggers.roomdisplay.ui
{
   import de.freggers.roomlib.GlobalAction;
   import de.freggers.roomlib.ItemInteraction;
   import de.freggers.ui.IGameInteractionProvider;
   import flash.display.Sprite;
   
   public final class HandContentTrash extends Sprite implements IGameInteractionProvider
   {
      
      private static const INTERACTIONS:Vector.<ItemInteraction> = GlobalAction.interactionVector(GlobalAction.TRASH_HAND_CONTENT);
       
      
      private var _icon:IconTrash;
      
      public function HandContentTrash()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._icon = new IconTrash();
         this._icon.mouseEnabled = this._icon.mouseChildren = false;
         this.highLight = false;
         addChild(this._icon);
      }
      
      public function set highLight(param1:Boolean) : void
      {
         if(param1)
         {
            this._icon.gotoAndStop("open");
         }
         else
         {
            this._icon.gotoAndStop("closed");
         }
      }
      
      public function get interactions() : Vector.<ItemInteraction>
      {
         return INTERACTIONS;
      }
      
      public function get isOldSkool() : Boolean
      {
         return false;
      }
      
      public function get wobId() : int
      {
         return 0;
      }
      
      public function get isThrowTarget() : Boolean
      {
         return false;
      }
      
      public function get isTrash() : Boolean
      {
         return true;
      }
   }
}
