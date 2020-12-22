package de.freggers.roomlib.util
{
   import de.freggers.data.Lightmap;
   import de.freggers.decoder.Decoder;
   import de.freggers.isocomp.AIsoComponent;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import de.freggers.util.MediaContainerContent;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Security;
   
   public class IsoObjectDataPack extends ADataPack
   {
      
      private static const DEFAULT_ANIM:String = "anim";
      
      private static const DEFAULT_DIR:String = "dir";
      
      private static const DEFAULT_FRAME:String = "frame";
       
      
      private var _animations:Object;
      
      private var _component:AIsoComponent;
      
      private var _sitBounds:Rectangle;
      
      private var _sitDirections:Array;
      
      private var _gripDirection:int = -1;
      
      private var _trigger:Object;
      
      private var _topHeight:int = -1;
      
      private var _totalHeight:int = -1;
      
      private var _defaultAnimation:String;
      
      private var _defaultDirection:int = -1;
      
      private var _defaultFrame:int = -1;
      
      public function IsoObjectDataPack(param1:String)
      {
         super(param1);
         this._animations = new Object();
      }
      
      public function getAnimationNames() : Array
      {
         var _loc2_:* = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._animations)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function hasFrame(param1:String, param2:uint, param3:uint) : Boolean
      {
         if(param2 < 0 || param3 < 0)
         {
            return false;
         }
         if(this._animations[param1] && this._animations[param1][Decoder.OBJ_ANIM_GRIPIMAGES] && this._animations[param1][Decoder.OBJ_ANIM_GRIPIMAGES][param2] && this._animations[param1][Decoder.OBJ_ANIM_DIRECTIONS] && this._animations[param1][Decoder.OBJ_ANIM_DIRECTIONS].indexOf(param2) >= 0 && this._animations[param1][Decoder.OBJ_ANIM_FRAMES] && this._animations[param1][Decoder.OBJ_ANIM_FRAMES][param2] && this._animations[param1][Decoder.OBJ_ANIM_FRAMES][param2].length > param3 && this._animations[param1][Decoder.OBJ_ANIM_FRAMES][param2][param3])
         {
            return true;
         }
         return false;
      }
      
      public function getFrame(param1:String, param2:uint, param3:uint) : ICroppedBitmapDataContainer
      {
         if(!this.hasFrame(param1,param2,param3))
         {
            return null;
         }
         touch();
         return this._animations[param1][Decoder.OBJ_ANIM_FRAMES][param2][param3] as ICroppedBitmapDataContainer;
      }
      
      public function getMask(param1:String, param2:uint) : ICroppedBitmapDataContainer
      {
         if(!this._animations[param1] || !this._animations[param1][Decoder.OBJ_ANIM_MASKS][param2])
         {
            return null;
         }
         touch();
         return (this._animations[param1][Decoder.OBJ_ANIM_MASKS][param2] as ICroppedBitmapDataContainer).clone();
      }
      
      public function getFrameCount(param1:String, param2:uint) : int
      {
         if(!this._animations[param1] || !this._animations[param1][Decoder.OBJ_ANIM_FRAMES][param2])
         {
            return -1;
         }
         touch();
         return this._animations[param1][Decoder.OBJ_ANIM_FRAMES][param2].length;
      }
      
      public function getGrip(param1:String, param2:uint) : BitmapData
      {
         touch();
         return this._animations[param1][Decoder.OBJ_ANIM_GRIPIMAGES][param2];
      }
      
      public function getOriginalGrip(param1:String) : BitmapData
      {
         if(!this._animations[param1])
         {
            return null;
         }
         return this._animations[param1][Decoder.OBJ_ANIM_ORIGINAL_GRIP];
      }
      
      public function getOriginalGripDirection() : int
      {
         return this._gripDirection;
      }
      
      public function getSitBounds() : Rectangle
      {
         return this._sitBounds;
      }
      
      public function getSitDirections() : Array
      {
         return this._sitDirections;
      }
      
      public function hasAnimation(param1:String) : Boolean
      {
         return this._animations[param1] != null;
      }
      
      public function hasComponent(param1:String, param2:uint) : Boolean
      {
         return this._component != null && this._component.hasdisplay && this._animations[param1][Decoder.OBJ_ANIM_ISOCOMPONENTBOUNDS][param2];
      }
      
      public function getComponentBounds(param1:String, param2:uint) : Rectangle
      {
         touch();
         return this._animations[param1][Decoder.OBJ_ANIM_ISOCOMPONENTBOUNDS][param2];
      }
      
      public function get component() : AIsoComponent
      {
         touch();
         return this._component;
      }
      
      public function get defaultFrame() : int
      {
         touch();
         return this._defaultFrame;
      }
      
      public function get defaultAnimation() : String
      {
         touch();
         return this._defaultAnimation;
      }
      
      public function get defaultDirection() : int
      {
         touch();
         return this._defaultDirection;
      }
      
      public function get topHeight() : int
      {
         touch();
         return this._topHeight;
      }
      
      public function get totalHeight() : int
      {
         touch();
         return this._totalHeight;
      }
      
      override public function decode(param1:MediaContainerContent) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc2_:Object = Decoder.decodeIsoObject(param1);
         _loc3_ = this.initFromDecodedData(_loc2_);
         if(param1)
         {
            param1.cleanup();
         }
         return _loc3_;
      }
      
      private function initFromDecodedData(param1:Object) : Boolean
      {
         var _loc2_:* = null;
         if(!param1)
         {
            return false;
         }
         _version = param1[Decoder.VERSION_NUMBER];
         if(_version > 2)
         {
            this._gripDirection = param1[Decoder.OBJ_GRIP_DIRECTION];
            this._sitBounds = param1[Decoder.OBJ_SIT_BOUNDS];
            this._sitDirections = param1[Decoder.OBJ_SIT_DIRECTIONS];
         }
         for(_loc2_ in param1[Decoder.OBJ_ANIMATIONS])
         {
            this._animations[_loc2_] = param1[Decoder.OBJ_ANIMATIONS][_loc2_];
         }
         if(!_lightmaps)
         {
            _lightmaps = new Object();
         }
         for(_loc2_ in param1[Decoder.LIGHTMAPS])
         {
            _lightmaps[_loc2_] = new Lightmap(param1[Decoder.LIGHTMAPS][_loc2_][Decoder.LIGHTMAP] as BitmapData,param1[Decoder.OBJ_GRIP_DIRECTION],new Point(param1[Decoder.LIGHTMAPS][_loc2_][Decoder.OFFSET_X],param1[Decoder.LIGHTMAPS][_loc2_][Decoder.OFFSET_Y]));
         }
         if(!_sounds)
         {
            _sounds = new Object();
         }
         for(_loc2_ in param1[Decoder.SOUNDS])
         {
            _sounds[_loc2_] = param1[Decoder.SOUNDS][_loc2_];
         }
         if(param1[Decoder.TRIGGER])
         {
            this._trigger = param1[Decoder.TRIGGER];
         }
         this._topHeight = param1[Decoder.OBJ_TOP_HEIGHT];
         this._totalHeight = param1[Decoder.OBJ_TOTAL_HEIGHT];
         this._defaultFrame = param1[Decoder.OBJ_DEFAULT_FRAME];
         this._defaultAnimation = param1[Decoder.OBJ_DEFAULT_ANIMATION];
         this._defaultDirection = param1[Decoder.OBJ_DEFAULT_DIRECTION];
         if(param1[Decoder.OBJ_ISOCOMPONENT])
         {
            this._component = param1[Decoder.OBJ_ISOCOMPONENT];
            this._component.init({});
            if(this._component.policyfile)
            {
               Security.loadPolicyFile(this._component.policyfile);
            }
            this._component.start();
         }
         touch();
         return true;
      }
   }
}
