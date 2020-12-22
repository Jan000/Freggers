package de.freggers.util
{
   public class MCCE
   {
       
      
      private var _t:int;
      
      private var _c;
      
      public function MCCE(param1:int, param2:*)
      {
         super();
         this._t = param1;
         this._c = param2;
      }
      
      public function get type() : int
      {
         return this._t;
      }
      
      public function get content() : *
      {
         return this._c;
      }
      
      public function set type(param1:int) : void
      {
         this._t = param1;
      }
      
      public function set content(param1:*) : void
      {
         this._c = param1;
      }
   }
}
