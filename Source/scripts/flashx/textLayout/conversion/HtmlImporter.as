package flashx.textLayout.conversion
{
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.utils.Dictionary;
   import flashx.textLayout.elements.BreakElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.TabElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormatValueHolder;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.property.StringProperty;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   class HtmlImporter extends BaseTextLayoutImporter
   {
      
      static var _fontDescription:Object = {
         "color":TextLayoutFormat.colorProperty,
         "trackingRight":TextLayoutFormat.trackingRightProperty,
         "fontFamily":TextLayoutFormat.fontFamilyProperty
      };
      
      static const _fontMiscDescription:Object = {
         "size":new StringProperty("size",null,false,null),
         "kerning":new StringProperty("kerning",null,false,null)
      };
      
      static var _textFormatDescription:Object = {
         "paragraphStartIndent":TextLayoutFormat.paragraphStartIndentProperty,
         "paragraphEndIndent":TextLayoutFormat.paragraphEndIndentProperty,
         "textIndent":TextLayoutFormat.textIndentProperty,
         "lineHeight":TextLayoutFormat.lineHeightProperty,
         "tabStops":TextLayoutFormat.tabStopsProperty
      };
      
      static const _textFormatMiscDescription:Object = {"blockIndent":new StringProperty("blockIndent",null,false,null)};
      
      static var _paragraphFormatDescription:Object = {"textAlign":TextLayoutFormat.textAlignProperty};
      
      static const _linkHrefDescription:Object = {"href":new StringProperty("href",null,false,null)};
      
      static const _linkTargetDescription:Object = {"target":new StringProperty("target",null,false,null)};
      
      static const _imageDescription:Object = {
         "height":InlineGraphicElement.heightPropertyDefinition,
         "width":InlineGraphicElement.widthPropertyDefinition
      };
      
      static const _imageMiscDescription:Object = {
         "src":new StringProperty("src",null,false,null),
         "id":new StringProperty("id",null,false,null)
      };
      
      static const _classDescription:Object = {};
      
      private static var _fontImporter:FontImporter;
      
      private static var _fontMiscImporter:CaseInsensitiveTLFFormatImporter;
      
      private static var _textFormatImporter:TextFormatImporter;
      
      private static var _textFormatMiscImporter:CaseInsensitiveTLFFormatImporter;
      
      private static var _paragraphFormatImporter:HtmlCustomParaFormatImporter;
      
      private static var _linkHrefImporter:CaseInsensitiveTLFFormatImporter;
      
      private static var _linkTargetImporter:CaseInsensitiveTLFFormatImporter;
      
      private static var _ilgFormatImporter:CaseInsensitiveTLFFormatImporter;
      
      private static var _ilgMiscFormatImporter:CaseInsensitiveTLFFormatImporter;
      
      private static var _classImporter:CaseInsensitiveTLFFormatImporter;
      
      private static var _activeFormat:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder();
      
      private static var _activeParaFormat:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder();
      
      private static var _activeImpliedParaFormat:TextLayoutFormatValueHolder = null;
      
      private static var _baseFontSize:Number;
      
      private static var stripRegex:RegExp = /<!--.*?-->|<\?(".*?"|'.*?'|[^>"']+)*>|<!(".*?"|'.*?'|[^>"']+)*>/sg;
      
      private static var tagRegex:RegExp = /<(\/?)(\w+)((?:\s+\w+(?:\s*=\s*(?:".*?"|'.*?'|[\w\.]+))?)*)\s*(\/?)>/sg;
      
      private static var attrRegex:RegExp = /\s+(\w+)(?:\s*=\s*(".*?"|'.*?'|[\w\.]+))?/sg;
      
      private static const anyPrintChar:RegExp = /[^\t\n\r ]/g;
       
      
      function HtmlImporter(param1:IConfiguration)
      {
         super(param1,null,createConfig());
      }
      
      private static function createConfig() : ImportExportConfiguration
      {
         var _loc1_:ImportExportConfiguration = new ImportExportConfiguration();
         _loc1_.addIEInfo("br",BreakElement,BaseTextLayoutImporter.parseBreak,null,false);
         _loc1_.addIEInfo("p",ParagraphElement,HtmlImporter.parsePara,null,true);
         _loc1_.addIEInfo("span",SpanElement,HtmlImporter.parseSpan,null,false);
         _loc1_.addIEInfo("a",LinkElement,HtmlImporter.parseLink,null,false);
         _loc1_.addIEInfo("img",InlineGraphicElement,HtmlImporter.parseInlineGraphic,null,false);
         _loc1_.addIEInfo("font",null,HtmlImporter.parseFont,null,false);
         _loc1_.addIEInfo("textformat",null,HtmlImporter.parseTextFormat,null,false);
         _loc1_.addIEInfo("u",null,HtmlImporter.parseUnderline,null,false);
         _loc1_.addIEInfo("i",null,HtmlImporter.parseItalic,null,false);
         _loc1_.addIEInfo("b",null,HtmlImporter.parseBold,null,false);
         if(_classDescription["class"] === undefined)
         {
            _classDescription["class"] = new StringProperty("class",null,false,null);
            _paragraphFormatImporter = new HtmlCustomParaFormatImporter(TextLayoutFormat,_paragraphFormatDescription);
            _textFormatImporter = new TextFormatImporter(TextLayoutFormat,_textFormatDescription);
            _fontImporter = new FontImporter(TextLayoutFormat,_fontDescription);
            _fontMiscImporter = new CaseInsensitiveTLFFormatImporter(Dictionary,_fontMiscDescription);
            _textFormatMiscImporter = new CaseInsensitiveTLFFormatImporter(Dictionary,_textFormatMiscDescription);
            _linkHrefImporter = new CaseInsensitiveTLFFormatImporter(Dictionary,_linkHrefDescription,false);
            _linkTargetImporter = new CaseInsensitiveTLFFormatImporter(Dictionary,_linkTargetDescription);
            _ilgFormatImporter = new CaseInsensitiveTLFFormatImporter(Dictionary,_imageDescription);
            _ilgMiscFormatImporter = new CaseInsensitiveTLFFormatImporter(Dictionary,_imageMiscDescription,false);
            _classImporter = new CaseInsensitiveTLFFormatImporter(Dictionary,_classDescription);
         }
         return _loc1_;
      }
      
      public static function parsePara(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc5_:XML = null;
         var _loc4_:ParagraphElement = (param1 as HtmlImporter).createParagraphFromXML(param2);
         if(param1.addChild(param3,_loc4_))
         {
            _loc5_ = getSingleFontChild(param2);
            parseChildrenUnderNewActiveFormat(param1,!!_loc5_?_loc5_:param2,_loc4_,_activeFormat,null);
            if(_loc4_.numChildren == 0)
            {
               _loc4_.addChild(new SpanElement());
            }
         }
         replaceBreakElementsWithParaSplits(_loc4_);
      }
      
      private static function getSingleFontChild(param1:XML) : XML
      {
         var _loc3_:XML = null;
         var _loc2_:XMLList = param1.children();
         if(_loc2_.length() == 1)
         {
            _loc3_ = _loc2_[0];
            if(_loc3_.name().localName.toLowerCase() == "font")
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function parseLink(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:LinkElement = HtmlImporter(param1).createLinkFromXML(param2);
         if(param1.addChild(param3,_loc4_))
         {
            parseChildrenUnderNewActiveFormat(param1,param2,_loc4_,_activeFormat,null);
            if(_loc4_.numChildren == 0)
            {
               _loc4_.addChild(new SpanElement());
            }
         }
      }
      
      public static function parseSpan(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc7_:XML = null;
         var _loc8_:String = null;
         var _loc9_:SpanElement = null;
         var _loc4_:SpanElement = new SpanElement();
         var _loc5_:Array = [_classImporter];
         param1.parseAttributes(param2,_loc5_);
         _loc4_.styleName = _classImporter.getFormatValue("class");
         _loc4_.format = _activeFormat;
         var _loc6_:XMLList = param2[0].children();
         if(_loc6_.length() == 0)
         {
            param1.addChild(param3,_loc4_);
            return;
         }
         for each(_loc7_ in _loc6_)
         {
            _loc8_ = !!_loc7_.name()?_loc7_.name().localName:null;
            if(_loc8_ == null)
            {
               if(_loc4_.parent == null)
               {
                  _loc4_.text = _loc7_.toString();
                  param1.addChild(param3,_loc4_);
               }
               else
               {
                  _loc9_ = new SpanElement();
                  copyAllStyleProps(_loc9_,_loc4_);
                  _loc9_.text = _loc7_.toString();
                  param1.addChild(param3,_loc9_);
               }
            }
            else
            {
               param1.parseObject(_loc8_,_loc7_,param3);
            }
         }
      }
      
      public static function parseInlineGraphic(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:InlineGraphicElement = HtmlImporter(param1).createInlineGraphicFromXML(param2);
         param1.addChild(param3,_loc4_);
      }
      
      public static function parseFont(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:ITextLayoutFormat = (param1 as HtmlImporter).parseFontAttributes(param2);
         parseChildrenUnderNewActiveFormatWithImpliedParaFormat(param1,param2,param3,_loc4_);
      }
      
      public static function parseTextFormat(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc7_:Number = NaN;
         var _loc4_:Array = [_textFormatImporter,_textFormatMiscImporter];
         param1.parseAttributes(param2,_loc4_);
         var _loc5_:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder(_textFormatImporter.result as ITextLayoutFormat);
         var _loc6_:String = _textFormatMiscImporter.getFormatValue("blockIndent");
         if(_loc6_)
         {
            _loc7_ = TextLayoutFormat.paragraphStartIndentProperty.setHelper(NaN,_loc6_);
            if(!isNaN(_loc7_))
            {
               _loc5_.paragraphStartIndent = _loc5_.paragraphStartIndent === undefined?_loc7_:_loc5_.paragraphStartIndent + _loc7_;
            }
         }
         parseChildrenUnderNewActiveFormat(param1,param2,param3,_activeParaFormat,_loc5_,true);
      }
      
      public static function parseBold(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder();
         _loc4_.fontWeight = FontWeight.BOLD;
         parseChildrenUnderNewActiveFormatWithImpliedParaFormat(param1,param2,param3,_loc4_);
      }
      
      public static function parseItalic(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder();
         _loc4_.fontStyle = FontPosture.ITALIC;
         parseChildrenUnderNewActiveFormatWithImpliedParaFormat(param1,param2,param3,_loc4_);
      }
      
      public static function parseUnderline(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder();
         _loc4_.textDecoration = TextDecoration.UNDERLINE;
         parseChildrenUnderNewActiveFormatWithImpliedParaFormat(param1,param2,param3,_loc4_);
      }
      
      private static function parseChildrenUnderNewActiveFormatWithImpliedParaFormat(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement, param4:ITextLayoutFormat) : void
      {
         var importFilter:BaseTextLayoutImporter = param1;
         var xmlToParse:XML = param2;
         var parent:FlowGroupElement = param3;
         var newFormat:ITextLayoutFormat = param4;
         var oldActiveImpliedParaFormat:TextLayoutFormatValueHolder = _activeImpliedParaFormat;
         if(_activeImpliedParaFormat == null)
         {
            _activeImpliedParaFormat = new TextLayoutFormatValueHolder(_activeFormat);
         }
         try
         {
            parseChildrenUnderNewActiveFormat(importFilter,xmlToParse,parent,_activeFormat,newFormat,true);
            return;
         }
         finally
         {
            _activeImpliedParaFormat = oldActiveImpliedParaFormat;
         }
      }
      
      private static function parseChildrenUnderNewActiveFormat(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement, param4:TextLayoutFormatValueHolder, param5:ITextLayoutFormat, param6:Boolean = false) : void
      {
         var importFilter:BaseTextLayoutImporter = param1;
         var xmlToParse:XML = param2;
         var parent:FlowGroupElement = param3;
         var currFormat:TextLayoutFormatValueHolder = param4;
         var newFormat:ITextLayoutFormat = param5;
         var chainedParent:Boolean = param6;
         var restoreBaseFontSize:Number = _baseFontSize;
         var restoreCoreStyles:Object = Property.shallowCopy(currFormat.coreStyles);
         if(newFormat)
         {
            if(newFormat.fontSize !== undefined)
            {
               _baseFontSize = newFormat.fontSize;
            }
            currFormat.apply(newFormat);
         }
         else
         {
            currFormat.coreStyles = null;
         }
         try
         {
            importFilter.parseFlowGroupElementChildren(xmlToParse,parent,null,chainedParent);
            return;
         }
         finally
         {
            currFormat.coreStyles = restoreCoreStyles;
            _baseFontSize = restoreBaseFontSize;
         }
      }
      
      private static function replaceBreakElementsWithParaSplits(param1:ParagraphElement) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:FlowGroupElement = null;
         var _loc5_:FlowLeafElement = param1.getFirstLeaf();
         while(_loc5_)
         {
            if(!(_loc5_ is BreakElement))
            {
               _loc5_ = _loc5_.getNextLeaf(param1);
            }
            else
            {
               if(!_loc2_)
               {
                  _loc2_ = [param1];
                  _loc4_ = param1.parent;
                  _loc3_ = _loc4_.getChildIndex(param1);
                  _loc4_.removeChildAt(_loc3_);
               }
               param1 = param1.splitAtPosition(_loc5_.getAbsoluteStart() + _loc5_.textLength) as ParagraphElement;
               _loc2_.push(param1);
               _loc5_.parent.removeChild(_loc5_);
               _loc5_ = param1.getFirstLeaf();
            }
         }
         if(_loc2_)
         {
            _loc4_.replaceChildren(_loc3_,_loc3_,_loc2_);
         }
      }
      
      override protected function importFromString(param1:String) : TextFlow
      {
         var _loc2_:XML = this.toXML(param1);
         return !!_loc2_?this.importFromXML(_loc2_):null;
      }
      
      override protected function importFromXML(param1:XML) : TextFlow
      {
         var _loc2_:TextFlow = new TextFlow(_textFlowConfiguration);
         _baseFontSize = _loc2_.fontSize === undefined?Number(12):Number(_loc2_.fontSize);
         this.parseObject(param1.name().localName,param1,_loc2_);
         resetImpliedPara();
         _loc2_.normalize();
         _loc2_.applyWhiteSpaceCollapse(null);
         return _loc2_;
      }
      
      override protected function clear() : void
      {
         _activeParaFormat.coreStyles = null;
         _activeFormat.coreStyles = null;
         super.clear();
      }
      
      override tlf_internal function createImpliedParagraph() : ParagraphElement
      {
         var rslt:ParagraphElement = null;
         var savedActiveFormat:TextLayoutFormatValueHolder = _activeFormat;
         if(_activeImpliedParaFormat)
         {
            _activeFormat = _activeImpliedParaFormat;
         }
         try
         {
            rslt = super.createImpliedParagraph();
         }
         finally
         {
            _activeFormat = savedActiveFormat;
         }
         return rslt;
      }
      
      override public function createParagraphFromXML(param1:XML) : ParagraphElement
      {
         var _loc2_:ParagraphElement = new ParagraphElement();
         var _loc3_:Array = [_paragraphFormatImporter,_classImporter];
         parseAttributes(param1,_loc3_);
         var _loc4_:TextLayoutFormat = new TextLayoutFormat(_paragraphFormatImporter.result as ITextLayoutFormat);
         if(_activeParaFormat)
         {
            _loc4_.apply(_activeParaFormat);
         }
         if(_activeFormat)
         {
            _loc4_.apply(_activeFormat);
         }
         var _loc5_:XML = getSingleFontChild(param1);
         if(_loc5_)
         {
            _loc4_.apply(this.parseFontAttributes(_loc5_));
         }
         if(_loc4_.lineHeight !== undefined)
         {
            _loc4_.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;
         }
         _loc2_.format = _loc4_;
         _loc2_.styleName = _classImporter.getFormatValue("class");
         return _loc2_;
      }
      
      override protected function onResetImpliedPara(param1:ParagraphElement) : void
      {
         replaceBreakElementsWithParaSplits(param1);
      }
      
      private function createLinkFromXML(param1:XML) : LinkElement
      {
         var _loc2_:LinkElement = new LinkElement();
         var _loc3_:Array = [_linkHrefImporter,_linkTargetImporter];
         parseAttributes(param1,_loc3_);
         _loc2_.href = _linkHrefImporter.getFormatValue("href");
         _loc2_.target = _linkTargetImporter.getFormatValue("target");
         if(!_loc2_.target)
         {
            _loc2_.target = "_self";
         }
         _loc2_.format = _activeFormat;
         return _loc2_;
      }
      
      private function createInlineGraphicFromXML(param1:XML) : InlineGraphicElement
      {
         var _loc2_:InlineGraphicElement = new InlineGraphicElement();
         var _loc3_:Array = [_ilgFormatImporter,_ilgMiscFormatImporter];
         parseAttributes(param1,_loc3_);
         var _loc4_:String = _ilgMiscFormatImporter.getFormatValue("src");
         _loc2_.source = _loc4_;
         _loc2_.height = InlineGraphicElement.heightPropertyDefinition.setHelper(_loc2_.height,_ilgFormatImporter.getFormatValue("height"));
         _loc2_.width = InlineGraphicElement.heightPropertyDefinition.setHelper(_loc2_.width,_ilgFormatImporter.getFormatValue("width"));
         var _loc5_:String = _ilgMiscFormatImporter.getFormatValue("id");
         _loc2_.id = _loc5_;
         _loc2_.format = _activeFormat;
         return _loc2_;
      }
      
      override public function createTabFromXML(param1:XML) : TabElement
      {
         return null;
      }
      
      private function parseFontAttributes(param1:XML) : ITextLayoutFormat
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:Array = [_fontImporter,_fontMiscImporter];
         parseAttributes(param1,_loc2_);
         var _loc3_:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder(_fontImporter.result as ITextLayoutFormat);
         var _loc4_:String = _fontMiscImporter.getFormatValue("kerning");
         if(_loc4_)
         {
            _loc6_ = Number(_loc4_);
            _loc3_.kerning = _loc6_ == 0?Kerning.OFF:Kerning.AUTO;
         }
         var _loc5_:String = _fontMiscImporter.getFormatValue("size");
         if(_loc5_)
         {
            _loc7_ = TextLayoutFormat.fontSizeProperty.setHelper(NaN,_loc5_);
            if(!isNaN(_loc7_))
            {
               if(_loc5_.search(/\s*(-|\+)/) != -1)
               {
                  _loc7_ = _loc7_ + _baseFontSize;
               }
               _loc3_.fontSize = _loc7_;
            }
         }
         return _loc3_;
      }
      
      override protected function handleUnknownAttribute(param1:String, param2:String) : void
      {
      }
      
      override protected function handleUnknownElement(param1:String, param2:XML, param3:FlowGroupElement) : void
      {
         parseFlowGroupElementChildren(param2,param3,null,true);
      }
      
      override tlf_internal function parseObject(param1:String, param2:XML, param3:FlowGroupElement, param4:Object = null) : void
      {
         super.parseObject(param1.toLowerCase(),param2,param3,param4);
      }
      
      override protected function checkNamespace(param1:XML) : Boolean
      {
         return true;
      }
      
      private function toXML(param1:String) : XML
      {
         var xml:XML = null;
         var source:String = param1;
         var originalSettings:Object = XML.settings();
         try
         {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            xml = this.toXMLInternal(source);
         }
         finally
         {
            XML.setSettings(originalSettings);
         }
         return xml;
      }
      
      private function toXMLInternal(param1:String) : XML
      {
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:* = null;
         var _loc8_:* = false;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:* = false;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:XML = null;
         param1 = param1.replace(stripRegex,"");
         var _loc2_:XML = <html/>;
         var _loc3_:XML = _loc2_;
         var _loc4_:int = tagRegex.lastIndex = 0;
         do
         {
            _loc6_ = tagRegex.exec(param1);
            if(!_loc6_)
            {
               this.appendTextChild(_loc3_,param1.substring(_loc4_));
               break;
            }
            if(_loc6_.index != _loc4_)
            {
               this.appendTextChild(_loc3_,param1.substring(_loc4_,_loc6_.index));
            }
            _loc7_ = _loc6_[0];
            _loc8_ = _loc6_[1] == "/";
            _loc9_ = _loc6_[2].toLowerCase();
            _loc10_ = _loc6_[3];
            _loc11_ = _loc6_[4] == "/";
            if(!_loc8_)
            {
               if(_loc9_ == "p" && _loc3_.name().localName == "p")
               {
                  _loc3_ = _loc3_.parent();
               }
               _loc7_ = "<" + _loc9_;
               while(true)
               {
                  _loc12_ = attrRegex.exec(_loc10_);
                  if(!_loc12_)
                  {
                     break;
                  }
                  _loc13_ = _loc12_[1].toLowerCase();
                  _loc7_ = _loc7_ + (" " + _loc13_ + "=");
                  _loc14_ = !!_loc12_[2]?_loc12_[2]:_loc13_;
                  _loc15_ = _loc14_.charAt(0);
                  _loc7_ = _loc7_ + (_loc15_ == "\'" || _loc15_ == "\""?_loc14_:"\"" + _loc14_ + "\"");
               }
               _loc7_ = _loc7_ + "/>";
               _loc3_.appendChild(new XML(_loc7_));
               if(!_loc11_ && !this.doesStartTagCloseElement(_loc9_))
               {
                  _loc3_ = _loc3_.children()[_loc3_.children().length() - 1];
               }
            }
            else if(_loc11_ || _loc10_.length)
            {
               reportError(GlobalSettings.resourceStringFunction("malformedTag",[_loc7_]));
            }
            else
            {
               _loc16_ = _loc3_;
               do
               {
                  _loc5_ = _loc16_.name().localName;
                  _loc16_ = _loc16_.parent();
                  if(_loc5_ == _loc9_)
                  {
                     _loc3_ = _loc16_;
                     break;
                  }
               }
               while(_loc16_);
               
            }
            _loc4_ = tagRegex.lastIndex;
            if(_loc4_ == param1.length)
            {
               break;
            }
         }
         while(_loc3_);
         
         return _loc2_;
      }
      
      private function doesStartTagCloseElement(param1:String) : Boolean
      {
         switch(param1)
         {
            case "br":
            case "img":
               return true;
            default:
               return false;
         }
      }
      
      private function appendTextChild(param1:XML, param2:String) : void
      {
         var xml:XML = null;
         var parent:XML = param1;
         var text:String = param2;
         var parentIsSpan:Boolean = parent.localName() == "span";
         var elemName:String = !!parentIsSpan?"dummy":"span";
         var xmlText:String = "<" + elemName + ">" + text + "</" + elemName + ">";
         try
         {
            xml = new XML(xmlText);
            parent.appendChild(!!parentIsSpan?xml.children()[0]:xml);
            return;
         }
         catch(e:*)
         {
            reportError(GlobalSettings.resourceStringFunction("malformedMarkup",[text]));
            return;
         }
      }
   }
}

import flashx.textLayout.conversion.TLFormatImporter;

class CaseInsensitiveTLFFormatImporter extends TLFormatImporter
{
    
   
   private var _convertValuesToLowerCase:Boolean;
   
   function CaseInsensitiveTLFFormatImporter(param1:Class, param2:Object, param3:Boolean = true)
   {
      var _loc5_:* = null;
      this._convertValuesToLowerCase = param3;
      var _loc4_:Object = new Object();
      for(_loc5_ in param2)
      {
         _loc4_[_loc5_.toLowerCase()] = param2[_loc5_];
      }
      super(param1,_loc4_);
   }
   
   override public function importOneFormat(param1:String, param2:String) : Boolean
   {
      return super.importOneFormat(param1.toLowerCase(),!!this._convertValuesToLowerCase?param2.toLowerCase():param2);
   }
   
   public function getFormatValue(param1:String) : *
   {
      return !!result?result[param1.toLowerCase()]:undefined;
   }
}

import flashx.textLayout.conversion.TLFormatImporter;

class HtmlCustomParaFormatImporter extends TLFormatImporter
{
    
   
   function HtmlCustomParaFormatImporter(param1:Class, param2:Object)
   {
      super(param1,param2);
   }
   
   override public function importOneFormat(param1:String, param2:String) : Boolean
   {
      param1 = param1.toLowerCase();
      if(param1 == "align")
      {
         param1 = "textAlign";
      }
      return super.importOneFormat(param1,param2.toLowerCase());
   }
}

import flashx.textLayout.conversion.TLFormatImporter;

class TextFormatImporter extends TLFormatImporter
{
    
   
   function TextFormatImporter(param1:Class, param2:Object)
   {
      super(param1,param2);
   }
   
   override public function importOneFormat(param1:String, param2:String) : Boolean
   {
      param1 = param1.toLowerCase();
      if(param1 == "leftmargin")
      {
         param1 = "paragraphStartIndent";
      }
      else if(param1 == "rightmargin")
      {
         param1 = "paragraphEndIndent";
      }
      else if(param1 == "indent")
      {
         param1 = "textIndent";
      }
      else if(param1 == "leading")
      {
         param1 = "lineHeight";
      }
      else if(param1 == "tabstops")
      {
         param1 = "tabStops";
         param2 = param2.replace(/,/g," ");
      }
      return super.importOneFormat(param1,param2);
   }
}

import flashx.textLayout.conversion.TLFormatImporter;

class FontImporter extends TLFormatImporter
{
    
   
   function FontImporter(param1:Class, param2:Object)
   {
      super(param1,param2);
   }
   
   override public function importOneFormat(param1:String, param2:String) : Boolean
   {
      param1 = param1.toLowerCase();
      if(param1 == "letterspacing")
      {
         param1 = "trackingRight";
      }
      else if(param1 == "face")
      {
         param1 = "fontFamily";
      }
      return super.importOneFormat(param1,param2);
   }
}
