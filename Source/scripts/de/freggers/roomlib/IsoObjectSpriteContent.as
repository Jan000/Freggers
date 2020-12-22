package de.freggers.roomlib
{
   import de.freggers.content.Effects;
   import de.freggers.content.IIsoSpriteContent;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import de.schulterklopfer.interaction.util.InteractiveBitmapDataContainerSprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   
   public final class IsoObjectSpriteContent extends InteractiveBitmapDataContainerSprite implements IIsoSpriteContent
   {
      
      public static const FILTER_MARK:BitmapFilter = new ColorMatrixFilter([1,0,0,0,255 / 6,0,1,0,0,255 / 6,0,0,1,0,255 / 6,0,0,0,1,0]);
      
      public static const FILTER_TARGET:BitmapFilter = FILTER_MARK;
      
      public static const FILTER_OUTLINE:BitmapFilter = new GlowFilter(16777215,1,2,2,2,1,true,true);
      
      public static const FILTER_COLLISION:BitmapFilter = new ColorMatrixFilter([1,0.33,0.33,0,255,0,0.33,0.33,0,0,0,0.33,0.33,0,0,0,0,0,1,0]);
      
      public static const FILTER_CLOAK:BitmapFilter = new ColorMatrixFilter([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.5,0]);
      
      public static const FILTER_ACTIVESOUND:BitmapFilter = new GlowFilter(16777215,1,3,3,3);
      
      private static const FILTER_MODEL:BitmapFilter = new ColorMatrixFilter([0.1,0.1,0.1,0,127,0.1,0.1,0.1,0,127,0.5,0.5,0.5,0,127,0,0,0,1,0]);
      
      private static const SUBFILTER_SPOOK_GHOST:BitmapFilter = new ColorMatrixFilter([0.7,0.2,0.2,0,25,0.2,0.7,0.2,0,25,0.2,0.2,0.7,0,25,0,0,0,0.5,0]);
      
      private static const SUBFILTER_SPOOK_GLOW:BitmapFilter = new GlowFilter(12320751,0.7,16,16,3,1);
      
      private static const FILTER_SPOOK:Array = new Array(SUBFILTER_SPOOK_GHOST,SUBFILTER_SPOOK_GLOW);
      
      public static const FLAG_MARK:uint = 4;
      
      public static const FLAG_OUTLINE:uint = 8;
      
      public static const FLAG_COLLISION:uint = 16;
      
      public static const FLAG_CLOAK:uint = 64;
      
      public static const FLAG_ACTIVESOUND:uint = 128;
      
      public static const FLAG_TARGET:uint = 256;
      
      public static const FLAG_MODEL:uint = 1024;
      
      public static const FLAG_SPOOK:uint = 512;
      
      private static var flagorder:Array = [FLAG_OUTLINE,FLAG_ACTIVESOUND,FLAG_MARK,FLAG_COLLISION,FLAG_CLOAK,FLAG_TARGET,FLAG_MODEL];
      
      private static var filterorder:Array = [FILTER_OUTLINE,FILTER_ACTIVESOUND,FILTER_MARK,FILTER_COLLISION,FILTER_CLOAK,FILTER_TARGET,FILTER_MODEL];
       
      
      private var _bounds:Rectangle;
      
      private var _isogfx:Sprite;
      
      private var _carryIcon:CarryIcon;
      
      private var _locatorArrow:MovieClip;
      
      private var _flags:uint = 0;
      
      private var _croppedBitmapData:ICroppedBitmapDataContainer;
      
      private var _effectsLayer:Sprite;
      
      private var _effects:Effects;
      
      private var _handleMouseCallback:Function;
      
      private var _displayBitmap:Bitmap;
      
      public function IsoObjectSpriteContent()
      {
         super();
         bitmap = new Bitmap();
         bitmap.visible = false;
         this._bounds = new Rectangle();
         this._isogfx = new Sprite();
         this._displayBitmap = new Bitmap();
         this._isogfx.mouseEnabled = this._isogfx.mouseChildren = false;
         this._effectsLayer = new Sprite();
         this._effectsLayer.mouseEnabled = this._effectsLayer.mouseChildren = false;
         this._effects = new Effects();
         this._isogfx.addChild(bitmap);
         this._isogfx.addChild(this._displayBitmap);
         this._isogfx.addChild(this._effectsLayer);
         this._effects.renderLayer = this._effectsLayer;
         addChild(this._isogfx);
      }
      
      public function setBitmapData(param1:ICroppedBitmapDataContainer, param2:int, param3:int) : void
      {
         var _loc4_:Rectangle = new Rectangle(this._displayBitmap.x,this._displayBitmap.y,this._displayBitmap.width,this._displayBitmap.height);
         var _loc5_:BitmapData = this._displayBitmap.bitmapData;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = this._bounds.width != param1.width || this._bounds.height != param1.height;
         if(this._croppedBitmapData)
         {
            _loc6_ = this._croppedBitmapData.isvirtual;
         }
         this._croppedBitmapData = param1;
         this._displayBitmap.bitmapData = this._croppedBitmapData.bitmapData;
         if(_loc5_ && _loc6_)
         {
            _loc5_.dispose();
         }
         this._displayBitmap.x = param1.crect.x + param2;
         this._displayBitmap.y = param1.crect.y + param3;
         var _loc8_:BitmapData = new BitmapData(param1.rect.width,param1.rect.height,true,0);
         _loc8_.copyPixels(this._displayBitmap.bitmapData,this._displayBitmap.bitmapData.rect,param1.crect.topLeft);
         _loc8_.threshold(_loc8_,_loc8_.rect,_loc8_.rect.topLeft,"<",1073741824,0,4278190080);
         _loc8_.floodFill(0,0,4278255360);
         _loc8_.floodFill(this._displayBitmap.width - 1,this._displayBitmap.height - 1,4278255360);
         _loc8_.threshold(_loc8_,_loc8_.rect,_loc8_.rect.topLeft,"!=",4278255360,4294901760);
         _loc8_.threshold(_loc8_,_loc8_.rect,_loc8_.rect.topLeft,"==",4278255360,0);
         _loc5_ = bitmap.bitmapData;
         bitmap.bitmapData = _loc8_;
         if(_loc5_ != null)
         {
            _loc5_.dispose();
         }
         bitmap.x = param2;
         bitmap.y = param3;
         this._bounds.width = param1.width;
         this._bounds.height = param1.height;
         this._effectsLayer.x = param2;
         this._effectsLayer.y = param3;
      }
      
      public function getBitmapData() : BitmapData
      {
         return this._displayBitmap.bitmapData;
      }
      
      override public function get width() : Number
      {
         return this._bounds.width;
      }
      
      override public function get height() : Number
      {
         return this._bounds.height;
      }
      
      public function set carryIcon(param1:CarryIcon) : void
      {
         var _loc2_:uint = 0;
         if(this._carryIcon == param1)
         {
            return;
         }
         if(this._carryIcon && this == this._carryIcon.parent)
         {
            this.removeChild(this._carryIcon);
         }
         this._carryIcon = param1;
         if(this._carryIcon)
         {
            this._carryIcon.mouseEnabled = this._carryIcon.mouseEnabled = false;
            _loc2_ = numChildren;
            if(this._locatorArrow)
            {
               _loc2_--;
            }
            addChildAt(this._carryIcon,_loc2_);
         }
      }
      
      public function get carryIcon() : CarryIcon
      {
         return this._carryIcon;
      }
      
      public function set locatorArrow(param1:MovieClip) : void
      {
         if(this._locatorArrow == param1)
         {
            return;
         }
         if(this._locatorArrow && this == this._locatorArrow.parent)
         {
            this.removeChild(this._locatorArrow);
         }
         this._locatorArrow = param1;
         if(this._locatorArrow)
         {
            this._locatorArrow.mouseEnabled = false;
            addChild(this._locatorArrow);
         }
      }
      
      public function get locatorArrow() : MovieClip
      {
         return this._locatorArrow;
      }
      
      public function set direction(param1:int) : void
      {
         if(this._carryIcon)
         {
            this._carryIcon.direction = param1;
         }
      }
      
      public function set flags(param1:uint) : void
      {
         if(this._flags == param1)
         {
            return;
         }
         this._flags = param1;
         this.updateFilters();
      }
      
      public function get flags() : uint
      {
         return this._flags;
      }
      
      private function updateFilters() : void
      {
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         var _loc3_:BitmapFilter = null;
         this._displayBitmap.filters = !!(this._flags & FLAG_SPOOK)?FILTER_SPOOK:null;
         var _loc4_:uint = this._flags;
         if((_loc4_ & FLAG_MODEL) != 0 && (_loc4_ & FLAG_MARK) != 0)
         {
            _loc4_ = _loc4_ & (~FLAG_MODEL & ~FLAG_MARK);
         }
         var _loc5_:uint = 0;
         while(_loc5_ < flagorder.length)
         {
            _loc2_ = flagorder[_loc5_] as uint;
            _loc3_ = filterorder[_loc5_] as BitmapFilter;
            if((_loc4_ & _loc2_) != 0)
            {
               if(!_loc1_)
               {
                  _loc1_ = new Array();
               }
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         this._isogfx.filters = _loc1_;
      }
      
      public function cleanup() : void
      {
         var _loc1_:BitmapData = null;
         if(this._croppedBitmapData && this._croppedBitmapData.isvirtual)
         {
            _loc1_ = this._croppedBitmapData.bitmapData;
            if(_loc1_ != null)
            {
               _loc1_.dispose();
            }
         }
         _loc1_ = bitmap.bitmapData;
         bitmap.bitmapData = null;
         if(_loc1_ != null)
         {
            _loc1_.dispose();
         }
      }
      
      public function update(param1:int) : void
      {
         if(this._effects != null)
         {
            this._effects.update(param1);
         }
      }
      
      public function get displayObject() : DisplayObject
      {
         return this._displayBitmap;
      }
      
      public function get effects() : Effects
      {
         return this._effects;
      }
      
      override public function toString() : String
      {
         return "IsoObjectSpriteContent[name=" + name + "]";
      }
   }
}
