package de.freggers.roomdisplay
{
   import de.freggers.roomlib.ItemInteraction;
   import de.freggers.ui.IGameInteractionProvider;
   import de.freggers.util.RectangleSprite;
   
   public final class ClickthroughTarget extends RectangleSprite implements IGameInteractionProvider
   {
       
      
      public function ClickthroughTarget(param1:Number, param2:Number, param3:uint = 16777215, param4:Number = 1)
      {
         super(param1,param2,param3,param4);
      }
      
      public function get interactions() : Vector.<ItemInteraction>
      {
         return null;
      }
      
      public function get isOldSkool() : Boolean
      {
         return false;
      }
      
      public function get isThrowTarget() : Boolean
      {
         return false;
      }
      
      public function get isTrash() : Boolean
      {
         return false;
      }
      
      public function get wobId() : int
      {
         return 0;
      }
   }
}
