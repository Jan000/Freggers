package de.freggers.roomlib.util
{
   public class ResourceRequest
   {
       
      
      private var resId:Number;
      
      private var reqId:Number;
      
      public function ResourceRequest(param1:Number, param2:Number)
      {
         super();
         this.reqId = param2;
         this.resId = param1;
      }
      
      public function get resourceID() : Number
      {
         return this.resId;
      }
      
      public function get requestID() : Number
      {
         return this.reqId;
      }
   }
}
