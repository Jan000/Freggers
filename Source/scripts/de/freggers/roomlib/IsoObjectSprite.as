package de.freggers.roomlib
{
   import de.freggers.isocomp.AIsoComponent;
   import de.freggers.isostar.IsoSprite;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import flash.geom.Matrix;
   
   public class IsoObjectSprite extends IsoSprite
   {
      
      public static const SPRITE_MASK_SIMPLE:int = 0;
      
      public static const SPRITE_MASK_BOTTOM_LEFT:int = 1;
      
      public static const SPRITE_MASK_BOTTOM_RIGHT:int = 2;
      
      public static const SPRITE_MASK_TOP_LEFT:int = 4;
      
      public static const SPRITE_MASK_TOP_RIGHT:int = 8;
       
      
      private var _component:AIsoComponent;
      
      private var _componentbmd:ICroppedBitmapDataContainer;
      
      private var _componentmatrix:Matrix;
      
      private var _media:IsoObjectMedia;
      
      private var _hasDefaults:Boolean = false;
      
      public function IsoObjectSprite(param1:Function = null, param2:Function = null)
      {
         super(new IsoObjectSpriteContent(),param1,param2);
         this._media = new IsoObjectMedia();
         this._media.onDefaultsAvailable = this.handleDefaultsAvailable;
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
         if(this._componentbmd)
         {
            this._componentbmd.dispose();
            this._componentbmd = null;
         }
         this._component = null;
         this._componentmatrix = null;
         if(this._media != null)
         {
            this._media.cleanup();
         }
         this._media = null;
      }
      
      public function handleDefaultsAvailable(param1:IsoObjectMedia) : void
      {
         topheight = this._media.topHeight;
         totalheight = this._media.totalHeight;
         this._hasDefaults = true;
      }
      
      public function get media() : IsoObjectMedia
      {
         return this._media;
      }
      
      public function get hasDefaults() : Boolean
      {
         return this._hasDefaults;
      }
      
      public function updateFrame(param1:String, param2:int, param3:int) : void
      {
         if(!this._media.hasFrame(param1,param2,param3))
         {
            return;
         }
         var _loc4_:ICroppedBitmapDataContainer = this._media.getFrame(param1,param2,param3);
         if(!_loc4_)
         {
            return;
         }
         (_content as IsoObjectSpriteContent).setBitmapData(_loc4_,(bounds.width - _loc4_.width) / 2,bounds.height - _loc4_.height);
      }
      
      function updateIsoObjectDisplay(param1:String, param2:int, param3:int) : void
      {
         if(param1 == null || param2 < 0 || param3 < 0 || !this._media.hasFrame(param1,param2,param3))
         {
            if(this._hasDefaults)
            {
               param1 = this._media.defaultAnimation;
               param3 = this._media.defaultFrame;
               if(!this._media.hasFrame(param1,param2,param3))
               {
                  param2 = this.media.defaultDirection;
               }
            }
            else
            {
               return;
            }
         }
         grip = this._media.getGrip(param1,param2);
         _intratilemask = this._media.getMask(param1,param2);
         this.updateFrame(param1,param2,param3);
      }
      
      override protected function get needsDirectionOffset() : Boolean
      {
         return this._media && this._media.version >= 3 && direction % 2 != 0;
      }
   }
}
