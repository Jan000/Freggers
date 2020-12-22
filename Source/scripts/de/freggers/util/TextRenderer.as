package de.freggers.util
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class TextRenderer
   {
       
      
      public function TextRenderer()
      {
         super();
      }
      
      public static function renderToBitmap(param1:String, param2:StyleSheet, param3:int = 0, param4:Boolean = true, param5:uint = 0, param6:Boolean = false) : BitmapData
      {
         var _loc12_:TextFormat = null;
         var _loc13_:Number = NaN;
         var _loc14_:TextLineMetrics = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:Number = NaN;
         var _loc18_:Matrix = null;
         var _loc7_:TextField = new TextField();
         _loc7_.wordWrap = true;
         _loc7_.multiline = param4;
         _loc7_.antiAliasType = AntiAliasType.ADVANCED;
         _loc7_.border = false;
         _loc7_.autoSize = TextFieldAutoSize.LEFT;
         if(param3 > 0 && !param6)
         {
            _loc7_.width = param3;
         }
         else
         {
            _loc7_.width = 999;
         }
         _loc7_.selectable = false;
         _loc7_.styleSheet = param2;
         _loc7_.htmlText = param1;
         var _loc8_:Number = _loc7_.height;
         if(param5 > 0)
         {
            _loc12_ = _loc7_.getTextFormat();
            _loc13_ = 0;
            _loc15_ = Math.min(_loc7_.numLines,param5);
            _loc16_ = 0;
            while(_loc16_ < _loc15_)
            {
               _loc14_ = _loc7_.getLineMetrics(_loc16_);
               _loc13_ = _loc13_ + (_loc14_.height + 2);
               _loc16_++;
            }
            _loc8_ = Math.min(_loc8_,_loc13_);
         }
         var _loc9_:BitmapData = new BitmapData(_loc7_.width,Math.ceil(_loc8_),true,0);
         _loc9_.draw(_loc7_);
         var _loc10_:Rectangle = _loc9_.getColorBoundsRect(4278190080,0,false);
         if(_loc10_.height <= 0 || _loc10_.width <= 0)
         {
            _loc10_.width = 1;
            _loc10_.height = 1;
            _loc10_.x = _loc10_.y = 0;
         }
         var _loc11_:BitmapData = new BitmapData(_loc10_.width,_loc10_.height,true,0);
         _loc11_.copyPixels(_loc9_,_loc10_,_loc11_.rect.topLeft);
         _loc9_.dispose();
         if(param6 && _loc11_.width > param3)
         {
            _loc17_ = param3 / _loc11_.width;
            if(int(_loc11_.width * _loc17_) == 0 || int(_loc11_.height * _loc17_) == 0)
            {
               return null;
            }
            _loc18_ = new Matrix();
            _loc18_.scale(_loc17_,_loc17_);
            _loc9_ = new BitmapData(_loc11_.width * _loc17_,_loc11_.height * _loc17_,true,0);
            _loc9_.draw(_loc11_,_loc18_,null,null,null,true);
            _loc11_.dispose();
            _loc11_ = _loc9_;
         }
         return _loc11_;
      }
   }
}
