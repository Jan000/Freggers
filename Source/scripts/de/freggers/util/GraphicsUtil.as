package de.freggers.util
{
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.geom.Point;
   
   public class GraphicsUtil
   {
      
      public static const TO_RADIANS:Number = Math.PI / 180;
      
      public static const TAN_15:Number = Math.tan(15 * TO_RADIANS);
       
      
      public function GraphicsUtil()
      {
         super();
      }
      
      public static function drawWedge(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc13_:Number = NaN;
         param1.moveTo(param3,param4);
         param1.lineTo(param3 + param2,param4);
         var _loc6_:int = Math.floor(param5 / 30);
         var _loc7_:Number = param5 - _loc6_ * 30;
         var _loc12_:int = 0;
         while(_loc12_ < _loc6_)
         {
            _loc8_ = param3 + param2 * Math.cos((_loc12_ + 1) * 30 * TO_RADIANS);
            _loc9_ = param4 + param2 * Math.sin((_loc12_ + 1) * 30 * TO_RADIANS);
            _loc10_ = _loc8_ + param2 * TAN_15 * Math.cos(((_loc12_ + 1) * 30 - 90) * TO_RADIANS);
            _loc11_ = _loc9_ + param2 * TAN_15 * Math.sin(((_loc12_ + 1) * 30 - 90) * TO_RADIANS);
            param1.curveTo(_loc10_,_loc11_,_loc8_,_loc9_);
            _loc12_++;
         }
         if(_loc7_ > 0)
         {
            _loc13_ = Math.tan(_loc7_ / 2 * TO_RADIANS);
            _loc8_ = param3 + param2 * Math.cos((_loc12_ * 30 + _loc7_) * TO_RADIANS);
            _loc9_ = param4 + param2 * Math.sin((_loc12_ * 30 + _loc7_) * TO_RADIANS);
            _loc10_ = _loc8_ + param2 * _loc13_ * Math.cos((_loc12_ * 30 + _loc7_ - 90) * TO_RADIANS);
            _loc11_ = _loc9_ + param2 * _loc13_ * Math.sin((_loc12_ * 30 + _loc7_ - 90) * TO_RADIANS);
            param1.curveTo(_loc10_,_loc11_,_loc8_,_loc9_);
         }
         param1.lineTo(param3,param4);
      }
      
      public static function drawPolygon(param1:Graphics, param2:Array, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(!(!param2[_loc4_] || !(param2[_loc4_] is Point)))
            {
               if(_loc4_ == 0)
               {
                  param1.moveTo((param2[_loc4_] as Point).x,(param2[_loc4_] as Point).y);
               }
               else if(param3)
               {
                  drawPixelLine(param1,(param2[_loc4_ - 1] as Point).x,(param2[_loc4_ - 1] as Point).y,(param2[_loc4_] as Point).x,(param2[_loc4_] as Point).y);
               }
               else
               {
                  param1.lineTo((param2[_loc4_] as Point).x,(param2[_loc4_] as Point).y);
               }
            }
            _loc4_++;
         }
      }
      
      public static function translatePoints(param1:Array, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(!(!param1[_loc4_] || !(param1[_loc4_] is Point)))
            {
               (param1[_loc4_] as Point).x = (param1[_loc4_] as Point).x + param2;
               (param1[_loc4_] as Point).y = (param1[_loc4_] as Point).y + param3;
            }
            _loc4_++;
         }
      }
      
      public static function drawPixelLine(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = false) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc7_:Number = param4 - param2;
         var _loc8_:Number = param5 - param3;
         var _loc9_:Number = param2;
         var _loc10_:Number = param3;
         if(param6)
         {
            param1.moveTo(param2,param3);
         }
         if(_loc7_ == 0 || _loc8_ == 0)
         {
            param1.lineTo(param4,param5);
            return;
         }
         var _loc11_:Number = _loc7_ / _loc8_;
         if(Math.abs(_loc11_) == 2)
         {
            _loc12_ = Math.abs(_loc7_);
            _loc13_ = 2;
            while(_loc13_ <= _loc12_)
            {
               if(_loc11_ < 0)
               {
                  if(_loc8_ < 0)
                  {
                     _loc10_--;
                  }
                  else
                  {
                     _loc10_++;
                  }
                  param1.lineTo(_loc9_,_loc10_);
                  if(_loc7_ < 0)
                  {
                     _loc9_ = _loc9_ - 2;
                  }
                  else
                  {
                     _loc9_ = _loc9_ + 2;
                  }
                  param1.lineTo(_loc9_,_loc10_);
               }
               else
               {
                  if(_loc7_ < 0)
                  {
                     _loc9_ = _loc9_ - 2;
                  }
                  else
                  {
                     _loc9_ = _loc9_ + 2;
                  }
                  param1.lineTo(_loc9_,_loc10_);
                  if(_loc8_ < 0)
                  {
                     _loc10_--;
                  }
                  else
                  {
                     _loc10_++;
                  }
                  param1.lineTo(_loc9_,_loc10_);
               }
               _loc13_ = _loc13_ + 2;
            }
         }
         else
         {
            param1.lineTo(param4,param5);
         }
      }
      
      public static function drawDashedLine(param1:Graphics, param2:Point, param3:Point, param4:int = 16777215, param5:Number = 1, param6:Number = 2, param7:Number = 1, param8:Number = 3, param9:String = null) : void
      {
         param1.lineStyle(param6,param4,param5,false,LineScaleMode.NONE,param9);
         var _loc10_:Point = param2.subtract(param3);
         var _loc11_:int = _loc10_.length / (param7 + param8);
         var _loc12_:Number = (param3.x - param2.x) / (_loc10_.length / param7);
         var _loc13_:Number = (param3.y - param2.y) / (_loc10_.length / param7);
         var _loc14_:Number = (param3.x - param2.x) / (_loc10_.length / param8);
         var _loc15_:Number = (param3.y - param2.y) / (_loc10_.length / param8);
         var _loc16_:Number = param2.x;
         var _loc17_:Number = param2.y;
         param1.moveTo(_loc16_,_loc17_);
         var _loc18_:int = 0;
         while(_loc18_ < _loc11_)
         {
            param1.moveTo(_loc16_,_loc17_);
            _loc16_ = _loc16_ + _loc12_;
            _loc17_ = _loc17_ + _loc13_;
            param1.lineTo(_loc16_,_loc17_);
            _loc16_ = _loc16_ + _loc14_;
            _loc17_ = _loc17_ + _loc15_;
            _loc18_++;
         }
      }
   }
}
