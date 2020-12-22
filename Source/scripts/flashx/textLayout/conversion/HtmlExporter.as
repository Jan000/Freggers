package flashx.textLayout.conversion
{
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.TabAlignment;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.elements.BreakElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TabElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.Float;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.TabStopFormat;
   import flashx.textLayout.formats.TextAlign;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   class HtmlExporter implements ITextExporter
   {
      
      private static var _config:ImportExportConfiguration;
      
      private static const brRegEx:RegExp = / /;
       
      
      function HtmlExporter()
      {
         super();
         if(!_config)
         {
            _config = new ImportExportConfiguration();
            _config.addIEInfo("P",ParagraphElement,null,this.exportParagraph,true);
            _config.addIEInfo("A",LinkElement,null,this.exportLink,false);
            _config.addIEInfo("TCY",TCYElement,null,this.exportTCY,false);
            _config.addIEInfo("SPAN",SpanElement,null,this.exportSpan,false);
            _config.addIEInfo("IMG",InlineGraphicElement,null,this.exportImage,false);
            _config.addIEInfo("TAB",TabElement,null,this.exportTab,false);
            _config.addIEInfo("BR",BreakElement,null,this.exportBreak,false);
         }
      }
      
      private static function getSpanTextReplacementXML(param1:String) : XML
      {
         return <BR/>;
      }
      
      public function export(param1:TextFlow, param2:String) : Object
      {
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
      
      private function exportToString(param1:TextFlow) : String
      {
         var result:String = null;
         var originalSettings:Object = null;
         var textFlow:TextFlow = param1;
         originalSettings = XML.settings();
         try
         {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            XML.prettyPrinting = false;
            result = this.exportToXML(textFlow).toXMLString();
            XML.setSettings(originalSettings);
         }
         catch(e:Error)
         {
            XML.setSettings(originalSettings);
            throw e;
         }
         return result;
      }
      
      private function exportToXML(param1:TextFlow) : XML
      {
         var _loc5_:ParagraphElement = null;
         var _loc6_:ParagraphElement = null;
         var _loc2_:XML = <BODY/>;
         var _loc3_:FlowLeafElement = param1.getFirstLeaf();
         if(_loc3_)
         {
            _loc5_ = _loc3_.getParagraph();
            _loc6_ = param1.getLastLeaf().getParagraph();
            while(true)
            {
               _loc2_.appendChild(this.exportElement(_loc5_));
               if(_loc5_ == _loc6_)
               {
                  break;
               }
               _loc5_ = param1.findLeaf(_loc5_.getAbsoluteStart() + _loc5_.textLength).getParagraph();
            }
         }
         var _loc4_:XML = <HTML/>;
         _loc4_.appendChild(_loc2_);
         return _loc4_;
      }
      
      private function exportParagraph(param1:String, param2:ParagraphElement) : XML
      {
         var _loc3_:XML = new XML("<" + param1 + "/>");
         var _loc4_:XML = this.exportFont(param2.computedFormat);
         this.exportChildren(_loc4_,param2);
         this.nest(_loc3_,_loc4_);
         return this.exportParagraphFormat(_loc3_,param2);
      }
      
      private function exportLink(param1:String, param2:LinkElement) : Object
      {
         var _loc3_:XML = new XML("<" + param1 + "/>");
         if(param2.href)
         {
            _loc3_.@HREF = param2.href;
         }
         if(param2.target)
         {
            _loc3_.@TARGET = param2.target;
         }
         else
         {
            _loc3_.@TARGET = "_blank";
         }
         this.exportChildren(_loc3_,param2);
         var _loc4_:ITextLayoutFormat = param2.computedFormat;
         var _loc5_:ITextLayoutFormat = param2.getParagraph().computedFormat;
         var _loc6_:XML = this.exportFont(_loc4_,_loc5_);
         return !!_loc6_?this.nest(_loc6_,_loc3_):_loc3_;
      }
      
      private function exportTCY(param1:String, param2:TCYElement) : XMLList
      {
         var _loc3_:XML = new XML("<" + param1 + "/>");
         this.exportChildren(_loc3_,param2);
         return _loc3_.children();
      }
      
      private function exportSpan(param1:String, param2:SpanElement) : Object
      {
         var _loc3_:XML = new XML("<" + param1 + "/>");
         BaseTextLayoutExporter.exportSpanText(_loc3_,param2,brRegEx,getSpanTextReplacementXML);
         var _loc4_:Object = _loc3_.children();
         if(_loc4_.length() == 1 && _loc4_[0].nodeKind() == "text")
         {
            _loc4_ = _loc3_.text()[0];
         }
         return this.exportSpanFormat(_loc4_,param2);
      }
      
      private function exportImage(param1:String, param2:InlineGraphicElement) : XML
      {
         var _loc3_:XML = new XML("<" + param1 + "/>");
         if(param2.id)
         {
            _loc3_.@ID = param2.id;
         }
         if(param2.source)
         {
            _loc3_.@SRC = param2.source;
         }
         if(param2.width !== undefined && param2.width != FormatValue.AUTO)
         {
            _loc3_.@WIDTH = param2.width;
         }
         if(param2.height !== undefined && param2.height != FormatValue.AUTO)
         {
            _loc3_.@HEIGHT = param2.height;
         }
         if(param2.float != Float.NONE)
         {
            _loc3_.@ALIGN = param2.float;
         }
         return _loc3_;
      }
      
      private function exportBreak(param1:String, param2:BreakElement) : XML
      {
         return new XML("<" + param1 + "/>");
      }
      
      private function exportTab(param1:String, param2:TabElement) : Object
      {
         return this.exportSpan(param1,param2);
      }
      
      private function exportTextFormatAttribute(param1:XML, param2:String, param3:*) : XML
      {
         if(!param1)
         {
            param1 = <TEXTFORMAT/>;
         }
         param1[param2] = param3;
         return param1;
      }
      
      private function exportParagraphFormat(param1:XML, param2:ParagraphElement) : XML
      {
         var _loc4_:String = null;
         var _loc5_:XML = null;
         var _loc7_:FlowLeafElement = null;
         var _loc8_:Number = NaN;
         var _loc9_:* = null;
         var _loc10_:TabStopFormat = null;
         var _loc3_:ITextLayoutFormat = param2.computedFormat;
         switch(_loc3_.textAlign)
         {
            case TextAlign.START:
               _loc4_ = _loc3_.direction == Direction.LTR?TextAlign.LEFT:TextAlign.RIGHT;
               break;
            case TextAlign.END:
               _loc4_ = _loc3_.direction == Direction.LTR?TextAlign.RIGHT:TextAlign.LEFT;
               break;
            default:
               _loc4_ = _loc3_.textAlign;
         }
         param1.@ALIGN = _loc4_;
         if(_loc3_.paragraphStartIndent != 0)
         {
            _loc5_ = this.exportTextFormatAttribute(_loc5_,_loc3_.direction == Direction.LTR?"LEFTMARGIN":"RIGHTMARGIN",_loc3_.paragraphStartIndent);
         }
         if(_loc3_.paragraphEndIndent != 0)
         {
            _loc5_ = this.exportTextFormatAttribute(_loc5_,_loc3_.direction == Direction.LTR?"RIGHTMARGIN":"LEFTMARGIN",_loc3_.paragraphEndIndent);
         }
         if(_loc3_.textIndent != 0)
         {
            _loc5_ = this.exportTextFormatAttribute(_loc5_,"INDENT",_loc3_.textIndent);
         }
         if(_loc3_.leadingModel == LeadingModel.APPROXIMATE_TEXT_FIELD)
         {
            _loc7_ = param2.getFirstLeaf();
            if(_loc7_)
            {
               _loc8_ = TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(_loc7_.computedFormat.lineHeight,_loc7_.getEffectiveFontSize());
               if(_loc8_ != 0)
               {
                  _loc5_ = this.exportTextFormatAttribute(_loc5_,"LEADING",_loc8_);
               }
            }
         }
         var _loc6_:Array = _loc3_.tabStops;
         if(_loc6_)
         {
            _loc9_ = "";
            for each(_loc10_ in _loc6_)
            {
               if(_loc10_.alignment != TabAlignment.START)
               {
                  break;
               }
               if(_loc9_.length)
               {
                  _loc9_ = _loc9_ + ", ";
               }
               _loc9_ = _loc9_ + _loc10_.position;
            }
            if(_loc9_.length)
            {
               _loc5_ = this.exportTextFormatAttribute(_loc5_,"TABSTOPS",_loc9_);
            }
         }
         return !!_loc5_?this.nest(_loc5_,param1):param1;
      }
      
      private function exportSpanFormat(param1:Object, param2:SpanElement) : Object
      {
         var _loc3_:ITextLayoutFormat = param2.computedFormat;
         var _loc4_:Object = param1;
         if(_loc3_.textDecoration.toString() == TextDecoration.UNDERLINE)
         {
            _loc4_ = this.nest(<U/>,_loc4_);
         }
         if(_loc3_.fontStyle.toString() == FontPosture.ITALIC)
         {
            _loc4_ = this.nest(<I/>,_loc4_);
         }
         if(_loc3_.fontWeight.toString() == FontWeight.BOLD)
         {
            _loc4_ = this.nest(<B/>,_loc4_);
         }
         var _loc5_:FlowElement = param2.getParentByType(LinkElement);
         if(!_loc5_)
         {
            _loc5_ = param2.getParagraph();
         }
         var _loc6_:XML = this.exportFont(_loc3_,_loc5_.computedFormat);
         if(_loc6_)
         {
            _loc4_ = this.nest(_loc6_,_loc4_);
         }
         return _loc4_;
      }
      
      private function exportFontAttribute(param1:XML, param2:String, param3:*) : XML
      {
         if(!param1)
         {
            param1 = <FONT/>;
         }
         param1[param2] = param3;
         return param1;
      }
      
      private function exportFont(param1:ITextLayoutFormat, param2:ITextLayoutFormat = null) : XML
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         if(!param2 || param2.fontFamily != param1.fontFamily)
         {
            _loc3_ = this.exportFontAttribute(_loc3_,"FACE",param1.fontFamily);
         }
         if(!param2 || param2.fontSize != param1.fontSize)
         {
            _loc3_ = this.exportFontAttribute(_loc3_,"SIZE",param1.fontSize);
         }
         if(!param2 || param2.color != param1.color)
         {
            _loc4_ = param1.color.toString(16);
            while(_loc4_.length < 6)
            {
               _loc4_ = "0" + _loc4_;
            }
            _loc4_ = "#" + _loc4_;
            _loc3_ = this.exportFontAttribute(_loc3_,"COLOR",_loc4_);
         }
         if(!param2 || param2.trackingRight != param1.trackingRight)
         {
            _loc3_ = this.exportFontAttribute(_loc3_,"LETTERSPACING",param1.trackingRight);
         }
         if(!param2 || param2.kerning != param1.kerning)
         {
            _loc3_ = this.exportFontAttribute(_loc3_,"KERNING",param1.kerning == Kerning.OFF?"0":"1");
         }
         return _loc3_;
      }
      
      private function exportElement(param1:FlowElement) : Object
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:FlowElementInfo = _config.lookupByClass(_loc2_);
         if(_loc3_ != null)
         {
            return _loc3_.exporter(_config.lookupName(_loc2_),param1);
         }
         return null;
      }
      
      private function exportChildren(param1:XML, param2:FlowGroupElement) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.numChildren)
         {
            param1.appendChild(this.exportElement(param2.getChildAt(_loc3_)));
            _loc3_++;
         }
      }
      
      private function nest(param1:XML, param2:Object) : XML
      {
         param1.setChildren(param2);
         return param1;
      }
   }
}
