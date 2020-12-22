package de.freggers.ui
{
   import caurina.transitions.Tweener;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import de.schulterklopfer.interaction.manager.InteractionManager;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public final class IconDropManager extends Sprite
   {
      
      private static const HEIGHT:Number = -100;
      
      private static const MIN_RADIUS:Number = 30;
      
      private static const MAX_RADIUS:Number = 50;
      
      public static const INTERACTION_GROUP:String = "IconDropManager";
       
      
      private var _iconDropSprites:Array;
      
      private var _iconDropLayer:Sprite;
      
      public function IconDropManager()
      {
         this._iconDropSprites = new Array();
         this._iconDropLayer = new Sprite();
         super();
         mouseEnabled = this._iconDropLayer.mouseEnabled = false;
         addChild(this._iconDropLayer);
      }
      
      private static function updateDropSpritePosition_show(param1:IconDropSprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         param1.x = param2 + (param4 - param2) * param1.t;
         var _loc7_:Number = 1 / 2.75;
         var _loc8_:Number = param1.t / _loc7_ / 2;
         var _loc9_:Number = (param1.t - _loc7_) / (1 - _loc7_);
         if(_loc8_ >= 0 && _loc8_ <= 0.5)
         {
            param1.y = param3 + 4 * param6 * (-(_loc8_ * _loc8_) + _loc8_) + param1.t * (param5 - param3);
         }
         else if(_loc9_ >= 0 && _loc9_ <= 1)
         {
            if(_loc9_ < 1 / 2.75)
            {
               param1.y = param3 + param6 - param6 * (7.5625 * _loc9_ * _loc9_) + param1.t * (param5 - param3);
            }
            else if(_loc9_ < 2 / 2.75)
            {
               param1.y = param3 + param6 - param6 * (7.5625 * (_loc9_ = _loc9_ - 1.5 / 2.75) * _loc9_ + 0.75) + param1.t * (param5 - param3);
            }
            else if(_loc9_ < 2.5 / 2.75)
            {
               param1.y = param3 + param6 - param6 * (7.5625 * (_loc9_ = _loc9_ - 2.25 / 2.75) * _loc9_ + 0.9375) + param1.t * (param5 - param3);
            }
            else
            {
               param1.y = param3 + param6 - param6 * (7.5625 * (_loc9_ = _loc9_ - 2.625 / 2.75) * _loc9_ + 0.984375) + param1.t * (param5 - param3);
            }
         }
      }
      
      public function get iconDropLayer() : Sprite
      {
         return this._iconDropLayer;
      }
      
      public function addIconDropSprite(param1:InteractiveObject, param2:Point, param3:Point, param4:Sprite, param5:uint) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = -Math.PI / 2 + Math.random() * Math.PI;
         _loc6_ = Math.sin(_loc8_) * (MIN_RADIUS + MIN_RADIUS + Math.random() * (MAX_RADIUS - MIN_RADIUS));
         _loc7_ = Math.cos(_loc8_) * (MIN_RADIUS + MIN_RADIUS + Math.random() * (MAX_RADIUS - MIN_RADIUS)) * 0.5;
         var _loc9_:IconDropSprite = new IconDropSprite(param1,param3.x + _loc6_,param3.y + _loc7_,param4,param5);
         _loc9_.x = param2.x;
         _loc9_.y = param2.y;
         this._iconDropSprites.push(_loc9_);
         this._iconDropLayer.addChild(_loc9_);
         InteractionManager.registerForMouse(param1,this.handleMouseManagerData,INTERACTION_GROUP);
         Tweener.addTween(_loc9_,{
            "t":1,
            "time":1,
            "transition":"linear",
            "onUpdate":updateDropSpritePosition_show,
            "onUpdateParams":[_loc9_,_loc9_.x,_loc9_.y,_loc9_.destX,_loc9_.destY,HEIGHT],
            "onComplete":this.waitThenMoveDropSpriteToDestinationSprite,
            "onCompleteParams":[_loc9_]
         });
      }
      
      private function handleMouseManagerData(param1:MouseManagerData) : void
      {
         if(param1.type == MouseManagerData.MOUSE_OVER && param1.currentTarget.parent is IconDropSprite)
         {
            this.moveDropSpriteToDestinationSprite(param1.currentTarget.parent as IconDropSprite);
         }
      }
      
      private function waitThenMoveDropSpriteToDestinationSprite(param1:IconDropSprite) : void
      {
         var _loc2_:uint = 4;
         if(param1.motion == IconDropSprite.MOVEMENT_DIRECT)
         {
            _loc2_ = 5;
         }
         param1.t = 0;
         Tweener.addTween(param1,{
            "t":1,
            "time":_loc2_ + Math.random() * 2,
            "transition":"linear",
            "onComplete":this.moveDropSpriteToDestinationSprite,
            "onCompleteParams":[param1]
         });
      }
      
      private function moveDropSpriteToDestinationSprite(param1:IconDropSprite) : void
      {
         var _loc2_:Rectangle = null;
         var _loc5_:Rectangle = null;
         _loc2_ = param1.destinationSprite.getBounds(this);
         var _loc3_:Number = _loc2_.x + _loc2_.width / 2 - param1.width / 2;
         var _loc4_:Number = _loc2_.y + _loc2_.height / 2;
         _loc5_ = param1.getBounds(this.iconDropLayer);
         var _loc6_:Number = _loc2_.width / _loc5_.width;
         var _loc7_:Number = _loc2_.height / _loc5_.height;
         var _loc8_:Number = Math.min(_loc6_,_loc7_);
         if(_loc8_ == 0)
         {
            _loc8_ = 1;
         }
         if(param1.motion == IconDropSprite.MOVEMENT_DIRECT)
         {
            Tweener.addTween(param1,{
               "x":_loc3_,
               "y":_loc4_,
               "scaleX":_loc8_,
               "scaleY":_loc8_,
               "time":1,
               "transition":"easeoutquad",
               "onComplete":this.hideDropSprite,
               "onCompleteParams":[param1]
            });
         }
         else
         {
            param1.t = 0;
            Tweener.addTween(param1,{
               "t":1,
               "scaleX":_loc8_,
               "scaleY":_loc8_,
               "time":1,
               "transition":"linear",
               "onUpdate":updateDropSpritePosition_show,
               "onUpdateParams":[param1,param1.x,param1.y,_loc3_,_loc4_,-100],
               "onComplete":this.hideDropSprite,
               "onCompleteParams":[param1]
            });
         }
      }
      
      private function hideDropSprite(param1:IconDropSprite) : void
      {
         Tweener.addTween(param1,{
            "x":param1.x + param1.width / 2,
            "scaleX":param1.scaleX / 10,
            "scaleY":param1.scaleY / 10,
            "alpha":0,
            "time":0.5,
            "transition":"easeoutcubic",
            "onComplete":this.removeDropSprite,
            "onCompleteParams":[param1]
         });
      }
      
      private function removeDropSprite(param1:IconDropSprite) : void
      {
         var _loc2_:int = this._iconDropSprites.indexOf(param1);
         if(_loc2_ > -1)
         {
            this._iconDropSprites.splice(_loc2_,1);
            this.removeIconDropSpriteReferences(param1);
         }
      }
      
      private function removeIconDropSpriteReferences(param1:IconDropSprite) : void
      {
         this._iconDropLayer.removeChild(param1);
         InteractionManager.removeForMouse(param1);
         Tweener.removeTweens(param1);
      }
      
      public function scroll(param1:Number, param2:Number) : void
      {
         var _loc3_:IconDropSprite = null;
         for each(_loc3_ in this._iconDropSprites)
         {
            _loc3_.x = _loc3_.x + param1;
            _loc3_.y = _loc3_.y + param2;
         }
      }
      
      public function removePendingIcons() : void
      {
         var _loc1_:IconDropSprite = null;
         for each(_loc1_ in this._iconDropSprites)
         {
            this.removeIconDropSpriteReferences(_loc1_);
         }
         this._iconDropSprites.length = 0;
      }
   }
}
