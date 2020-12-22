package de.freggers.roomlib.util
{
   class ResourceCallbackData
   {
       
      
      private var target:Object;
      
      private var callback:Function;
      
      private var request:ResourceRequest;
      
      function ResourceCallbackData(param1:Object, param2:Function, param3:ResourceRequest)
      {
         super();
         if(param2 == null || !param3)
         {
            throw new Error("Attempted to create a callback with invalid data.");
         }
         this.target = param1;
         this.callback = param2;
         this.request = param3;
      }
      
      public function get callTarget() : Object
      {
         return this.target;
      }
      
      public function get requestID() : Number
      {
         return this.request.requestID;
      }
      
      public function execute(param1:Object) : void
      {
         if(this.callback != null && this.request)
         {
            this.callback(this.target,param1,this.request);
            this.cleanup();
         }
      }
      
      public function get invalidated() : Boolean
      {
         return this.callback == null || this.request == null;
      }
      
      public function cleanup() : void
      {
         this.callback = null;
         this.target = null;
         this.request = null;
      }
   }
}
