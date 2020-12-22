package flashx.textLayout.conversion
{
   import flashx.textLayout.elements.DivElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowValueHolder;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   class TextLayoutExporter extends BaseTextLayoutExporter
   {
      
      private static var nameCounter:int = 0;
      
      private static var _formatDescription:Object = TextLayoutFormat.description;
      
      private static const brTabRegEx:RegExp = new RegExp("[" + " " + "\t" + "]");
       
      
      private var queuedExport:Object = null;
      
      function TextLayoutExporter()
      {
         super(new Namespace("http://ns.adobe.com/textLayout/2008"),null,TextLayoutImporter.defaultConfiguration);
      }
      
      public static function exportImage(param1:BaseTextLayoutExporter, param2:InlineGraphicElement) : XMLList
      {
         var _loc3_:XMLList = exportFlowElement(param1,param2);
         if(param2.height !== undefined)
         {
            _loc3_.@height = param2.height;
         }
         if(param2.width !== undefined)
         {
            _loc3_.@width = param2.width;
         }
         if(param2.source != null)
         {
            _loc3_.@source = param2.source;
         }
         return _loc3_;
      }
      
      public static function exportLink(param1:BaseTextLayoutExporter, param2:LinkElement) : XMLList
      {
         var _loc3_:XMLList = exportFlowGroupElement(param1,param2);
         if(param2.href)
         {
            _loc3_.@href = param2.href;
         }
         if(param2.target)
         {
            _loc3_.@target = param2.target;
         }
         return _loc3_;
      }
      
      public static function exportDiv(param1:BaseTextLayoutExporter, param2:DivElement) : XMLList
      {
         return exportContainerFormattedElement(param1,param2);
      }
      
      public static function exportTCY(param1:BaseTextLayoutExporter, param2:TCYElement) : XMLList
      {
         return exportFlowGroupElement(param1,param2);
      }
      
      private static function exportToName(param1:BaseTextLayoutExporter, param2:Object) : String
      {
         var _loc3_:String = "ObjectID" + nameCounter.toString();
         TextLayoutExporter(param1).queueForExport(param2,_loc3_);
         nameCounter++;
         return _loc3_;
      }
      
      override protected function clear() : void
      {
         nameCounter = 0;
         this.queuedExport = null;
      }
      
      override protected function exportToXML(param1:TextFlow) : XML
      {
         var _loc2_:XML = super.exportToXML(param1);
         var _loc3_:XMLList = this.exportQueuedObjects();
         if(_loc3_)
         {
            _loc2_.appendChild(_loc3_);
         }
         return _loc2_;
      }
      
      private function exportQueuedObjects() : XMLList
      {
         var _loc2_:* = null;
         var _loc3_:Object = null;
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         if(!this.queuedExport)
         {
            return null;
         }
         var _loc1_:XMLList = new XMLList();
         for(_loc2_ in this.queuedExport)
         {
            _loc3_ = this.queuedExport[_loc2_];
            _loc4_ = new XMLList();
            if(_loc3_ is FlowValueHolder)
            {
               _loc5_ = <format/>;
               _loc5_.setNamespace(flowNS);
               _loc4_ = _loc4_ + _loc5_;
               _loc4_.@id = _loc2_;
               exportStyles(_loc4_,_loc3_.coreStyles,this.formatDescription);
               exportStyles(_loc4_,_loc3_.userStyles);
            }
            _loc1_ = _loc1_ + _loc4_;
         }
         return _loc1_;
      }
      
      private function queueForExport(param1:Object, param2:String) : void
      {
         if(!this.queuedExport)
         {
            this.queuedExport = new Object();
         }
         this.queuedExport[param2] = param1;
      }
      
      override protected function get spanTextReplacementRegex() : RegExp
      {
         return brTabRegEx;
      }
      
      override protected function getSpanTextReplacementXML(param1:String) : XML
      {
         var _loc2_:XML = null;
         if(param1 == " ")
         {
            _loc2_ = <br/>;
         }
         else if(param1 == "\t")
         {
            _loc2_ = <tab/>;
         }
         else
         {
            return null;
         }
         _loc2_.setNamespace(flowNS);
         return _loc2_;
      }
      
      override protected function exportFlowElement(param1:FlowElement) : XMLList
      {
         var _loc2_:XMLList = super.exportFlowElement(param1);
         var _loc3_:Object = param1.coreStyles;
         if(_loc3_)
         {
            delete _loc3_[TextLayoutFormat.whiteSpaceCollapseProperty.name];
            exportStyles(_loc2_,_loc3_,this.formatDescription);
         }
         if(param1.id != null)
         {
            _loc2_["id"] = param1.id;
         }
         if(param1.styleName != null)
         {
            _loc2_["styleName"] = param1.styleName;
         }
         var _loc4_:Object = param1.userStyles;
         if(_loc4_)
         {
            exportStyles(_loc2_,_loc4_);
         }
         return _loc2_;
      }
      
      override protected function get formatDescription() : Object
      {
         return _formatDescription;
      }
   }
}
