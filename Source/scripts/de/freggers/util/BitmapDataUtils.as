package de.freggers.util
{
   import flash.display.BitmapData;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class BitmapDataUtils
   {
       
      
      public function BitmapDataUtils()
      {
         super();
      }
      
      public static function recolorBitmapData(param1:BitmapData, param2:Array, param3:Boolean = false) : BitmapData
      {
         var _loc4_:BitmapData = null;
         var _loc5_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         if(!param1)
         {
            return param1;
         }
         if(param3)
         {
            _loc4_ = param1.clone();
         }
         else
         {
            _loc4_ = param1;
         }
         param2.length = 3;
         _loc5_ = 0;
         while(_loc5_ < param2.length)
         {
            if(!param2[_loc5_] || !(param2[_loc5_] is int))
            {
               param2[_loc5_] = 0;
            }
            _loc5_++;
         }
         var _loc6_:Array = new Array(256);
         var _loc7_:Array = new Array(256);
         var _loc8_:Array = new Array(256);
         _loc5_ = 0;
         while(_loc5_ < 255)
         {
            _loc9_ = _loc5_ / 255;
            _loc10_ = (param2[0] >> 16 & 255) * _loc9_;
            _loc13_ = (param2[0] >> 8 & 255) * _loc9_;
            _loc16_ = (param2[0] & 255) * _loc9_;
            _loc6_[_loc5_] = (_loc10_ & 255) << 16 | (_loc13_ & 255) << 8 | _loc16_ & 255;
            _loc11_ = (param2[1] >> 16 & 255) * _loc9_;
            _loc14_ = (param2[1] >> 8 & 255) * _loc9_;
            _loc17_ = (param2[1] & 255) * _loc9_;
            _loc7_[_loc5_] = (_loc11_ & 255) << 16 | (_loc14_ & 255) << 8 | _loc17_ & 255;
            _loc12_ = (param2[2] >> 16 & 255) * _loc9_;
            _loc15_ = (param2[2] >> 8 & 255) * _loc9_;
            _loc18_ = (param2[2] & 255) * _loc9_;
            _loc8_[_loc5_] = (_loc12_ & 255) << 16 | (_loc15_ & 255) << 8 | _loc18_ & 255;
            _loc5_++;
         }
         _loc4_.colorTransform(_loc4_.rect,new ColorTransform(1 / 3,1 / 3,1 / 3,1,0,0,0,0));
         _loc4_.paletteMap(_loc4_,_loc4_.rect,new Point(0,0),_loc6_,_loc7_,_loc8_,null);
         _loc4_.colorTransform(_loc4_.rect,new ColorTransform(3,3,3,1,0,0,0,0));
         return _loc4_;
      }
      
      public static function crop(param1:BitmapData, param2:uint = 1) : BitmapData
      {
         if(!param1)
         {
            return null;
         }
         var _loc3_:Rectangle = getCropRectangle(param1,param2);
         if(_loc3_.isEmpty())
         {
            return null;
         }
         if(_loc3_.equals(param1.rect))
         {
            return param1.clone();
         }
         var _loc4_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height,param1.transparent);
         _loc4_.copyPixels(param1,_loc3_,_loc4_.rect.topLeft);
         return _loc4_;
      }
      
      public static function scale(param1:BitmapData, param2:Number, param3:Number) : BitmapData
      {
         if(param1 == null)
         {
            return null;
         }
         if(param2 == 1 && param3 == 1)
         {
            return param1.clone();
         }
         var _loc4_:int = Math.ceil(param1.width * param2);
         var _loc5_:int = Math.ceil(param1.height * param3);
         var _loc6_:Matrix = new Matrix();
         _loc6_.scale(_loc4_ / param1.width,_loc5_ / param1.height);
         var _loc7_:BitmapData = new BitmapData(_loc4_,_loc5_,param1.transparent,0);
         _loc7_.draw(param1,_loc6_,null,null,null,true);
         return _loc7_;
      }
      
      public static function scaleToSize(param1:BitmapData, param2:int, param3:int, param4:Boolean = false) : BitmapData
      {
         var _loc5_:BitmapData = null;
         var _loc6_:Matrix = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(!param1)
         {
            return null;
         }
         if(param2 != param1.width || param3 != param1.height)
         {
            _loc6_ = new Matrix();
            _loc7_ = param2 / param1.width;
            _loc8_ = param3 / param1.height;
            if(param4)
            {
               _loc7_ = _loc8_ = _loc7_ < _loc8_?Number(_loc7_):Number(_loc8_);
            }
            _loc6_.scale(_loc7_,_loc8_);
            _loc5_ = new BitmapData(param2,param3,true,0);
            _loc5_.draw(param1,_loc6_,null,null,null,true);
            param1.dispose();
         }
         else
         {
            _loc5_ = param1;
         }
         return _loc5_;
      }
      
      public static function cropAndScaleToSize(param1:BitmapData, param2:int, param3:int, param4:Boolean = false) : BitmapData
      {
         var _loc7_:BitmapData = null;
         var _loc8_:Matrix = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(!param1)
         {
            return null;
         }
         var _loc5_:Rectangle = getCropRectangle(param1);
         if(!_loc5_)
         {
            return null;
         }
         var _loc6_:BitmapData = new BitmapData(_loc5_.width,_loc5_.height,true,0);
         _loc6_.copyPixels(param1,_loc5_,_loc6_.rect.topLeft);
         if(param2 != _loc6_.width || param3 != _loc6_.height)
         {
            _loc8_ = new Matrix();
            _loc9_ = param2 / _loc6_.width;
            _loc10_ = param3 / _loc6_.height;
            if(param4)
            {
               _loc9_ = _loc10_ = _loc9_ < _loc10_?Number(_loc9_):Number(_loc10_);
            }
            _loc8_.scale(_loc9_,_loc10_);
            _loc7_ = new BitmapData(param2,param3,true,0);
            _loc7_.draw(_loc6_,_loc8_,null,null,null,true);
            _loc6_.dispose();
         }
         else
         {
            _loc7_ = _loc6_;
         }
         return _loc7_;
      }
      
      public static function getRectByBrightness(param1:BitmapData, param2:Number) : Rectangle
      {
         var _loc3_:uint = 255 * param2;
         param1.applyFilter(param1,param1.rect,param1.rect.topLeft,new ColorMatrixFilter([1,0,0,0,-_loc3_,0,1,0,0,-_loc3_,0,0,1,0,-_loc3_,0,0,0,1,0]));
         return param1.getColorBoundsRect(4294967295,4278190080,false);
      }
      
      public static function selectPixels(param1:BitmapData, param2:Rectangle, param3:uint, param4:uint) : Rectangle
      {
         var _loc15_:uint = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         if(!param1 || param2.isEmpty())
         {
            return new Rectangle();
         }
         var _loc5_:Rectangle = param1.rect.intersection(param2);
         if(_loc5_.isEmpty())
         {
            return _loc5_;
         }
         var _loc6_:int = -1;
         var _loc7_:int = -1;
         var _loc8_:int = -1;
         var _loc9_:int = -1;
         var _loc10_:uint = param4 >> 24 & 255;
         var _loc11_:uint = param4 >> 16 & 255;
         var _loc12_:uint = param4 >> 8 & 255;
         var _loc13_:uint = param4 & 255;
         var _loc14_:ByteArray = param1.getPixels(_loc5_);
         _loc14_.position = 0;
         while(_loc14_.bytesAvailable)
         {
            _loc15_ = _loc14_.readUnsignedInt() & param3;
            if(_loc15_ != 0 && (_loc15_ >> 24 & 255) >= _loc10_ && (_loc15_ >> 16 & 255) >= _loc11_ && (_loc15_ >> 8 & 255) >= _loc12_ && (_loc15_ & 255) >= _loc13_)
            {
               _loc17_ = _loc14_.position / 4 % _loc5_.width;
               _loc18_ = _loc14_.position / 4 / _loc5_.width;
               if(_loc6_ < 0)
               {
                  _loc6_ = _loc17_;
                  _loc7_ = _loc17_;
                  _loc8_ = _loc18_;
                  _loc9_ = _loc18_;
               }
               else
               {
                  if(_loc17_ < _loc6_)
                  {
                     _loc6_ = _loc17_;
                  }
                  else if(_loc17_ > _loc7_)
                  {
                     _loc7_ = _loc17_;
                  }
                  if(_loc18_ < _loc8_)
                  {
                     _loc8_ = _loc18_;
                  }
                  else if(_loc18_ > _loc9_)
                  {
                     _loc9_ = _loc18_;
                  }
               }
            }
            _loc14_.position = _loc14_.position + 4;
         }
         var _loc16_:Rectangle = new Rectangle();
         if(_loc6_ >= 0)
         {
            _loc16_.x = _loc6_ + _loc5_.x;
            _loc16_.y = _loc8_ + _loc5_.y;
            _loc16_.width = _loc7_ - _loc6_ + 1;
            _loc16_.height = _loc9_ - _loc8_ + 1;
         }
         return _loc16_;
      }
      
      public static function getCropRectangle(param1:BitmapData, param2:uint = 1) : Rectangle
      {
         var _loc3_:Rectangle = param1.getColorBoundsRect(4278190080,0,false);
         if(param2 > 1)
         {
            _loc3_ = selectPixels(param1,_loc3_,4278190080,(param2 & 255) << 24);
         }
         return _loc3_;
      }
      
      public static function unCrop(param1:BitmapData, param2:Point, param3:Rectangle, param4:uint = 0) : BitmapData
      {
         var _loc5_:BitmapData = new BitmapData(param3.width,param3.height,true,param4);
         _loc5_.copyPixels(param1,param1.rect,param2);
         return _loc5_;
      }
   }
}
