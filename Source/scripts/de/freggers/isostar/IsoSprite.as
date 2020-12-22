package de.freggers.isostar
{
   import de.freggers.content.IIsoSpriteContent;
   import de.freggers.data.Lightmap;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class IsoSprite extends IsoSortable implements IEventTarget
   {
      
      public static const FLAG_SHADOW:int = 512;
      
      public static const FLAG_LIGHT:int = 1024;
      
      public static const FLAG_INVALID:int = 2048;
      
      public static const FLAG_GHOSTTRAIL:int = 4096;
      
      public static const FLAG_NO_INTRATILE_MASK:int = 8192;
      
      public static const FLAG_SKIP_GROUPCHECK:int = 16384;
      
      private static const MASK_OFFSETS:Array = [new Point(0,0),new Point(0,1),new Point(1,0)];
      
      private static function equalsPoint(param1:Point, param2:int, param3:Vector.<Point>):Boolean
      {
         return (this as Point).equals(param1);
      } 
      
      private var _cutmaskbm:Bitmap;
      
      private var _cutmaskbmd:BitmapData;
      
      private var _colormatrixfilter:ColorMatrixFilter;
      
      private var _enableMouse:Boolean = true;
      
      private var _hasmouse:Boolean;
      
      private var _topX:Number;
      
      private var _topY:Number;
      
      protected var _shadow:IsoShadow;
      
      protected var _light:IsoLight;
      
      private var _grip:BitmapData;
      
      protected var _subgripbounds:Rectangle;
      
      protected var _gripbounds:Rectangle;
      
      private var _lightmap:Lightmap;
      
      private var _lightintensity:Number = 0;
      
      private var _lightcolor:uint;
      
      private var _isoparent:IIsoContainer;
      
      private var _topheight:uint;
      
      private var _totalheight:uint;
      
      protected var _content:IIsoSpriteContent;
      
      private var _icon:DisplayObject;
      
      protected var _intratilemask:ICroppedBitmapDataContainer;
      
      private var _direction:uint;
      
      private var _isAdded:Boolean = false;
      
      private var _displayindextf:TextField;
      
      private var _bbox:Sprite;
      
      private var _border:Sprite;
      
      private var _base:Sprite;
      
      private var _gripbm:Bitmap;
      
      private var _onAddCallback:Function;
      
      private var _onRemoveCallback:Function;
      
      public function IsoSprite(param1:IIsoSpriteContent, param2:Function = null, param3:Function = null)
      {
         super();
         this.init(param1);
         this._onAddCallback = param2;
      }
      
      private function init(param1:IIsoSpriteContent) : void
      {
         this._content = param1;
         this._cutmaskbm = new Bitmap();
         this._colormatrixfilter = new ColorMatrixFilter();
         var _loc2_:DisplayObject = this._content as DisplayObject;
         if(_loc2_ != null)
         {
            if(_loc2_.parent && _loc2_.parent == this)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
            this.addChild(_loc2_);
         }
         this.addChild(this._cutmaskbm);
         this._cutmaskbm.blendMode = BlendMode.ERASE;
      }
      
      override public function set filters(param1:Array) : void
      {
      }
      
      public function get isoparent() : IIsoContainer
      {
         return this._isoparent;
      }
      
      public function set isoparent(param1:IIsoContainer) : void
      {
         this._isoparent = param1;
      }
      
      public function set lightmap(param1:Lightmap) : void
      {
         if(this._lightmap == param1)
         {
            return;
         }
         if(this._isoparent && this._lightmap)
         {
            this._isoparent.removeLight(this);
         }
         this._lightmap = param1;
         if(this._isoparent && param1)
         {
            this._isoparent.addLight(this);
         }
      }
      
      public function get lightmap() : Lightmap
      {
         return this._lightmap;
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      public function set direction(param1:int) : void
      {
         this._direction = param1;
         if(this._light)
         {
            this._light.dir = this._direction;
         }
         if(this._content)
         {
            this._content.direction = param1;
         }
      }
      
      override public function update(param1:int) : void
      {
         super.update(param1);
         if(this._content)
         {
            this._content.update(param1);
         }
         removeDirty();
      }
      
      override public function set flags(param1:int) : void
      {
         if((param1 & FLAG_SHADOW) != 0)
         {
            if(!this._shadow)
            {
               this._shadow = new IsoShadow(this._isoparent,this._grip,getIsoPosition(true),getFlagArgs(FLAG_SHADOW) as IsoShadowConfig);
               if(group)
               {
                  group.addIsoShadow(this._shadow as IsoShadow);
               }
            }
         }
         else if(this._shadow)
         {
            if(group)
            {
               group.removeIsoShadow(this._shadow as IsoShadow);
            }
            this._shadow = null;
         }
         if((param1 & FLAG_GHOSTTRAIL) != 0)
         {
            if((_flags & FLAG_GHOSTTRAIL) == 0)
            {
               if(group)
               {
                  group.notifyAddFlag(this,FLAG_GHOSTTRAIL);
               }
            }
         }
         else if((_flags & FLAG_GHOSTTRAIL) != 0)
         {
            if(group)
            {
               group.notifyRemoveFlag(this,FLAG_GHOSTTRAIL);
            }
         }
         _flags = param1;
      }
      
      public function set grip(param1:BitmapData) : void
      {
         if(this._grip == param1)
         {
            return;
         }
         this._grip = param1;
         if(this._grip == null)
         {
            return;
         }
         this._gripbounds = this._grip.rect;
         this._subgripbounds = this._grip.getColorBoundsRect(4294967295,4278190080);
         if(this._shadow)
         {
            this._shadow.grip = this._grip;
         }
         this.updateIsoBounds();
         this.updateScreenPosition();
         this.updateCutmask();
         addGroupLayerTaint();
      }
      
      public function set content(param1:IIsoSpriteContent) : void
      {
         if(!param1)
         {
            return;
         }
         this._content = param1;
         var _loc2_:DisplayObject = param1 as DisplayObject;
         if(_loc2_ != null)
         {
            if(_loc2_.parent && _loc2_.parent == this)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
            this.addChild(_loc2_);
         }
      }
      
      public function get content() : IIsoSpriteContent
      {
         return this._content;
      }
      
      public function getContentDisplayObjectBounds(param1:DisplayObject = null) : Rectangle
      {
         if(param1 == null)
         {
            param1 = this.parent;
         }
         if(param1 == null)
         {
            return null;
         }
         return this.content.displayObject.getBounds(param1);
      }
      
      public function updateLight(param1:Boolean = false) : void
      {
         var _loc7_:Number = NaN;
         if(this._isoparent == null)
         {
            return;
         }
         var _loc2_:uint = this._isoparent.getLightAt(isoU,isoV);
         if(this._lightcolor == _loc2_ && !param1)
         {
            return;
         }
         this._lightcolor = _loc2_;
         var _loc3_:Number = _loc2_ >> 16 & 255;
         var _loc4_:Number = _loc2_ >> 8 & 255;
         var _loc5_:Number = _loc2_ & 255;
         var _loc6_:Array = this._colormatrixfilter.matrix;
         _loc6_[0] = _loc3_ / 128;
         _loc6_[6] = _loc4_ / 128;
         _loc6_[12] = _loc5_ / 128;
         this._colormatrixfilter.matrix = _loc6_;
         super.filters = [this._colormatrixfilter];
         if(this._shadow)
         {
            _loc7_ = Math.max(_loc3_,_loc4_,_loc5_) / 128;
            this._shadow.brightness = 0.1 + (_loc7_ + 1) / 10;
         }
      }
      
      private function updateShadowPosition() : void
      {
         if(this._shadow == null || this._isoparent == null)
         {
            return;
         }
         this._shadow.setIsoPosition(isoU,isoV,this._isoparent.getHeightAt(isoU,isoV));
      }
      
      public function updateLightPosition() : void
      {
         if(this._light == null || this._isoparent == null)
         {
            return;
         }
         this._light.uvzValues(isoU,isoV,this._isoparent.getHeightAt(isoU,isoV));
      }
      
      override protected function recalc() : void
      {
         super.recalc();
         this.updateIsoBounds();
         this.updateLight();
         this.updateScreenPosition();
         this.updateCutmask();
         this.updateShadowPosition();
         this.updateLightPosition();
      }
      
      private function updateScreenPosition() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         if(!this._grip)
         {
            return;
         }
         var _loc4_:Point = IsoGrid.dim(this._grip.width,this._grip.height);
         var _loc5_:Number = IsoGrid.units2height(this._totalheight);
         bounds.width = _loc4_.x;
         bounds.height = _loc4_.y + _loc5_;
         _loc1_ = IsoGrid.xy(isoU - this._gripbounds.width / 2,isoV + this._gripbounds.height / 2,isoZ);
         _loc2_ = IsoGrid.xy(isoU + this._gripbounds.width / 2,isoV + this._gripbounds.height / 2,isoZ);
         _loc3_ = IsoGrid.xy(isoU - this._gripbounds.width / 2,isoV - this._gripbounds.height / 2,isoZ);
         var _loc6_:Number = !!this.needsDirectionOffset?Number(1 / Math.SQRT2):Number(1);
         bounds.x = baseX - bounds.width / 2;
         bounds.y = baseY - bounds.height + (_loc2_.y - _loc3_.y) / 2 * _loc6_;
         if(this._base)
         {
            this._base.x = (bounds.width - this._base.width) / 2;
            this._base.y = bounds.height - this._base.height;
         }
         if(this.x != bounds.x)
         {
            this.x = bounds.x;
         }
         if(this.y != bounds.y)
         {
            this.y = bounds.y;
         }
      }
      
      private function updateIsoBounds() : void
      {
         if(!this._grip)
         {
            return;
         }
         min_u = isoU - this._gripbounds.width / 2 + this._subgripbounds.x;
         max_u = min_u + this._subgripbounds.width - 1;
         min_v = isoV - this._gripbounds.height / 2 + this._subgripbounds.y;
         max_v = min_v + this._subgripbounds.height - 1;
         min_z = isoZ;
         max_z = min_z + this._topheight - 1;
         this._topX = IsoGrid.uvztox(isoU,isoV,isoZ + this._totalheight);
         this._topY = IsoGrid.uvztoy(isoU,isoV,isoZ + this._totalheight);
      }
      
      override public function cleanup() : void
      {
         if(this._cutmaskbmd)
         {
            this._cutmaskbmd.dispose();
            this._cutmaskbmd = null;
         }
         if(this.group)
         {
            if(this._shadow)
            {
               this.group.removeIsoShadow(this._shadow);
            }
            if(this._light)
            {
               this.group.removeIsoLight(this._light);
            }
         }
         if(this._content)
         {
            this._content.cleanup();
         }
         this._onAddCallback = null;
         this._onRemoveCallback = null;
      }
      
      private function updateBackgroundCutmask() : void
      {
         var _loc1_:ICroppedBitmapDataContainer = null;
         var _loc2_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc3_:Point = new Point();
         var _loc8_:Vector.<Point> = new Vector.<Point>();
         _loc11_ = Math.floor((isoU - this._gripbounds.width / 2) / IsoGrid.upt);
         _loc12_ = Math.ceil((isoU + this._gripbounds.width / 2) / IsoGrid.upt);
         _loc13_ = Math.floor((isoV - this._gripbounds.height / 2) / IsoGrid.upt);
         _loc14_ = Math.ceil((isoV + this._gripbounds.height / 2) / IsoGrid.upt);
         _loc9_ = _loc11_;
         while(_loc9_ <= _loc12_)
         {
            _loc8_.push(new Point(_loc9_,_loc14_));
            _loc9_++;
         }
         _loc10_ = _loc14_ - 1;
         while(_loc10_ >= _loc13_)
         {
            _loc8_.push(new Point(_loc12_,_loc10_));
            _loc10_--;
         }
         _loc11_ = Math.ceil((isoU - this._gripbounds.width / 2) / IsoGrid.upt);
         _loc12_ = Math.floor((isoU + this._gripbounds.width / 2) / IsoGrid.upt);
         _loc13_ = Math.ceil((isoV - this._gripbounds.height / 2) / IsoGrid.upt);
         _loc14_ = Math.floor((isoV + this._gripbounds.height / 2) / IsoGrid.upt);
         _loc9_ = _loc11_;
         while(_loc9_ <= _loc12_)
         {
            _loc2_ = new Point(_loc9_,_loc14_);
            if(!_loc8_.some(equalsPoint,_loc2_))
            {
               _loc8_.push(_loc2_);
            }
            _loc9_++;
         }
         _loc10_ = _loc14_ - 1;
         while(_loc10_ >= _loc13_)
         {
            _loc2_ = new Point(_loc12_,_loc10_);
            if(!_loc8_.some(equalsPoint,_loc2_))
            {
               _loc8_.push(_loc2_);
            }
            _loc10_--;
         }
         _loc6_ = _loc8_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc7_ = _loc8_[_loc4_] as Point;
            if(_loc7_)
            {
               _loc5_ = 0;
               while(_loc5_ < IsoStar.BACKGROUNDMASK_SEARCHDEPTH)
               {
                  _loc9_ = _loc7_.x + _loc5_;
                  _loc10_ = _loc7_.y + _loc5_;
                  if(!(_loc9_ < 0 || _loc10_ < 0))
                  {
                     _loc1_ = this._isoparent.getMask(_loc9_,_loc10_);
                     if(_loc1_)
                     {
                        _loc2_ = IsoGrid.xy(_loc9_,_loc10_,0,IsoGrid.MODE_MAIN);
                        _loc3_.x = _loc2_.x - IsoGrid.tile_width / 2 - bounds.x - this._cutmaskbm.x;
                        _loc3_.y = _loc2_.y - _loc1_.height + IsoGrid.tile_height - bounds.y - this._cutmaskbm.y;
                        this._cutmaskbmd.threshold(_loc1_.bitmapData,_loc1_.bitmapData.rect,_loc3_,"==",4294967295,4294967295);
                     }
                  }
                  _loc5_++;
               }
            }
            _loc4_++;
         }
      }
      
      private function updateIntraTileCutmask() : void
      {
         var _loc1_:ICroppedBitmapDataContainer = null;
         var _loc2_:uint = 0;
         var _loc5_:IsoSprite = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Rectangle = null;
         var _loc9_:Rectangle = null;
         var _loc11_:Rectangle = null;
         var _loc12_:BitmapData = null;
         if((_flags & FLAG_NO_INTRATILE_MASK) == FLAG_NO_INTRATILE_MASK)
         {
            return;
         }
         if(!group)
         {
            return;
         }
         var _loc3_:IsoStar = group.getIsoStar();
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Vector.<IsoSortable> = _loc3_.sprites;
         var _loc10_:Rectangle = this._subgripbounds.clone();
         _loc10_.x = _loc10_.x + (isoU - this._gripbounds.width / 2);
         _loc10_.y = _loc10_.y + (isoV - this._gripbounds.height / 2);
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc2_] as IsoSprite;
            if(!(!_loc5_ || _loc5_ == this || !_loc5_._gripbounds || !_loc5_._subgripbounds || (_loc5_._flags & FLAG_NO_INTRATILE_MASK) == FLAG_NO_INTRATILE_MASK))
            {
               _loc1_ = _loc5_._intratilemask;
               _loc11_ = _loc5_._subgripbounds.clone();
               _loc11_.x = _loc11_.x + (_loc5_.isoU - _loc5_._gripbounds.width / 2);
               _loc11_.y = _loc11_.y + (_loc5_.isoV - _loc5_._gripbounds.height / 2);
               if(!(!_loc1_ || !_loc10_.intersects(_loc11_)))
               {
                  _loc6_ = _loc5_.bounds;
                  _loc7_ = _loc6_.intersection(bounds);
                  if(!_loc7_.isEmpty())
                  {
                     _loc8_ = _loc7_.clone();
                     _loc8_.x = _loc8_.x - _loc6_.x;
                     _loc8_.y = _loc8_.y - _loc6_.y;
                     _loc7_.x = _loc7_.x - (bounds.x + _loc1_.crect.x + (_loc5_.content.width - _loc6_.width) / 2);
                     _loc7_.y = _loc7_.y - (bounds.y + _loc1_.crect.y + (_loc5_.content.height - _loc6_.height));
                     _loc12_ = _loc1_.bitmapData;
                     this._cutmaskbmd.threshold(_loc12_,_loc8_,_loc7_.topLeft,"==",0,4294967295);
                     if(_loc1_.isvirtual)
                     {
                        _loc12_.dispose();
                     }
                     break;
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public function updateCutmask() : void
      {
         var _loc1_:BitmapData = null;
         if(!this._cutmaskbmd)
         {
            if(this._content && !bounds.isEmpty())
            {
               this._cutmaskbmd = new BitmapData(bounds.width,bounds.height,true,0);
               this._cutmaskbm.bitmapData = this._cutmaskbmd;
            }
         }
         else if(this._cutmaskbmd.width != bounds.width || this._cutmaskbmd.height != bounds.height)
         {
            _loc1_ = this._cutmaskbmd;
            if(this._content && !bounds.isEmpty())
            {
               this._cutmaskbmd = new BitmapData(bounds.width,bounds.height,true,0);
               this._cutmaskbm.bitmapData = this._cutmaskbmd;
            }
            _loc1_.dispose();
         }
         if(this._cutmaskbmd == null)
         {
            return;
         }
         this._cutmaskbmd.fillRect(this._cutmaskbmd.rect,0);
         if(this._isoparent)
         {
            this.updateBackgroundCutmask();
         }
         this.updateIntraTileCutmask();
      }
      
      override public function hitTestPoint(param1:Number, param2:Number, param3:Boolean = false) : Boolean
      {
         if(!super.hitTestPoint(param1,param2,param3))
         {
            return false;
         }
         if(!param3)
         {
            return true;
         }
         if(!this._content)
         {
            return false;
         }
         return this._content.hitTestPoint(param1,param2,param3);
      }
      
      override public function intersects(param1:IsoSortable, param2:Array = null, param3:Array = null, param4:Boolean = false) : Boolean
      {
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         if((flags & FLAG_NO_COLLISION) == FLAG_NO_COLLISION || (param1.flags & FLAG_NO_COLLISION) == FLAG_NO_COLLISION || !super.intersects(param1,param2,param3,param4))
         {
            return false;
         }
         var _loc5_:Boolean = false;
         if(param1 is IsoSortableGroup)
         {
            return true;
         }
         if(param1 is IsoSprite)
         {
            _loc6_ = new Point(min_u - this._subgripbounds.x,min_v - this._subgripbounds.y);
            _loc7_ = new Point((param1 as IsoSprite).min_u - (param1 as IsoSprite).subgripbounds.x,(param1 as IsoSprite).min_v - (param1 as IsoSprite).subgripbounds.y);
            _loc5_ = this._grip.hitTest(_loc6_,1,(param1 as IsoSprite).grip,_loc7_,1);
         }
         if(_loc5_ && !param4)
         {
            if(param1.max_z < min_z)
            {
               if(param2 != null && param2.indexOf(param1) == -1)
               {
                  param2.push(param1);
               }
               _loc5_ = false;
            }
            else if(param1.min_z > max_z)
            {
               if(param3 && param3.indexOf(param1) == -1)
               {
                  param3.push(param1);
               }
               _loc5_ = false;
            }
         }
         return _loc5_;
      }
      
      public function get enableMouse() : Boolean
      {
         return this._enableMouse;
      }
      
      public function set enableMouse(param1:Boolean) : void
      {
         this._enableMouse = param1;
         this._hasmouse = this._hasmouse && param1;
      }
      
      public function get hasmouse() : Boolean
      {
         return this._hasmouse;
      }
      
      public function set hasmouse(param1:Boolean) : void
      {
         this._hasmouse = param1;
      }
      
      public function set lightintensity(param1:Number) : void
      {
         if(this._lightintensity == param1)
         {
            return;
         }
         this._lightintensity = param1;
         if(this._isoparent && this._lightmap)
         {
            this._isoparent.markLightDirty(this);
         }
         if(this._light)
         {
            this._light.alpha = this._lightintensity / 100;
         }
      }
      
      public function get lightintensity() : Number
      {
         return this._lightintensity;
      }
      
      override public function toString() : String
      {
         return "IsoSprite#[min_u=" + min_u + ", max_u=" + max_u + ", min_v=" + min_v + ", max_v=" + max_v + ", min_z=" + min_z + ", max_z=" + max_z + "]";
      }
      
      public function set topheight(param1:Number) : void
      {
         if(this._topheight == param1)
         {
            return;
         }
         this._topheight = param1;
         this.updateIsoBounds();
         this.updateScreenPosition();
         this.updateCutmask();
      }
      
      public function set totalheight(param1:Number) : void
      {
         if(this._totalheight == param1)
         {
            return;
         }
         this._totalheight = param1;
         this.updateIsoBounds();
         this.updateScreenPosition();
         this.updateCutmask();
      }
      
      public function get topheight() : Number
      {
         return this._topheight;
      }
      
      public function get totalheight() : Number
      {
         return this._totalheight;
      }
      
      public function get subgripbounds() : Rectangle
      {
         return this._subgripbounds;
      }
      
      public function get gripbounds() : Rectangle
      {
         return this._gripbounds;
      }
      
      public function get grip() : BitmapData
      {
         return this._grip;
      }
      
      public function get topX() : Number
      {
         return this._topX;
      }
      
      public function get topY() : Number
      {
         return this._topY;
      }
      
      public function get intratilemask() : ICroppedBitmapDataContainer
      {
         return this._intratilemask;
      }
      
      public function get shadow() : IsoShadow
      {
         return this._shadow;
      }
      
      public function set shadow(param1:IsoShadow) : void
      {
         this._shadow = param1;
         if(!this._shadow)
         {
            return;
         }
         this._shadow.alpha = this.alpha;
         this._shadow.visible = this.visible;
         this.updateShadowPosition();
      }
      
      public function get light() : IsoLight
      {
         return this._light;
      }
      
      public function set light(param1:IsoLight) : void
      {
         this._light = param1;
         if(!this._light)
         {
            return;
         }
         this.updateLightPosition();
      }
      
      override public function set alpha(param1:Number) : void
      {
         super.alpha = param1;
         if(this._shadow)
         {
            this._shadow.alpha = param1;
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(this._shadow)
         {
            this._shadow.visible = param1;
         }
      }
      
      function onAdd(param1:IIsoContainer) : void
      {
         var parent:IIsoContainer = param1;
         this._isoparent = parent;
         this._isAdded = true;
         if(this._onAddCallback != null)
         {
            try
            {
               this._onAddCallback();
            }
            catch(err:ArgumentError)
            {
            }
            this._onAddCallback = null;
         }
         this.updateLight(true);
      }
      
      function onRemove() : void
      {
         this._isAdded = false;
         if(this._onRemoveCallback != null)
         {
            try
            {
               this._onRemoveCallback(this);
            }
            catch(err:ArgumentError)
            {
            }
            this._onRemoveCallback = null;
         }
      }
      
      public function get isAdded() : Boolean
      {
         return this._isAdded;
      }
      
      protected function get needsDirectionOffset() : Boolean
      {
         return false;
      }
   }
}
