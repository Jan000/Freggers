package flashx.textLayout.elements
{
   import flash.display.DisplayObjectContainer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.events.ModelChange;
   import flashx.textLayout.formats.FlowElementDisplayType;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormatValueHolder;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   [IMXMLObject]
   public class FlowElement implements ITextLayoutFormat
   {
      
      private static const idString:String = "id";
      
      private static const styleNameString:String = "styleName";
      
      private static const impliedElementString:String = "impliedElement";
      
      tlf_internal static var _scratchTextLayoutFormat:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder();
      
      private static var defaultStylesPrototype:Object;
      
      private static function factory():void
      {
      }
      {
         createDefaultStylesPrototyope();
      }
      
      private var _parent:FlowGroupElement;
      
      tlf_internal var _formatValueHolder:FlowValueHolder;
      
      protected var _computedFormat:TextLayoutFormatValueHolder;
      
      private var _parentRelativeStart:int = 0;
      
      private var _textLength:int = 0;
      
      public function FlowElement()
      {
         super();
         if(this.abstract)
         {
            throw new Error(GlobalSettings.resourceStringFunction("invalidFlowElementConstruct"));
         }
      }
      
      private static function createDefaultStylesPrototyope() : void
      {
         defaultStylesPrototype = new Object();
         defaultStylesPrototype.hasNonInheritedStyles = false;
         defaultStylesPrototype.setPropertyIsEnumerable("hasNonInheritedStyles",false);
         Property.defaultsAllHelper(TextLayoutFormat.description,defaultStylesPrototype);
      }
      
      tlf_internal static function createTextLayoutFormatPrototype(param1:ITextLayoutFormat, param2:TextLayoutFormatValueHolder) : TextLayoutFormatValueHolder
      {
         var _loc5_:* = null;
         var _loc6_:* = undefined;
         var _loc7_:Property = null;
         var _loc11_:TextLayoutFormatValueHolder = null;
         var _loc12_:Object = null;
         var _loc3_:Object = !!param2?param2.coreStyles:defaultStylesPrototype;
         factory.prototype = _loc3_;
         var _loc4_:Object = new factory();
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = _loc3_.hasNonInheritedStyles;
         if(_loc9_)
         {
            TextLayoutFormatValueHolder.resetModifiedNoninheritedStyles(_loc4_);
         }
         if(param1 != null)
         {
            _loc11_ = param1 as TextLayoutFormatValueHolder;
            if(_loc11_)
            {
               _loc12_ = _loc11_.coreStyles;
               for(_loc5_ in _loc12_)
               {
                  _loc7_ = TextLayoutFormat.description[_loc5_];
                  _loc6_ = _loc12_[_loc5_];
                  if(_loc6_ == FormatValue.INHERIT)
                  {
                     if(param2)
                     {
                        if(!_loc7_.inherited)
                        {
                           _loc6_ = param2[_loc5_];
                           if(_loc4_[_loc5_] != _loc6_)
                           {
                              _loc4_[_loc5_] = _loc6_;
                              _loc8_ = true;
                           }
                        }
                     }
                  }
                  else if(_loc4_[_loc5_] != _loc6_)
                  {
                     if(!_loc7_.inherited)
                     {
                        _loc8_ = true;
                     }
                     _loc4_[_loc5_] = _loc6_;
                     _loc9_ = true;
                  }
               }
            }
            else
            {
               for each(_loc7_ in TextLayoutFormat.description)
               {
                  _loc5_ = _loc7_.name;
                  _loc6_ = param1[_loc5_];
                  if(_loc6_ !== undefined)
                  {
                     if(_loc6_ == FormatValue.INHERIT)
                     {
                        if(param2)
                        {
                           if(!_loc7_.inherited)
                           {
                              _loc6_ = param2[_loc5_];
                              if(_loc4_[_loc5_] != _loc6_)
                              {
                                 _loc4_[_loc5_] = _loc6_;
                                 _loc8_ = true;
                              }
                           }
                        }
                     }
                     else if(_loc4_[_loc5_] != _loc6_)
                     {
                        if(!_loc7_.inherited)
                        {
                           _loc8_ = true;
                        }
                        _loc4_[_loc5_] = _loc6_;
                        _loc9_ = true;
                     }
                  }
               }
            }
         }
         var _loc10_:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder();
         if(!_loc9_)
         {
            _loc10_.coreStyles = _loc3_;
         }
         else
         {
            if(_loc4_.hasNonInheritedStyles != _loc8_)
            {
               _loc4_.hasNonInheritedStyles = _loc8_;
               _loc4_.setPropertyIsEnumerable("hasNonInheritedStyles",false);
            }
            _loc10_.coreStyles = _loc4_;
         }
         return _loc10_;
      }
      
      public function initialized(param1:Object, param2:String) : void
      {
         this.id = param2;
      }
      
      protected function get abstract() : Boolean
      {
         return true;
      }
      
      public function get userStyles() : Object
      {
         var _loc1_:Object = this._formatValueHolder == null?null:this._formatValueHolder.userStyles;
         return !!_loc1_?Property.shallowCopy(_loc1_):null;
      }
      
      public function set userStyles(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         if(param1)
         {
            _loc2_ = new Object();
            for(_loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
         }
         this.writableTextLayoutFormatValueHolder().userStyles = _loc2_;
         this.modelChanged(ModelChange.USER_STYLE_CHANGED,0,this.textLength,true);
      }
      
      public function get coreStyles() : Object
      {
         var _loc1_:Object = this._formatValueHolder == null?null:this._formatValueHolder.coreStyles;
         return !!_loc1_?Property.shallowCopy(_loc1_):null;
      }
      
      tlf_internal function setCoreStylesInternal(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         if(param1)
         {
            _loc2_ = new Object();
            for(_loc3_ in param1)
            {
               _loc4_ = param1[_loc3_];
               if(_loc4_ != undefined)
               {
                  _loc2_[_loc3_] = _loc4_;
               }
            }
         }
         this.writableTextLayoutFormatValueHolder().coreStyles = _loc2_;
         this.formatChanged();
      }
      
      public function set linkNormalFormat(param1:*) : void
      {
         this.setStyle(LinkElement.LINK_NORMAL_FORMAT_NAME,param1);
      }
      
      public function get linkNormalFormat() : *
      {
         return this.getStyle(LinkElement.LINK_NORMAL_FORMAT_NAME);
      }
      
      public function set linkActiveFormat(param1:*) : void
      {
         this.setStyle(LinkElement.LINK_ACTIVE_FORMAT_NAME,param1);
      }
      
      public function get linkActiveFormat() : *
      {
         return this.getStyle(LinkElement.LINK_ACTIVE_FORMAT_NAME);
      }
      
      public function set linkHoverFormat(param1:*) : void
      {
         this.setStyle(LinkElement.LINK_HOVER_FORMAT_NAME,param1);
      }
      
      public function get linkHoverFormat() : *
      {
         return this.getStyle(LinkElement.LINK_HOVER_FORMAT_NAME);
      }
      
      public function equalUserStyles(param1:FlowElement) : Boolean
      {
         var _loc2_:Object = !!this._formatValueHolder?this._formatValueHolder.userStyles:null;
         var _loc3_:Object = !!param1._formatValueHolder?param1._formatValueHolder.userStyles:null;
         return Property.equalStyleObjects(_loc2_,_loc3_);
      }
      
      tlf_internal function equalStylesForMerge(param1:FlowElement) : Boolean
      {
         return this.id == param1.id && this.styleName == param1.styleName && TextLayoutFormat.isEqual(param1.format,this.format) && this.equalUserStyles(param1);
      }
      
      public function shallowCopy(param1:int = 0, param2:int = -1) : FlowElement
      {
         if(param2 == -1)
         {
            param2 = this.textLength;
         }
         var _loc3_:FlowElement = new (getDefinitionByName(getQualifiedClassName(this)) as Class)();
         _loc3_.styleName = this.styleName;
         _loc3_.id = this.id;
         if(this._formatValueHolder != null)
         {
            _loc3_._formatValueHolder = new FlowValueHolder(this._formatValueHolder);
         }
         return _loc3_;
      }
      
      public function deepCopy(param1:int = 0, param2:int = -1) : FlowElement
      {
         if(param2 == -1)
         {
            param2 = this.textLength;
         }
         return this.shallowCopy(param1,param2);
      }
      
      public function getText(param1:int = 0, param2:int = -1, param3:String = "\n") : String
      {
         return "";
      }
      
      public function splitAtPosition(param1:int) : FlowElement
      {
         if(param1 < 0 || param1 > this.textLength)
         {
            throw RangeError(GlobalSettings.resourceStringFunction("invalidSplitAtPosition"));
         }
         return this;
      }
      
      tlf_internal function get bindableElement() : Boolean
      {
         return this.getPrivateStyle("bindable") == true;
      }
      
      tlf_internal function set bindableElement(param1:Boolean) : void
      {
         this.setPrivateStyle("bindable",param1);
      }
      
      tlf_internal function mergeToPreviousIfPossible() : Boolean
      {
         return false;
      }
      
      tlf_internal function createContentElement() : void
      {
      }
      
      tlf_internal function releaseContentElement() : void
      {
      }
      
      tlf_internal function canReleaseContentElement() : Boolean
      {
         return true;
      }
      
      public function get parent() : FlowGroupElement
      {
         return this._parent;
      }
      
      tlf_internal function setParentAndRelativeStart(param1:FlowGroupElement, param2:int) : void
      {
         this._parent = param1;
         this._parentRelativeStart = param2;
         this.attributesChanged(false);
      }
      
      tlf_internal function setParentAndRelativeStartOnly(param1:FlowGroupElement, param2:int) : void
      {
         this._parent = param1;
         this._parentRelativeStart = param2;
      }
      
      public function get textLength() : int
      {
         return this._textLength;
      }
      
      tlf_internal function setTextLength(param1:int) : void
      {
         this._textLength = param1;
      }
      
      public function get parentRelativeStart() : int
      {
         return this._parentRelativeStart;
      }
      
      tlf_internal function setParentRelativeStart(param1:int) : void
      {
         this._parentRelativeStart = param1;
      }
      
      public function get parentRelativeEnd() : int
      {
         return this._parentRelativeStart + this._textLength;
      }
      
      tlf_internal function getAncestorWithContainer() : ContainerFormattedElement
      {
         var _loc2_:ContainerFormattedElement = null;
         var _loc1_:FlowElement = this;
         while(_loc1_)
         {
            _loc2_ = _loc1_ as ContainerFormattedElement;
            if(_loc2_)
            {
               if(!_loc2_._parent || _loc2_.flowComposer)
               {
                  return _loc2_;
               }
            }
            _loc1_ = _loc1_._parent;
         }
         return null;
      }
      
      tlf_internal function getPrivateStyle(param1:String) : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.getPrivateData(param1):undefined;
      }
      
      tlf_internal function setPrivateStyle(param1:String, param2:*) : void
      {
         if(this.getPrivateStyle(param1) != param2)
         {
            this.writableTextLayoutFormatValueHolder().setPrivateData(param1,param2);
            this.modelChanged(ModelChange.STYLE_SELECTOR_CHANGED,0,this.textLength);
         }
      }
      
      public function get id() : String
      {
         return this.getPrivateStyle(idString);
      }
      
      public function set id(param1:String) : void
      {
         return this.setPrivateStyle(idString,param1);
      }
      
      public function get styleName() : String
      {
         return this.getPrivateStyle(styleNameString);
      }
      
      public function set styleName(param1:String) : void
      {
         return this.setPrivateStyle(styleNameString,param1);
      }
      
      tlf_internal function get impliedElement() : Boolean
      {
         return this.getPrivateStyle(impliedElementString) !== undefined;
      }
      
      tlf_internal function set impliedElement(param1:Boolean) : void
      {
         this.setPrivateStyle(impliedElementString,"true");
      }
      
      public function get color() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.color:undefined;
      }
      
      public function set color(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().color = param1;
         this.formatChanged();
      }
      
      public function get backgroundColor() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.backgroundColor:undefined;
      }
      
      public function set backgroundColor(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().backgroundColor = param1;
         this.formatChanged();
      }
      
      public function get lineThrough() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.lineThrough:undefined;
      }
      
      public function set lineThrough(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().lineThrough = param1;
         this.formatChanged();
      }
      
      public function get textAlpha() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.textAlpha:undefined;
      }
      
      public function set textAlpha(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().textAlpha = param1;
         this.formatChanged();
      }
      
      public function get backgroundAlpha() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.backgroundAlpha:undefined;
      }
      
      public function set backgroundAlpha(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().backgroundAlpha = param1;
         this.formatChanged();
      }
      
      public function get fontSize() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.fontSize:undefined;
      }
      
      public function set fontSize(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().fontSize = param1;
         this.formatChanged();
      }
      
      public function get baselineShift() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.baselineShift:undefined;
      }
      
      public function set baselineShift(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().baselineShift = param1;
         this.formatChanged();
      }
      
      public function get trackingLeft() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.trackingLeft:undefined;
      }
      
      public function set trackingLeft(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().trackingLeft = param1;
         this.formatChanged();
      }
      
      public function get trackingRight() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.trackingRight:undefined;
      }
      
      public function set trackingRight(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().trackingRight = param1;
         this.formatChanged();
      }
      
      public function get lineHeight() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.lineHeight:undefined;
      }
      
      public function set lineHeight(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().lineHeight = param1;
         this.formatChanged();
      }
      
      public function get breakOpportunity() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.breakOpportunity:undefined;
      }
      
      public function set breakOpportunity(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().breakOpportunity = param1;
         this.formatChanged();
      }
      
      public function get digitCase() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.digitCase:undefined;
      }
      
      public function set digitCase(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().digitCase = param1;
         this.formatChanged();
      }
      
      public function get digitWidth() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.digitWidth:undefined;
      }
      
      public function set digitWidth(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().digitWidth = param1;
         this.formatChanged();
      }
      
      public function get dominantBaseline() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.dominantBaseline:undefined;
      }
      
      public function set dominantBaseline(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().dominantBaseline = param1;
         this.formatChanged();
      }
      
      public function get kerning() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.kerning:undefined;
      }
      
      public function set kerning(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().kerning = param1;
         this.formatChanged();
      }
      
      public function get ligatureLevel() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.ligatureLevel:undefined;
      }
      
      public function set ligatureLevel(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().ligatureLevel = param1;
         this.formatChanged();
      }
      
      public function get alignmentBaseline() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.alignmentBaseline:undefined;
      }
      
      public function set alignmentBaseline(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().alignmentBaseline = param1;
         this.formatChanged();
      }
      
      public function get locale() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.locale:undefined;
      }
      
      public function set locale(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().locale = param1;
         this.formatChanged();
      }
      
      public function get typographicCase() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.typographicCase:undefined;
      }
      
      public function set typographicCase(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().typographicCase = param1;
         this.formatChanged();
      }
      
      public function get fontFamily() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.fontFamily:undefined;
      }
      
      public function set fontFamily(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().fontFamily = param1;
         this.formatChanged();
      }
      
      public function get textDecoration() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.textDecoration:undefined;
      }
      
      public function set textDecoration(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().textDecoration = param1;
         this.formatChanged();
      }
      
      public function get fontWeight() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.fontWeight:undefined;
      }
      
      public function set fontWeight(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().fontWeight = param1;
         this.formatChanged();
      }
      
      public function get fontStyle() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.fontStyle:undefined;
      }
      
      public function set fontStyle(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().fontStyle = param1;
         this.formatChanged();
      }
      
      public function get whiteSpaceCollapse() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.whiteSpaceCollapse:undefined;
      }
      
      public function set whiteSpaceCollapse(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().whiteSpaceCollapse = param1;
         this.formatChanged();
      }
      
      public function get renderingMode() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.renderingMode:undefined;
      }
      
      public function set renderingMode(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().renderingMode = param1;
         this.formatChanged();
      }
      
      public function get cffHinting() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.cffHinting:undefined;
      }
      
      public function set cffHinting(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().cffHinting = param1;
         this.formatChanged();
      }
      
      public function get fontLookup() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.fontLookup:undefined;
      }
      
      public function set fontLookup(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().fontLookup = param1;
         this.formatChanged();
      }
      
      public function get textRotation() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.textRotation:undefined;
      }
      
      public function set textRotation(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().textRotation = param1;
         this.formatChanged();
      }
      
      public function get textIndent() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.textIndent:undefined;
      }
      
      public function set textIndent(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().textIndent = param1;
         this.formatChanged();
      }
      
      public function get paragraphStartIndent() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.paragraphStartIndent:undefined;
      }
      
      public function set paragraphStartIndent(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().paragraphStartIndent = param1;
         this.formatChanged();
      }
      
      public function get paragraphEndIndent() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.paragraphEndIndent:undefined;
      }
      
      public function set paragraphEndIndent(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().paragraphEndIndent = param1;
         this.formatChanged();
      }
      
      public function get paragraphSpaceBefore() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.paragraphSpaceBefore:undefined;
      }
      
      public function set paragraphSpaceBefore(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().paragraphSpaceBefore = param1;
         this.formatChanged();
      }
      
      public function get paragraphSpaceAfter() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.paragraphSpaceAfter:undefined;
      }
      
      public function set paragraphSpaceAfter(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().paragraphSpaceAfter = param1;
         this.formatChanged();
      }
      
      public function get textAlign() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.textAlign:undefined;
      }
      
      public function set textAlign(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().textAlign = param1;
         this.formatChanged();
      }
      
      public function get textAlignLast() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.textAlignLast:undefined;
      }
      
      public function set textAlignLast(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().textAlignLast = param1;
         this.formatChanged();
      }
      
      public function get textJustify() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.textJustify:undefined;
      }
      
      public function set textJustify(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().textJustify = param1;
         this.formatChanged();
      }
      
      public function get justificationRule() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.justificationRule:undefined;
      }
      
      public function set justificationRule(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().justificationRule = param1;
         this.formatChanged();
      }
      
      public function get justificationStyle() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.justificationStyle:undefined;
      }
      
      public function set justificationStyle(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().justificationStyle = param1;
         this.formatChanged();
      }
      
      public function get direction() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.direction:undefined;
      }
      
      public function set direction(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().direction = param1;
         this.formatChanged();
      }
      
      public function get tabStops() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.tabStops:undefined;
      }
      
      public function set tabStops(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().tabStops = param1;
         this.formatChanged();
      }
      
      public function get leadingModel() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.leadingModel:undefined;
      }
      
      public function set leadingModel(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().leadingModel = param1;
         this.formatChanged();
      }
      
      public function get columnGap() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.columnGap:undefined;
      }
      
      public function set columnGap(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().columnGap = param1;
         this.formatChanged();
      }
      
      public function get paddingLeft() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.paddingLeft:undefined;
      }
      
      public function set paddingLeft(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().paddingLeft = param1;
         this.formatChanged();
      }
      
      public function get paddingTop() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.paddingTop:undefined;
      }
      
      public function set paddingTop(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().paddingTop = param1;
         this.formatChanged();
      }
      
      public function get paddingRight() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.paddingRight:undefined;
      }
      
      public function set paddingRight(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().paddingRight = param1;
         this.formatChanged();
      }
      
      public function get paddingBottom() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.paddingBottom:undefined;
      }
      
      public function set paddingBottom(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().paddingBottom = param1;
         this.formatChanged();
      }
      
      public function get columnCount() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.columnCount:undefined;
      }
      
      public function set columnCount(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().columnCount = param1;
         this.formatChanged();
      }
      
      public function get columnWidth() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.columnWidth:undefined;
      }
      
      public function set columnWidth(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().columnWidth = param1;
         this.formatChanged();
      }
      
      public function get firstBaselineOffset() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.firstBaselineOffset:undefined;
      }
      
      public function set firstBaselineOffset(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().firstBaselineOffset = param1;
         this.formatChanged();
      }
      
      public function get verticalAlign() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.verticalAlign:undefined;
      }
      
      public function set verticalAlign(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().verticalAlign = param1;
         this.formatChanged();
      }
      
      public function get blockProgression() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.blockProgression:undefined;
      }
      
      public function set blockProgression(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().blockProgression = param1;
         this.formatChanged();
      }
      
      public function get lineBreak() : *
      {
         return !!this._formatValueHolder?this._formatValueHolder.lineBreak:undefined;
      }
      
      public function set lineBreak(param1:*) : void
      {
         this.writableTextLayoutFormatValueHolder().lineBreak = param1;
         this.formatChanged();
      }
      
      public function get format() : ITextLayoutFormat
      {
         return this._formatValueHolder;
      }
      
      public function set format(param1:ITextLayoutFormat) : void
      {
         if(param1 == null)
         {
            if(this._formatValueHolder == null || this._formatValueHolder.coreStyles == null)
            {
               return;
            }
            this._formatValueHolder.coreStyles = null;
         }
         else
         {
            this.writableTextLayoutFormatValueHolder().format = param1;
         }
         this.formatChanged();
      }
      
      private function writableTextLayoutFormatValueHolder() : FlowValueHolder
      {
         if(this._formatValueHolder == null)
         {
            this._formatValueHolder = new FlowValueHolder();
         }
         return this._formatValueHolder;
      }
      
      tlf_internal function formatChanged(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.modelChanged(ModelChange.TEXTLAYOUT_FORMAT_CHANGED,0,this.textLength);
         }
         this._computedFormat = null;
      }
      
      tlf_internal function get formatForCascade() : TextLayoutFormatValueHolder
      {
         var _loc2_:TextLayoutFormatValueHolder = null;
         var _loc3_:ITextLayoutFormat = null;
         var _loc4_:TextLayoutFormatValueHolder = null;
         var _loc1_:TextFlow = this.getTextFlow();
         if(_loc1_)
         {
            _loc2_ = _loc1_.getTextLayoutFormatStyle(this);
            if(_loc2_)
            {
               _loc3_ = this.format;
               if(_loc3_ == null)
               {
                  return _loc2_;
               }
               _loc4_ = new TextLayoutFormatValueHolder();
               _loc4_.apply(_loc2_);
               _loc4_.apply(_loc3_);
               return _loc4_;
            }
         }
         return this._formatValueHolder;
      }
      
      public function get computedFormat() : ITextLayoutFormat
      {
         if(this._computedFormat == null)
         {
            this._computedFormat = this.doComputeTextLayoutFormat();
         }
         return this._computedFormat;
      }
      
      tlf_internal function doComputeTextLayoutFormat() : TextLayoutFormatValueHolder
      {
         var _loc1_:TextLayoutFormatValueHolder = !!this.parent?TextLayoutFormatValueHolder(this.parent.computedFormat):null;
         return FlowElement.createTextLayoutFormatPrototype(this.formatForCascade,_loc1_);
      }
      
      tlf_internal function attributesChanged(param1:Boolean = true) : void
      {
         this.formatChanged(param1);
      }
      
      public function getStyle(param1:String) : *
      {
         if(TextLayoutFormat.description.hasOwnProperty(param1))
         {
            return this.computedFormat[param1];
         }
         return this.getUserStyleWorker(param1);
      }
      
      public function setStyle(param1:String, param2:*) : void
      {
         if(TextLayoutFormat.description[param1] !== undefined)
         {
            this[param1] = param2;
         }
         else
         {
            this.writableTextLayoutFormatValueHolder().setUserStyle(param1,param2);
            this.modelChanged(ModelChange.USER_STYLE_CHANGED,0,this.textLength,true);
         }
      }
      
      public function clearStyle(param1:String) : void
      {
         this.setStyle(param1,undefined);
      }
      
      tlf_internal function getUserStyleWorker(param1:String) : *
      {
         var _loc3_:* = undefined;
         if(this._formatValueHolder != null)
         {
            _loc3_ = this._formatValueHolder.getUserStyle(param1);
            if(_loc3_ !== undefined)
            {
               return _loc3_;
            }
         }
         var _loc2_:TextFlow = this.getTextFlow();
         if(_loc2_ && _loc2_.formatResolver)
         {
            _loc3_ = _loc2_.formatResolver.resolveUserFormat(this,param1);
            if(_loc3_ !== undefined)
            {
               return _loc3_;
            }
         }
         return !!this.parent?this.parent.getUserStyleWorker(param1):undefined;
      }
      
      tlf_internal function modelChanged(param1:String, param2:int, param3:int, param4:Boolean = true, param5:Boolean = true) : void
      {
         var _loc6_:TextFlow = this.getTextFlow();
         if(_loc6_)
         {
            _loc6_.processModelChanged(param1,this,param2,param3,param4,param5);
         }
      }
      
      tlf_internal function appendElementsForDelayedUpdate(param1:TextFlow) : void
      {
      }
      
      tlf_internal function applyDelayedElementUpdate(param1:TextFlow, param2:Boolean, param3:Boolean) : void
      {
      }
      
      public function get display() : String
      {
         return FlowElementDisplayType.INLINE;
      }
      
      public function set tracking(param1:Object) : void
      {
         this.trackingRight = param1;
      }
      
      tlf_internal function createGeometry(param1:DisplayObjectContainer) : void
      {
      }
      
      tlf_internal function applyWhiteSpaceCollapse(param1:String) : void
      {
         if(this.whiteSpaceCollapse !== undefined)
         {
            this.whiteSpaceCollapse = undefined;
         }
         this.setPrivateStyle(impliedElementString,undefined);
      }
      
      tlf_internal function isReadOnlyFlowElement() : Boolean
      {
         return false;
      }
      
      tlf_internal function getHighestReadOnlyFlowElement() : FlowElement
      {
         var _loc1_:FlowElement = null;
         if(this.isReadOnlyFlowElement())
         {
            _loc1_ = this;
         }
         var _loc2_:FlowElement = this.parent;
         while(_loc2_ != null)
         {
            if(_loc2_.isReadOnlyFlowElement())
            {
               _loc1_ = _loc2_;
            }
            _loc2_ = _loc2_.parent;
         }
         return _loc1_;
      }
      
      public function getAbsoluteStart() : int
      {
         var _loc1_:int = this.parentRelativeStart;
         var _loc2_:FlowElement = this.parent;
         while(_loc2_)
         {
            _loc1_ = _loc1_ + _loc2_.parentRelativeStart;
            _loc2_ = _loc2_.parent;
         }
         return _loc1_;
      }
      
      public function getElementRelativeStart(param1:FlowElement) : int
      {
         var _loc2_:int = this.parentRelativeStart;
         var _loc3_:FlowElement = this.parent;
         while(_loc3_ && _loc3_ != param1)
         {
            _loc2_ = _loc2_ + _loc3_.parentRelativeStart;
            _loc3_ = _loc3_.parent;
         }
         return _loc2_;
      }
      
      public function getTextFlow() : TextFlow
      {
         var _loc1_:FlowElement = this;
         while(_loc1_.parent != null)
         {
            _loc1_ = _loc1_.parent;
         }
         return _loc1_ as TextFlow;
      }
      
      public function getParagraph() : ParagraphElement
      {
         var _loc1_:FlowElement = this;
         while(_loc1_)
         {
            if(_loc1_ is ParagraphElement)
            {
               return _loc1_ as ParagraphElement;
            }
            _loc1_ = _loc1_.parent;
         }
         return null;
      }
      
      public function getParentByType(param1:Class) : FlowElement
      {
         var _loc2_:FlowElement = this.parent;
         while(_loc2_)
         {
            if(_loc2_ is param1)
            {
               return _loc2_;
            }
            _loc2_ = _loc2_.parent;
         }
         return null;
      }
      
      public function getPreviousSibling() : FlowElement
      {
         if(!this.parent)
         {
            return null;
         }
         var _loc1_:int = this.parent.getChildIndex(this);
         return _loc1_ == 0?null:this.parent.getChildAt(_loc1_ - 1);
      }
      
      public function getNextSibling() : FlowElement
      {
         if(!this.parent)
         {
            return null;
         }
         var _loc1_:int = this.parent.getChildIndex(this);
         return _loc1_ == this.parent.numChildren - 1?null:this.parent.getChildAt(_loc1_ + 1);
      }
      
      public function getCharAtPosition(param1:int) : String
      {
         return null;
      }
      
      public function getCharCodeAtPosition(param1:int) : int
      {
         var _loc2_:String = this.getCharAtPosition(param1);
         return _loc2_ && _loc2_.length > 0?int(_loc2_.charCodeAt(0)):0;
      }
      
      tlf_internal function getElementByIDHelper(param1:String) : FlowElement
      {
         if(this.id == param1)
         {
            return this;
         }
         return null;
      }
      
      tlf_internal function getElementsByStyleNameHelper(param1:Array, param2:String) : void
      {
         if(this.styleName == param2)
         {
            param1.push(this);
         }
      }
      
      private function updateRange(param1:int) : void
      {
         this.setParentRelativeStart(this.parentRelativeStart + param1);
      }
      
      tlf_internal function updateLengths(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:FlowElement = null;
         this.setTextLength(this.textLength + param2);
         var _loc4_:FlowGroupElement = this.parent;
         if(_loc4_)
         {
            _loc5_ = _loc4_.getChildIndex(this) + 1;
            _loc6_ = _loc4_.numChildren;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc4_.getChildAt(_loc5_++);
               _loc7_.updateRange(param2);
            }
            _loc4_.updateLengths(param1,param2,param3);
         }
      }
      
      tlf_internal function getEnclosingController(param1:int) : ContainerController
      {
         var _loc2_:TextFlow = this.getTextFlow();
         if(_loc2_ == null || _loc2_.flowComposer == null || _loc2_.flowComposer.numLines == 0)
         {
            return null;
         }
         var _loc3_:FlowElement = this;
         while(_loc3_ && (!(_loc3_ is ContainerFormattedElement) || ContainerFormattedElement(_loc3_).flowComposer == null))
         {
            _loc3_ = _loc3_.parent;
         }
         var _loc4_:IFlowComposer = ContainerFormattedElement(_loc3_).flowComposer;
         if(!_loc4_)
         {
            return null;
         }
         var _loc5_:int = ContainerFormattedElement(_loc3_).flowComposer.findControllerIndexAtPosition(this.getAbsoluteStart() + param1,false);
         return _loc5_ != -1?_loc4_.getControllerAt(_loc5_):null;
      }
      
      tlf_internal function deleteContainerText(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ContainerController = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:IFlowComposer = null;
         var _loc10_:int = 0;
         if(this.getTextFlow())
         {
            _loc3_ = this.getAbsoluteStart() + param1;
            _loc4_ = _loc3_ - param2;
            while(param2 > 0)
            {
               _loc6_ = this.getEnclosingController(param1 - 1);
               if(!_loc6_)
               {
                  _loc6_ = this.getEnclosingController(param1 - param2);
                  if(_loc6_)
                  {
                     _loc9_ = _loc6_.flowComposer;
                     _loc10_ = _loc9_.getControllerIndex(_loc6_);
                     while(_loc10_ + 1 < _loc9_.numControllers && _loc6_.absoluteStart + _loc6_.textLength < param1)
                     {
                        _loc6_ = _loc9_.getControllerAt(_loc10_ + 1);
                        if(_loc6_.textLength)
                        {
                           break;
                        }
                        _loc10_++;
                     }
                  }
                  if(!_loc6_)
                  {
                     break;
                  }
               }
               _loc7_ = _loc6_.absoluteStart;
               if(_loc4_ < _loc7_)
               {
                  _loc5_ = _loc3_ - _loc7_ + 1;
               }
               else if(_loc4_ < _loc7_ + _loc6_.textLength)
               {
                  _loc5_ = param2;
               }
               _loc8_ = _loc6_.textLength < _loc5_?int(_loc6_.textLength):int(_loc5_);
               if(_loc8_ <= 0)
               {
                  break;
               }
               ContainerController(_loc6_).setTextLengthOnly(_loc6_.textLength - _loc8_);
               param2 = param2 - _loc8_;
               _loc3_ = _loc3_ - _loc8_;
               param1 = param1 - _loc8_;
            }
         }
      }
      
      tlf_internal function normalizeRange(param1:uint, param2:uint) : void
      {
      }
      
      tlf_internal function quickCloneTextLayoutFormat(param1:FlowElement) : void
      {
         this._formatValueHolder = !!param1._formatValueHolder?new FlowValueHolder(param1._formatValueHolder):null;
      }
      
      tlf_internal function updateForMustUseComposer(param1:TextFlow) : Boolean
      {
         return false;
      }
   }
}
