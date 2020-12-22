package de.freggers.property
{
   public class PropertyConfig
   {
       
      
      private var _type:String;
      
      private var _display:String;
      
      private var _name:String;
      
      private var _priority:int = 0;
      
      public function PropertyConfig(param1:String, param2:String)
      {
         super();
         this._name = param1;
         this._type = param2;
      }
      
      public static function fromData(param1:String, param2:Object) : PropertyConfig
      {
         var _loc3_:PropertyConfig = null;
         if(param2["type"])
         {
            _loc3_ = new PropertyConfig(param1,param2["type"]);
            _loc3_._display = param2["display"];
            _loc3_._priority = int(param2["priority"]);
         }
         return _loc3_;
      }
      
      public static function displayStringToObject(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         if(param1.indexOf(";") != -1)
         {
            _loc3_ = param1.split(";");
            _loc5_ = _loc3_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc7_ = _loc3_[_loc4_];
               if(!(_loc7_ == null || _loc7_.indexOf("=") == -1))
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Object();
                  }
                  _loc6_ = _loc7_.split("=");
                  _loc2_[_loc6_[0]] = _loc6_[1];
               }
               _loc4_++;
            }
            return _loc2_;
         }
         return param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get display() : String
      {
         return this._display;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
   }
}
