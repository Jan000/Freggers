package de.freggers.ui
{
   import flash.display.Sprite;
   
   public class AProgressBar extends Sprite
   {
      
      public static const PROGRESS_NONE:Number = 0;
      
      public static const PROGRESS_FULL:Number = 1;
       
      
      private var _progress:Number = 0;
      
      private var _startValue:Number;
      
      private var _endValue:Number;
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      public function AProgressBar(param1:Number = 0, param2:Number = 1)
      {
         super();
         this._startValue = param1;
         this._endValue = param2;
      }
      
      public function setRange(param1:Number, param2:Number) : void
      {
         if(this._startValue != param1 || this._endValue != param2)
         {
            this._startValue = param1;
            this._endValue = param2;
            this.updateContents();
         }
      }
      
      public function get startValue() : Number
      {
         return this._startValue;
      }
      
      public function get endValue() : Number
      {
         return this._endValue;
      }
      
      public function set progress(param1:Number) : void
      {
         if(param1 < PROGRESS_NONE || param1 > PROGRESS_FULL)
         {
            return;
         }
         if(param1 != this._progress)
         {
            this._progress = param1;
            this.updateContents();
         }
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function get value() : Number
      {
         return this._startValue + this._progress * (this._endValue - this._startValue);
      }
      
      public function set barWidth(param1:Number) : void
      {
         this._width = param1;
      }
      
      public function get barWidth() : Number
      {
         return this._width;
      }
      
      public function set barHeight(param1:Number) : void
      {
         this._height = param1;
      }
      
      public function get barHeight() : Number
      {
         return this._height;
      }
      
      protected function updateContents() : void
      {
      }
   }
}
