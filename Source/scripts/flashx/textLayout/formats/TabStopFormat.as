package flashx.textLayout.formats
{
   import flash.text.engine.TabAlignment;
   import flashx.textLayout.property.EnumStringProperty;
   import flashx.textLayout.property.NumberProperty;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.property.StringProperty;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TabStopFormat implements ITabStopFormat
   {
      
      private static var _positionProperty:NumberProperty = new NumberProperty("position",0,false,Category.TABSTOP,0,10000);
      
      private static var _alignmentProperty:EnumStringProperty = new EnumStringProperty("alignment",TabAlignment.START,false,Category.TABSTOP,TabAlignment.START,TabAlignment.CENTER,TabAlignment.END,TabAlignment.DECIMAL);
      
      private static var _decimalAlignmentTokenProperty:StringProperty = new StringProperty("decimalAlignmentToken",null,false,Category.TABSTOP);
      
      private static var _description:Object = {
         "position":_positionProperty,
         "alignment":_alignmentProperty,
         "decimalAlignmentToken":_decimalAlignmentTokenProperty
      };
      
      private static var _emptyTabStopFormat:ITabStopFormat;
      
      private static var _defaults:TabStopFormat;
       
      
      private var _position;
      
      private var _alignment;
      
      private var _decimalAlignmentToken;
      
      public function TabStopFormat(param1:ITabStopFormat = null)
      {
         super();
         if(param1)
         {
            this.apply(param1);
         }
      }
      
      tlf_internal static function get positionProperty() : NumberProperty
      {
         return _positionProperty;
      }
      
      tlf_internal static function get alignmentProperty() : EnumStringProperty
      {
         return _alignmentProperty;
      }
      
      tlf_internal static function get decimalAlignmentTokenProperty() : StringProperty
      {
         return _decimalAlignmentTokenProperty;
      }
      
      tlf_internal static function get description() : Object
      {
         return _description;
      }
      
      tlf_internal static function get emptyTabStopFormat() : ITabStopFormat
      {
         if(_emptyTabStopFormat == null)
         {
            _emptyTabStopFormat = new TabStopFormat();
         }
         return _emptyTabStopFormat;
      }
      
      public static function isEqual(param1:ITabStopFormat, param2:ITabStopFormat) : Boolean
      {
         if(param1 == null)
         {
            param1 = emptyTabStopFormat;
         }
         if(param2 == null)
         {
            param2 = emptyTabStopFormat;
         }
         if(param1 == param2)
         {
            return true;
         }
         if(!_positionProperty.equalHelper(param1.position,param2.position))
         {
            return false;
         }
         if(!_alignmentProperty.equalHelper(param1.alignment,param2.alignment))
         {
            return false;
         }
         if(!_decimalAlignmentTokenProperty.equalHelper(param1.decimalAlignmentToken,param2.decimalAlignmentToken))
         {
            return false;
         }
         return true;
      }
      
      public static function get defaultFormat() : ITabStopFormat
      {
         if(_defaults == null)
         {
            _defaults = new TabStopFormat();
            Property.defaultsAllHelper(_description,_defaults);
         }
         return _defaults;
      }
      
      public function get position() : *
      {
         return this._position;
      }
      
      public function set position(param1:*) : void
      {
         this._position = _positionProperty.setHelper(this._position,param1);
      }
      
      public function get alignment() : *
      {
         return this._alignment;
      }
      
      public function set alignment(param1:*) : void
      {
         this._alignment = _alignmentProperty.setHelper(this._alignment,param1);
      }
      
      public function get decimalAlignmentToken() : *
      {
         return this._decimalAlignmentToken;
      }
      
      public function set decimalAlignmentToken(param1:*) : void
      {
         this._decimalAlignmentToken = _decimalAlignmentTokenProperty.setHelper(this._decimalAlignmentToken,param1);
      }
      
      public function copy(param1:ITabStopFormat) : void
      {
         if(param1 == null)
         {
            param1 = emptyTabStopFormat;
         }
         this.position = param1.position;
         this.alignment = param1.alignment;
         this.decimalAlignmentToken = param1.decimalAlignmentToken;
      }
      
      public function concat(param1:ITabStopFormat) : void
      {
         this.position = _positionProperty.concatHelper(this.position,param1.position);
         this.alignment = _alignmentProperty.concatHelper(this.alignment,param1.alignment);
         this.decimalAlignmentToken = _decimalAlignmentTokenProperty.concatHelper(this.decimalAlignmentToken,param1.decimalAlignmentToken);
      }
      
      public function concatInheritOnly(param1:ITabStopFormat) : void
      {
         this.position = _positionProperty.concatInheritOnlyHelper(this.position,param1.position);
         this.alignment = _alignmentProperty.concatInheritOnlyHelper(this.alignment,param1.alignment);
         this.decimalAlignmentToken = _decimalAlignmentTokenProperty.concatInheritOnlyHelper(this.decimalAlignmentToken,param1.decimalAlignmentToken);
      }
      
      public function apply(param1:ITabStopFormat) : void
      {
         var _loc2_:* = undefined;
         if((_loc2_ = param1.position) !== undefined)
         {
            this.position = _loc2_;
         }
         if((_loc2_ = param1.alignment) !== undefined)
         {
            this.alignment = _loc2_;
         }
         if((_loc2_ = param1.decimalAlignmentToken) !== undefined)
         {
            this.decimalAlignmentToken = _loc2_;
         }
      }
      
      public function removeMatching(param1:ITabStopFormat) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(_positionProperty.equalHelper(this.position,param1.position))
         {
            this.position = undefined;
         }
         if(_alignmentProperty.equalHelper(this.alignment,param1.alignment))
         {
            this.alignment = undefined;
         }
         if(_decimalAlignmentTokenProperty.equalHelper(this.decimalAlignmentToken,param1.decimalAlignmentToken))
         {
            this.decimalAlignmentToken = undefined;
         }
      }
      
      public function removeClashing(param1:ITabStopFormat) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!_positionProperty.equalHelper(this.position,param1.position))
         {
            this.position = undefined;
         }
         if(!_alignmentProperty.equalHelper(this.alignment,param1.alignment))
         {
            this.alignment = undefined;
         }
         if(!_decimalAlignmentTokenProperty.equalHelper(this.decimalAlignmentToken,param1.decimalAlignmentToken))
         {
            this.decimalAlignmentToken = undefined;
         }
      }
   }
}
