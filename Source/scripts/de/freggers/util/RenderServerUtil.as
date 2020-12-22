package de.freggers.util
{
   public class RenderServerUtil
   {
      
      public static const DEFAULT_COLOR_COUNT:int = 64;
      
      public static const KEY_BODY:String = "bo";
      
      public static const KEY_PART:String = "pa";
      
      public static const KEY_COLOR:String = "co";
      
      public static const KEY_ANIMATION:String = "an";
      
      public static const KEY_FRAME:String = "fr";
      
      public static const KEY_DIRECTION:String = "di";
      
      public static const KEY_PACKAGE:String = "pk";
      
      public static const KEY_OUTPUTTYPE:String = "ot";
      
      public static const VAL_OUTPUTTYPE_BIN:String = "bin";
      
      public static const VAL_OUTPUTTYPE_PNG:String = "png";
      
      public static const KEY_OUTPUTPATH:String = "op";
      
      public static const KEY_BASE:String = "ba";
      
      public static const KEY_NUMCOLORS:String = "nc";
      
      public static const KEY_SCALEUNIFORM:String = "su";
      
      public static const KEY_SCALEX:String = "sx";
      
      public static const KEY_SCALEY:String = "sy";
      
      public static const KEY_SCALEZ:String = "sz";
      
      public static const PARAM_DELIMITER:String = ";";
      
      public static const DELIMITER:String = ":";
       
      
      public function RenderServerUtil()
      {
         super();
      }
      
      public static function packageQueryString(param1:String, param2:int, param3:String, param4:Array, param5:Array, param6:Array = null, param7:int = 64, param8:int = 100, param9:int = 100, param10:int = 100) : String
      {
         return URLString(param1,param2,param4,param5,param6,param7,param8,param9,param10) + PARAM_DELIMITER + KEY_OUTPUTTYPE + "=" + VAL_OUTPUTTYPE_BIN + PARAM_DELIMITER + KEY_PACKAGE + "=" + param3;
      }
      
      public static function packageQueryStringFromUrlString(param1:String, param2:String) : String
      {
         return param1 + PARAM_DELIMITER + KEY_OUTPUTTYPE + "=" + VAL_OUTPUTTYPE_BIN + PARAM_DELIMITER + KEY_PACKAGE + "=" + param2;
      }
      
      public static function pngQueryString(param1:String, param2:int, param3:String, param4:int, param5:int, param6:Array, param7:Array, param8:Array = null, param9:int = 64, param10:int = 100, param11:int = 100, param12:int = 100) : String
      {
         return URLString(param1,param2,param6,param7,param8,param9,param10,param11,param12) + PARAM_DELIMITER + KEY_OUTPUTTYPE + "=" + VAL_OUTPUTTYPE_PNG + PARAM_DELIMITER + KEY_ANIMATION + "=" + escape(param3) + PARAM_DELIMITER + KEY_FRAME + "=" + param4 + PARAM_DELIMITER + KEY_DIRECTION + "=" + param5;
      }
      
      public static function URLString(param1:String, param2:int, param3:Array, param4:Array, param5:Array = null, param6:int = 64, param7:int = 100, param8:int = 100, param9:int = 100) : String
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc15_:String = null;
         var _loc16_:Array = null;
         if(!param5)
         {
            param5 = new Array(param3.length);
         }
         if(param3.length != param4.length || param3.length != param5.length)
         {
            return null;
         }
         var _loc10_:String = KEY_BODY + "=" + escape(param1) + PARAM_DELIMITER + KEY_BASE + "=" + param2 + PARAM_DELIMITER + KEY_NUMCOLORS + "=" + param6;
         var _loc14_:int = 0;
         while(_loc14_ < param3.length)
         {
            _loc15_ = param3[_loc14_];
            if(!(!_loc15_ || !(param4[_loc14_] is Array)))
            {
               _loc10_ = _loc10_ + (PARAM_DELIMITER + KEY_PART + "=" + escape(_loc15_));
               if(3 - param4[_loc14_].length > 0)
               {
                  _loc11_ = 0;
                  while(_loc11_ < 3 - param4[_loc14_].length)
                  {
                     param4[_loc14_].push(0);
                     _loc11_++;
                  }
               }
               _loc11_ = 0;
               while(_loc11_ < param4[_loc14_].length)
               {
                  _loc10_ = _loc10_ + (DELIMITER + (param4[_loc14_][_loc11_] as int).toString(16));
                  _loc11_++;
               }
               _loc16_ = param5[_loc14_];
               if(_loc16_)
               {
                  _loc11_ = 0;
                  while(_loc11_ < _loc16_.length)
                  {
                     if(_loc16_[_loc11_]["mesh_label"] && _loc16_[_loc11_]["colors"] && _loc16_[_loc11_]["colors"] is Array && _loc16_[_loc11_]["colors"].length == 3)
                     {
                        _loc10_ = _loc10_ + (DELIMITER + _loc16_[_loc11_]["mesh_label"]);
                        _loc12_ = 0;
                        while(_loc12_ < _loc16_[_loc11_]["colors"].length)
                        {
                           _loc10_ = _loc10_ + (DELIMITER + (_loc16_[_loc11_]["colors"][_loc12_] as int).toString(16));
                           _loc12_++;
                        }
                     }
                     _loc11_++;
                  }
               }
            }
            _loc14_++;
         }
         if(param7 == param8 && param8 == param9)
         {
            if(param7 != 100)
            {
               _loc10_ = _loc10_ + (PARAM_DELIMITER + KEY_SCALEUNIFORM + "=" + param7);
            }
         }
         else
         {
            if(param7 != 100)
            {
               _loc10_ = _loc10_ + (PARAM_DELIMITER + KEY_SCALEX + "=" + param7);
            }
            if(param8 != 100)
            {
               _loc10_ = _loc10_ + (PARAM_DELIMITER + KEY_SCALEY + "=" + param8);
            }
            if(param9 != 100)
            {
               _loc10_ = _loc10_ + (PARAM_DELIMITER + KEY_SCALEZ + "=" + param9);
            }
         }
         return _loc10_;
      }
   }
}
