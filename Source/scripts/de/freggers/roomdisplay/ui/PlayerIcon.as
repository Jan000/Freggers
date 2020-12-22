package de.freggers.roomdisplay.ui
{
   import de.freggers.roomlib.Player;
   import de.freggers.util.BitmapDataUtils;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import de.freggers.util.TextRenderer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   
   public class PlayerIcon extends Sprite
   {
      
      public static const FULL_BODY:int = 0;
      
      public static const HEAD_ONLY:int = 1;
      
      private static const OUTLINE_FILTERS:Array = [new GlowFilter(16777215,1,4,4,5),new DropShadowFilter(3,90,0,0.75,5,5)];
       
      
      public function PlayerIcon(param1:Player, param2:int, param3:int = 0, param4:Boolean = false)
      {
         var _loc6_:BitmapData = null;
         var _loc8_:Rectangle = null;
         var _loc9_:BitmapData = null;
         var _loc10_:StyleSheet = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Bitmap = null;
         super();
         param2 = param2 % 7;
         if(!param1 || !param1.isoobj.media.hasDefaultDatapack())
         {
            return;
         }
         if(!param1.isoobj.media.hasFrame(param1.isoobj.media.defaultAnimation,param2,param1.isoobj.media.defaultFrame))
         {
            return;
         }
         var _loc5_:ICroppedBitmapDataContainer = param1.isoobj.media.getFrame(param1.isoobj.media.defaultAnimation,param2,param1.isoobj.media.defaultFrame);
         switch(param3)
         {
            case HEAD_ONLY:
               _loc6_ = BitmapDataUtils.unCrop(_loc5_.bitmapData,_loc5_.crect.topLeft,_loc5_.rect);
               _loc8_ = new Rectangle(0,0,_loc6_.width,77);
               _loc9_ = new BitmapData(_loc8_.width,_loc8_.height);
               _loc9_.copyPixels(_loc6_,_loc8_,_loc6_.rect.topLeft);
               _loc6_ = BitmapDataUtils.crop(_loc9_);
               break;
            case FULL_BODY:
            default:
               _loc6_ = _loc5_.bitmapData;
         }
         var _loc7_:Bitmap = new Bitmap(_loc6_,PixelSnapping.AUTO,true);
         _loc7_.x = -_loc6_.width / 2;
         _loc7_.y = -_loc6_.height;
         addChild(_loc7_);
         if(param4)
         {
            _loc10_ = new StyleSheet();
            _loc10_.setStyle(".foo",{
               "fontWeight":"bold",
               "fontSize":12,
               "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif"
            });
            _loc11_ = TextRenderer.renderToBitmap("<span class=\'foo\'>" + param1.name + "</span>",_loc10_);
            _loc12_ = new Bitmap(_loc11_,PixelSnapping.AUTO,true);
            _loc12_.x = -_loc11_.width / 2;
            addChild(_loc12_);
         }
         filters = OUTLINE_FILTERS.concat();
      }
   }
}
