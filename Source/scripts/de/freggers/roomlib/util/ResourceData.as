package de.freggers.roomlib.util
{
   import flash.utils.getTimer;
   
   class ResourceData
   {
       
      
      private var _cacheMode:uint;
      
      var _resource:Object = null;
      
      var _lastAccess:int = -1;
      
      var _available:Boolean = false;
      
      var _isLibrary:Boolean;
      
      function ResourceData(param1:uint, param2:Boolean = false)
      {
         super();
         this._cacheMode = param1;
         this._isLibrary = param2;
      }
      
      public function get cacheMode() : uint
      {
         return this._cacheMode;
      }
      
      public function cleanup() : void
      {
         this._resource = null;
      }
      
      public function set resource(param1:Object) : void
      {
         if(param1)
         {
            this._resource = param1;
            return;
         }
         throw new Error("Cannot use null or undefined value as resources.");
      }
      
      function touch() : void
      {
         this._lastAccess = getTimer();
      }
      
      public function get resource() : Object
      {
         this.touch();
         return this._resource;
      }
      
      public function age(param1:int) : Number
      {
         if(this._lastAccess < 0 || this._lastAccess > param1)
         {
            return 0;
         }
         return param1 - this._lastAccess;
      }
      
      public function get available() : Boolean
      {
         return this._available;
      }
   }
}
