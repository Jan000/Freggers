package de.freggers.roomdisplay.data
{
   public class UserLevelProgress
   {
       
      
      private var _level:int;
      
      private var _xpTotal:int;
      
      private var _xpCurrent:int;
      
      private var _xpCap:int;
      
      public function UserLevelProgress(param1:int, param2:int, param3:int, param4:int)
      {
         super();
         this._level = param1;
         this._xpTotal = param2;
         this._xpCurrent = param3;
         this._xpCap = param4;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get xpTotal() : int
      {
         return this._xpTotal;
      }
      
      public function get xpCurrent() : int
      {
         return this._xpCurrent;
      }
      
      public function get xpCap() : int
      {
         return this._xpCap;
      }
   }
}
