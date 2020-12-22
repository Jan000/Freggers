package de.freggers.roomdisplay
{
   import de.freggers.locale.RoomDisplay.LocaleStrings;
   import de.freggers.util.TextRenderer;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.StyleSheet;
   
   public class Dialog extends Sprite
   {
      
      public static const OPTION_OK:int = 1;
      
      public static const OPTION_YES:int = 2;
      
      public static const OPTION_NO:int = 4;
      
      public static const OPTION_CANCEL:int = 15;
      
      private static const MAX_WIDTH:Number = 370;
      
      private static const MIN_WIDTH:Number = 200;
      
      private static const MIN_HEIGHT:Number = 80;
      
      private static const TEXT_COLOR:int = 16777215;
      
      private static const BUTTON_TEXT_COLOR:int = 6585711;
      
      private static const BUTTONS_TO_TEXT_SPACING:Number = 15;
      
      private static const BORDER_WIDTH:Number = 2;
      
      private static const BOTTOM_BORDER:Number = 15;
      
      private static const TOP_BORDER:Number = 15;
      
      private static const BORDER_SPACING:Number = 17;
      
      private static const FONT_SIZE:Number = 12;
      
      private static const BUTTON_SPACING:Number = 10;
      
      private static const MIN_BUTTON_WIDTH:Number = 54;
      
      private static const BUTTON_HEIGHT:Number = 24;
      
      private static const BUTTON_MARGIN:Number = 6;
      
      private static const BUTTON_BORDER_WIDTH:Number = 1;
      
      private static const BUTTON_GLOW:GlowFilter = new GlowFilter(16098343);
      
      private static const DIALOG_SHADOW:DropShadowFilter = new DropShadowFilter(6,45,0,0.5,8,8);
       
      
      public var onButtonClick:Function;
      
      public var data:Object;
      
      private var buttons:Array;
      
      public function Dialog(param1:String, param2:int)
      {
         var _loc10_:Bitmap = null;
         var _loc15_:Sprite = null;
         var _loc17_:String = null;
         super();
         if(param2 == 0)
         {
            throw new Error("Invalid button configuration");
         }
         var _loc3_:StyleSheet = new StyleSheet();
         _loc3_.setStyle(".foo",{
            "fontSize":FONT_SIZE,
            "fontWeight":"normal",
            "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif",
            "color":"#" + TEXT_COLOR.toString(16)
         });
         var _loc4_:BitmapData = TextRenderer.renderToBitmap("<span class=\'foo\'>" + param1 + "</span>",_loc3_,MAX_WIDTH);
         var _loc5_:Bitmap = new Bitmap(_loc4_,"auto",true);
         var _loc6_:Number = _loc5_.width + 2 * BORDER_SPACING;
         var _loc7_:Number = _loc5_.height + TOP_BORDER + BUTTONS_TO_TEXT_SPACING + BUTTON_HEIGHT + BOTTOM_BORDER;
         if(_loc6_ < MIN_WIDTH)
         {
            _loc6_ = MIN_WIDTH;
         }
         if(_loc7_ < MIN_HEIGHT)
         {
            _loc7_ = MIN_HEIGHT;
         }
         _loc3_.setStyle(".foo",{
            "fontSize":FONT_SIZE,
            "fontWeight":"bold",
            "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif",
            "color":"#" + BUTTON_TEXT_COLOR.toString(16)
         });
         var _loc8_:Array = new Array();
         var _loc9_:Array = new Array();
         var _loc11_:* = 1;
         var _loc12_:Number = MIN_BUTTON_WIDTH;
         while(_loc11_ <= 15)
         {
            if(param2 & _loc11_)
            {
               switch(_loc11_)
               {
                  case OPTION_CANCEL:
                     _loc17_ = LocaleStrings.CANCEL;
                     break;
                  case OPTION_NO:
                     _loc17_ = LocaleStrings.NO;
                     break;
                  case OPTION_OK:
                     _loc17_ = LocaleStrings.OK;
                     break;
                  case OPTION_YES:
                     _loc17_ = LocaleStrings.YES;
               }
               if(_loc17_)
               {
                  _loc4_ = TextRenderer.renderToBitmap("<span class=\'foo\'>" + _loc17_ + "</span>",_loc3_);
                  if(_loc12_ < _loc4_.width)
                  {
                     _loc12_ = _loc4_.width;
                  }
                  _loc10_ = new Bitmap(_loc4_,"auto",true);
                  _loc8_.push(_loc10_);
                  _loc9_.push(_loc11_);
               }
            }
            _loc11_ = _loc11_ << 1;
         }
         var _loc13_:Number = (_loc12_ + 2 * BUTTON_MARGIN) * _loc8_.length + BUTTON_SPACING * (_loc8_.length - 1) + 2 * BORDER_SPACING;
         if(_loc6_ < _loc13_)
         {
            _loc6_ = _loc13_;
         }
         else if(_loc6_ > MAX_WIDTH)
         {
            _loc6_ = MAX_WIDTH;
         }
         var _loc14_:Sprite = new DialogBackground();
         _loc14_.width = _loc6_;
         _loc14_.height = _loc7_;
         addChild(_loc14_);
         _loc5_.x = (_loc6_ - _loc5_.width) / 2;
         _loc5_.y = TOP_BORDER;
         addChild(_loc5_);
         this.buttons = new Array();
         var _loc16_:int = 0;
         while(_loc16_ < _loc8_.length)
         {
            _loc15_ = new DialogButton(_loc9_[_loc16_]);
            _loc14_ = new ButtonBackground();
            _loc14_.width = _loc12_;
            _loc14_.height = BUTTON_HEIGHT;
            _loc15_.addChild(_loc14_);
            _loc10_ = _loc8_[_loc16_];
            _loc10_.x = (_loc12_ - _loc10_.width) / 2;
            _loc10_.y = (BUTTON_HEIGHT - _loc10_.height) / 2;
            _loc15_.addChild(_loc10_);
            _loc15_.x = (_loc6_ - _loc13_) / 2 + BORDER_SPACING + _loc16_ * (_loc12_ + 2 * BUTTON_MARGIN + BUTTON_SPACING);
            _loc15_.y = _loc7_ - _loc15_.height - BOTTOM_BORDER;
            addChild(_loc15_);
            this.buttons.push(_loc15_);
            _loc16_++;
         }
         filters = [DIALOG_SHADOW];
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : Boolean
      {
         var _loc2_:DialogButton = null;
         if(!(param1.target is DisplayObject) || !contains(param1.target as DisplayObject))
         {
            return hitTestPoint(param1.stageX,param1.stageY);
         }
         if((param1.target as DisplayObject).parent is DialogButton)
         {
            _loc2_ = (param1.target as DisplayObject).parent as DialogButton;
            if(param1.type == MouseManagerData.CLICK)
            {
               this.handleButtonClick(_loc2_);
               return true;
            }
            if(param1.type == MouseManagerData.MOUSE_MOVE)
            {
               this.removeButtonsHighlight(_loc2_);
               _loc2_.filters = [BUTTON_GLOW];
               return true;
            }
         }
         else if(param1.type == MouseManagerData.MOUSE_MOVE)
         {
            this.removeButtonsHighlight(null);
         }
         return hitTestPoint(param1.stageX,param1.stageY);
      }
      
      private function removeButtonsHighlight(param1:DialogButton) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.buttons.length)
         {
            if((this.buttons[_loc2_] as DialogButton).isHighlighted && this.buttons[_loc2_] != param1)
            {
               (this.buttons[_loc2_] as DialogButton).filters = [];
               break;
            }
            _loc2_++;
         }
      }
      
      private function handleButtonClick(param1:DialogButton) : void
      {
         var button:DialogButton = param1;
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this.onButtonClick != null)
         {
            try
            {
               this.onButtonClick(button.type,this.data);
            }
            catch(err:ArgumentError)
            {
            }
         }
      }
   }
}

import flash.display.Sprite;

class DialogButton extends Sprite
{
    
   
   private var _type:int;
   
   function DialogButton(param1:int)
   {
      super();
      this._type = param1;
   }
   
   public function get isHighlighted() : Boolean
   {
      return filters != null && filters.length > 0;
   }
   
   public function get type() : int
   {
      return this._type;
   }
}
