package de.freggers.roomdisplay
{
   import de.freggers.isostar.IsoSprite;
   import flash.events.Event;
   
   public class MyLocationArrow extends LocationArrow
   {
      
      private static const STATE_BLEND_OUT:int = -1;
      
      private static const STATE_FINISHED:int = -2;
      
      private static const STATE_UNSTARTED:int = -3;
      
      private static const LOOPS:uint = 4;
       
      
      public var onAnimationFinished:Function;
      
      private var _counter:int = -3;
      
      private var _isosprite:IsoSprite;
      
      public function MyLocationArrow(param1:IsoSprite)
      {
         super();
         this.stop();
         this._isosprite = param1;
         this.addEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
         visible = false;
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         var e:Event = param1;
         if(!this._isosprite.isAdded)
         {
            return;
         }
         if(this._counter == STATE_UNSTARTED)
         {
            visible = true;
            this._counter = 0;
            this.gotoAndPlay(0);
         }
         x = this._isosprite.bounds.width / 2;
         if(this.currentFrame == this.totalFrames)
         {
            this._counter++;
         }
         if(this._counter >= LOOPS)
         {
            this._counter = STATE_BLEND_OUT;
            gotoAndStop(0);
         }
         if(this._counter == STATE_BLEND_OUT)
         {
            if(alpha > 0)
            {
               alpha = alpha / 1.2;
            }
            if(alpha <= 0)
            {
               this._counter = STATE_FINISHED;
               if(this.onAnimationFinished != null)
               {
                  try
                  {
                     this.onAnimationFinished(this._isosprite);
                  }
                  catch(e:ArgumentError)
                  {
                  }
               }
               else
               {
                  parent.removeChild(this);
               }
            }
         }
      }
   }
}
