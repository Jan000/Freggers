package de.freggers.ui
{
   import flash.display.BitmapData;
   
   public interface ISelectable extends IGameInteractionProvider
   {
       
      
      function get name() : String;
      
      function get icon() : BitmapData;
   }
}
