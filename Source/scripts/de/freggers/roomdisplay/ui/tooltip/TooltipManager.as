package de.freggers.roomdisplay.ui.tooltip
{
   import de.freggers.roomlib.IsoItem;
   import de.freggers.roomlib.IsoObjectContainer;
   import de.freggers.roomlib.Player;
   import flash.display.DisplayObjectContainer;
   import flash.utils.getTimer;
   
   public class TooltipManager
   {
      
      private static const SHOW_IMMEDIATELY_INTERVAL:int = 500;
       
      
      private var _tooltipContainer:DisplayObjectContainer;
      
      private var _targetSetAt:int = -1;
      
      private var _targetUnsetAt:int = -1;
      
      private var _target:IsoObjectContainer;
      
      private var _toolTip:ATooltip;
      
      private var _showImmediately:Boolean = false;
      
      public function TooltipManager(param1:DisplayObjectContainer)
      {
         super();
         this._tooltipContainer = param1;
         this._tooltipContainer.mouseEnabled = this._tooltipContainer.mouseChildren = false;
      }
      
      public function set target(param1:IsoObjectContainer) : void
      {
         var _loc2_:int = getTimer();
         if(this._toolTip != null)
         {
            this._toolTip.hide();
            if(this._toolTip.parent != null)
            {
               this._toolTip.parent.removeChild(this._toolTip);
            }
            this._toolTip.cleanup();
            this._targetUnsetAt = _loc2_;
            this._toolTip = null;
         }
         this._target = param1;
         if(param1 != null)
         {
            if(param1 is Player)
            {
               this._toolTip = new PlayerTooltip(param1 as Player);
            }
            else
            {
               this._toolTip = new ItemTooltip(param1 as IsoItem);
            }
            this._showImmediately = _loc2_ - this._targetUnsetAt < SHOW_IMMEDIATELY_INTERVAL;
            this._targetSetAt = _loc2_;
         }
         else
         {
            this._targetSetAt = -1;
            this._target = null;
         }
      }
      
      public function get target() : IsoObjectContainer
      {
         return this._target;
      }
      
      public function cleanup() : void
      {
         this.target = null;
         this._tooltipContainer = null;
      }
      
      public function update(param1:int) : Boolean
      {
         var _loc3_:int = 0;
         if(this._toolTip == null || this._targetSetAt < 0)
         {
            return false;
         }
         var _loc2_:Boolean = false;
         if(!this._toolTip.isShowing)
         {
            _loc3_ = this._toolTip.showDelay;
            if(this._showImmediately)
            {
               _loc3_ = 0;
            }
            if(param1 - this._targetSetAt >= _loc3_)
            {
               this._tooltipContainer.addChild(this._toolTip);
               this._toolTip.createContents();
               this._toolTip.show();
               _loc2_ = true;
            }
         }
         this._toolTip.update(param1);
         return _loc2_;
      }
   }
}
