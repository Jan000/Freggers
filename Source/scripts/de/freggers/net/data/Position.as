package de.freggers.net.data
{
   public class Position
   {
       
      
      private var _u:int;
      
      private var _v:int;
      
      private var _z:int;
      
      private var _direction:int;
      
      public function Position(param1:int, param2:int, param3:int, param4:int = 0)
      {
         super();
         this._u = param1;
         this._v = param2;
         this._z = param3;
         this._direction = param4;
      }
      
      public static function fromArray(param1:Array) : Position
      {
         if(!param1)
         {
            return null;
         }
         return new Position(param1[0],param1[1],param1[2],param1[3]);
      }
      
      public function get u() : int
      {
         return this._u;
      }
      
      public function get v() : int
      {
         return this._v;
      }
      
      public function get z() : int
      {
         return this._z;
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      public function toString() : String
      {
         return "Position(" + this._u + ", " + this._v + ", " + this._z + ", " + this._direction + ")";
      }
   }
}
