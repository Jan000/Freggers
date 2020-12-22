package flashx.textLayout.conversion
{
   class ImportExportConfiguration
   {
       
      
      private var flowElementInfoList:Object;
      
      function ImportExportConfiguration()
      {
         super();
      }
      
      public function addIEInfo(param1:String, param2:Class, param3:Function, param4:Function, param5:Boolean) : void
      {
         if(this.flowElementInfoList == null)
         {
            this.flowElementInfoList = new Object();
         }
         this.flowElementInfoList[param1] = new FlowElementInfo(param2,param3,param4,param5);
      }
      
      public function overrideIEInfo(param1:String, param2:Class, param3:Function, param4:Function) : void
      {
         if(this.flowElementInfoList == null)
         {
            this.flowElementInfoList = new Object();
         }
         this.flowElementInfoList[param1].flowClass = param2;
         this.flowElementInfoList[param1].parser = param3;
         this.flowElementInfoList[param1].exporter = param4;
      }
      
      public function lookup(param1:String) : FlowElementInfo
      {
         return !!this.flowElementInfoList?this.flowElementInfoList[param1]:null;
      }
      
      public function lookupName(param1:String) : String
      {
         var _loc2_:* = null;
         for(_loc2_ in this.flowElementInfoList)
         {
            if(this.flowElementInfoList[_loc2_].flowClassName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function lookupByClass(param1:String) : FlowElementInfo
      {
         var _loc2_:* = null;
         for(_loc2_ in this.flowElementInfoList)
         {
            if(this.flowElementInfoList[_loc2_].flowClassName == param1)
            {
               return this.flowElementInfoList[_loc2_];
            }
         }
         return null;
      }
   }
}
