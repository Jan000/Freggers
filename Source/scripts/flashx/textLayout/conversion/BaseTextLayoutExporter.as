package flashx.textLayout.conversion
{
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.elements.ContainerFormattedElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphFormattedElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.WhiteSpaceCollapse;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   class BaseTextLayoutExporter implements ITextExporter
   {
      
      private static const brRegEx:RegExp = / /;
       
      
      private var _config:ImportExportConfiguration;
      
      private var _rootTag:XML;
      
      private var _ns:Namespace;
      
      function BaseTextLayoutExporter(param1:Namespace, param2:XML, param3:ImportExportConfiguration)
      {
         super();
         this._config = param3;
         this._ns = param1;
         this._rootTag = param2;
      }
      
      public static function exportFlowElement(param1:BaseTextLayoutExporter, param2:FlowElement) : XMLList
      {
         return param1.exportFlowElement(param2);
      }
      
      public static function exportSpanText(param1:XML, param2:SpanElement, param3:RegExp, param4:Function) : void
      {
         var _loc7_:XML = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:XML = null;
         var _loc5_:String = param2.text;
         var _loc6_:Array = _loc5_.match(param3);
         if(_loc6_)
         {
            while(_loc6_ != null)
            {
               _loc8_ = _loc6_.index;
               _loc9_ = _loc5_.substr(0,_loc8_);
               if(_loc9_.length > 0)
               {
                  _loc7_ = <dummy/>;
                  _loc7_.appendChild(_loc9_);
                  param1.appendChild(_loc7_.text()[0]);
               }
               _loc10_ = param4(_loc5_.charAt(_loc8_));
               param1.appendChild(_loc10_);
               _loc5_ = _loc5_.slice(_loc8_ + 1,_loc5_.length);
               _loc6_ = _loc5_.match(param3);
               if(!_loc6_ && _loc5_.length > 0)
               {
                  _loc7_ = <dummy/>;
                  _loc7_.appendChild(_loc5_);
                  param1.appendChild(_loc7_.text()[0]);
               }
            }
         }
         else
         {
            param1.appendChild(param2.text);
         }
      }
      
      public static function exportSpan(param1:BaseTextLayoutExporter, param2:SpanElement) : XMLList
      {
         var _loc3_:XMLList = exportFlowElement(param1,param2);
         exportSpanText(_loc3_[0],param2,param1.spanTextReplacementRegex,param1.getSpanTextReplacementXML);
         return _loc3_;
      }
      
      public static function exportFlowGroupElement(param1:BaseTextLayoutExporter, param2:FlowGroupElement) : XMLList
      {
         var _loc5_:FlowElement = null;
         var _loc6_:XMLList = null;
         var _loc3_:XMLList = exportFlowElement(param1,param2);
         var _loc4_:int = 0;
         while(_loc4_ < param2.numChildren)
         {
            _loc5_ = param2.getChildAt(_loc4_);
            _loc6_ = param1.exportChild(_loc5_);
            if(_loc6_)
            {
               _loc3_.appendChild(_loc6_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function exportParagraphFormattedElement(param1:BaseTextLayoutExporter, param2:ParagraphFormattedElement) : XMLList
      {
         return param1.exportParagraphFormattedElement(param2);
      }
      
      public static function exportContainerFormattedElement(param1:BaseTextLayoutExporter, param2:ContainerFormattedElement) : XMLList
      {
         return param1.exportContainerFormattedElement(param2);
      }
      
      public static function exportTextFlow(param1:BaseTextLayoutExporter, param2:TextFlow) : XMLList
      {
         var _loc3_:XMLList = exportContainerFormattedElement(param1,param2);
         _loc3_[TextLayoutFormat.whiteSpaceCollapseProperty.name] = WhiteSpaceCollapse.PRESERVE;
         return _loc3_;
      }
      
      protected function clear() : void
      {
      }
      
      public function export(param1:TextFlow, param2:String) : Object
      {
         this.clear();
         if(param2 == ConversionType.STRING_TYPE)
         {
            return this.exportToString(param1);
         }
         if(param2 == ConversionType.XML_TYPE)
         {
            return this.exportToXML(param1);
         }
         return null;
      }
      
      protected function exportToXML(param1:TextFlow) : XML
      {
         var _loc2_:XML = null;
         if(this._rootTag)
         {
            _loc2_ = new XML(this._rootTag);
            _loc2_.addNamespace(this._ns);
            _loc2_.appendChild(this.exportChild(param1));
         }
         else
         {
            _loc2_ = XML(exportTextFlow(this,param1));
            _loc2_.addNamespace(this._ns);
         }
         return _loc2_;
      }
      
      protected function exportToString(param1:TextFlow) : String
      {
         var result:String = null;
         var originalSettings:Object = null;
         var source:TextFlow = param1;
         originalSettings = XML.settings();
         try
         {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            XML.prettyPrinting = false;
            result = this.exportToXML(source).toXMLString();
            XML.setSettings(originalSettings);
         }
         catch(e:Error)
         {
            XML.setSettings(originalSettings);
            throw e;
         }
         return result;
      }
      
      protected function exportFlowElement(param1:FlowElement) : XMLList
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:String = this._config.lookupName(_loc2_);
         var _loc4_:XML = new XML("<" + _loc3_ + "/>");
         _loc4_.setNamespace(this._ns);
         return XMLList(_loc4_);
      }
      
      protected function get spanTextReplacementRegex() : RegExp
      {
         return brRegEx;
      }
      
      protected function getSpanTextReplacementXML(param1:String) : XML
      {
         var _loc2_:XML = <br/>;
         _loc2_.setNamespace(this.flowNS);
         return _loc2_;
      }
      
      protected function exportParagraphFormattedElement(param1:FlowElement) : XMLList
      {
         var _loc4_:FlowElement = null;
         var _loc2_:XMLList = this.exportFlowElement(param1);
         var _loc3_:int = 0;
         while(_loc3_ < ParagraphFormattedElement(param1).numChildren)
         {
            _loc4_ = ParagraphFormattedElement(param1).getChildAt(_loc3_);
            _loc2_.appendChild(this.exportChild(_loc4_));
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function exportContainerFormattedElement(param1:FlowElement) : XMLList
      {
         return this.exportParagraphFormattedElement(param1);
      }
      
      public function exportChild(param1:FlowElement) : XMLList
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:FlowElementInfo = this._config.lookupByClass(_loc2_);
         if(_loc3_ != null)
         {
            return _loc3_.exporter(this,param1);
         }
         return null;
      }
      
      private function exportObjectAsDictionary(param1:String, param2:Object) : XMLList
      {
         if(param1 != LinkElement.LINK_NORMAL_FORMAT_NAME && param1 != LinkElement.LINK_ACTIVE_FORMAT_NAME && param1 != LinkElement.LINK_HOVER_FORMAT_NAME)
         {
            return null;
         }
         var _loc3_:String = "TextLayoutFormat";
         var _loc4_:XML = new XML("<" + _loc3_ + "/>");
         _loc4_.setNamespace(this.flowNS);
         this.exportStyles(XMLList(_loc4_),param2,this.formatDescription);
         var _loc5_:XMLList = XMLList(new XML("<" + param1 + "/>"));
         _loc5_.appendChild(_loc4_);
         return _loc5_;
      }
      
      protected function exportStyles(param1:XMLList, param2:Object, param3:Object = null, param4:Array = null) : void
      {
         var _loc6_:* = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Property = null;
         var _loc10_:XMLList = null;
         var _loc11_:Object = null;
         var _loc5_:Array = [];
         for(_loc6_ in param2)
         {
            _loc8_ = param2[_loc6_];
            if(!param4 || param4.indexOf(_loc8_) == -1)
            {
               if(param3)
               {
                  _loc9_ = param3[_loc6_];
                  if(_loc9_)
                  {
                     _loc5_.push({
                        "xmlName":_loc6_,
                        "xmlVal":_loc9_.toXMLString(_loc8_)
                     });
                  }
               }
               else if(_loc8_ is String || _loc8_.hasOwnProperty("toString"))
               {
                  _loc5_.push({
                     "xmlName":_loc6_,
                     "xmlVal":_loc8_
                  });
               }
               else
               {
                  _loc10_ = this.exportObjectAsDictionary(_loc6_ as String,_loc8_);
                  if(_loc10_)
                  {
                     _loc5_.push({
                        "xmlName":_loc6_,
                        "xmlVal":_loc10_
                     });
                  }
               }
            }
         }
         _loc5_.sortOn("xmlName");
         for each(_loc7_ in _loc5_)
         {
            _loc11_ = _loc7_.xmlVal;
            if(_loc11_ is String)
            {
               param1[_loc7_.xmlName] = _loc11_;
            }
            else if(_loc11_ is XMLList)
            {
               param1.appendChild(_loc11_);
            }
         }
      }
      
      function get flowNS() : Namespace
      {
         return this._ns;
      }
      
      protected function get formatDescription() : Object
      {
         return null;
      }
   }
}
