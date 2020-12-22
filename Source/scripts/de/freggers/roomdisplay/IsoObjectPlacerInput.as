package de.freggers.roomdisplay
{
   import de.freggers.isostar.IsoShadowConfig;
   import de.freggers.isostar.IsoSortable;
   import de.freggers.isostar.IsoSprite;
   import de.freggers.isostar.IsoStar;
   import de.freggers.roomlib.IsoObject;
   import de.freggers.roomlib.IsoObjectSpriteContent;
   import de.freggers.roomlib.Player;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.KeyboardEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Vector3D;
   import flash.ui.Keyboard;
   
   public class IsoObjectPlacerInput implements IInputModule
   {
       
      
      private var _isoEngine:IsoStar;
      
      private var _isoObject:IsoObject;
      
      private var _isoObjectPlacer:IsoObject;
      
      private var _skipCollision:Boolean;
      
      private var _player:Player;
      
      private var _hint:RotateHint;
      
      public var onPlaceIsoObject:Function;
      
      public var onCancelPlace:Function;
      
      public var onPlayerChangeDirection:Function;
      
      public function IsoObjectPlacerInput(param1:IsoStar, param2:Player = null)
      {
         super();
         this._isoEngine = param1;
         this._player = param2;
      }
      
      public function isMouseHandler() : Boolean
      {
         return true;
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : Boolean
      {
         return false;
      }
      
      private function updateHintPosition() : void
      {
         if(this._hint == null)
         {
            return;
         }
         var _loc1_:DisplayObject = this._isoObjectPlacer.sprite.content.displayObject;
         var _loc2_:Number = _loc1_.width;
         this._hint.x = _loc1_.x + (_loc2_ - this._hint.width) / 2;
         this._hint.y = _loc1_.y + -this._hint.height - 20;
      }
      
      public function placeItem() : void
      {
         var placedPos:Vector3D = null;
         if(this._isoObjectPlacer == null || this.onPlaceIsoObject == null || this.detectCollision(this._isoObjectPlacer.sprite))
         {
            return;
         }
         try
         {
            placedPos = new Vector3D(Math.round(this._isoObjectPlacer.uvz.x),Math.round(this._isoObjectPlacer.uvz.y),Math.round(this._isoObjectPlacer.uvz.z));
            this.onPlaceIsoObject(placedPos,this._isoObjectPlacer.direction);
            return;
         }
         catch(err:ArgumentError)
         {
            return;
         }
      }
      
      public function updatePlacerPosition() : void
      {
         if(this._isoObjectPlacer == null)
         {
            return;
         }
         var _loc1_:Vector3D = this._isoEngine.getCurrentMouseIsoPosition();
         if(!_loc1_ || _loc1_.equals(this._isoObjectPlacer.uvz))
         {
            return;
         }
         this._isoObjectPlacer.uvz = _loc1_;
         this._isoEngine.checkGrouping(this._isoObjectPlacer.sprite,true);
         if(this.onPlayerChangeDirection != null && this._player != null)
         {
            this.onPlayerChangeDirection(IsoStar.computeDirection(_loc1_.subtract(this._player.isoobj.uvz)));
         }
         var _loc2_:uint = this._isoObjectPlacer.displayflags;
         if(this.detectCollision(this._isoObjectPlacer.sprite))
         {
            _loc2_ = _loc2_ | IsoObjectSpriteContent.FLAG_COLLISION;
         }
         else
         {
            _loc2_ = _loc2_ & ~IsoObjectSpriteContent.FLAG_COLLISION;
         }
         this._isoObjectPlacer.displayflags = _loc2_;
      }
      
      private function detectCollision(param1:IsoSprite) : Boolean
      {
         return this._isoEngine.detectCollisionObject(param1) || this._isoEngine.detectCollisionLevel(param1);
      }
      
      public function isKeyboardHandler() : Boolean
      {
         return true;
      }
      
      public function handleKeyboardEvent(param1:KeyboardEvent) : Boolean
      {
         var objectDirection:int = 0;
         var evt:KeyboardEvent = param1;
         var inputHandled:Boolean = false;
         if(evt.type == KeyboardEvent.KEY_UP)
         {
            switch(evt.keyCode)
            {
               case Keyboard.SHIFT:
                  inputHandled = true;
                  break;
               case Keyboard.ESCAPE:
                  if(this.onCancelPlace != null)
                  {
                     try
                     {
                        this.onCancelPlace();
                     }
                     catch(err:ArgumentError)
                     {
                     }
                  }
                  inputHandled = true;
                  break;
               case Keyboard.SPACE:
                  objectDirection = this._isoObjectPlacer.direction;
                  if(--objectDirection < 0)
                  {
                     objectDirection = 7;
                  }
                  while(!this._isoObjectPlacer.media.hasFrame(this._isoObjectPlacer.animation,objectDirection,0))
                  {
                     if(--objectDirection < 0)
                     {
                        objectDirection = 7;
                     }
                  }
                  this._isoObjectPlacer.direction = objectDirection;
                  this.updateHintPosition();
                  inputHandled = true;
                  break;
               default:
                  inputHandled = false;
            }
         }
         return inputHandled;
      }
      
      public function cleanup() : void
      {
         if(this._isoObject)
         {
            this._isoObject.flags = this._isoObject.flags & (~IsoSortable.FLAG_NO_COLLISION & ~IsoSprite.FLAG_NO_INTRATILE_MASK);
            this._isoObject = null;
         }
         if(this._isoObjectPlacer)
         {
            this._isoEngine.remove(this._isoObjectPlacer.sprite);
            this._isoObjectPlacer.cleanup();
            this._isoObjectPlacer = null;
         }
         this._isoEngine = null;
         this.onCancelPlace = null;
         this.onPlaceIsoObject = null;
         this._hint = null;
      }
      
      public function set isoObject(param1:IsoObject) : void
      {
         var _loc2_:int = 0;
         var _loc3_:IsoShadowConfig = null;
         if(this._isoObject == param1)
         {
            return;
         }
         this._isoObject = param1;
         if(this._isoObjectPlacer)
         {
            this._isoEngine.remove(this._isoObjectPlacer.sprite);
         }
         if(this._isoObject)
         {
            _loc2_ = this._isoObject.flags;
            this._skipCollision = (_loc2_ & IsoSortable.FLAG_NO_COLLISION) != 0;
            this._isoObject.flags = _loc2_ | IsoSortable.FLAG_NO_COLLISION | IsoSprite.FLAG_NO_INTRATILE_MASK;
            this._isoObjectPlacer = new IsoObject(this._isoObject.uvz.clone());
            this._isoObjectPlacer.sprite.mouseEnabled = this._isoObjectPlacer.sprite.mouseChildren = false;
            this._isoObjectPlacer.media.merge(this._isoObject.media);
            this._isoObjectPlacer.direction = this._isoObject.direction;
            this._isoObjectPlacer.animation = this._isoObject.media.defaultAnimation;
            this._isoObjectPlacer.alpha = 1;
            _loc3_ = new IsoShadowConfig();
            _loc3_.isHard = true;
            _loc3_.scale = 1;
            this._isoObjectPlacer.setFlagArgs(IsoSprite.FLAG_SHADOW,_loc3_);
            this._isoObjectPlacer.flags = IsoSortable.FLAG_GROUPABLE | IsoSprite.FLAG_SHADOW | IsoSprite.FLAG_NO_INTRATILE_MASK;
            this._isoEngine.add(this._isoObjectPlacer.sprite);
            if(this._isoObjectPlacer.sprite.content is DisplayObjectContainer)
            {
               this._hint = new RotateHint();
               this._hint.filters = [new GlowFilter(16777215,1,4,4,3)];
               (this._isoObjectPlacer.sprite.content as DisplayObjectContainer).addChild(this._hint);
               this.updateHintPosition();
            }
            this.updatePlacerPosition();
         }
      }
      
      public function get isoObject() : IsoObject
      {
         return this._isoObject;
      }
   }
}
