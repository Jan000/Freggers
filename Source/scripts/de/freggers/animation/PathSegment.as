package de.freggers.animation
{
   import de.freggers.data.Level;
   import flash.geom.Vector3D;
   
   public class PathSegment
   {
       
      
      protected var points:Array;
      
      protected var level:Level;
      
      public var duration:int;
      
      public var position:Vector3D;
      
      public var direction:int = -1;
      
      public function PathSegment(param1:Array, param2:int, param3:Level = null)
      {
         this.position = new Vector3D();
         super();
         this.points = param1;
         this.duration = param2;
         this.level = param3;
      }
      
      public function compute(param1:int) : void
      {
      }
      
      public function toString() : String
      {
         return "AMPathSegment[points=(" + this.points + "),ground=" + (this.level != null) + "]";
      }
      
      public function get start() : Vector3D
      {
         if(!this.points || this.points.length == 0)
         {
            return null;
         }
         return this.points[0] as Vector3D;
      }
      
      public function get end() : Vector3D
      {
         if(!this.points || this.points.length == 0)
         {
            return null;
         }
         return this.points[this.points.length - 1] as Vector3D;
      }
   }
}
