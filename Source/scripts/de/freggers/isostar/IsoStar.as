package de.freggers.isostar
{
   import caurina.transitions.Tweener;
   import de.freggers.data.IMapData;
   import de.freggers.data.Level;
   import de.freggers.data.LevelBackground;
   import de.freggers.data.Lightmap;
   import de.freggers.data.MapDataV1;
   import de.freggers.decoder.Decoder;
   import de.freggers.isostar.grouping.Grouping;
   import de.freggers.roomcomp.ARoomComponent;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class IsoStar extends IsoSortableGroup implements IIsoContainer
   {
      
      public static var DEBUG:int = 0;
      
      public static var INTERLACEIDLEFRAMES:uint = 2;
      
      public static var CURRENTADDID:uint = 0;
      
      public static var GROUPGENERATION_INTERVAL:uint = 250;
      
      public static const DEBUG_SHOW_BBOX:int = 1;
      
      public static const DEBUG_SHOW_DISPLAYINDEX:int = 2;
      
      public static const DEBUG_SHOW_BOUNDS:int = 4;
      
      public static const DEBUG_REDUCE_ALPHA:int = 8;
      
      public static const DEBUG_SHOW_BASE:int = 16;
      
      public static const MANUAL_SPRITE_SORTING:Boolean = true;
      
      public static const BACKGROUNDMASK_SEARCHDEPTH:int = 6;
      
      public static const COLLISION_NONE:int = 0;
      
      public static const COLLISION_OBJECTS:int = 1;
      
      public static const COLLISION_LEVEL:int = 2;
      
      public static const COLLISION_SELF:int = 4;
      
      public static const NLAYERS:int = 3;
      
      private static var HEIGHT_NO_DATA:int = -1;
      
      private static const SCROLL_TWEEN_ID:String = "scrollTo";
      
      private static const SIN30_div_COS30_mult_SQRT2:Number = IsoGrid.SIN30 * Math.SQRT2 / IsoGrid.COS30;
       
      
      private var _flag_buildgroups:Boolean = false;
      
      private var _generatedgroupsat:Number = 0;
      
      private var _isogrid:IsoGrid;
      
      private var _level:Level;
      
      private var _scrollRect:Rectangle;
      
      private var _scrollOffset:Point;
      
      private var _isScrolling:Boolean;
      
      private var _background:LevelBackground;
      
      private var _backgroundBitmap:Bitmap;
      
      private var _roomcomplayer:Sprite;
      
      private var _fgcontainer:Sprite;
      
      private var _shadowlayer:Sprite;
      
      private var _lightinglayer:Sprite;
      
      private var _isolights:Sprite;
      
      private var _offset:Point;
      
      private var _lightmap:Lightmap;
      
      private var _lightmapDirtyRegions:Vector.<Rectangle>;
      
      private var _lightDirtySprites:Vector.<IsoSprite>;
      
      private var _lightsEnabled:Boolean = true;
      
      private var _checkGroupsFor:Vector.<IsoStarGCE>;
      
      private var _collectedIsoSortables:Vector.<IsoSortable>;
      
      private var _ghostTrailIsoSortables:Vector.<IsoSortable>;
      
      private var _ghostTrailLastUpdate:Dictionary;
      
      private var _scrollcontainer:Sprite;
      
      private var _maincontainer:Sprite;
      
      private var _lastScrolledAt:Number = 0;
      
      public var enableGrouping:Boolean = true;
      
      public var foregroundlayer:Sprite;
      
      public var onScreenOffestChange:Function;
      
      public function IsoStar(param1:LevelBackground, param2:Level, param3:int, param4:int, param5:DisplayObject = null)
      {
         super(param2.bounds);
         this.mouseEnabled = false;
         this._level = param2;
         this._background = param1;
         if(param5 != null)
         {
            this.mask = param5;
         }
         if(param1)
         {
            this.bounds = new Rectangle(0,0,param1.width,param1.height);
         }
         else
         {
            this.bounds = new Rectangle(0,0,param5.width,param5.height);
         }
         this._collectedIsoSortables = new Vector.<IsoSortable>();
         this._ghostTrailIsoSortables = new Vector.<IsoSortable>();
         this._ghostTrailLastUpdate = new Dictionary();
         this._checkGroupsFor = new Vector.<IsoStarGCE>();
         treedepth = 0;
         CURRENTADDID = 0;
         this.init(param3,param4);
         this.rebuildLightmap();
      }
      
      private static function roundUpBounds(param1:Rectangle) : void
      {
         param1.width = param1.width + (param1.x - Math.floor(param1.x) + Math.ceil(param1.left) - param1.left);
         param1.height = param1.height + (param1.y - Math.floor(param1.y) + Math.ceil(param1.bottom) - param1.bottom);
         param1.x = Math.floor(param1.x);
         param1.y = Math.floor(param1.y);
      }
      
      private static function shouldJoin(param1:Rectangle, param2:Rectangle, param3:Rectangle) : Boolean
      {
         var _loc4_:Rectangle = param1.intersection(param2);
         var _loc5_:Number = _loc4_.width * _loc4_.height;
         return _loc5_ * 2 >= param3.width * param3.height - (param1.width * param1.height + param2.width * param2.height - _loc5_);
      }
      
      public static function computeDirection(param1:Vector3D) : int
      {
         var _loc3_:Number = NaN;
         var _loc2_:int = -1;
         if(param1.x != 0 || param1.y != 0)
         {
            if(param1.x == 0)
            {
               if(param1.y > 0)
               {
                  _loc2_ = 6;
               }
               else if(param1.y < 0)
               {
                  _loc2_ = 2;
               }
            }
            else
            {
               _loc3_ = param1.y / param1.x;
               if(_loc3_ < -2)
               {
                  _loc2_ = param1.x > 0?2:6;
               }
               else if(_loc3_ >= -2 && _loc3_ < -0.5)
               {
                  _loc2_ = param1.x > 0?1:5;
               }
               else if(_loc3_ >= -0.5 && _loc3_ < 0.5)
               {
                  _loc2_ = param1.x > 0?0:4;
               }
               else if(_loc3_ >= 0.5 && _loc3_ < 2)
               {
                  _loc2_ = param1.x > 0?7:3;
               }
               else if(_loc3_ >= 2)
               {
                  _loc2_ = param1.x > 0?6:2;
               }
            }
         }
         return _loc2_;
      }
      
      public function getAbsoluteMousePosition() : Point
      {
         return new Point(this._fgcontainer.mouseX,this._fgcontainer.mouseY);
      }
      
      override public function notifyRemoveFlag(param1:IsoSortable, param2:uint) : void
      {
         var _loc3_:int = 0;
         switch(param2)
         {
            case IsoSprite.FLAG_GHOSTTRAIL:
               _loc3_ = this._ghostTrailIsoSortables.indexOf(param1);
               if(_loc3_ >= 0)
               {
                  this._ghostTrailIsoSortables.splice(_loc3_,1);
               }
         }
      }
      
      override public function notifyAddFlag(param1:IsoSortable, param2:uint) : void
      {
         var _loc3_:int = 0;
         switch(param2)
         {
            case IsoSprite.FLAG_GHOSTTRAIL:
               _loc3_ = this._ghostTrailIsoSortables.indexOf(param1);
               if(_loc3_ < 0)
               {
                  this._ghostTrailIsoSortables.push(param1);
               }
         }
      }
      
      override public function cleanup() : void
      {
         var _loc1_:int = 0;
         var _loc2_:IsoSprite = null;
         var _loc4_:* = null;
         var _loc5_:ARoomComponent = null;
         super.cleanup();
         Tweener.removeTweens(this._scrollOffset);
         this._scrollOffset = null;
         if(this._level)
         {
            if(this._level.roomcomponents)
            {
               for(_loc4_ in this._level.roomcomponents)
               {
                  _loc5_ = this._level.roomcomponents[_loc4_][Decoder.SWF_DATA] as ARoomComponent;
                  if(_loc5_)
                  {
                     _loc5_.stop();
                     if(this._roomcomplayer.contains(_loc5_))
                     {
                        this._roomcomplayer.removeChild(_loc5_);
                     }
                     _loc5_.destroy();
                  }
               }
            }
            this._level.cleanup();
            this._level = null;
         }
         if(this._background)
         {
            this._background.cleanup();
            this._background = null;
         }
         this._lightmap.cleanup();
         this._lightmap = null;
         this._lightmapDirtyRegions = null;
         this._lightDirtySprites = null;
         var _loc3_:int = this._shadowlayer.numChildren - 1;
         while(_loc3_ >= 0)
         {
            this._shadowlayer.removeChildAt(_loc3_);
            _loc3_--;
         }
         this._backgroundBitmap = null;
         this._collectedIsoSortables.length = 0;
         this._checkGroupsFor.length = 0;
      }
      
      private function init(param1:int, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc5_:ARoomComponent = null;
         var _loc6_:Rectangle = null;
         var _loc7_:int = 0;
         var _loc8_:Matrix = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:ColorMatrixFilter = null;
         this._maincontainer = new Sprite();
         this._maincontainer.mouseEnabled = false;
         this._scrollcontainer = new Sprite();
         this._scrollcontainer.mouseEnabled = false;
         this._scrollRect = new Rectangle(0,0,param1,param2);
         this.foregroundlayer = new Sprite();
         this.foregroundlayer.mouseEnabled = false;
         this._offset = this.isoorigin.add(this._background.offset);
         this._fgcontainer = new Sprite();
         this._fgcontainer.mouseEnabled = false;
         this._roomcomplayer = new Sprite();
         this._roomcomplayer.mouseEnabled = this._roomcomplayer.mouseChildren = false;
         this._roomcomplayer.x = -this._offset.x;
         this._roomcomplayer.y = -this._offset.y;
         this._shadowlayer = new Sprite();
         this._shadowlayer.mouseEnabled = false;
         this._lightinglayer = new Sprite();
         this._lightinglayer.mouseEnabled = this._lightinglayer.mouseChildren = false;
         this._isolights = new Sprite();
         this._isolights.mouseEnabled = this._isolights.mouseChildren = false;
         this._lightinglayer.blendMode = BlendMode.LAYER;
         this._lightinglayer.cacheAsBitmap = true;
         this._lightinglayer.addChild(this._isolights);
         this._fgcontainer.addChild(this._roomcomplayer);
         this._fgcontainer.addChild(this._shadowlayer);
         this._fgcontainer.addChild(isosortablecontainer);
         this._fgcontainer.addChild(this.foregroundlayer);
         this._shadowlayer.cacheAsBitmap = true;
         if(this._level.hasRoomComponents)
         {
            _loc3_ = this._level.roomcomponents;
            for(_loc4_ in _loc3_)
            {
               _loc5_ = _loc3_[_loc4_][Decoder.SWF_DATA] as ARoomComponent;
               _loc6_ = _loc3_[_loc4_][Decoder.SWF_BOUNDS] as Rectangle;
               _loc7_ = _loc3_[_loc4_][Decoder.SWF_DIRECTION] as int;
               if(_loc5_ && _loc6_)
               {
                  _loc5_.init({});
                  _loc8_ = _loc5_.transform.matrix;
                  _loc8_.identity();
                  _loc9_ = _loc6_.width / _loc5_.width;
                  _loc10_ = _loc6_.height / _loc5_.height;
                  _loc8_.scale(_loc9_,_loc10_);
                  if(_loc7_ == 0 || _loc7_ == 6)
                  {
                     _loc8_.b = (_loc7_ == 0?-1:1) * Math.tan(Math.PI / 19);
                  }
                  _loc8_.translate(_loc6_.x,_loc6_.y);
                  _loc5_.transform.matrix = _loc8_;
                  this._roomcomplayer.addChild(_loc5_);
                  if(this._background.avgbrightness != 1)
                  {
                     _loc11_ = new ColorMatrixFilter([this._background.avgbrightness,0,0,0,0,0,this._background.avgbrightness,0,0,0,0,0,this._background.avgbrightness,0,0,0,0,0,1,0]);
                     _loc5_.filters = [_loc11_];
                  }
                  _loc5_.start();
               }
            }
         }
         this._maincontainer.addChild(this._fgcontainer);
         this._maincontainer.x = this._lightinglayer.x = this._offset.x;
         this._maincontainer.y = this._lightinglayer.y = this._offset.y;
         this._scrollOffset = new Point();
         this._backgroundBitmap = new Bitmap(this._background.bitmapData);
         this._backgroundBitmap.x = -this._offset.x;
         this._backgroundBitmap.y = -this._offset.y;
         this._lightinglayer.addChildAt(this._backgroundBitmap,0);
         this._scrollcontainer.addChild(this._lightinglayer);
         this._scrollcontainer.addChild(this._maincontainer);
         addChild(this._scrollcontainer);
         this.handleResize(param1,param2);
         this.setScreenOffset((this._background.width - this._scrollRect.width) / 2,(this._background.height - this._scrollRect.height) / 2);
      }
      
      private function updateRoomComponentLighting() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:ARoomComponent = null;
         var _loc4_:int = 0;
         if(this._level.hasRoomComponents && this._background.avgbrightness != 1)
         {
            _loc1_ = this._background.avgbrightness;
            _loc2_ = this._roomcomplayer.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = this._roomcomplayer.getChildAt(_loc4_) as ARoomComponent;
               _loc3_.filters = [new ColorMatrixFilter([_loc1_,0,0,0,0,0,_loc1_,0,0,0,0,0,_loc1_,0,0,0,0,0,1,0])];
               _loc4_++;
            }
         }
      }
      
      public function get isoorigin() : Point
      {
         return new Point(this._level.bounds.height * IsoGrid.tile_width / (2 * IsoGrid.upt),0);
      }
      
      public function get offset() : Point
      {
         return this._offset;
      }
      
      private function __onScrollTweenUpdate() : void
      {
         this.setScreenOffset(this._scrollOffset.x,this._scrollOffset.y);
      }
      
      private function __onScrollTweenComplete() : void
      {
         this._isScrolling = false;
      }
      
      private function getIsoPositionFor(param1:Point, param2:int = -1) : Vector3D
      {
         var _loc3_:int = param2 < 0?int(this.heightAt(param1.x,param1.y)):int(param2);
         if(_loc3_ == HEIGHT_NO_DATA)
         {
            return null;
         }
         var _loc4_:Vector3D = IsoGrid.xyztouvz(param1.x,param1.y,_loc3_);
         if(_loc4_.z < 0 || _loc4_.z >= this._level.maxz)
         {
            return null;
         }
         if(!this._level.bounds.contains(Math.round(_loc4_.x),Math.round(_loc4_.y)))
         {
            return null;
         }
         return _loc4_;
      }
      
      public function getCurrentMouseIsoPosition(param1:int = -1) : Vector3D
      {
         return this.getIsoPositionFor(this.getAbsoluteMousePosition(),param1);
      }
      
      public function detectCollisionLevel(param1:IsoSprite) : Boolean
      {
         if(!this._level.collisionmap || !param1.grip)
         {
            return false;
         }
         var _loc2_:Point = new Point(param1.min_u - param1.subgripbounds.x,param1.min_v - param1.subgripbounds.y);
         var _loc3_:BitmapData = this._level.collisionmap;
         return _loc3_.hitTest(_loc3_.rect.topLeft,1,param1.grip,_loc2_,1);
      }
      
      public function createIsoLight(param1:IsoSprite) : void
      {
         if(!param1 || !param1.lightmap)
         {
            return;
         }
         var _loc2_:Lightmap = param1.lightmap;
         var _loc3_:int = param1.direction;
         if(param1.light)
         {
            if(param1.light.lightmap != _loc2_)
            {
               param1.light.lightmap = _loc2_;
            }
         }
         else
         {
            param1.light = new IsoLight(this,_loc2_,new Vector3D(param1.isoU,param1.isoV,param1.isoZ),_loc3_);
         }
         param1.light.alpha = param1.lightintensity / 100;
         param1.light.dir = param1.direction;
         param1.updateLightPosition();
         this.addIsoLight(param1.light);
      }
      
      override public function addIsoShadow(param1:IsoShadow) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.parent != this._shadowlayer)
         {
            this._shadowlayer.addChild(param1);
         }
      }
      
      override public function removeIsoShadow(param1:IsoShadow) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.parent == this._shadowlayer)
         {
            this._shadowlayer.removeChild(param1);
         }
         param1.cleanup();
      }
      
      override public function addIsoLight(param1:IsoLight) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.parent != this._isolights)
         {
            this._isolights.addChild(param1);
         }
      }
      
      override public function removeIsoLight(param1:IsoLight) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.parent == this._isolights)
         {
            this._isolights.removeChild(param1);
         }
         param1.cleanup();
      }
      
      public function addIsoFlatThing(param1:AIsoFlatThing) : void
      {
         if(!this._shadowlayer.contains(param1))
         {
            this._shadowlayer.addChild(param1);
         }
      }
      
      public function removeIsoFlatThing(param1:AIsoFlatThing) : void
      {
         if(this._shadowlayer.contains(param1))
         {
            this._shadowlayer.removeChild(param1);
         }
      }
      
      public function handleResize(param1:int, param2:int) : void
      {
         this.updateScreenRect(param1,param2);
         if(param1 > this._background.width)
         {
            this._scrollcontainer.x = (param1 - this._background.width) / 2;
         }
         else
         {
            this._scrollcontainer.x = 0;
         }
         if(param2 > this._background.height)
         {
            this._scrollcontainer.y = (param2 - this._background.height) / 2;
         }
         else
         {
            this._scrollcontainer.y = 0;
         }
      }
      
      public function centerView(param1:Number, param2:String = null) : void
      {
         this.scrollTo((this._background.width - this._scrollRect.width) / 2,(this._background.height - this._scrollRect.height) / 2,param1,param2);
      }
      
      public function get background() : LevelBackground
      {
         return this._background;
      }
      
      public function set background(param1:LevelBackground) : void
      {
         if(!param1 || this._background == param1 || this._background.width != param1.width || this._background.height != param1.height || this._background.offset.x != param1.offset.x || this._background.offset.y != param1.offset.y)
         {
            return;
         }
         this._background = param1;
         this.updateBackground();
         this.rebuildLightmap();
         this.updateRoomComponentLighting();
      }
      
      private function updateScreenRect(param1:int, param2:int) : void
      {
         var _loc3_:int = this._scrollRect.x;
         var _loc4_:int = this._scrollRect.y;
         if(param1 >= this._background.width)
         {
            param1 = this._background.width;
            _loc3_ = 0;
         }
         if(param2 >= this._background.height)
         {
            param2 = this._background.height;
            _loc4_ = 0;
         }
         if(_loc3_ > 0 && _loc3_ + param1 > this._background.width)
         {
            _loc3_ = this._background.width - param1;
         }
         if(_loc4_ > 0 && _loc4_ + param2 > this._background.height)
         {
            _loc4_ = this._background.height - param2;
         }
         this._scrollRect.width = param1;
         this._scrollRect.height = param2;
         this._scrollRect.x = _loc3_;
         this._scrollRect.y = _loc4_;
         this._scrollcontainer.scrollRect = this._scrollRect;
      }
      
      public function setScreenOffset(param1:int, param2:int, param3:int = 0, param4:int = 0) : void
      {
         if(this._background.width + 2 * param3 > this._scrollRect.width)
         {
            if(param1 < -param3)
            {
               param1 = -param3;
            }
            if(param1 + this._scrollRect.width - param3 > this._background.width)
            {
               param1 = this._background.width - this._scrollRect.width + param3;
            }
         }
         else
         {
            param1 = 0;
         }
         if(this._background.height + 2 * param4 > this._scrollRect.height)
         {
            if(param2 < -param4)
            {
               param2 = -param4;
            }
            if(param2 + this._scrollRect.height - param4 > this._background.height)
            {
               param2 = this._background.height - this._scrollRect.height + param4;
            }
         }
         else
         {
            param2 = 0;
         }
         if(this._scrollRect.x == param1 && this._scrollRect.y == param2)
         {
            return;
         }
         var _loc5_:Number = param1 - this._scrollRect.x;
         var _loc6_:Number = param2 - this._scrollRect.y;
         this._scrollRect.x = param1;
         this._scrollRect.y = param2;
         this._scrollcontainer.scrollRect = this._scrollRect;
         if(this.onScreenOffestChange != null)
         {
            this.onScreenOffestChange(_loc5_,_loc6_);
         }
      }
      
      public function updateBackground() : void
      {
         if(this._background == null)
         {
            return;
         }
         this._backgroundBitmap.bitmapData = this._background.bitmapData;
      }
      
      public function get isScrolling() : Boolean
      {
         return this._isScrolling;
      }
      
      public function scrollTo(param1:int, param2:int, param3:Number = 5000, param4:String = null, param5:Boolean = false) : void
      {
         this.__scrollTo(param1,param2,param3,param4,param5);
      }
      
      public function __scrollTo(param1:int, param2:int, param3:Number = 5000, param4:String = null, param5:Boolean = false) : void
      {
         this._scrollOffset.x = this._scrollRect.x;
         this._scrollOffset.y = this._scrollRect.y;
         if(param5)
         {
            param1 = param1 + this._scrollRect.x;
            param2 = param2 + this._scrollRect.y;
         }
         if(this._scrollRect.x != param1 || this._scrollRect.y != param2)
         {
            this._isScrolling = true;
            Tweener.addTween(this._scrollOffset,{
               "x":param1,
               "y":param2,
               "time":param3 / 1000,
               "transition":param4,
               "onUpdate":this.__onScrollTweenUpdate,
               "onComplete":this.__onScrollTweenComplete
            });
         }
         else
         {
            this._isScrolling = false;
         }
      }
      
      override protected function computeBounds() : void
      {
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ARoomComponent = null;
         var _loc4_:int = 0;
         if(this._lightmapDirtyRegions.length > 0)
         {
            this.rebuildLightmapDirtyRegions();
         }
         if(this._ghostTrailIsoSortables && this._ghostTrailIsoSortables.length > 0)
         {
            this.updateGhostTrails(param1);
         }
         if(this._level.hasRoomComponents)
         {
            _loc2_ = this._roomcomplayer.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = this._roomcomplayer.getChildAt(_loc4_) as ARoomComponent;
               _loc3_.update(param1);
               _loc4_++;
            }
         }
         super.update(param1);
      }
      
      private function updateGhostTrails(param1:int) : void
      {
         var _loc2_:IsoSortable = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:IsoGhost = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         while(_loc8_ < this._ghostTrailIsoSortables.length)
         {
            _loc2_ = this._ghostTrailIsoSortables[_loc8_] as IsoSortable;
            if(!(!_loc2_ || !_loc2_.group))
            {
               _loc5_ = _loc2_.getFlagArgs(IsoSprite.FLAG_GHOSTTRAIL);
               if(_loc5_)
               {
                  _loc3_ = int(this._ghostTrailLastUpdate[_loc2_]);
                  _loc4_ = int(_loc5_[IsoGhost.UPDATEINTERVAL]);
                  if(!_loc4_)
                  {
                     _loc4_ = 250;
                  }
                  if(param1 - _loc3_ > _loc4_)
                  {
                     this._ghostTrailLastUpdate[_loc2_] = param1;
                     _loc6_ = new IsoGhost(_loc2_,_loc5_[IsoGhost.STARTALPHA],_loc5_[IsoGhost.ENDALPHA],_loc5_[IsoGhost.DURATION],_loc5_[IsoGhost.STEPS],_loc5_[IsoGhost.COLOR],_loc5_[IsoGhost.BLUR],_loc5_[IsoGhost.MODE]);
                     _loc2_.group.addIsoSortable(_loc6_);
                     _loc7_ = computeDirection(_loc2_.delta);
                     if(_loc2_.group.getDisplayIndex(_loc2_) < _loc2_.group.getDisplayIndex(_loc6_) && !(_loc7_ >= 2 && _loc7_ <= 4))
                     {
                        _loc2_.group.swapIsoSortables(_loc2_,_loc6_);
                     }
                  }
               }
            }
            _loc8_++;
         }
      }
      
      override public function update_interlaced(param1:int) : void
      {
         if(this.enableGrouping && this._flag_buildgroups && param1 - this._generatedgroupsat > GROUPGENERATION_INTERVAL)
         {
            this._flag_buildgroups = false;
            Grouping.buildGroups(this);
            this._generatedgroupsat = param1;
         }
         if(this._checkGroupsFor.length > 0)
         {
            this._doCheckGrouping();
         }
         super.update_interlaced(param1);
      }
      
      public function rebuildGroups() : void
      {
         this._flag_buildgroups = true;
      }
      
      private function _doCheckGrouping() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:IsoStarGCE = null;
         var _loc1_:Vector.<IsoStarGCE> = this._checkGroupsFor.concat();
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc4_ = _loc1_[_loc2_] as IsoStarGCE;
            if(_loc4_)
            {
               this._checkGrouping(_loc4_.isoSortable,_loc4_.forceDirty);
               _loc3_ = this._checkGroupsFor.indexOf(_loc4_);
               this._checkGroupsFor.splice(_loc3_,1);
            }
            _loc2_++;
         }
      }
      
      private function _checkGrouping(param1:IsoSortable, param2:Boolean = false) : void
      {
         if(!param1 || !param1.group)
         {
            return;
         }
         var _loc3_:IsoSortableGroup = searchGroupDown(param1.min_u,param1.min_v,param1.max_u,param1.max_v);
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_ == param1.group)
         {
            if(param2)
            {
               _loc3_.setDirty();
            }
            return;
         }
         param1.group.removeIsoSortable(param1);
         _loc3_.addIsoSortable(param1);
      }
      
      public function checkGrouping(param1:IsoSortable, param2:Boolean = false) : void
      {
         var _loc3_:IsoStarGCE = null;
         var _loc4_:uint = 0;
         if(param1 == null || (param1.flags & IsoSprite.FLAG_SKIP_GROUPCHECK) != 0)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < this._checkGroupsFor.length)
         {
            _loc3_ = this._checkGroupsFor[_loc4_] as IsoStarGCE;
            if(_loc3_)
            {
               if(_loc3_.isoSortable == param1)
               {
                  return;
               }
            }
            _loc4_++;
         }
         this._checkGroupsFor.push(new IsoStarGCE(param1,param2));
      }
      
      public function add(param1:IsoSortable) : void
      {
         var _loc4_:IsoSprite = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:int = this._collectedIsoSortables.indexOf(param1);
         if(_loc2_ < 0)
         {
            this._collectedIsoSortables.push(param1);
         }
         if(param1 is IsoSprite)
         {
            (param1 as IsoSprite).onAdd(this);
            if((param1.flags & IsoSortable.FLAG_GROUPABLE) != 0)
            {
               this._flag_buildgroups = true;
            }
         }
         var _loc3_:IsoSortableGroup = searchGroupDown(param1.min_u,param1.min_v,param1.max_u,param1.max_v);
         if(_loc3_ == null)
         {
            _loc3_ = this;
         }
         _loc3_.addIsoSortable(param1);
         param1.addid = ++CURRENTADDID;
         if(CURRENTADDID == uint.MAX_VALUE)
         {
            CURRENTADDID = 0;
         }
         if(param1 is IsoSprite)
         {
            _loc4_ = param1 as IsoSprite;
            if(_loc4_.shadow)
            {
               this.addIsoShadow(_loc4_.shadow);
            }
         }
         if((param1.flags & IsoSprite.FLAG_GHOSTTRAIL) != 0)
         {
            _loc2_ = this._ghostTrailIsoSortables.indexOf(param1);
            if(_loc2_ < 0)
            {
               this._ghostTrailIsoSortables.push(param1);
            }
         }
      }
      
      public function remove(param1:IsoSortable) : void
      {
         var _loc3_:int = 0;
         var _loc4_:IsoSprite = null;
         var _loc5_:Array = null;
         var _loc6_:IsoSprite = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Rectangle = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = this._collectedIsoSortables.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         if(param1 is IsoSprite)
         {
            _loc6_ = param1 as IsoSprite;
            this.removeLight(_loc6_);
            if(_loc6_.intratilemask != null)
            {
               _loc5_ = new Array();
               _loc7_ = _loc6_.subgripbounds.clone();
               _loc7_.x = _loc6_.min_u;
               _loc7_.y = _loc6_.min_v;
               _loc3_ = 0;
               while(_loc3_ < this._collectedIsoSortables.length)
               {
                  _loc4_ = this._collectedIsoSortables[_loc3_] as IsoSprite;
                  if(_loc4_ != null)
                  {
                     _loc8_ = new Rectangle(_loc4_.min_u,_loc4_.min_v,_loc4_.max_u - _loc4_.min_u,_loc4_.max_v - _loc4_.min_v);
                     if(_loc7_.intersects(_loc8_))
                     {
                        _loc5_.push(_loc4_);
                     }
                  }
                  _loc3_++;
               }
            }
            if(_loc5_ != null)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc5_.length)
               {
                  _loc4_ = _loc5_[_loc3_] as IsoSprite;
                  if(_loc4_ != null)
                  {
                     _loc4_.updateCutmask();
                  }
                  _loc3_++;
               }
            }
         }
         if(_loc2_ >= 0)
         {
            this._collectedIsoSortables.splice(_loc2_,1);
         }
         _loc2_ = this._ghostTrailIsoSortables.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._ghostTrailIsoSortables.splice(_loc2_,1);
         }
         if(param1 is IsoSprite)
         {
            (param1 as IsoSprite).onRemove();
         }
         param1.cleanup();
         if(param1.group)
         {
            param1.group.removeIsoSortable(param1);
         }
      }
      
      override public function getIsoStar() : IsoStar
      {
         return this;
      }
      
      public function get screenrect() : Rectangle
      {
         return this._scrollRect;
      }
      
      public function getLightAt(param1:int, param2:int) : uint
      {
         if(!this._lightmap)
         {
            return 0;
         }
         return this._lightmap.getLightAt(param1,param2);
      }
      
      public function get lightmap() : Lightmap
      {
         if(!this._background)
         {
            return null;
         }
         return this._background.lightmap;
      }
      
      public function get level() : Level
      {
         return this._level;
      }
      
      public function isManaging(param1:IsoSortable) : Boolean
      {
         return this._collectedIsoSortables.indexOf(param1) >= 0;
      }
      
      public function get sprites() : Vector.<IsoSortable>
      {
         return this._collectedIsoSortables;
      }
      
      public function get ghostTrailIsoSortables() : Vector.<IsoSortable>
      {
         return this._ghostTrailIsoSortables;
      }
      
      public function getMask(param1:int, param2:int) : ICroppedBitmapDataContainer
      {
         if(!this._level)
         {
            return undefined;
         }
         return this._level.getMask(param1,param2,IsoGrid.MODE_MAIN);
      }
      
      public function hasMasks() : Boolean
      {
         if(!this._level)
         {
            return false;
         }
         return this._level.hasMasks();
      }
      
      public function getMapData(param1:int, param2:int, param3:int = 1001) : IMapData
      {
         if(!this._level)
         {
            return undefined;
         }
         return this._level.getMapData(param1,param2,param3);
      }
      
      public function getHeightAt(param1:int, param2:int) : int
      {
         if(this._level == null)
         {
            return -1;
         }
         return this._level.getHeightAt(param1,param2);
      }
      
      override public function get width() : Number
      {
         if(!this._scrollRect)
         {
            return 0;
         }
         return this._scrollRect.width;
      }
      
      override public function get height() : Number
      {
         if(!this._scrollRect)
         {
            return 0;
         }
         return this._scrollRect.height;
      }
      
      override public function toString() : String
      {
         return "IsoStar[" + this._level.bounds.width + " x " + this._level.bounds.height + "]";
      }
      
      public function set hardShadows(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(this._shadowlayer)
         {
            _loc2_ = 0;
            while(_loc2_ < this._shadowlayer.numChildren)
            {
               if(this._shadowlayer.getChildAt(_loc2_) is IsoShadow)
               {
                  (this._shadowlayer.getChildAt(_loc2_) as IsoShadow).isHard = param1;
               }
               _loc2_++;
            }
         }
      }
      
      public function rebuildLightmap() : void
      {
         if(!this._background)
         {
            return;
         }
         if(!this._lightmap)
         {
            this._lightmap = this._background.lightmap.clone();
            this._lightmapDirtyRegions = new Vector.<Rectangle>();
            this._lightDirtySprites = new Vector.<IsoSprite>();
         }
         this.setLightmapDirtyRegion(this._lightmap.bounds);
      }
      
      private function setLightmapDirtyRegion(param1:Rectangle) : void
      {
         var _loc2_:Rectangle = null;
         for each(_loc2_ in this._lightmapDirtyRegions)
         {
            if(_loc2_.containsRect(param1))
            {
               return;
            }
         }
         this._lightmapDirtyRegions.push(this._lightmap.bounds.intersection(param1));
      }
      
      public function markLightDirty(param1:IsoSprite) : void
      {
         if(!param1.lightmap)
         {
            return;
         }
         var _loc2_:Rectangle = param1.lightmap.getBoundsForDirection(param1.direction);
         _loc2_.offset(param1.isoU,param1.isoV);
         roundUpBounds(_loc2_);
         this.setLightmapDirtyRegion(_loc2_);
      }
      
      public function removeLight(param1:IsoSprite) : void
      {
         if(!param1 || !param1.light)
         {
            return;
         }
         this.markLightDirty(param1);
         this.removeIsoLight(param1.light);
         param1.light = null;
      }
      
      private function rebuildLightmapDirtyRegions() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:IsoSprite = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Rectangle = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this._lightmapDirtyRegions.length > 1)
         {
            _loc4_ = this._lightmapDirtyRegions.length;
            do
            {
               _loc3_ = false;
               _loc8_ = 0;
               do
               {
                  _loc6_ = null;
                  while(_loc6_ == null && _loc8_ < _loc4_)
                  {
                     _loc6_ = this._lightmapDirtyRegions[_loc8_];
                     _loc8_++;
                  }
                  if(_loc6_ == null)
                  {
                     break;
                  }
                  _loc9_ = _loc8_;
                  while(_loc9_ < _loc4_)
                  {
                     _loc7_ = null;
                     while(_loc7_ == null && _loc9_ < _loc4_)
                     {
                        _loc7_ = this._lightmapDirtyRegions[_loc9_];
                        _loc9_++;
                     }
                     if(_loc7_ == null)
                     {
                        break;
                     }
                     if(_loc6_.intersects(_loc7_))
                     {
                        _loc5_ = _loc6_.union(_loc7_);
                        if(shouldJoin(_loc6_,_loc7_,_loc5_))
                        {
                           _loc6_ = _loc5_;
                           _loc3_ = true;
                           this._lightmapDirtyRegions[_loc9_ - 1] = null;
                        }
                     }
                  }
                  this._lightmapDirtyRegions[_loc8_ - 1] = _loc6_;
               }
               while(_loc8_ < _loc4_);
               
            }
            while(_loc3_);
            
         }
         this._lightmap.lock();
         for each(_loc1_ in this._lightmapDirtyRegions)
         {
            if(_loc1_ != null)
            {
               this.rebuildLightmapArea(_loc1_,this._lightDirtySprites);
            }
         }
         this._lightmap.unlock();
         this._lightmapDirtyRegions.length = 0;
         for each(_loc2_ in this._lightDirtySprites)
         {
            _loc2_.updateLight();
         }
         this._lightDirtySprites.length = 0;
      }
      
      private function rebuildLightmapArea(param1:Rectangle, param2:Vector.<IsoSprite>) : void
      {
         var _loc3_:Lightmap = null;
         var _loc4_:Rectangle = null;
         var _loc5_:int = 0;
         var _loc6_:IsoSprite = null;
         var _loc7_:IsoSortable = null;
         if(param1.isEmpty())
         {
            return;
         }
         this._lightmap.writeArea(this._background.lightmap,param1,param1.topLeft);
         if(this._lightsEnabled)
         {
            for each(_loc7_ in this._collectedIsoSortables)
            {
               if(_loc7_ is IsoSprite)
               {
                  _loc6_ = _loc7_ as IsoSprite;
                  if(param1.contains(_loc6_.isoU,_loc6_.isoV) && param2.indexOf(_loc6_) < 0)
                  {
                     param2.push(_loc6_);
                  }
                  if(_loc6_.lightmap != null)
                  {
                     _loc3_ = _loc6_.lightmap;
                     _loc5_ = _loc6_.direction;
                     _loc4_ = _loc3_.getBoundsForDirection(_loc5_);
                     _loc4_.offset(_loc6_.isoU,_loc6_.isoV);
                     if(_loc4_.intersects(param1))
                     {
                        this._lightmap.blendWith(_loc3_,_loc6_.lightintensity,new Point(_loc6_.isoU,_loc6_.isoV),_loc5_,param1);
                     }
                  }
               }
            }
         }
      }
      
      public function addLight(param1:IsoSprite) : void
      {
         if(!this._lightsEnabled || !param1 || !param1.lightmap || this._collectedIsoSortables.indexOf(param1) < 0)
         {
            return;
         }
         if(!param1.light)
         {
            this.createIsoLight(param1);
         }
         else if(param1.lightmap != param1.light.lightmap)
         {
            param1.light.lightmap = this.lightmap;
         }
         this.markLightDirty(param1);
      }
      
      public function get lightsEnabled() : Boolean
      {
         return this._lightsEnabled;
      }
      
      public function set lightsEnabled(param1:Boolean) : void
      {
         this._lightsEnabled = param1;
         this._isolights.visible = param1;
         this.rebuildLightmap();
      }
      
      public function get lightmapData() : BitmapData
      {
         return this._lightmap.lightData;
      }
      
      private function drawAllMasks(param1:BitmapData, param2:Number, param3:Number) : void
      {
         var _loc4_:ICroppedBitmapDataContainer = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc10_:BitmapData = null;
         var _loc13_:Number = NaN;
         if(this._level == null)
         {
            return;
         }
         if(!this._level.hasMasks())
         {
            return;
         }
         var _loc9_:uint = 0;
         var _loc11_:Point = new Point();
         var _loc12_:Number = this._level.bounds.width + this._level.bounds.height;
         _loc6_ = 0;
         while(_loc6_ < this._level.bounds.height)
         {
            _loc5_ = 0;
            while(_loc5_ < this._level.bounds.width)
            {
               _loc4_ = this.getMask(_loc5_ / IsoGrid.upt,_loc6_ / IsoGrid.upt);
               if(_loc4_ != null)
               {
                  _loc10_ = _loc4_.bitmapData;
                  if(!_loc4_.isvirtual)
                  {
                     _loc10_ = _loc10_.clone();
                  }
                  _loc13_ = (_loc5_ + _loc6_) / _loc12_;
                  _loc10_.threshold(_loc10_,_loc10_.rect,_loc10_.rect.topLeft,"==",4278190080,0,4294967295);
                  _loc10_.applyFilter(_loc10_,_loc10_.rect,_loc10_.rect.topLeft,new GlowFilter(0,1,2,2,2,1,true));
                  _loc10_.applyFilter(_loc10_,_loc10_.rect,_loc10_.rect.topLeft,new ColorMatrixFilter([1 - _loc13_,0,0,0,0,0,_loc13_,0,0,0,0,0,1 - _loc13_,0,0,0,0,0,1,0]));
                  _loc11_.x = IsoGrid.uvztox(_loc5_,_loc6_,0) + _loc4_.crect.x + param2 - IsoGrid.tile_width / 2;
                  _loc11_.y = IsoGrid.uvztoy(_loc5_,_loc6_,0) + _loc4_.crect.y - _loc4_.rect.height + param3 + IsoGrid.tile_height;
                  param1.copyPixels(_loc10_,_loc10_.rect,_loc11_,null,null,true);
                  _loc10_.dispose();
               }
               _loc5_ = _loc5_ + IsoGrid.upt;
            }
            _loc6_ = _loc6_ + IsoGrid.upt;
         }
      }
      
      private function heightAt(param1:int, param2:int) : int
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:* = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         if(this._level == null)
         {
            return HEIGHT_NO_DATA;
         }
         var _loc3_:int = this._level.bounds.width;
         var _loc4_:int = this._level.bounds.height;
         var _loc5_:int = int(IsoGrid.xyztou(param1,param2,0) + 0.5);
         var _loc6_:int = int(IsoGrid.xyztov(param1,param2,0) + 0.5);
         if(_loc5_ >= _loc3_ || _loc6_ >= _loc4_)
         {
            return HEIGHT_NO_DATA;
         }
         var _loc7_:int = _loc3_ - _loc5_;
         var _loc8_:int = _loc4_ - _loc6_;
         var _loc9_:int = Math.min(_loc7_,_loc8_);
         var _loc16_:int = HEIGHT_NO_DATA;
         _loc10_ = _loc9_ - 1;
         while(_loc10_ >= 0)
         {
            _loc13_ = _loc5_ + _loc10_;
            _loc14_ = _loc6_ + _loc10_;
            if(!(_loc13_ < 0 || _loc14_ < 0))
            {
               _loc11_ = _loc14_ * _loc3_ + _loc13_;
               _loc12_ = this._level.map[_loc11_] >> MapDataV1.HEIGHT_OFFSET & MapDataV1.HEIGHT_MAX;
               _loc15_ = int(SIN30_div_COS30_mult_SQRT2 * (_loc10_ + 0.5));
               if(_loc15_ <= _loc12_)
               {
                  _loc16_ = _loc15_;
                  break;
               }
            }
            _loc10_--;
         }
         return _loc16_;
      }
   }
}
