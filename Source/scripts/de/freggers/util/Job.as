package de.freggers.util
{
   public class Job implements IJob
   {
      
      public static const WAITING:int = 0;
      
      public static const PROCESSING:int = 1;
      
      public static const PROCESSED:int = 2;
       
      
      private var _callback:Function;
      
      private var _argarr:Array;
      
      private var _addedAt:int;
      
      public var _flags:int = 0;
      
      public function Job(param1:Function, param2:Array = null)
      {
         super();
         this._callback = param1;
         if(param2 === null)
         {
            param2 = new Array();
         }
         this._argarr = param2;
      }
      
      public function process(param1:int) : void
      {
         var processedAt:int = param1;
         try
         {
            this._argarr.push(this._addedAt,processedAt);
            this._callback.apply(null,this._argarr);
            return;
         }
         catch(e:ArgumentError)
         {
            return;
         }
      }
      
      public function toString() : String
      {
         return "Job[" + this._callback + "(" + this._argarr + "), " + this.flags + "]";
      }
      
      public function get flags() : int
      {
         return this._flags;
      }
      
      public function set flags(param1:int) : void
      {
         this._flags = param1;
      }
      
      public function set addedAt(param1:int) : void
      {
         this._addedAt = param1;
      }
      
      public function get addedAt() : int
      {
         return this._addedAt;
      }
   }
}
