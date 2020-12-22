package de.freggers.util
{
   public class StringUtil
   {
      
      private static const REGEXP_LT:RegExp = /</g;
      
      private static const REGEXP_GT:RegExp = />/g;
      
      private static const REGEXP_AMP:RegExp = /&/g;
      
      private static const REGEXP_QUOT:RegExp = /"/g;
      
      private static const REGEXP_252:RegExp = /�/g;
      
      private static const REGEXP_220:RegExp = /�/g;
      
      private static const REGEXP_228:RegExp = /�/g;
      
      private static const REGEXP_196:RegExp = /�/g;
      
      private static const REGEXP_246:RegExp = /�/g;
      
      private static const REGEXP_214:RegExp = /�/g;
      
      private static const REGEXP_223:RegExp = /�/g;
      
      private static const REGEXP_LETTER:RegExp = /[a-z]/i;
      
      private static const CASE_CHECK_MIN_LENGTH:int = 10;
      
      private static const UPPER_CASE_MAX_PERCENT:Number = 0.7;
      
      private static const VALID_HEX_VALUES:String = "0123456789abcdef";
       
      
      public function StringUtil()
      {
         super();
      }
      
      public static function formattedString(param1:String, param2:Array) : String
      {
         var _loc3_:RegExp = null;
         if(!param1 || !param2)
         {
            return param1;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_] != null)
            {
               _loc3_ = new RegExp("\\{" + _loc4_ + "\\}","g");
               param1 = param1.replace(_loc3_,param2[_loc4_]);
            }
            _loc4_++;
         }
         return param1;
      }
      
      public static function replaceTokens(param1:String, param2:Object) : String
      {
         var _loc4_:RegExp = null;
         var _loc5_:* = null;
         if(param1 == null || param2 == null)
         {
            return param1;
         }
         var _loc3_:String = param1;
         for(_loc5_ in param2)
         {
            _loc4_ = new RegExp(_loc5_,"g");
            _loc3_ = _loc3_.replace(_loc4_,param2[_loc5_]);
         }
         return _loc3_;
      }
      
      public static function escapeHTML(param1:String) : String
      {
         if(!param1)
         {
            return param1;
         }
         return param1.replace(REGEXP_AMP,"&amp;").replace(REGEXP_QUOT,"&quot;").replace(REGEXP_LT,"&lt;").replace(REGEXP_GT,"&gt;").replace(REGEXP_252,"&#252;").replace(REGEXP_220,"&#220;").replace(REGEXP_228,"&#228;").replace(REGEXP_196,"&#196;").replace(REGEXP_246,"&#246;").replace(REGEXP_214,"&#214;").replace(REGEXP_223,"&#223;");
      }
      
      public static function normalizeCase(param1:String) : String
      {
         var _loc2_:int = 0;
         if(!param1 || param1.length < CASE_CHECK_MIN_LENGTH)
         {
            return param1;
         }
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(REGEXP_LETTER.test(param1.charAt(_loc2_)))
            {
               _loc3_++;
            }
            _loc2_++;
         }
         if(_loc3_ == 0)
         {
            return param1;
         }
         var _loc4_:String = param1.toLocaleLowerCase();
         var _loc5_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1.charCodeAt(_loc2_) != _loc4_.charCodeAt(_loc2_))
            {
               _loc5_++;
            }
            _loc2_++;
         }
         if(_loc5_ / _loc3_ > UPPER_CASE_MAX_PERCENT)
         {
            return _loc4_;
         }
         return param1;
      }
      
      public static function isHexString(param1:String) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:String = param1.toLowerCase();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(VALID_HEX_VALUES.indexOf(_loc2_.charAt(_loc3_)) < 0)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public static function prefix(param1:String, param2:String, param3:int) : String
      {
         var _loc5_:int = 0;
         if(!param1)
         {
            return null;
         }
         if(!param2 || param3 == 0)
         {
            return param1;
         }
         var _loc4_:String = "";
         while(_loc5_ < param3)
         {
            _loc4_ = _loc4_ + param2;
            _loc5_++;
         }
         return _loc4_ + param1;
      }
      
      public static function trim(param1:String) : String
      {
         if(!param1)
         {
            return param1;
         }
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         var _loc4_:int = _loc2_ - 1;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            if(param1.charCodeAt(_loc5_) > 32)
            {
               _loc3_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         _loc5_ = _loc2_ - 1;
         while(_loc5_ >= 0)
         {
            if(param1.charCodeAt(_loc5_) > 32)
            {
               _loc4_ = _loc5_ + 1;
               break;
            }
            _loc5_--;
         }
         return param1.substring(_loc3_,_loc4_);
      }
      
      public static function startsWith(param1:String, param2:String) : Boolean
      {
         return param1.indexOf(param2) == 0;
      }
      
      public static function endsWith(param1:String, param2:String) : Boolean
      {
         var _loc3_:int = param1.lastIndexOf(param2);
         if(_loc3_ == -1)
         {
            return false;
         }
         return _loc3_ == param1.length - param2.length;
      }
      
      public static function simplify(param1:String) : String
      {
         return param1.toLowerCase().replace(/\s+/g," ").replace(/<DF>/g,"ss").replace(/<E4>/gi,"ae").replace(/<FC>/gi,"ue").replace(/<F6>/gi,"oe");
      }
   }
}
