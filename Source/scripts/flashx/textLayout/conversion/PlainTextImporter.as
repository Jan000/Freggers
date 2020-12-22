package flashx.textLayout.conversion
{
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.TextFlow;
   
   class PlainTextImporter implements ITextImporter
   {
      
      private static const _newLineRegex:RegExp = /\n|\r\n?/g;
       
      
      protected var _config:IConfiguration;
      
      function PlainTextImporter(param1:IConfiguration = null)
      {
         super();
         this._config = param1;
      }
      
      public function importToFlow(param1:Object) : TextFlow
      {
         if(param1 is String)
         {
            return this.importFromString(String(param1));
         }
         return null;
      }
      
      protected function importFromString(param1:String) : TextFlow
      {
         var _loc4_:String = null;
         var _loc5_:ParagraphElement = null;
         var _loc6_:SpanElement = null;
         var _loc2_:Array = param1.split(_newLineRegex);
         var _loc3_:TextFlow = new TextFlow(this._config);
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = new ParagraphElement();
            _loc6_ = new SpanElement();
            _loc6_.replaceText(0,0,_loc4_);
            _loc5_.replaceChildren(0,0,_loc6_);
            _loc3_.replaceChildren(_loc3_.numChildren,_loc3_.numChildren,_loc5_);
         }
         return _loc3_;
      }
      
      public function get errors() : Vector.<String>
      {
         return null;
      }
      
      public function get throwOnError() : Boolean
      {
         return false;
      }
      
      public function set throwOnError(param1:Boolean) : void
      {
      }
   }
}
