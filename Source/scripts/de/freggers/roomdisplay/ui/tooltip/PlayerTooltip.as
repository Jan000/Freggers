package de.freggers.roomdisplay.ui.tooltip
{
   import de.freggers.locale.RoomDisplay.LocaleStrings;
   import de.freggers.roomdisplay.FormattedMessage;
   import de.freggers.roomlib.Player;
   import de.freggers.util.StringUtil;
   import de.freggers.util.TextRenderer;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PlayerTooltip extends ATooltip
   {
       
      
      private var _player:Player;
      
      private var _bubbleSize:Point;
      
      public function PlayerTooltip(param1:Player)
      {
         this._bubbleSize = new Point();
         super();
         this._player = param1;
         visible = false;
      }
      
      private static function getPlayerIdleString(param1:Player) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Date = new Date();
         _loc2_.setTime(_loc2_.getTime() - param1.idleTimeStamp.getTime());
         var _loc3_:String = "";
         if(_loc2_.getUTCHours() > 0)
         {
            _loc4_ = _loc2_.getUTCHours() == 1?LocaleStrings.MSG_IDLE_HOUR:LocaleStrings.MSG_IDLE_HOURS;
            _loc3_ = _loc3_ + (_loc2_.getUTCHours() + " " + _loc4_ + " ");
         }
         if(_loc2_.getUTCMinutes() > 0)
         {
            _loc5_ = _loc2_.getUTCMinutes() == 1?LocaleStrings.MSG_IDLE_MINUTE:LocaleStrings.MSG_IDLE_MINUTES;
            _loc3_ = _loc3_ + (_loc2_.getUTCMinutes() + " " + _loc5_);
         }
         if(_loc3_.charAt(_loc3_.length - 1) == " ")
         {
            _loc3_ = _loc3_.substr(0,_loc3_.length - 1);
         }
         if(!_loc3_)
         {
            return _loc3_;
         }
         _loc3_ = StringUtil.formattedString(LocaleStrings.MSG_IDLE,[_loc3_]);
         return _loc3_;
      }
      
      override public function cleanup() : void
      {
         this._player = null;
      }
      
      override public function show() : void
      {
         visible = true;
      }
      
      override public function hide() : void
      {
         visible = false;
      }
      
      override public function get isShowing() : Boolean
      {
         return visible;
      }
      
      override public function createContents() : void
      {
         var _loc6_:Shape = null;
         var _loc7_:Bitmap = null;
         var _loc8_:Bitmap = null;
         var _loc11_:FormattedMessage = null;
         var _loc12_:String = null;
         var _loc13_:FormattedMessage = null;
         if(this._player == null)
         {
            return;
         }
         var _loc1_:FormattedMessage = new FormattedMessage("{0}",[this._player.name],[FormattedMessage.STYLE_BOLD]);
         var _loc2_:Bitmap = new Bitmap(TextRenderer.renderToBitmap(_loc1_.toString(),_loc1_.styleSheet,MAX_WIDTH));
         _loc2_.alpha = 0.7;
         var _loc3_:Number = _loc2_.height;
         var _loc4_:Number = Math.max(MIN_WIDTH,_loc2_.width);
         var _loc5_:Number = 0;
         if(this._player.extraIcons)
         {
            _loc3_ = _loc3_ + (this._player.extraIcons.height + 2);
            _loc4_ = _loc4_ = Math.max(_loc4_,this._player.extraIcons.width);
         }
         if(this._player.isStateSet(Player.STATE_AWAY))
         {
            _loc11_ = new FormattedMessage("{0}",["\"" + this._player.getState(Player.STATE_AWAY) + "\""],[FormattedMessage.STYLE_ITALIC]);
            _loc7_ = new Bitmap(TextRenderer.renderToBitmap(_loc11_.toString(),_loc11_.styleSheet,MAX_WIDTH));
            _loc3_ = _loc3_ + _loc7_.height;
            _loc4_ = Math.max(_loc4_,_loc7_.width);
         }
         if(this._player.idleTimeStamp)
         {
            _loc12_ = getPlayerIdleString(this._player);
            if(_loc12_)
            {
               _loc13_ = new FormattedMessage(_loc12_);
               _loc8_ = new Bitmap(TextRenderer.renderToBitmap(_loc13_.toString(),_loc13_.styleSheet,MAX_WIDTH));
               _loc3_ = _loc3_ + _loc8_.height;
               _loc4_ = Math.max(_loc4_,_loc8_.width);
            }
         }
         if(_loc7_ || _loc8_)
         {
            _loc3_ = _loc3_ + SPACING;
         }
         var _loc9_:Number = _loc4_ + MARGIN_LEFT + MARGIN_RIGHT;
         var _loc10_:Number = _loc3_ + MARGIN_TOP + MARGIN_BOTTOM;
         _loc6_ = new Shape();
         _loc6_.graphics.clear();
         _loc6_.graphics.beginFill(16777215,0.7);
         _loc6_.graphics.drawRoundRect(-_loc9_ / 2,0,_loc9_,_loc10_,8,8);
         _loc6_.graphics.endFill();
         addChild(_loc6_);
         this._bubbleSize.x = _loc6_.width;
         this._bubbleSize.y = _loc6_.height;
         _loc2_.y = MARGIN_TOP;
         _loc2_.x = (_loc4_ - _loc2_.width) / 2 + MARGIN_LEFT - this._bubbleSize.x / 2;
         addChild(_loc2_);
         _loc5_ = MARGIN_TOP + _loc2_.height + SPACING;
         if(_loc7_)
         {
            _loc7_.x = (_loc4_ - _loc7_.width) / 2 + MARGIN_LEFT - this._bubbleSize.x / 2;
            _loc7_.y = _loc5_;
            addChild(_loc7_);
            _loc5_ = _loc5_ + _loc7_.height;
         }
         if(_loc8_)
         {
            _loc8_.x = (_loc4_ - _loc8_.width) / 2 + MARGIN_LEFT - this._bubbleSize.x / 2;
            _loc8_.y = _loc5_;
            addChild(_loc8_);
            _loc5_ = _loc5_ + _loc8_.height;
         }
         if(this._player.extraIcons)
         {
            this._player.extraIcons.x = _loc4_ / 2 + MARGIN_LEFT - this._bubbleSize.x / 2;
            this._player.extraIcons.y = _loc5_ + 14;
            addChild(this._player.extraIcons);
         }
      }
      
      override public function updatePosition() : void
      {
         if(!this._player.isoobj.sprite.isAdded)
         {
            return;
         }
         var _loc1_:Rectangle = this._player.isoobj.sprite.bounds.clone();
         _loc1_.width = _loc1_.width * (this._player.isoobj.sprite.isoparent as Sprite).scaleX;
         _loc1_.height = _loc1_.height * (this._player.isoobj.sprite.isoparent as Sprite).scaleY;
         var _loc2_:Point = this._player.isoobj.sprite.parent.localToGlobal(_loc1_.topLeft);
         x = _loc2_.x + _loc1_.width / 2;
         y = _loc2_.y - this._player.isoIcons.height - 5 - this._bubbleSize.y;
      }
   }
}
