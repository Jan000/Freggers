package de.freggers.animation
{
   public class LightAnimation implements IChangeable
   {
      
      public static const MODE_LOOP:uint = 0;
      
      public static const MODE_BOUNCE:uint = 1;
       
      
      private var _target:ITarget;
      
      private var _intensities:Array;
      
      private var _durations:Array;
      
      private var _cumulatedTime:Number = 0;
      
      private var _segmentTime:Number = 0;
      
      private var _currentIndex:int = 0;
      
      private var _totalTime:Number = 0;
      
      private var _mode:uint;
      
      private var _loopCount:int;
      
      private var _loopsPlayed:int = 0;
      
      private var _playForward:Boolean = true;
      
      private var _currentIntensity:int;
      
      private var _previousIntensity:Number;
      
      private var _nextIntensity:Number;
      
      private var _onComplete:Function;
      
      public function LightAnimation(param1:ITarget, param2:Array, param3:Array, param4:int, param5:uint, param6:Function)
      {
         super();
         this._loopCount = param4;
         this._mode = param5;
         this._target = param1;
         this._intensities = param2;
         this._durations = param3;
         this._onComplete = param6;
         if(this._durations.length != this._intensities.length - 1)
         {
            this._durations.pop();
         }
         this._totalTime = 0;
         var _loc7_:int = 0;
         while(_loc7_ < this._durations.length)
         {
            this._totalTime = this._totalTime + this._durations[_loc7_];
            _loc7_++;
         }
         this._currentIntensity = this._intensities[this._currentIndex];
         this._target.lightintensity = this._currentIntensity;
         this._previousIntensity = this._currentIntensity;
         if(this._intensities.length > 0)
         {
            this._nextIntensity = param2[this._currentIndex + 1];
         }
         else
         {
            this._nextIntensity = this._currentIntensity;
         }
      }
      
      public function get target() : ITarget
      {
         return this._target;
      }
      
      public function update(param1:int) : void
      {
         if(this._loopCount > 0 && this._loopsPlayed == this._loopCount)
         {
            return;
         }
         this._cumulatedTime = this._cumulatedTime + param1;
         this._segmentTime = this._segmentTime + param1;
         if(this._cumulatedTime >= this._totalTime)
         {
            this._cumulatedTime = this._cumulatedTime % this._totalTime;
            switch(this._mode)
            {
               case MODE_BOUNCE:
                  this._playForward = !this._playForward;
                  this._intensities.reverse();
                  this._durations.reverse();
                  if(this._playForward)
                  {
                     this._loopsPlayed++;
                  }
                  break;
               case MODE_LOOP:
               default:
                  this._loopsPlayed++;
            }
            this._currentIndex = 0;
            this._currentIntensity = this._intensities[this._currentIndex];
            this._previousIntensity = this._currentIntensity;
            if(this._intensities.length > this._currentIndex)
            {
               this._nextIntensity = this._intensities[this._currentIndex + 1];
            }
            else
            {
               this._nextIntensity = this._currentIntensity;
            }
            this._segmentTime = 0;
         }
         else if(this._segmentTime >= this._durations[this._currentIndex])
         {
            if(this._currentIndex + 1 >= this._intensities.length)
            {
               return;
            }
            this._currentIndex++;
            this._currentIntensity = this._intensities[this._currentIndex];
            this._previousIntensity = this._currentIntensity;
            if(this._intensities.length > this._currentIndex)
            {
               this._nextIntensity = this._intensities[(this._currentIndex + 1) % this._intensities.length];
            }
            else
            {
               this._nextIntensity = this._currentIntensity;
            }
            this._segmentTime = 0;
         }
         var _loc2_:int = this._previousIntensity + Math.round((this._nextIntensity - this._previousIntensity) * (this._segmentTime / this._durations[this._currentIndex]));
         if(_loc2_ != this._currentIntensity)
         {
            this._currentIntensity = _loc2_;
            this._target.lightintensity = this._currentIntensity;
         }
      }
      
      public function get finished() : Boolean
      {
         if(this._loopCount == 0)
         {
            return false;
         }
         return this._loopsPlayed == this._loopCount;
      }
      
      public function cleanup() : void
      {
         this._target = null;
         this._intensities = null;
         this._durations = null;
         this._onComplete = null;
      }
      
      public function get ref() : *
      {
         return null;
      }
      
      public function get onComplete() : Function
      {
         return this._onComplete;
      }
   }
}
