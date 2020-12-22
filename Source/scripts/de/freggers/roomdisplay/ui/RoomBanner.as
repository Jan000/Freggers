package de.freggers.roomdisplay.ui
{
   import de.freggers.locale.RoomDisplay.LocaleStrings;
   import de.freggers.roomlib.util.StyleSheetBuilder;
   import de.freggers.util.StringUtil;
   import de.freggers.util.TextRenderer;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   
   public class RoomBanner extends RoomBannerGfx
   {
      
      private static const TEXT_WIDTH:int = 300;
      
      private static const MARGIN:int = 10;
      
      private static const TOPIC_STYLE:StyleSheet = new StyleSheetBuilder(".topic").add("fontSize",14).add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").add("color","#AC7F47").add("textAlign","center").add("fontWeight","bold").build();
      
      private static const TITLE_STYLE:StyleSheet = new StyleSheetBuilder(".title").add("fontSize",16).add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").add("color","#4F362D").add("textAlign","center").add("fontWeight","bold").build();
      
      private static const OUTLINE:GlowFilter = new GlowFilter(16777215,1,5,5,5);
       
      
      public var onVoteClick:Function;
      
      public var onPrefsClick:Function;
      
      public var onAvatarClick:Function;
      
      public var onApartmentsButtonClick:Function;
      
      private var playerIcon:Bitmap;
      
      private var userName:String;
      
      private var topicBitmap:Bitmap;
      
      private var titleBitmap:Bitmap;
      
      private var titleBitmapData:BitmapData;
      
      private var topicBitmapData:BitmapData;
      
      private var playerIconContainer:Sprite;
      
      public function RoomBanner()
      {
         super();
         this.playerIconContainer = new Sprite();
         this.topicBitmap = new Bitmap();
         this.titleBitmap = new Bitmap();
         likeButton.mouseChildren = false;
         prefButton.mouseChildren = false;
         this.playerIconContainer.mouseChildren = false;
         this.playerIconContainer.buttonMode = true;
         apartmentsIcon.apartmentsButton.buttonMode = true;
         apartmentsIcon.apartmentsTextLabel.mouseEnabled = false;
         apartmentsIcon.apartmentsTextLabel.text = LocaleStrings.MSG_APARTMENTS_BUTTON;
         mouseEnabled = false;
         this.topicBitmap.visible = false;
         this.titleBitmap.visible = false;
         addChild(this.topicBitmap);
         addChild(this.titleBitmap);
         addChild(this.playerIconContainer);
         this.reset();
      }
      
      private function disposeBitmap(param1:Bitmap, param2:BitmapData) : void
      {
         if(param2 != null)
         {
            param1.bitmapData = null;
            param2.dispose();
            param2 = null;
         }
      }
      
      public function setTitle(param1:String) : void
      {
         this.disposeBitmap(this.titleBitmap,this.titleBitmapData);
         param1 = "<span class=\"title\">" + param1 + "</span>";
         this.titleBitmapData = TextRenderer.renderToBitmap(param1,TITLE_STYLE,TEXT_WIDTH,true);
         this.titleBitmap.bitmapData = this.titleBitmapData;
         this.layout();
      }
      
      public function setOwner(param1:String, param2:Boolean) : void
      {
         prefButton.buttonMode = param2;
         prefButton.visible = param2;
         if(this.playerIcon != null)
         {
            this.playerIconContainer.removeChild(this.playerIcon);
            this.playerIcon = null;
         }
         this.userName = param1;
         likeButton.visible = true;
         apartmentsIcon.visible = true;
         arrow.visible = true;
         this.setTitle(StringUtil.formattedString(LocaleStrings.MSG_HOME_OF,[param1]));
      }
      
      public function setAvatar(param1:int, param2:String) : void
      {
         var loader:Loader = null;
         var userId:int = param1;
         var version:String = param2;
         loader = new Loader();
         var loaderInfo:* = loader.contentLoaderInfo;
         loaderInfo.addEventListener(Event.COMPLETE,this.handleIconLoaded);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void
         {
            var _loc2_:String = "[!] Cannot load Fregger for RoomBanner";
         });
         var url:String = "/img/tiny/" + userId + "/0/fregger.png?v=" + version;
         loader.load(new URLRequest(url));
      }
      
      public function setTopic(param1:String) : void
      {
         this.disposeBitmap(this.topicBitmap,this.topicBitmapData);
         if(param1 != null && param1 != "")
         {
            param1 = "<span class=\"topic\">&quot;" + param1 + "&quot;</span>";
            this.topicBitmapData = TextRenderer.renderToBitmap(param1,TOPIC_STYLE,TEXT_WIDTH,true);
            this.topicBitmap.bitmapData = this.topicBitmapData;
         }
         this.layout();
      }
      
      public function setLikeCount(param1:int, param2:Boolean) : void
      {
         likeButton.buttonMode = param2;
         likeButton.mouseEnabled = param2;
         likeButton.gotoAndStop(!!param2?"enabled":"disabled");
         likeButton.likeCountTextField.text = param1;
      }
      
      public function reset() : void
      {
         prefButton.buttonMode = false;
         prefButton.visible = false;
         prefButton.gotoAndStop("out");
         this.setLikeCount(0,false);
         this.playerIconContainer.visible = false;
         likeButton.visible = false;
         apartmentsIcon.visible = false;
         arrow.visible = false;
         this.userName = null;
         this.disposePlayerIcon();
         this.disposeBitmap(this.titleBitmap,this.titleBitmapData);
         this.disposeBitmap(this.topicBitmap,this.topicBitmapData);
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : void
      {
         if(param1.target == prefButton)
         {
            if(param1.type == MouseManagerData.MOUSE_OVER)
            {
               prefButton.gotoAndStop("over");
            }
            else if(param1.type == MouseManagerData.MOUSE_OUT)
            {
               prefButton.gotoAndStop("out");
            }
            else if(param1.type == MouseManagerData.CLICK)
            {
               this.onPrefsClick();
            }
         }
         else if(param1.type == MouseManagerData.CLICK)
         {
            if(param1.target == likeButton)
            {
               this.onVoteClick();
            }
            else if(param1.target == this.playerIconContainer)
            {
               if(this.userName != null)
               {
                  this.onAvatarClick(this.userName);
               }
            }
            else if(param1.target == apartmentsIcon.apartmentsButton)
            {
               this.onApartmentsButtonClick();
            }
         }
      }
      
      private function disposePlayerIcon() : void
      {
         if(this.playerIcon != null && this.playerIcon.parent != null)
         {
            this.playerIcon.parent.removeChild(this.playerIcon);
            this.playerIcon.bitmapData.dispose();
            this.playerIcon.bitmapData = null;
            this.playerIcon = null;
         }
      }
      
      private function handleIconLoaded(param1:Event) : void
      {
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         if(_loc2_ == null)
         {
            return;
         }
         this.disposePlayerIcon();
         this.playerIcon = _loc2_.loader.content as Bitmap;
         if(this.playerIcon == null)
         {
            return;
         }
         this.playerIcon.x = -this.playerIcon.width;
         this.playerIcon.filters = [OUTLINE];
         this.playerIconContainer.visible = true;
         this.playerIconContainer.addChild(this.playerIcon);
      }
      
      private function layout() : void
      {
         var _loc6_:Sprite = null;
         var _loc7_:TextField = null;
         var _loc8_:Sprite = null;
         var _loc1_:Number = 2 * MARGIN;
         _loc1_ = _loc1_ + (!!likeButton.visible?likeButton.height:14);
         if(this.topicBitmap.bitmapData == null)
         {
            this.titleBitmap.y = (_loc1_ - this.titleBitmap.height) / 2;
         }
         else
         {
            if(likeButton.visible)
            {
               _loc1_ = Math.max(likeButton.height + 2 * MARGIN,MARGIN + this.titleBitmap.height + 5 + this.topicBitmap.height + MARGIN);
            }
            else
            {
               _loc1_ = MARGIN + this.topicBitmap.height + MARGIN;
               if(this.titleBitmap.height > 0)
               {
                  _loc1_ = _loc1_ + (this.titleBitmap.height + 5);
               }
            }
            if(this.titleBitmap.height > 0)
            {
               this.titleBitmap.y = (_loc1_ - this.topicBitmap.height - this.titleBitmap.height - 5) / 2;
               this.topicBitmap.y = this.titleBitmap.y + this.titleBitmap.height + 5;
            }
            else
            {
               this.topicBitmap.y = (_loc1_ - this.topicBitmap.height) / 2;
            }
         }
         var _loc2_:int = Math.max(this.titleBitmap.width,this.topicBitmap.width);
         var _loc3_:int = !!prefButton.visible?int(MARGIN + prefButton.width):0;
         var _loc4_:int = _loc3_ + MARGIN + _loc2_ + (!!likeButton.visible?MARGIN + likeButton.width:0) + MARGIN;
         var _loc5_:int = -_loc4_ / 2;
         this.titleBitmap.x = _loc5_ + _loc3_ + MARGIN + (_loc2_ - this.titleBitmap.width) / 2;
         this.topicBitmap.x = _loc5_ + _loc3_ + MARGIN + (_loc2_ - this.topicBitmap.width) / 2;
         likeButton.x = _loc5_ + _loc4_ - likeButton.width - MARGIN;
         likeButton.y = MARGIN;
         prefButton.x = _loc5_ + MARGIN;
         prefButton.y = MARGIN;
         this.playerIconContainer.x = _loc5_ - 5 - 16;
         this.playerIconContainer.y = MARGIN;
         arrow.x = _loc5_;
         background.height = _loc1_;
         background.width = _loc4_;
         background.x = _loc5_;
         this.topicBitmap.visible = true;
         this.titleBitmap.visible = true;
         if(apartmentsIcon.visible)
         {
            _loc6_ = apartmentsIcon.apartmentsButton;
            _loc7_ = apartmentsIcon.apartmentsTextLabel;
            _loc8_ = apartmentsIcon.apartmentsBackground;
            apartmentsIcon.x = _loc5_ + _loc4_ + 7;
            _loc8_.height = _loc1_;
            _loc8_.width = _loc1_;
            _loc7_.x = (_loc1_ - _loc7_.width) / 2;
            _loc7_.y = _loc1_ - _loc7_.height;
            _loc6_.x = (_loc1_ - _loc6_.width) / 2;
         }
      }
   }
}
