package de.freggers.ui
{
   import de.freggers.roomlib.ItemInteraction;
   
   public interface IGameInteractionProvider
   {
       
      
      function get interactions() : Vector.<ItemInteraction>;
      
      function get isThrowTarget() : Boolean;
      
      function get isTrash() : Boolean;
      
      function get wobId() : int;
   }
}
