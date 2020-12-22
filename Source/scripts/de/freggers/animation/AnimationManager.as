package de.freggers.animation
{
   import de.freggers.data.Level;
   
   public class AnimationManager
   {
       
      
      private var lastUpdate:int;
      
      private var running:Boolean = false;
      
      private var compositeAnimations:Array;
      
      public var onComplete:Function;
      
      public var onTick:Function;
      
      public function AnimationManager()
      {
         super();
         this.lastUpdate = 0;
         this.compositeAnimations = new Array();
      }
      
      public function start(param1:int) : void
      {
         this.lastUpdate = param1;
         this.running = true;
      }
      
      public function stop() : void
      {
         this.running = false;
         this.lastUpdate = 0;
         this.compositeAnimations.length = 0;
      }
      
      public function animate(param1:ITarget, param2:int, param3:int, param4:int, param5:Array, param6:*) : void
      {
         if(!this.running)
         {
            return;
         }
         this.getCompositeAnimationFor(param1).animation = new Animation(param1,param2,param3,param4,param5,param6);
      }
      
      public function moveground(param1:ITarget, param2:Array, param3:int, param4:int, param5:Level, param6:*) : void
      {
         if(!this.running)
         {
            return;
         }
         var _loc7_:Point2PointMovement = new Point2PointMovement(param1,param2,param3,param5,param6);
         _loc7_.update(param4);
         this.getCompositeAnimationFor(param1).movement = _loc7_;
      }
      
      public function moveThrowHorizontal(param1:ITarget, param2:Array, param3:int, param4:Level, param5:*, param6:Function) : void
      {
         if(!this.running)
         {
            return;
         }
         this.getCompositeAnimationFor(param1).movement = new HorizontalThrow(param1,param2,param3,param4,param5,param6);
      }
      
      public function animateLight(param1:ITarget, param2:Array, param3:Array, param4:int, param5:uint, param6:Function) : void
      {
         if(!this.running)
         {
            return;
         }
         var _loc7_:LightAnimation = this.getCompositeAnimationFor(param1).lightAnimation = new LightAnimation(param1,param2,param3,param4,param5,param6);
      }
      
      public function update(param1:int) : void
      {
         var composite:CompositeAnimation = null;
         var time:int = param1;
         if(!this.running)
         {
            return;
         }
         var elapsed:int = time - this.lastUpdate;
         var i:int = this.compositeAnimations.length - 1;
         while(i >= 0)
         {
            composite = this.compositeAnimations[i];
            composite.update(elapsed);
            if(composite.finished)
            {
               this.compositeAnimations.splice(i,1);
               try
               {
                  if(this.onComplete != null)
                  {
                     this.onComplete(composite);
                  }
               }
               catch(error:ArgumentError)
               {
               }
               if(composite.onComplete != null)
               {
                  try
                  {
                     composite.onComplete(composite);
                  }
                  catch(error:ArgumentError)
                  {
                  }
               }
               composite.cleanup();
            }
            i--;
         }
         this.lastUpdate = time;
      }
      
      public function remove(param1:CompositeAnimation) : void
      {
         var _loc2_:int = this.compositeAnimations.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.compositeAnimations.splice(_loc2_,1);
         }
      }
      
      private function getCompositeAnimationFor(param1:ITarget) : CompositeAnimation
      {
         var _loc2_:CompositeAnimation = this.getCompositeAnimation(param1);
         if(_loc2_ == null)
         {
            _loc2_ = new CompositeAnimation(param1);
            _loc2_.onAnimationComplete = this.onComplete;
            _loc2_.onAnimationUpdate = this.onTick;
            this.compositeAnimations.push(_loc2_);
         }
         return _loc2_;
      }
      
      public function getCompositeAnimation(param1:ITarget) : CompositeAnimation
      {
         var _loc3_:CompositeAnimation = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.compositeAnimations.length)
         {
            if(this.compositeAnimations[_loc2_])
            {
               _loc3_ = this.compositeAnimations[_loc2_] as CompositeAnimation;
               if(_loc3_.target == param1)
               {
                  return this.compositeAnimations[_loc2_];
               }
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getMovement(param1:ITarget) : Movement
      {
         var _loc2_:CompositeAnimation = this.getCompositeAnimation(param1);
         return !!_loc2_?_loc2_.movement:null;
      }
      
      public function getAnimation(param1:ITarget) : Animation
      {
         var _loc2_:CompositeAnimation = this.getCompositeAnimation(param1);
         return !!_loc2_?_loc2_.animation:null;
      }
   }
}
