package de.freggers.animation
{
   public interface IChangeable
   {
       
      
      function get target() : ITarget;
      
      function get ref() : *;
      
      function get onComplete() : Function;
      
      function update(param1:int) : void;
      
      function get finished() : Boolean;
      
      function cleanup() : void;
   }
}
