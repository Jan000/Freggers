package de.freggers.animation
{
   public class Movement implements IChangeable
   {
       
      
      private var _segmentPlaytime:Number = 0;
      
      private var _target:ITarget;
      
      private var _duration:int = -1;
      
      private var _dir:int;
      
      private var _ref;
      
      private var _onComplete:Function;
      
      private var _segments:Array;
      
      private var _segmentIndex:int = -1;
      
      private var _totalPlaytime:int = 0;
      
      public function Movement(param1:ITarget, param2:int, param3:*, param4:Function)
      {
         super();
         this._target = param1;
         this._ref = param3;
         this._onComplete = param4;
         this._duration = param2;
      }
      
      protected function set segments(param1:Array) : void
      {
         if(!param1 || param1.length < 1)
         {
            this.cleanup();
            return;
         }
         this._segments = param1;
         this._segmentIndex = 0;
      }
      
      protected function get segments() : Array
      {
         return this._segments;
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
         return this._onComplete;
      }
      
      public function update(param1:int) : void
      {
         if(this._segmentIndex < 0 || this._segmentIndex >= this._segments.length)
         {
            return;
         }
         this._segmentPlaytime = this._segmentPlaytime + param1;
         this._totalPlaytime = this._totalPlaytime + param1;
         var _loc2_:PathSegment = this._segments[this._segmentIndex] as PathSegment;
         var _loc3_:Boolean = false;
         if(this._segmentPlaytime >= _loc2_.duration)
         {
            _loc3_ = true;
            while(this._segmentPlaytime >= _loc2_.duration && this._segmentIndex < this._segments.length)
            {
               this._segmentPlaytime = this._segmentPlaytime - _loc2_.duration;
               this._segmentIndex++;
               if(this._segmentIndex < this._segments.length)
               {
                  _loc2_ = this._segments[this._segmentIndex] as PathSegment;
               }
               else
               {
                  _loc2_ = this._segments[this._segments.length - 1] as PathSegment;
                  this._segmentPlaytime = _loc2_.duration;
               }
            }
         }
         _loc2_.compute(this._segmentPlaytime);
         var _loc4_:int = _loc2_.direction;
         if(_loc4_ > -1 && this.target.direction != _loc4_)
         {
            this._target.direction = _loc4_;
         }
         if(!this._target.uvz.equals(_loc2_.position))
         {
            this._target.uvz = _loc2_.position;
         }
      }
      
      public function get finished() : Boolean
      {
         if(this._segmentIndex >= this._segments.length)
         {
            return true;
         }
         return false;
      }
      
      public function cleanup() : void
      {
         this._segmentPlaytime = 0;
         this._totalPlaytime = 0;
         this._duration = -1;
         this._segmentIndex = -1;
         this._target = null;
         this._ref = null;
      }
   }
}
