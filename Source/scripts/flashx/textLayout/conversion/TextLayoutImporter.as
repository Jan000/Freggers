package flashx.textLayout.conversion
{
   import flash.utils.Dictionary;
   import flashx.textLayout.elements.BreakElement;
   import flashx.textLayout.elements.DivElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TabElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormatValueHolder;
   import flashx.textLayout.property.StringProperty;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TextLayoutImporter extends BaseTextLayoutImporter
   {
      
      private static var _defaultConfiguration:ImportExportConfiguration;
      
      private static const _formatImporter:TLFormatImporter = new TLFormatImporter(TextLayoutFormatValueHolder,TextLayoutFormat.description);
      
      private static const _idImporter:SingletonAttributeImporter = new SingletonAttributeImporter("id");
      
      private static const _styleNameImporter:SingletonAttributeImporter = new SingletonAttributeImporter("styleName");
      
      private static const _customFormatImporter:CustomFormatImporter = new CustomFormatImporter();
      
      private static const _flowElementFormatImporters:Array = [_formatImporter,_idImporter,_styleNameImporter,_customFormatImporter];
      
      static const _linkDescription:Object = {
         "href":new StringProperty("href",null,false,null),
         "target":new StringProperty("target",null,false,null)
      };
      
      private static const _linkFormatImporter:TLFormatImporter = new TLFormatImporter(Dictionary,_linkDescription);
      
      private static const _linkElementFormatImporters:Array = [_linkFormatImporter,_formatImporter,_idImporter,_styleNameImporter,_customFormatImporter];
      
      private static const _imageDescription:Object = {
         "height":InlineGraphicElement.heightPropertyDefinition,
         "width":InlineGraphicElement.widthPropertyDefinition,
         "source":new StringProperty("source",null,false,null),
         "float":new StringProperty("float",null,false,null),
         "rotation":InlineGraphicElement.rotationPropertyDefinition
      };
      
      private static const _ilgFormatImporter:TLFormatImporter = new TLFormatImporter(Dictionary,_imageDescription);
      
      private static const _ilgElementFormatImporters:Array = [_ilgFormatImporter,_formatImporter,_idImporter,_styleNameImporter,_customFormatImporter];
       
      
      protected var bindingsArray:Array;
      
      public function TextLayoutImporter(param1:IConfiguration)
      {
         super(param1,flowNS,defaultConfiguration);
      }
      
      public static function get defaultConfiguration() : ImportExportConfiguration
      {
         if(!_defaultConfiguration)
         {
            _defaultConfiguration = new ImportExportConfiguration();
            _defaultConfiguration.addIEInfo("TextFlow",TextFlow,BaseTextLayoutImporter.parseTextFlow,BaseTextLayoutExporter.exportTextFlow,true);
            _defaultConfiguration.addIEInfo("br",BreakElement,BaseTextLayoutImporter.parseBreak,BaseTextLayoutExporter.exportFlowElement,false);
            _defaultConfiguration.addIEInfo("p",ParagraphElement,BaseTextLayoutImporter.parsePara,BaseTextLayoutExporter.exportParagraphFormattedElement,true);
            _defaultConfiguration.addIEInfo("span",SpanElement,BaseTextLayoutImporter.parseSpan,BaseTextLayoutExporter.exportSpan,false);
            _defaultConfiguration.addIEInfo("tab",TabElement,BaseTextLayoutImporter.parseTab,BaseTextLayoutExporter.exportFlowElement,false);
            _defaultConfiguration.addIEInfo("tcy",TCYElement,TextLayoutImporter.parseTCY,TextLayoutExporter.exportTCY,false);
            _defaultConfiguration.addIEInfo("a",LinkElement,TextLayoutImporter.parseLink,TextLayoutExporter.exportLink,false);
            _defaultConfiguration.addIEInfo("div",DivElement,TextLayoutImporter.parseDivElement,TextLayoutExporter.exportDiv,true);
            _defaultConfiguration.addIEInfo("img",InlineGraphicElement,TextLayoutImporter.parseInlineGraphic,TextLayoutExporter.exportImage,false);
            _defaultConfiguration.addIEInfo(LinkElement.LINK_NORMAL_FORMAT_NAME,null,TextLayoutImporter.parseLinkNormalFormat,null,false);
            _defaultConfiguration.addIEInfo(LinkElement.LINK_ACTIVE_FORMAT_NAME,null,TextLayoutImporter.parseLinkActiveFormat,null,false);
            _defaultConfiguration.addIEInfo(LinkElement.LINK_HOVER_FORMAT_NAME,null,TextLayoutImporter.parseLinkHoverFormat,null,false);
         }
         return _defaultConfiguration;
      }
      
      public static function restoreDefaults() : void
      {
         _defaultConfiguration = null;
      }
      
      private static function get flowNS() : Namespace
      {
         return new Namespace("flow","http://ns.adobe.com/textLayout/2008");
      }
      
      private static function arrayHasString(param1:Array, param2:String) : Boolean
      {
         var _loc3_:String = null;
         for each(_loc3_ in param1)
         {
            if(param2 == _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function parseTCY(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:TCYElement = TextLayoutImporter(param1).createTCYFromXML(param2);
         if(param1.addChild(param3,_loc4_))
         {
            param1.parseFlowGroupElementChildren(param2,_loc4_);
            if(_loc4_.numChildren == 0)
            {
               _loc4_.addChild(new SpanElement());
            }
         }
      }
      
      public static function parseLink(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:LinkElement = TextLayoutImporter(param1).createLinkFromXML(param2);
         if(param1.addChild(param3,_loc4_))
         {
            param1.parseFlowGroupElementChildren(param2,_loc4_);
            if(_loc4_.numChildren == 0)
            {
               _loc4_.addChild(new SpanElement());
            }
         }
      }
      
      public static function parseLinkNormalFormat(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         param3.linkNormalFormat = TextLayoutImporter(param1).createDictionaryFromXML(param2);
      }
      
      public static function parseLinkActiveFormat(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         param3.linkActiveFormat = TextLayoutImporter(param1).createDictionaryFromXML(param2);
      }
      
      public static function parseLinkHoverFormat(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         param3.linkHoverFormat = TextLayoutImporter(param1).createDictionaryFromXML(param2);
      }
      
      public static function parseDivElement(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:DivElement = TextLayoutImporter(param1).createDivFromXML(param2);
         if(param1.addChild(param3,_loc4_))
         {
            param1.parseFlowGroupElementChildren(param2,_loc4_);
            if(_loc4_.numChildren == 0)
            {
               _loc4_.addChild(new ParagraphElement());
            }
         }
      }
      
      public static function parseInlineGraphic(param1:BaseTextLayoutImporter, param2:XML, param3:FlowGroupElement) : void
      {
         var _loc4_:InlineGraphicElement = TextLayoutImporter(param1).createInlineGraphicFromXML(param2);
         param1.addChild(param3,_loc4_);
      }
      
      override protected function clear() : void
      {
         this.bindingsArray = null;
         super.clear();
      }
      
      override protected function parseContent(param1:XML) : TextFlow
      {
         var _loc2_:String = param1.name().localName;
         var _loc3_:XML = _loc2_ == "TextFlow"?param1:param1..TextFlow[0];
         if(!_loc3_)
         {
            reportError(GlobalSettings.resourceStringFunction("missingTextFlow"));
            return null;
         }
         if(!checkNamespace(_loc3_))
         {
            return null;
         }
         return parseTextFlow(this,_loc3_);
      }
      
      private function parseStandardFlowElementAttributes(param1:FlowElement, param2:XML, param3:Array = null) : void
      {
         if(param3 == null)
         {
            param3 = _flowElementFormatImporters;
         }
         parseAttributes(param2,param3);
         param1.format = this.extractTextFormatAttributesHelper(param1.format,_formatImporter) as ITextLayoutFormat;
         param1.id = _idImporter.result as String;
         param1.styleName = _styleNameImporter.result as String;
         param1.userStyles = _customFormatImporter.result as Dictionary;
      }
      
      override public function createTextFlowFromXML(param1:XML, param2:TextFlow = null) : TextFlow
      {
         var _loc4_:String = null;
         var _loc3_:TextFlow = null;
         if(param1["id"] != undefined)
         {
            _loc4_ = null;
            _loc4_ = param1["id"];
            _loc3_ = this.getBoundObjNamed(_loc4_,TextFlow) as TextFlow;
         }
         if(!checkNamespace(param1))
         {
            return _loc3_;
         }
         if(!_loc3_)
         {
            _loc3_ = new TextFlow(_textFlowConfiguration);
         }
         this.parseStandardFlowElementAttributes(_loc3_,param1);
         parseFlowGroupElementChildren(param1,_loc3_);
         _loc3_.normalize();
         _loc3_.applyWhiteSpaceCollapse(null);
         return _loc3_;
      }
      
      public function createDivFromXML(param1:XML) : DivElement
      {
         var _loc2_:DivElement = new DivElement();
         this.parseStandardFlowElementAttributes(_loc2_,param1);
         return _loc2_;
      }
      
      override public function createParagraphFromXML(param1:XML) : ParagraphElement
      {
         var _loc2_:ParagraphElement = new ParagraphElement();
         this.parseStandardFlowElementAttributes(_loc2_,param1);
         return _loc2_;
      }
      
      public function createTCYFromXML(param1:XML) : TCYElement
      {
         var _loc2_:TCYElement = new TCYElement();
         this.parseStandardFlowElementAttributes(_loc2_,param1);
         return _loc2_;
      }
      
      public function createLinkFromXML(param1:XML) : LinkElement
      {
         var _loc2_:LinkElement = new LinkElement();
         this.parseStandardFlowElementAttributes(_loc2_,param1,_linkElementFormatImporters);
         if(_linkFormatImporter.result)
         {
            _loc2_.href = _linkFormatImporter.result["href"] as String;
            _loc2_.target = _linkFormatImporter.result["target"] as String;
         }
         return _loc2_;
      }
      
      override public function createSpanFromXML(param1:XML) : SpanElement
      {
         var _loc2_:SpanElement = new SpanElement();
         this.parseStandardFlowElementAttributes(_loc2_,param1);
         return _loc2_;
      }
      
      public function createInlineGraphicFromXML(param1:XML) : InlineGraphicElement
      {
         var _loc3_:String = null;
         var _loc2_:InlineGraphicElement = new InlineGraphicElement();
         this.parseStandardFlowElementAttributes(_loc2_,param1,_ilgElementFormatImporters);
         if(_ilgFormatImporter.result)
         {
            _loc3_ = _ilgFormatImporter.result["source"];
            _loc2_.source = _loc3_;
            _loc2_.height = InlineGraphicElement.heightPropertyDefinition.setHelper(_loc2_.height,_ilgFormatImporter.result["height"]);
            _loc2_.width = InlineGraphicElement.widthPropertyDefinition.setHelper(_loc2_.width,_ilgFormatImporter.result["width"]);
            _loc2_.float = InlineGraphicElement.floatPropertyDefinition.setHelper(_loc2_.float,_ilgFormatImporter.result["float"]);
         }
         return _loc2_;
      }
      
      public function extractTextFormatAttributesHelper(param1:Object, param2:TLFormatImporter) : Object
      {
         return extractAttributesHelper(param1,param2);
      }
      
      protected function parseNamedFormatDefinition(param1:XML, param2:TLFormatImporter) : void
      {
         var _loc4_:XML = null;
         if(!checkNamespace(param1))
         {
            return;
         }
         var _loc3_:String = param1.@id.toString();
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return;
         }
         param2.reset();
         for each(_loc4_ in param1.attributes())
         {
            param2.importOneFormat(_loc4_.name().localName,_loc4_.toString());
         }
         if(!this.bindingsArray)
         {
            this.bindingsArray = new Array();
         }
         this.bindingsArray[_loc3_] = !!param2.result?param2.result:new param2.classType();
      }
      
      function getBoundObjNamed(param1:String, param2:Class) : Object
      {
         if(!this.bindingsArray)
         {
            this.bindingsArray = new Array();
         }
         if(this.bindingsArray[param1] == null)
         {
            if(param2 == TextFlow)
            {
               this.bindingsArray[param1] = new param2(this._textFlowConfiguration);
            }
            else
            {
               this.bindingsArray[param1] = new param2();
            }
         }
         return this.bindingsArray[param1];
      }
      
      public function createDictionaryFromXML(param1:XML) : Dictionary
      {
         var _loc7_:* = null;
         var _loc8_:* = undefined;
         var _loc2_:Array = [_customFormatImporter];
         var _loc3_:XMLList = param1..TextLayoutFormat;
         if(_loc3_.length() != 1)
         {
            reportError(GlobalSettings.resourceStringFunction("expectedExactlyOneTextLayoutFormat",[param1.name()]));
         }
         var _loc4_:XML = _loc3_.length() > 0?_loc3_[0]:param1;
         parseAttributes(_loc4_,_loc2_);
         var _loc5_:Dictionary = _customFormatImporter.result as Dictionary;
         var _loc6_:Object = TextLayoutFormat.description;
         for(_loc7_ in _loc6_)
         {
            _loc8_ = _loc5_[_loc7_];
            if(_loc8_ !== undefined)
            {
               _loc8_ = _loc6_[_loc7_].setHelper(undefined,_loc8_);
               if(_loc8_ !== undefined)
               {
                  _loc5_[_loc7_] = _loc8_;
               }
            }
         }
         return _loc5_;
      }
   }
}
