package de.freggers.roomdisplay
{
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import flash.events.KeyboardEvent;
   
   public interface IInputModule
   {
       
      
      function isMouseHandler() : Boolean;
      
      function isKeyboardHandler() : Boolean;
      
      function handleKeyboardEvent(param1:KeyboardEvent) : Boolean;
      
      function handleMouseManagerData(param1:MouseManagerData) : Boolean;
      
      function cleanup() : void;
   }
}
