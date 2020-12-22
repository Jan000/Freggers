package flashx.textLayout.conversion
{
   import flash.utils.getQualifiedClassName;
   
   class FlowElementInfo
   {
       
      
      private var _flowClass:Class;
      
      private var _flowClassName:String;
      
      private var _parser:Function;
      
      private var _exporter:Function;
      
      private var _isParagraphFormattedElement:Boolean;
      
      function FlowElementInfo(param1:Class, param2:Function, param3:Function, param4:Boolean)
      {
         super();
         this._flowClass = param1;
         this._parser = param2;
         this._exporter = param3;
         this._flowClassName = getQualifiedClassName(param1);
         this._isParagraphFormattedElement = param4;
      }
      
      public function get flowClass() : Class
      {
         return this._flowClass;
      }
      
      public function get flowClassName() : String
      {
         return this._flowClassName;
      }
      
      public function get parser() : Function
      {
         return this._parser;
      }
      
      public function get exporter() : Function
      {
         return this._exporter;
      }
      
      public function get isParagraphFormattedElement() : Boolean
      {
         return this._isParagraphFormattedElement;
      }
   }
}
