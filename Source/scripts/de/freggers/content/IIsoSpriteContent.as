package de.freggers.content
{
   import flash.display.DisplayObject;
   
   public interface IIsoSpriteContent
   {
       
      
      function set direction(param1:int) : void;
      
      function get displayObject() : DisplayObject;
      
      function get effects() : Effects;
      
      function get width() : Number;
      
      function get height() : Number;
      
      function set filters(param1:Array) : void;
      
      function get filters() : Array;
      
      function update(param1:int) : void;
      
      function cleanup() : void;
      
      function hitTestPoint(param1:Number, param2:Number, param3:Boolean = false) : Boolean;
   }
}
