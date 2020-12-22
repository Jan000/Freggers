package de.freggers.animation
{
   import flash.geom.Vector3D;
   
   public interface ITarget
   {
       
      
      function getFrameCount(param1:String, param2:uint) : int;
      
      function get valid() : Boolean;
      
      function get animation() : String;
      
      function set animation(param1:String) : void;
      
      function get direction() : int;
      
      function set direction(param1:int) : void;
      
      function get frame() : int;
      
      function set frame(param1:int) : void;
      
      function get lightintensity() : Number;
      
      function set lightintensity(param1:Number) : void;
      
      function get uvz() : Vector3D;
      
      function set uvz(param1:Vector3D) : void;
      
      function get flags() : int;
      
      function set flags(param1:int) : void;
      
      function getFlagArgs(param1:int) : Object;
      
      function setFlagArgs(param1:int, param2:Object) : void;
      
      function showDefaults() : void;
      
      function hasAnimation(param1:String) : Boolean;
   }
}
