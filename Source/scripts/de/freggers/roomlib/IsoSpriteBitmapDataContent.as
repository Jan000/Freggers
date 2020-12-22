package de.freggers.roomlib
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public final class IsoSpriteBitmapDataContent extends IsoSpriteDisplayObjectContent
   {
       
      
      public function IsoSpriteBitmapDataContent(param1:BitmapData)
      {
         super(new Bitmap(param1));
      }
      
      public function get bitmapData() : BitmapData
      {
         return (displayObject as Bitmap).bitmapData;
      }
   }
}
