package de.freggers.roomlib
{
   import de.freggers.net.data.IAvatarData;
   import de.freggers.ui.TimerBar;
   import de.freggers.util.BitmapDataUtils;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import de.freggers.util.RenderServerUtil;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class Player extends IsoObjectContainer
   {
      
      public static const GHOST_INITIAL_ALPHA:Number = 0.4;
      
      public static const DEFAULT_SCALE:int = 100;
      
      public static const SHRINKSCALE:int = 60;
      
      public static const STATE_COMPOSING:uint = 0;
      
      public static const STATE_IDLE:uint = 1;
      
      public static const STATE_AWAY:uint = 2;
      
      public static const STATE_SHRINKED:uint = 4;
      
      public static const STATE_NOSOUND:uint = 6;
      
      public static const STATE_PLAYING:uint = 7;
      
      public static const STATE_CARRYING:uint = 8;
      
      public static const STATE_CLOAK:uint = 10;
      
      public static const STATE_QUICK_LIGHT:uint = 13;
      
      public static const STATE_QUICK_STRONG:uint = 14;
      
      public static const STATE_PRANKED:uint = 16;
      
      public static const ICONSCALE:Number = 0.5;
       
      
      public var userid:int;
      
      public var body:String;
      
      public var prerendered:String;
      
      public var baseurl:String;
      
      public var rights:int;
      
      private var _renderparts:Array;
      
      public var _isGhost:Boolean = false;
      
      public var scalex:int = 100;
      
      public var scaley:int = 100;
      
      public var scalez:int = 100;
      
      public var baseFrameWidth:int = 64;
      
      private var guiChanged:Boolean = true;
      
      private var _idleTimeStamp:Date = null;
      
      private var _isoIcons:IconBox;
      
      private var _extraIcons:IconBox;
      
      private var _timerBar:TimerBar;
      
      private var _isoOverlays:Sprite;
      
      public function Player(param1:int, param2:int)
      {
         super(param2);
         this.userid = param1;
         this._isoOverlays = new Sprite();
      }
      
      public static function createFromData(param1:IAvatarData) : Player
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1.userName == null || param1.userId <= 0)
         {
            return null;
         }
         var _loc2_:Player = new Player(param1.userId,param1.wobId);
         _loc2_.name = param1.userName;
         _loc2_.rights = param1.rights;
         if(param1.status && param1.status is Array)
         {
            _loc3_ = param1.status;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_])
               {
                  _loc2_.setState(_loc4_,true,_loc3_[_loc4_]);
               }
               _loc4_++;
            }
         }
         _loc2_.initIconBoxes();
         return _loc2_;
      }
      
      public function set isGhost(param1:Boolean) : void
      {
         this._isGhost = param1;
         isoobj.alpha = !!this._isGhost?Number(GHOST_INITIAL_ALPHA):Number(1);
      }
      
      public function get isGhost() : Boolean
      {
         return this._isGhost;
      }
      
      public function get idleTimeStamp() : Date
      {
         return this._idleTimeStamp;
      }
      
      public function get renderparts() : Array
      {
         return this._renderparts;
      }
      
      public function set renderparts(param1:Array) : void
      {
         if(!param1)
         {
            return;
         }
         this._renderparts = param1;
         this.guiChanged = true;
      }
      
      private function generateGui() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(this.prerendered)
         {
            _gui = this.prerendered;
         }
         else
         {
            _loc1_ = new Array();
            _loc2_ = new Array();
            _loc3_ = new Array();
            if(this._renderparts && this._renderparts.length > 0)
            {
               this._renderparts.sortOn("mesh_label");
               _loc4_ = 0;
               while(_loc4_ < this._renderparts.length)
               {
                  if(!(!this._renderparts[_loc4_]["mesh_label"] || !this._renderparts[_loc4_]["colors"]))
                  {
                     _loc1_.push(this._renderparts[_loc4_]["mesh_label"]);
                     _loc2_.push(this._renderparts[_loc4_]["colors"]);
                     _loc3_.push(this._renderparts[_loc4_]["textures"]);
                  }
                  _loc4_++;
               }
            }
            _loc3_.length = _loc1_.length;
            _gui = RenderServerUtil.URLString(this.body,this.baseFrameWidth,_loc1_,_loc2_,_loc3_,64,this.scalex,this.scaley,this.scalez);
         }
         this.guiChanged = false;
      }
      
      override public function get gui() : String
      {
         if(this.guiChanged)
         {
            this.generateGui();
         }
         return _gui;
      }
      
      override public function set gui(param1:String) : void
      {
      }
      
      override public function url(param1:Object) : String
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:String = this.baseurl;
         var _loc3_:String = param1["datapack"];
         if(!_loc3_)
         {
            return null;
         }
         if(this.prerendered)
         {
            _loc2_ = _loc2_ + ("/" + this.prerendered.split(".").join("/") + "_" + _loc3_ + ".bin");
         }
         else
         {
            if(this.guiChanged)
            {
               this.generateGui();
            }
            if(!this.gui)
            {
               return null;
            }
            _loc2_ = _loc2_ + ("?" + RenderServerUtil.packageQueryStringFromUrlString(this.gui,_loc3_));
         }
         return _loc2_;
      }
      
      override public function setState(param1:uint, param2:Boolean, param3:Object) : void
      {
         super.setState(param1,param2,param3);
         this.applyState(param1);
      }
      
      override public function applyStates() : void
      {
         var _loc1_:uint = 0;
         super.applyStates();
         while(_loc1_ < _stateValues.length)
         {
            this.applyState(_stateValues[_loc1_]);
            _loc1_++;
         }
      }
      
      private function applyState(param1:uint) : void
      {
         var _loc2_:Date = null;
         switch(param1)
         {
            case STATE_AWAY:
               if(this._isoIcons)
               {
                  if(_setStates[param1])
                  {
                     this._isoIcons.showIcon(IconBox.ICON_AWAY);
                  }
                  else
                  {
                     this._isoIcons.hideIcon(IconBox.ICON_AWAY);
                  }
                  this.layoutIsoOverlays();
               }
               break;
            case STATE_QUICK_LIGHT:
            case STATE_QUICK_STRONG:
               if(this._extraIcons)
               {
                  if(_setStates[STATE_QUICK_LIGHT] || _setStates[STATE_QUICK_STRONG])
                  {
                     this._extraIcons.showIcon(IconBox.ICON_QUICK);
                  }
                  else
                  {
                     this._extraIcons.hideIcon(IconBox.ICON_QUICK);
                  }
               }
               break;
            case STATE_PRANKED:
               if(this._extraIcons)
               {
                  if(_setStates[param1])
                  {
                     this._extraIcons.showIcon(IconBox.ICON_PRANKED);
                  }
                  else
                  {
                     this._extraIcons.hideIcon(IconBox.ICON_PRANKED);
                  }
               }
               break;
            case STATE_CARRYING:
               break;
            case STATE_COMPOSING:
               if(this._isoIcons)
               {
                  if(_setStates[param1])
                  {
                     this._isoIcons.showIcon(IconBox.ICON_COMPOSING);
                     switch(_stateValues[param1])
                     {
                        case 0:
                           this._isoIcons.pauseIcon(IconBox.ICON_COMPOSING);
                           break;
                        case 1:
                           this._isoIcons.playIcon(IconBox.ICON_COMPOSING);
                     }
                  }
                  else
                  {
                     this._isoIcons.stopIcon(IconBox.ICON_COMPOSING);
                     this._isoIcons.hideIcon(IconBox.ICON_COMPOSING);
                  }
                  this.layoutIsoOverlays();
               }
               break;
            case STATE_IDLE:
               if(_setStates[param1])
               {
                  _loc2_ = new Date();
                  _loc2_.seconds = _loc2_.seconds - int(_stateValues[param1]);
                  this._idleTimeStamp = _loc2_;
               }
               else
               {
                  this._idleTimeStamp = null;
               }
               break;
            case STATE_NOSOUND:
               if(this._extraIcons)
               {
                  if(_setStates[param1])
                  {
                     this._extraIcons.showIcon(IconBox.ICON_NOSOUND);
                  }
                  else
                  {
                     this._extraIcons.hideIcon(IconBox.ICON_NOSOUND);
                  }
               }
               break;
            case STATE_PLAYING:
               if(this._extraIcons)
               {
                  if(_setStates[param1])
                  {
                     this._extraIcons.showIcon(IconBox.ICON_PLAYING);
                  }
                  else
                  {
                     this._extraIcons.hideIcon(IconBox.ICON_PLAYING);
                  }
               }
               break;
            case STATE_CLOAK:
               if(_setStates[param1])
               {
                  isoobj.displayflags = isoobj.displayflags | IsoObjectSpriteContent.FLAG_CLOAK;
               }
               else
               {
                  isoobj.displayflags = isoobj.displayflags & ~IsoObjectSpriteContent.FLAG_CLOAK;
               }
         }
      }
      
      public function updateIsoOverlaysPosition() : void
      {
         if(!isoobj.sprite.isAdded)
         {
            return;
         }
         this._isoOverlays.x = isoobj.sprite.bounds.x + (isoobj.sprite.bounds.width - this._isoOverlays.width) / 2;
         this._isoOverlays.y = isoobj.sprite.bounds.y - this._isoOverlays.height;
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
         if(this._isoOverlays.parent != null)
         {
            this._isoOverlays.parent.removeChild(this._isoOverlays);
         }
         if(this._extraIcons.parent != null)
         {
            this._extraIcons.parent.removeChild(this._extraIcons);
         }
         this._isoIcons = null;
         this._extraIcons = null;
         this._timerBar = null;
         this._isoOverlays = null;
      }
      
      private function initIconBoxes() : void
      {
         if(this._isoIcons == null)
         {
            this._isoIcons = new IconBox();
            this._isoIcons.addIcon(IconBox.ICON_COMPOSING,new icon_composing());
            this._isoIcons.addIcon(IconBox.ICON_AWAY,new icon_away());
            this._isoOverlays.addChild(this._isoIcons);
            this.layoutIsoOverlays();
         }
         if(this._extraIcons == null)
         {
            this._extraIcons = new IconBox();
            if((this.rights & 16) == 16)
            {
               this._extraIcons.addIcon(IconBox.ICON_ADMIN,new icon_admin());
               this._extraIcons.showIcon(IconBox.ICON_ADMIN);
            }
            else if((this.rights & 8) == 8)
            {
               this._extraIcons.addIcon(IconBox.ICON_SERVEROP,new icon_serverop());
               this._extraIcons.showIcon(IconBox.ICON_SERVEROP);
            }
            this._extraIcons.addIcon(IconBox.ICON_NOSOUND,new icon_nosound());
            this._extraIcons.addIcon(IconBox.ICON_PLAYING,new icon_playing());
            this._extraIcons.addIcon(IconBox.ICON_QUICK,new icon_quick());
            this._extraIcons.addIcon(IconBox.ICON_PRANKED,new icon_pranked());
         }
      }
      
      public function get isoIcons() : Sprite
      {
         return this._isoOverlays;
      }
      
      public function get extraIcons() : IconBox
      {
         return this._extraIcons;
      }
      
      private function layoutIsoOverlays() : void
      {
         var _loc1_:Number = 0;
         if(this._isoIcons != null)
         {
            _loc1_ = this._isoIcons.width;
         }
         if(this._timerBar != null)
         {
            _loc1_ = Math.max(_loc1_,this._timerBar.width);
         }
         var _loc2_:Number = 0;
         if(this._isoIcons != null)
         {
            this._isoIcons.x = _loc1_ / 2;
            this._isoIcons.y = this._isoIcons.height;
            _loc2_ = _loc2_ + this._isoIcons.height;
         }
         if(this._timerBar != null)
         {
            this._timerBar.x = (_loc1_ - this._timerBar.width) / 2;
            this._timerBar.y = _loc2_ + 2;
            _loc2_ = _loc2_ + (this._timerBar.height + 2);
         }
         this.updateIsoOverlaysPosition();
      }
      
      public function setCarryIcon(param1:CarryIcon) : void
      {
         if(param1 != null)
         {
            param1.direction = isoobj.direction;
         }
         (isoobj.sprite.content as IsoObjectSpriteContent).carryIcon = param1;
      }
      
      public function setTimerBar(param1:int) : void
      {
         if(isoobj.sprite.isAdded)
         {
            this.clearTimerBar();
            this._timerBar = new TimerBar(param1,this.clearTimerBar);
            this._isoOverlays.addChild(this._timerBar);
            this.layoutIsoOverlays();
         }
      }
      
      public function clearTimerBar() : void
      {
         if(this._timerBar != null)
         {
            if(this._timerBar.parent != null)
            {
               this._timerBar.parent.removeChild(this._timerBar);
            }
            this._timerBar = null;
            this.layoutIsoOverlays();
         }
      }
      
      public function hasTimerBar() : Boolean
      {
         return this._timerBar != null;
      }
      
      public function updateTimerBar(param1:int) : void
      {
         if(this._timerBar != null)
         {
            this._timerBar.update(param1);
         }
      }
      
      override public function get icon() : BitmapData
      {
         var _loc1_:ICroppedBitmapDataContainer = isoobj.media.getFrame(isoobj.media.defaultAnimation,0,isoobj.media.defaultFrame);
         var _loc2_:BitmapData = BitmapDataUtils.unCrop(_loc1_.bitmapData,_loc1_.crect.topLeft,_loc1_.rect);
         var _loc3_:Rectangle = new Rectangle(0,0,_loc2_.width,77);
         var _loc4_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height);
         _loc4_.copyPixels(_loc2_,_loc3_,_loc2_.rect.topLeft);
         _loc2_.dispose();
         return BitmapDataUtils.crop(_loc4_);
      }
   }
}
