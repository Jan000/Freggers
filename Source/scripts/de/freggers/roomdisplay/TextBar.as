package de.freggers.roomdisplay
{
   import de.freggers.locale.RoomDisplay.LocaleStrings;
   import de.freggers.roomlib.IsoObjectContainer;
   import de.freggers.roomlib.Player;
   import de.freggers.roomlib.util.StyleSheetBuilder;
   import de.freggers.util.BitmapDataUtils;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import de.freggers.util.TextRenderer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   
   public class TextBar extends Sprite
   {
      
      public static const MSG_USR:int = 0;
      
      public static const MSG_SRV:int = 1;
      
      public static const MSG_CLASSES:Array = [[MsgUsrSay,MsgUsrEmote,MsgUsrThink,MsgUsrShout,MsgUsrWhisper],[MsgSrvNormal]];
      
      public static const VERB:Array = ["","",LocaleStrings.MSG_THINK,LocaleStrings.MSG_SHOUT,LocaleStrings.MSG_WHISPER];
      
      private static const MARGIN_TOP:int = 2;
      
      private static const MARGIN_LEFT:int = 8;
      
      private static const MARGIN_BOTTOM:int = 2;
      
      private static const MARGIN_RIGHT:int = 8;
      
      private static const PADDING:int = 2;
      
      public static const M_USR_SAY:int = 0;
      
      public static const M_USR_EMOTE:int = 1;
      
      public static const M_USR_THINK:int = 2;
      
      public static const M_USR_SHOUT:int = 3;
      
      public static const M_USR_WHISPER:int = 4;
      
      private static const TEXT_BAR_STYLE:StyleSheet = new StyleSheetBuilder().addStyle(".foo",{
         "fontSize":12,
         "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif"
      }).addStyle(".u",{"fontWeight":"bold"}).addStyle(".t",{}).build();
      
      private static const ICON_SCALE:Number = 0.5;
      
      private static const MIN_ICON_HEIGHT:Number = 39;
      
      private static const FACE_ICON_RANGE:Array = [35,39];
      
      private static const FACE_HAIR_ICON_RANGE:Array = [21,53];
      
      private static const COMPLETE_ICON_RANGE:Array = [21,86];
       
      
      private var _msgSender:IsoObjectContainer;
      
      private var _mode:int;
      
      private var _type:int;
      
      private var _usericon:BitmapData;
      
      private var _message:FormattedMessage;
      
      private var _textbm:Bitmap;
      
      private var _textbmd:BitmapData;
      
      private var _offsettop:Number;
      
      private var _offsetbottom:Number;
      
      public function TextBar(param1:IsoObjectContainer, param2:FormattedMessage, param3:int, param4:int = 0)
      {
         super();
         this._mode = param4;
         this._type = param3;
         this._msgSender = param1;
         this._message = param2;
         this._offsetbottom = this._offsettop = 0;
         this.init();
      }
      
      private function init() : void
      {
         var _loc2_:Bitmap = null;
         var _loc5_:int = 0;
         var _loc6_:ICroppedBitmapDataContainer = null;
         var _loc7_:BitmapData = null;
         var _loc8_:BitmapData = null;
         var _loc9_:Rectangle = null;
         var _loc10_:Player = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Number = NaN;
         var _loc1_:Sprite = new MSG_CLASSES[this._type][this._mode]();
         var _loc3_:StyleSheet = new StyleSheet();
         FormattedMessage.mergeStyles(_loc3_,TEXT_BAR_STYLE);
         var _loc4_:Array = this._message.styles;
         if(_loc4_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               FormattedMessage.mergeStyles(_loc3_,_loc4_[_loc5_]);
               _loc5_++;
            }
         }
         switch(this._type)
         {
            case MSG_USR:
               switch(this._mode)
               {
                  case M_USR_EMOTE:
                     this._textbmd = TextRenderer.renderToBitmap("<span class=\'foo\'><span class=\'t\'>" + this._msgSender.name + " " + this._message + "</span></span>",_loc3_,200);
                     break;
                  default:
                     this._textbmd = TextRenderer.renderToBitmap("<span class=\'foo\'>" + "<span class=\'u\'>" + this._msgSender.name + " </span>" + "<span class=\'t\'>" + VERB[this._mode] + ": " + this._message + "</span></span>",_loc3_,200);
               }
               this._textbm = new Bitmap(this._textbmd);
               if(this._msgSender.isoobj.media.hasDefaultDatapack())
               {
                  _loc6_ = this._msgSender.isoobj.media.getFrame(this._msgSender.isoobj.media.defaultAnimation,this._msgSender.isoobj.media.defaultDirection,this._msgSender.isoobj.media.defaultFrame);
                  _loc7_ = _loc6_.bitmapData;
                  _loc8_ = new BitmapData(_loc6_.rect.width,_loc6_.rect.height,true,0);
                  _loc8_.copyPixels(_loc7_,_loc7_.rect,_loc6_.crect.topLeft);
                  _loc9_ = new Rectangle();
                  if(this._msgSender is Player)
                  {
                     _loc10_ = this._msgSender as Player;
                     if(!_loc10_.prerendered && (_loc10_.scalex == _loc10_.scaley && _loc10_.scaley == _loc10_.scalez) && _loc10_.scaley == Player.DEFAULT_SCALE)
                     {
                        _loc9_.x = _loc6_.crect.x;
                        _loc9_.y = FACE_ICON_RANGE[0];
                        _loc9_.height = FACE_ICON_RANGE[1];
                        _loc9_.width = _loc6_.crect.width;
                        if(this._textbm.height >= FACE_HAIR_ICON_RANGE[1] * ICON_SCALE && this._textbm.height < COMPLETE_ICON_RANGE[1] * ICON_SCALE)
                        {
                           _loc9_.y = FACE_HAIR_ICON_RANGE[0];
                           _loc9_.height = FACE_HAIR_ICON_RANGE[1];
                        }
                        else if(this._textbm.height >= COMPLETE_ICON_RANGE[1] * ICON_SCALE)
                        {
                           _loc9_.y = COMPLETE_ICON_RANGE[0];
                           _loc9_.height = COMPLETE_ICON_RANGE[1];
                        }
                     }
                     else
                     {
                        _loc9_.x = _loc6_.crect.x;
                        _loc9_.y = _loc6_.crect.y;
                        _loc9_.height = Math.max(Math.min(this._textbm.height,_loc6_.crect.height),MIN_ICON_HEIGHT);
                        _loc9_.width = _loc6_.crect.width;
                     }
                     _loc11_ = new BitmapData(_loc9_.width,_loc9_.height,true,0);
                     _loc11_.copyPixels(_loc8_,_loc9_,_loc11_.rect.topLeft);
                     _loc8_ = BitmapDataUtils.scale(_loc11_,ICON_SCALE,ICON_SCALE);
                     _loc11_.dispose();
                     _loc2_ = new Bitmap(_loc8_);
                  }
                  else
                  {
                     _loc12_ = 1.5 * this._textbm.height / _loc7_.height;
                     _loc8_ = BitmapDataUtils.scale(_loc7_,_loc12_,_loc12_);
                     _loc2_ = new Bitmap(_loc8_);
                  }
                  if(_loc6_.isvirtual)
                  {
                     _loc7_.dispose();
                  }
               }
               break;
            case MSG_SRV:
               this._textbmd = TextRenderer.renderToBitmap("<span class=\'foo\'><span class=\'t\'>" + this._message + "</span></span>",_loc3_,200);
               this._textbm = new Bitmap(this._textbmd);
         }
         _loc1_.width = MARGIN_LEFT + this._textbm.width + MARGIN_RIGHT;
         _loc1_.height = MARGIN_TOP + this._textbm.height + MARGIN_BOTTOM;
         this._textbm.x = MARGIN_LEFT;
         this._textbm.y = MARGIN_TOP;
         _loc1_.alpha = 0.8;
         addChild(_loc1_);
         if(_loc2_)
         {
            _loc2_.x = MARGIN_LEFT;
            _loc2_.y = MARGIN_TOP;
            _loc1_.width = _loc1_.width + (_loc2_.width + PADDING);
            this._textbm.x = this._textbm.x + (_loc2_.width + PADDING);
            if(_loc2_.height + MARGIN_BOTTOM + MARGIN_TOP > _loc1_.height)
            {
               _loc1_.height = _loc2_.height + MARGIN_BOTTOM + MARGIN_TOP;
               this._textbm.y = (_loc1_.height - this._textbm.height) / 2;
            }
            addChild(_loc2_);
         }
         addChild(this._textbm);
      }
   }
}
