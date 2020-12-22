package de.freggers.util
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public interface ICroppedBitmapDataContainer
   {
       
      
      function set bitmapData(param1:BitmapData) : void;
      
      function get bitmapData() : BitmapData;
      
      function get rect() : Rectangle;
      
      function get crect() : Rectangle;
      
      function get width() : int;
      
      function get height() : int;
      
      function get isvirtual() : Boolean;
      
      function clone() : ICroppedBitmapDataContainer;
      
      function dispose() : void;
      
      function hitTest(param1:Point, param2:uint, param3:Point, param4:Boolean = false) : Boolean;
      
      function getPixels() : ByteArray;
      
      function getVector() : Vector.<uint>;
   }
}
