package flashx.textLayout.utils
{
   import flash.text.engine.JustificationStyle;
   import flash.text.engine.TextBaseline;
   import flash.utils.Dictionary;
   import flashx.textLayout.formats.JustificationRule;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public final class LocaleUtil
   {
      
      private static var _localeSettings:Dictionary = null;
      
      private static var _lastLocaleKey:String = "";
      
      private static var _lastLocale:LocaleSettings = null;
       
      
      public function LocaleUtil()
      {
         super();
      }
      
      public static function justificationRule(param1:String) : String
      {
         var _loc2_:LocaleSettings = fetchLocaleSet(param1);
         return _loc2_.justificationRule;
      }
      
      public static function justificationStyle(param1:String) : String
      {
         var _loc2_:LocaleSettings = fetchLocaleSet(param1);
         return _loc2_.justificationStyle;
      }
      
      public static function leadingModel(param1:String) : String
      {
         var _loc2_:LocaleSettings = fetchLocaleSet(param1);
         return _loc2_.leadingModel;
      }
      
      public static function dominantBaseline(param1:String) : String
      {
         var _loc2_:LocaleSettings = fetchLocaleSet(param1);
         return _loc2_.dominantBaseline;
      }
      
      private static function initializeDefaultLocales() : void
      {
         var locale:LocaleSettings = null;
         _localeSettings = new Dictionary();
         try
         {
            locale = addLocale("en");
            locale.justificationRule = JustificationRule.SPACE;
            locale.justificationStyle = JustificationStyle.PUSH_IN_KINSOKU;
            locale.leadingModel = LeadingModel.ROMAN_UP;
            locale.dominantBaseline = TextBaseline.ROMAN;
            locale = addLocale("ja");
            locale.justificationRule = JustificationRule.EAST_ASIAN;
            locale.justificationStyle = JustificationStyle.PUSH_IN_KINSOKU;
            locale.leadingModel = LeadingModel.IDEOGRAPHIC_TOP_DOWN;
            locale.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
            locale = addLocale("zh");
            locale.justificationRule = JustificationRule.EAST_ASIAN;
            locale.justificationStyle = JustificationStyle.PUSH_IN_KINSOKU;
            locale.leadingModel = LeadingModel.IDEOGRAPHIC_TOP_DOWN;
            locale.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
         }
         catch(e:ArgumentError)
         {
            trace(e);
         }
         finally
         {
            2;
            return;
         }
      }
      
      private static function addLocale(param1:String) : LocaleSettings
      {
         _localeSettings[param1] = new LocaleSettings();
         return _localeSettings[param1];
      }
      
      private static function getLocale(param1:String) : LocaleSettings
      {
         var _loc2_:String = param1.toLowerCase();
         if(_loc2_.indexOf("en") == 0)
         {
            return _localeSettings["en"];
         }
         if(_loc2_.indexOf("ja") == 0)
         {
            return _localeSettings["ja"];
         }
         if(_loc2_.indexOf("zh") == 0)
         {
            return _localeSettings["zh"];
         }
         return _localeSettings["en"];
      }
      
      private static function fetchLocaleSet(param1:String) : LocaleSettings
      {
         if(_localeSettings == null)
         {
            initializeDefaultLocales();
         }
         var _loc2_:LocaleSettings = null;
         if(param1 == _lastLocaleKey)
         {
            _loc2_ = _lastLocale;
         }
         else
         {
            _loc2_ = getLocale(param1);
            _lastLocale = _loc2_;
            _lastLocaleKey = param1;
         }
         return _loc2_;
      }
   }
}

import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.tlf_internal;

use namespace tlf_internal;

class LocaleSettings
{
    
   
   private var _justificationRule:String = null;
   
   private var _justificationStyle:String = null;
   
   private var _leadingModel:String = null;
   
   private var _dominantBaseline:String = null;
   
   function LocaleSettings()
   {
      super();
   }
   
   public function get justificationRule() : String
   {
      return this._justificationRule;
   }
   
   public function set justificationRule(param1:String) : void
   {
      var _loc2_:Object = TextLayoutFormat.justificationRuleProperty.setHelper(this._justificationRule,param1);
      this._justificationRule = _loc2_ == null?null:_loc2_ as String;
   }
   
   public function get justificationStyle() : String
   {
      return this._justificationStyle;
   }
   
   public function set justificationStyle(param1:String) : void
   {
      var _loc2_:Object = TextLayoutFormat.justificationStyleProperty.setHelper(this._justificationStyle,param1);
      this._justificationStyle = _loc2_ == null?null:_loc2_ as String;
   }
   
   public function get leadingModel() : String
   {
      return this._leadingModel;
   }
   
   public function set leadingModel(param1:String) : void
   {
      var _loc2_:Object = TextLayoutFormat.leadingModelProperty.setHelper(this._leadingModel,param1);
      this._leadingModel = _loc2_ == null?null:_loc2_ as String;
   }
   
   public function get dominantBaseline() : String
   {
      return this._dominantBaseline;
   }
   
   public function set dominantBaseline(param1:String) : void
   {
      var _loc2_:Object = TextLayoutFormat.dominantBaselineProperty.setHelper(this._dominantBaseline,param1);
      this._dominantBaseline = _loc2_ == null?null:_loc2_ as String;
   }
}
