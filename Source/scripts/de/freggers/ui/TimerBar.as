package de.freggers.ui
{
   import flash.utils.getTimer;
   
   public class TimerBar extends SimpleProgressBar
   {
      
      private static const DEFAULT_BAR_WIDTH:Number = 50;
      
      private static const DEFAULT_BAR_HEIGHT:Number = 7;
       
      
      private var _onComplete:Function;
      
      private var _startedAt:int;
      
      public function TimerBar(param1:int, param2:Function)
      {
         super(0,param1);
         this._onComplete = param2;
         barWidth = DEFAULT_BAR_WIDTH;
         barHeight = DEFAULT_BAR_HEIGHT;
         this._startedAt = getTimer();
         updateContents();
      }
      
      public function update(param1:int) : void
      {
         var time:int = param1;
         var value:Number = (time - this._startedAt) / endValue;
         if(value > PROGRESS_FULL)
         {
            value = PROGRESS_FULL;
         }
         progress = value;
         if(progress == PROGRESS_FULL && this._onComplete != null)
         {
            try
            {
               this._onComplete();
               return;
            }
            catch(err:Error)
            {
               return;
            }
         }
      }
   }
}
