package de.freggers.animation
{
   public class CompositeAnimation implements IChangeable
   {
       
      
      public var onAnimationComplete:Function;
      
      public var onAnimationUpdate:Function;
      
      private var _target:ITarget;
      
      private var _movement:Movement;
      
      private var _frameAnim:Animation;
      
      private var _lightAnim:LightAnimation;
      
      public function CompositeAnimation(param1:ITarget)
      {
         super();
         this._target = param1;
      }
      
      public function set movement(param1:Movement) : void
      {
         if(param1 && param1.target != this._target)
         {
            if(!param1.target)
            {
               return;
            }
         }
         if(this._movement)
         {
            if(!param1)
            {
               this.removeMovement();
            }
            else
            {
               this._movement.cleanup();
            }
         }
         this._movement = param1;
      }
      
      public function get movement() : Movement
      {
         return this._movement;
      }
      
      public function set animation(param1:Animation) : void
      {
         if(param1 && param1.target != this._target)
         {
            if(!param1.target)
            {
               return;
            }
         }
         if(this._frameAnim)
         {
            if(param1)
            {
               this._frameAnim._target = null;
            }
            this.removeAnimComponent(this._frameAnim);
         }
         this._frameAnim = param1;
      }
      
      public function get animation() : Animation
      {
         return this._frameAnim;
      }
      
      public function set lightAnimation(param1:LightAnimation) : void
      {
         if(this._lightAnim)
         {
            this._lightAnim.cleanup();
         }
         this._lightAnim = param1;
      }
      
      public function get lightAnimation() : LightAnimation
      {
         return this._lightAnim;
      }
      
      public function get target() : ITarget
      {
         return this._target;
      }
      
      public function get ref() : *
      {
         return null;
      }
      
      public function update(param1:int) : void
      {
         if(this._frameAnim)
         {
            this.updateAnimComponent(this._frameAnim,param1);
            if(this._frameAnim.finished)
            {
               this.removeAnimComponent(this._frameAnim);
               this._frameAnim = null;
            }
         }
         if(this._movement)
         {
            this.updateAnimComponent(this._movement,param1);
            if(this._movement.finished)
            {
               this.removeMovement();
            }
         }
         if(this._lightAnim)
         {
            this.updateAnimComponent(this._lightAnim,param1);
            if(this._lightAnim.finished)
            {
               this.removeLightAnimation();
            }
         }
      }
      
      private function removeMovement() : void
      {
         this.removeAnimComponent(this._movement);
         if(this._movement)
         {
            this.removeAnimComponent(this._frameAnim);
            this._frameAnim = null;
            this._movement = null;
         }
      }
      
      private function removeLightAnimation() : void
      {
         this.removeAnimComponent(this._lightAnim);
         this._lightAnim = null;
      }
      
      private function updateAnimComponent(param1:IChangeable, param2:int) : void
      {
         var anim:IChangeable = param1;
         var delta:int = param2;
         anim.update(delta);
         if(this.onAnimationUpdate != null)
         {
            try
            {
               this.onAnimationUpdate(anim);
               return;
            }
            catch(e:ArgumentError)
            {
               return;
            }
         }
      }
      
      private function removeAnimComponent(param1:IChangeable) : void
      {
         var anim:IChangeable = param1;
         if(anim)
         {
            if(this.onAnimationComplete != null)
            {
               try
               {
                  this.onAnimationComplete(anim);
               }
               catch(e:ArgumentError)
               {
               }
            }
            if(anim.onComplete != null)
            {
               try
               {
                  anim.onComplete(anim);
               }
               catch(e:ArgumentError)
               {
               }
            }
            anim.cleanup();
         }
      }
      
      public function get onComplete() : Function
      {
         return null;
      }
      
      public function get finished() : Boolean
      {
         return !this._movement && !this._frameAnim && !this._lightAnim;
      }
      
      public function cleanup() : void
      {
         this.onAnimationComplete = null;
         this.onAnimationUpdate = null;
         this._movement = null;
         this._frameAnim = null;
         this._lightAnim = null;
      }
   }
}
