package de.freggers.roomlib
{
   import de.freggers.animation.ITarget;
   import de.freggers.isostar.IsoSprite;
   import de.freggers.roomlib.util.ADataPack;
   import de.freggers.roomlib.util.IsoObjectDataPack;
   import de.freggers.roomlib.util.MediaDataPack;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class IsoObject implements ITarget
   {
       
      
      private var _currentDirection:int = -1;
      
      private var _uvz:Vector3D;
      
      private var _alpha:Number = 1;
      
      private var _visible:Boolean;
      
      private var _currentFrame:int = -1;
      
      private var _currentAnimation:String;
      
      private var _lightmapLabel:String;
      
      private var _lightintensity:Number = 0;
      
      private var _sprite:IsoObjectSprite;
      
      private var _displayflags:uint;
      
      private var _type:uint = 0;
      
      private var _filters:Array;
      
      private var _flags:int;
      
      private var _flagargs:Dictionary;
      
      public var onTopOf:IsoObject;
      
      public var onSpriteAdded:Function;
      
      public function IsoObject(param1:Vector3D)
      {
         this._uvz = new Vector3D();
         super();
         this._uvz = param1;
         this._visible = true;
         this._flagargs = new Dictionary();
         this._sprite = new IsoObjectSprite(this.handleSpriteAdded);
         this._sprite.media.onDataPackAdded = this.handleDataPackAdded;
      }
      
      private function handleSpriteAdded() : void
      {
         var content:IsoObjectSpriteContent = null;
         this.forceUpdate();
         if(this._sprite.content && this._sprite.content is IsoObjectSpriteContent)
         {
            content = this._sprite.content as IsoObjectSpriteContent;
            content.effects.initAllEffects(content);
            content.effects.startAllEffects();
         }
         if(this.onSpriteAdded != null)
         {
            try
            {
               this.onSpriteAdded(this);
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      public function get valid() : Boolean
      {
         return this._currentAnimation != null && this._currentFrame >= 0;
      }
      
      public function get animation() : String
      {
         return this._currentAnimation;
      }
      
      public function set animation(param1:String) : void
      {
         if(param1 == this._currentAnimation)
         {
            return;
         }
         this._currentFrame = 0;
         this._currentAnimation = param1;
         if(this._sprite.isAdded && this._sprite.media.hasAnimation(this._currentAnimation))
         {
            this._sprite.updateIsoObjectDisplay(this._currentAnimation,this._currentDirection,this._currentFrame);
         }
      }
      
      public function get frame() : int
      {
         return this._currentFrame;
      }
      
      public function get media() : IsoObjectMedia
      {
         return this._sprite.media;
      }
      
      public function cleanup() : void
      {
         this._currentAnimation = null;
         this._currentFrame = -1;
         this.onTopOf = null;
         this.onSpriteAdded = null;
         if(this._sprite)
         {
            this._sprite.cleanup();
            this._sprite = null;
         }
      }
      
      public function showDefaults() : void
      {
         var _loc1_:IsoObjectMedia = null;
         if(this._sprite.isAdded && this._sprite.hasDefaults)
         {
            _loc1_ = this._sprite.media;
            if(this._currentAnimation == _loc1_.defaultAnimation && this._currentFrame == _loc1_.defaultFrame && this._currentDirection == _loc1_.defaultDirection)
            {
               return;
            }
            this._currentAnimation = _loc1_.defaultAnimation;
            this._currentFrame = _loc1_.defaultFrame;
            if(!this._sprite.media.hasFrame(this._currentAnimation,this._currentDirection,this._currentFrame))
            {
               this._currentDirection = _loc1_.defaultDirection;
            }
            this._sprite.updateIsoObjectDisplay(this._currentAnimation,this._currentDirection,this._currentFrame);
         }
      }
      
      public function set direction(param1:int) : void
      {
         param1 = (param1 % 8 + 8) % 8;
         if(param1 == this._currentDirection)
         {
            return;
         }
         this._currentDirection = param1;
         if(this._sprite.isAdded)
         {
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
            this._sprite.direction = this._currentDirection;
            this._sprite.updateIsoObjectDisplay(this._currentAnimation,this._currentDirection,this._currentFrame);
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
         }
      }
      
      public function get direction() : int
      {
         return this._currentDirection;
      }
      
      public function set frame(param1:int) : void
      {
         this._currentFrame = param1;
         if(this._sprite.isAdded)
         {
            this._sprite.updateFrame(this._currentAnimation,this._currentDirection,this._currentFrame);
         }
      }
      
      public function set uvz(param1:Vector3D) : void
      {
         if(!param1 || this._uvz.equals(param1))
         {
            return;
         }
         this._uvz.x = param1.x;
         this._uvz.y = param1.y;
         this._uvz.z = param1.z;
         if(this._sprite.isAdded)
         {
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
            this._sprite.setIsoPosition(param1.x,param1.y,param1.z);
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
         }
      }
      
      public function set isoU(param1:Number) : void
      {
         if(this._uvz.x == param1)
         {
            return;
         }
         this._uvz.x = param1;
         if(this._sprite.isAdded)
         {
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
            this._sprite.isoU = param1;
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
         }
      }
      
      public function set isoV(param1:Number) : void
      {
         if(this._uvz.y == param1)
         {
            return;
         }
         this._uvz.y = param1;
         if(this._sprite.isAdded)
         {
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
            this._sprite.isoV = param1;
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
         }
      }
      
      public function set isoZ(param1:Number) : void
      {
         if(this._uvz.z == param1)
         {
            return;
         }
         this._uvz.z = param1;
         if(this._sprite.isAdded)
         {
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
            this._sprite.isoZ = param1;
            if(this._lightmapLabel)
            {
               this._sprite.isoparent.markLightDirty(this._sprite);
            }
         }
      }
      
      public function set filters(param1:Array) : void
      {
         this._filters = param1;
         if(this._sprite.isAdded)
         {
            this._sprite.content.filters = param1;
         }
      }
      
      public function get icon() : BitmapData
      {
         if(this._sprite.hasDefaults)
         {
            return null;
         }
         var _loc1_:IsoObjectMedia = this._sprite.media;
         var _loc2_:ICroppedBitmapDataContainer = _loc1_.getFrame(_loc1_.defaultAnimation,_loc1_.defaultDirection,_loc1_.defaultFrame);
         return _loc2_.bitmapData;
      }
      
      public function get uvz() : Vector3D
      {
         if(!this._sprite.isAdded)
         {
            return this._uvz.clone();
         }
         return this._sprite.getIsoPosition();
      }
      
      public function get isoU() : Number
      {
         return this._uvz.x;
      }
      
      public function get isoV() : Number
      {
         return this._uvz.y;
      }
      
      public function get isoZ() : Number
      {
         return this._uvz.z;
      }
      
      public function get filters() : Array
      {
         if(this._sprite.isAdded)
         {
            return this._sprite.filters;
         }
         return this._filters;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._visible = param1;
         if(this._sprite.isAdded)
         {
            this._sprite.visible = param1;
         }
      }
      
      public function set displayflags(param1:uint) : void
      {
         if(this._displayflags == param1)
         {
            return;
         }
         this._displayflags = param1;
         if(this._sprite.isAdded)
         {
            (this._sprite.content as IsoObjectSpriteContent).flags = this._displayflags;
         }
      }
      
      public function get displayflags() : uint
      {
         return this._displayflags;
      }
      
      public function set type(param1:uint) : void
      {
         if(this._type == param1)
         {
            return;
         }
         this._type = param1;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this._alpha == param1)
         {
            return;
         }
         this._alpha = param1;
         if(!this._sprite.isAdded)
         {
            return;
         }
         this._sprite.alpha = param1;
      }
      
      public function set lightmap(param1:String) : void
      {
         if(param1 == this._lightmapLabel)
         {
            return;
         }
         this._lightmapLabel = param1;
         if(this._sprite.isAdded)
         {
            this._sprite.lightmap = this._sprite.media.getLightmap(this._lightmapLabel);
         }
      }
      
      public function get lightmap() : String
      {
         return this._lightmapLabel;
      }
      
      public function set lightintensity(param1:Number) : void
      {
         if(this._lightintensity == param1)
         {
            return;
         }
         this._lightintensity = param1;
         if(this._sprite.isAdded)
         {
            this._sprite.lightintensity = this._lightintensity;
         }
      }
      
      public function get lightintensity() : Number
      {
         return this._lightintensity;
      }
      
      public function forceUpdate() : void
      {
         var _loc1_:* = null;
         this._sprite.visible = this._visible;
         if(this._sprite.hasDefaults)
         {
            if(this._currentAnimation == null)
            {
               this._currentAnimation = this._sprite.media.defaultAnimation;
            }
            if(this._currentDirection < 0)
            {
               this._currentDirection = this._sprite.media.defaultDirection;
            }
            if(this._currentFrame < 0)
            {
               this._currentFrame = this._sprite.media.defaultFrame;
            }
         }
         if(!this._sprite.isAdded)
         {
            return;
         }
         if(this._filters)
         {
            this._sprite.content.filters = this._filters;
         }
         this._sprite.alpha = this._alpha;
         this._sprite.direction = this._currentDirection;
         this._sprite.updateIsoObjectDisplay(this._currentAnimation,this._currentDirection,this._currentFrame);
         this._sprite.setIsoPosition(this._uvz.x,this._uvz.y,this._uvz.z);
         this._sprite.lightmap = this._sprite.media.getLightmap(this._lightmapLabel);
         this._sprite.lightintensity = this._lightintensity;
         for(_loc1_ in this._flagargs)
         {
            this._sprite.setFlagArgs(int(_loc1_),this._flagargs[_loc1_]);
         }
         this._sprite.flags = this._flags;
         (this._sprite.content as IsoObjectSpriteContent).flags = this._displayflags;
      }
      
      private function handleDataPackAdded(param1:ADataPack) : void
      {
         if(param1 is IsoObjectDataPack)
         {
            if((param1 as IsoObjectDataPack).hasAnimation(this._currentAnimation))
            {
               this.forceUpdate();
            }
         }
         else if(param1 is MediaDataPack && this._sprite.isAdded)
         {
            if(this._lightmapLabel != null && param1.hasLightmap(this._lightmapLabel))
            {
               this._sprite.lightmap = param1.getLightmap(this._lightmapLabel);
               this._sprite.lightintensity = this._lightintensity;
            }
         }
      }
      
      public function get sprite() : IsoSprite
      {
         return this._sprite;
      }
      
      public function getFrameCount(param1:String, param2:uint) : int
      {
         return this._sprite.media.getFrameCount(param1,param2);
      }
      
      public function hasAnimation(param1:String) : Boolean
      {
         return this._sprite.media.hasAnimation(param1);
      }
      
      public function get flags() : int
      {
         return this._flags;
      }
      
      public function set flags(param1:int) : void
      {
         if(this._sprite && this._sprite.isAdded)
         {
            this._sprite.flags = param1;
         }
         this._flags = param1;
      }
      
      public function getFlagArgs(param1:int) : Object
      {
         return this._flagargs[param1];
      }
      
      public function setFlagArgs(param1:int, param2:Object) : void
      {
         if(this._sprite && this._sprite.isAdded)
         {
            this._sprite.setFlagArgs(param1,param2);
         }
         this._flagargs[param1] = param2;
      }
   }
}
