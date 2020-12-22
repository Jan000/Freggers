package de.freggers.property
{
   public class Property
   {
      
      public static const TYPE_TOOLTIP_TEXT:String = "tooltip text";
      
      public static const TYPE_EFFECT:String = "effect";
      
      public static const TYPE_ITEM_STATE:String = "item state";
      
      public static const ITEM_STATE_ACTION_CREATED:String = "created";
      
      public static const ITEM_STATE_ACTION_KEEP:String = "keep";
      
      public static const ITEM_STATE_ACTION_DELETED:String = "deleted";
      
      private static const VALID_TYPES:Array = [TYPE_EFFECT,TYPE_TOOLTIP_TEXT,TYPE_ITEM_STATE];
       
      
      private var _value:String;
      
      private var _config:PropertyConfig;
      
      private var _effectId:int;
      
      private var _effectGui:String;
      
      public function Property(param1:PropertyConfig, param2:String)
      {
         super();
         this._config = param1;
         this._value = param2;
      }
      
      public static function isValidType(param1:String) : Boolean
      {
         return VALID_TYPES.indexOf(param1) >= 0;
      }
      
      public function get type() : String
      {
         return this._config.type;
      }
      
      public function get value() : String
      {
         return this._value;
      }
      
      public function get name() : String
      {
         return this._config.name;
      }
      
      public function get display() : String
      {
         return this._config.display;
      }
      
      public function get priority() : int
      {
         return this._config.priority;
      }
      
      public function setEffectIdentity(param1:int, param2:String) : void
      {
         this._effectId = param1;
         this._effectGui = param2;
      }
      
      public function get effectId() : int
      {
         return this._effectId;
      }
      
      public function get effectGui() : String
      {
         return this._effectGui;
      }
   }
}
