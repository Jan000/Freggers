package de.freggers.util
{
   public interface IJob
   {
       
      
      function process(param1:int) : void;
      
      function set addedAt(param1:int) : void;
      
      function get addedAt() : int;
      
      function get flags() : int;
      
      function set flags(param1:int) : void;
   }
}
