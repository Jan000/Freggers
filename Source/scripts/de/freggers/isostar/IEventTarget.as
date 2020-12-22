package de.freggers.isostar
{
   import flash.geom.Vector3D;
   
   public interface IEventTarget
   {
       
      
      function get isoU() : Number;
      
      function get isoV() : Number;
      
      function get isoZ() : Number;
      
      function get hasmouse() : Boolean;
      
      function set hasmouse(param1:Boolean) : void;
      
      function get enableMouse() : Boolean;
      
      function set enableMouse(param1:Boolean) : void;
      
      function get displayindex() : int;
      
      function hitTestPoint(param1:Number, param2:Number, param3:Boolean = false) : Boolean;
      
      function getIsoPosition(param1:Boolean = true) : Vector3D;
   }
}
