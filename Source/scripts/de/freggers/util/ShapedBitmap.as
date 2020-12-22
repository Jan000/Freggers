package de.freggers.util
{
   import de.schulterklopfer.interaction.util.InteractiveBitmapDataContainerSprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public final class ShapedBitmap extends InteractiveBitmapDataContainerSprite
   {
       
      
      public function ShapedBitmap(param1:BitmapData)
      {
         super();
         bitmap = new Bitmap(param1,"never",true);
         addChild(bitmap);
      }
   }
}
