package de.freggers.roomdisplay.ui.controlbar
{
   import flash.display.MovieClip;
   
   public final class UniversalHelperDelegate
   {
       
      
      private var _hasNotify:Boolean;
      
      private var _isRead:Boolean;
      
      private var _helperView:MovieClip;
      
      public function UniversalHelperDelegate(param1:MovieClip)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:MovieClip) : void
      {
         this._helperView = param1;
         this._helperView.buttonMode = true;
         this._helperView.gotoAndStop("inactive");
         this._helperView.mouseChildren = false;
      }
      
      public function notify(param1:Boolean) : void
      {
         this._hasNotify = true;
         this._isRead = param1;
         this._helperView.gotoAndStop(!!this._isRead?"inactive":"active");
      }
      
      public function hasNotify() : Boolean
      {
         return this._hasNotify;
      }
      
      public function reset() : void
      {
         this._hasNotify = false;
         this._helperView.gotoAndStop("inactive");
      }
      
      public function markAsRead() : void
      {
         this._isRead = true;
         this._helperView.gotoAndStop(!!this._isRead?"inactive":"active");
      }
   }
}
