package de.freggers.animation
{
   public class Animation implements IChangeable
   {
      
      public static const MODE_LOOP:int = 0;
      
      public static const MODE_BOUNCE:int = 1;
       
      
      private var _cumulatedPlayTime:Number = 0;
      
      var _target:ITarget;
      
      private var _loopDuration:Number;
      
      private var _durationPerFrame:Number;
      
      private var _animation:String;
      
      private var _ref;
      
      private var _playedFramesCount:int = -1;
      
      private var _frameIndices:Array;
      
      private var _frameCount:int;
      
      var _loopCount:int;
      
      public function Animation(param1:ITarget, param2:int, param3:int, param4:int, param5:Array, param6:*)
      {
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         super();
         this._target = param1;
         this._ref = param6;
         this._animation = param1.animation;
         this._loopDuration = param2;
         this._loopCount = param3;
         if(param5 && param5.length != 0)
         {
            _loc7_ = param5;
            this._frameCount = _loc7_.length;
         }
         else
         {
            this._frameCount = param1.getFrameCount(this._animation,param1.direction);
            _loc7_ = new Array(this._frameCount);
            _loc8_ = 0;
            while(_loc8_ < this._frameCount)
            {
               _loc7_[_loc8_] = _loc8_;
               _loc8_++;
            }
         }
         if(this._frameCount > 1 && param4 == MODE_BOUNCE)
         {
            _loc9_ = _loc7_.concat().reverse();
            _loc9_.shift();
            _loc7_ = _loc7_.concat(_loc9_);
         }
         this._frameIndices = _loc7_;
         this._durationPerFrame = this._loopDuration / this._frameIndices.length;
      }
      
      public function get target() : ITarget
      {
         return this._target;
      }
      
      public function get ref() : *
      {
         return this._ref;
      }
      
      public function get onComplete() : Function
      {
         return null;
      }
      
      public function update(param1:int) : void
      {
         this._cumulatedPlayTime = this._cumulatedPlayTime + param1;
         var _loc2_:int = Math.floor(this._cumulatedPlayTime / this._durationPerFrame);
         if(_loc2_ == this._playedFramesCount)
         {
            return;
         }
         this._target.frame = this._frameIndices[int(Math.floor(this._cumulatedPlayTime % this._loopDuration / this._durationPerFrame))];
         this._playedFramesCount = _loc2_;
      }
      
      public function get finished() : Boolean
      {
         if(this._loopCount > 0)
         {
            if(this._cumulatedPlayTime >= this._loopDuration * this._loopCount)
            {
               return true;
            }
         }
         else if(this._frameCount == 1)
         {
            this._target = null;
            return true;
         }
         return false;
      }
      
      public function cleanup() : void
      {
         this._cumulatedPlayTime = 0;
         this._loopDuration = -1;
         this._loopCount = -1;
         this._durationPerFrame = 0;
         this._frameIndices = null;
         if(this._target)
         {
            this._target.showDefaults();
         }
         this._target = null;
         this._animation = null;
         this._ref = null;
      }
   }
}
