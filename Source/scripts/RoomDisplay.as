package
{
   import caurina.transitions.Tweener;
   import caurina.transitions.properties.DisplayShortcuts;
   import caurina.transitions.properties.FilterShortcuts;
   import com.adobe.crypto.MD5;
   import de.freggers.animation.Animation;
   import de.freggers.animation.AnimationManager;
   import de.freggers.animation.CompositeAnimation;
   import de.freggers.animation.IChangeable;
   import de.freggers.animation.Movement;
   import de.freggers.animation.MovementWayPoint;
   import de.freggers.audio.AudioSystem;
   import de.freggers.audio.SoundConfig;
   import de.freggers.audio.SoundLoop;
   import de.freggers.audio.SoundTrack;
   import de.freggers.data.BinaryDecodable;
   import de.freggers.data.BinaryLoader;
   import de.freggers.data.Level;
   import de.freggers.data.LevelBackground;
   import de.freggers.games.IGameClient;
   import de.freggers.games.SinglePlayerGameManager;
   import de.freggers.isostar.IsoDisplayObject;
   import de.freggers.isostar.IsoEffectConfig;
   import de.freggers.isostar.IsoGhost;
   import de.freggers.isostar.IsoGrid;
   import de.freggers.isostar.IsoSortable;
   import de.freggers.isostar.IsoSprite;
   import de.freggers.isostar.IsoSpriteEffect;
   import de.freggers.isostar.IsoStar;
   import de.freggers.locale.RoomDisplay.LocaleStrings;
   import de.freggers.net.Client;
   import de.freggers.net.command.ActionThrow;
   import de.freggers.net.command.ActionUpdateWob;
   import de.freggers.net.command.ChatSrv;
   import de.freggers.net.command.ChatUsr;
   import de.freggers.net.command.Cmd;
   import de.freggers.net.command.CtxtRoom;
   import de.freggers.net.command.CtxtServer;
   import de.freggers.net.command.EnvItem;
   import de.freggers.net.command.EnvMisc;
   import de.freggers.net.command.EnvUser;
   import de.freggers.net.command.MayVote;
   import de.freggers.net.command.TrRoomJoin;
   import de.freggers.net.command.TrRoomLeave;
   import de.freggers.net.data.AnimationData;
   import de.freggers.net.data.GhosttrailData;
   import de.freggers.net.data.IAvatarData;
   import de.freggers.net.data.IWOBStatus;
   import de.freggers.net.data.InteractionData;
   import de.freggers.net.data.ItemData;
   import de.freggers.net.data.LightmapData;
   import de.freggers.net.data.Path;
   import de.freggers.net.data.Position;
   import de.freggers.net.data.SoundBlock;
   import de.freggers.net.data.WayPoint;
   import de.freggers.notify.NotifyManager;
   import de.freggers.notify.events.OpenUrlEvent;
   import de.freggers.notify.events.RequestActionEvent;
   import de.freggers.notify.events.ShowBadgesEvent;
   import de.freggers.notify.events.WalkToRoomEvent;
   import de.freggers.property.Property;
   import de.freggers.property.PropertyConfig;
   import de.freggers.property.PropertyFactory;
   import de.freggers.roomdisplay.AmfApi;
   import de.freggers.roomdisplay.CenteredMessageManager;
   import de.freggers.roomdisplay.ClickthroughTarget;
   import de.freggers.roomdisplay.ControlsEvent;
   import de.freggers.roomdisplay.Debugger;
   import de.freggers.roomdisplay.Dialog;
   import de.freggers.roomdisplay.EffectData;
   import de.freggers.roomdisplay.FFHStream;
   import de.freggers.roomdisplay.FormattedMessage;
   import de.freggers.roomdisplay.IInputModule;
   import de.freggers.roomdisplay.IsoObjectPlacerInput;
   import de.freggers.roomdisplay.ItemMenu;
   import de.freggers.roomdisplay.JSApi;
   import de.freggers.roomdisplay.MenuItem;
   import de.freggers.roomdisplay.MessageContainer;
   import de.freggers.roomdisplay.MessageManager;
   import de.freggers.roomdisplay.MetroPlan;
   import de.freggers.roomdisplay.MyLoader;
   import de.freggers.roomdisplay.MyLoaderEvent;
   import de.freggers.roomdisplay.MyLocationArrow;
   import de.freggers.roomdisplay.MyWalkDest;
   import de.freggers.roomdisplay.RoomHopPlan;
   import de.freggers.roomdisplay.TargetPicker;
   import de.freggers.roomdisplay.TextBar;
   import de.freggers.roomdisplay.ThrowData;
   import de.freggers.roomdisplay.Utils;
   import de.freggers.roomdisplay.data.UserLevelProgress;
   import de.freggers.roomdisplay.milwkit.MILWKITScreen;
   import de.freggers.roomdisplay.shop.NewShopItemsScreen;
   import de.freggers.roomdisplay.shop.ShopItem;
   import de.freggers.roomdisplay.ui.AutowalkAnimation;
   import de.freggers.roomdisplay.ui.ControlBar;
   import de.freggers.roomdisplay.ui.CreditsDisplay;
   import de.freggers.roomdisplay.ui.HandContentTrash;
   import de.freggers.roomdisplay.ui.LayerManager;
   import de.freggers.roomdisplay.ui.LevelDisplay;
   import de.freggers.roomdisplay.ui.MousePointer;
   import de.freggers.roomdisplay.ui.RoomBanner;
   import de.freggers.roomdisplay.ui.UniversalHelperScreen;
   import de.freggers.roomdisplay.ui.tooltip.TooltipManager;
   import de.freggers.roomlib.AnimationSprite;
   import de.freggers.roomlib.CarryIcon;
   import de.freggers.roomlib.Exit;
   import de.freggers.roomlib.IsoItem;
   import de.freggers.roomlib.IsoObject;
   import de.freggers.roomlib.IsoObjectContainer;
   import de.freggers.roomlib.IsoObjectSprite;
   import de.freggers.roomlib.IsoObjectSpriteContent;
   import de.freggers.roomlib.IsoSpriteBitmapDataContent;
   import de.freggers.roomlib.ItemInteraction;
   import de.freggers.roomlib.Player;
   import de.freggers.roomlib.Room;
   import de.freggers.roomlib.util.ADataPack;
   import de.freggers.roomlib.util.InstanceFactory;
   import de.freggers.roomlib.util.IsoObjectDataPack;
   import de.freggers.roomlib.util.MediaDataPack;
   import de.freggers.roomlib.util.MessageFilter;
   import de.freggers.roomlib.util.ResourceManager;
   import de.freggers.roomlib.util.ResourceRequest;
   import de.freggers.roomlib.util.WOBRegistry;
   import de.freggers.ui.ISelectable;
   import de.freggers.ui.IconDropManager;
   import de.freggers.ui.IconDropSprite;
   import de.freggers.util.BABitmapDataContainer;
   import de.freggers.util.BitmapDataUtils;
   import de.freggers.util.CroppedBitmapDataContainer;
   import de.freggers.util.FlashCookies;
   import de.freggers.util.Job;
   import de.freggers.util.JobQueue;
   import de.freggers.util.RenderServerUtil;
   import de.freggers.util.ShapedBitmap;
   import de.freggers.util.StringUtil;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import de.schulterklopfer.interaction.manager.InteractionManager;
   import de.schulterklopfer.interaction.manager.MouseManager;
   import de.schulterklopfer.interaction.manager.WidgetManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public final class RoomDisplay extends Sprite implements IGameClient
   {
      
      private static const INTERACTION_GROUP_ISOSPRITE_CONTENTS:String = "__contents__";
      
      private static const INTERACTION_GROUP_EXITS:String = "__exits__";
      
      public static const INTERACTION_GROUP_WIDGETS:String = "__widgets__";
      
      public static const VERSION:String = "20190130-160700" + "phi" + "";
      
      private static const COS30_1_D_SIN30_1_D_SQRT2:Number = Math.cos(Math.PI / 6) / (Math.sin(Math.PI / 6) * Math.SQRT2);
      
      private static const requiredparams:Array = ["username","sessionid","host","port","roombaseurl","portablebaseurl","itembaseurl","npcbaseurl","amfgw","imgfactory","overlaybaseurl","property_cfg"];
      
      private static const smileys:Object = {
         "Sml_grins":Sml_grins,
         "Sml_grr":Sml_grr,
         "Sml_heul":Sml_heul,
         "Sml_hmm":Sml_hmm,
         "Sml_lach":Sml_lach,
         "Sml_lieb":Sml_lieb,
         "Sml_lol":Sml_lol,
         "Sml_muede":Sml_muede,
         "Sml_ooh":Sml_ooh,
         "Sml_zunge":Sml_zunge,
         "Sml_zwinker":Sml_zwinker,
         "Sml_toifl":Sml_toifl
      };
      
      private static const SOP_MENU_EXTENSION:Array = ["warn","kick","skick"];
      
      private static const WINDOW_OFFSET:int = 10;
      
      private static const GHOST_M_RESOURCE_NAME:String = "@m_ghost";
      
      private static const GHOST_F_RESOURCE_NAME:String = "@f_ghost";
      
      private static const GHOST_M_SHRINK_RESOURCE_NAME:String = "@m_ghost_shrinked";
      
      private static const GHOST_F_SHRINK_RESOURCE_NAME:String = "@f_ghost_shrinked";
      
      private static const LOOPEVERY:uint = 20;
      
      private static var param:Object;
      
      private static const ZOOM_IN:uint = 1;
      
      private static const ZOOM_OUT:uint = 2;
      
      private static const ZOOM_DONE:uint = 0;
      
      private static const ZOOM_DURATION:uint = 400;
      
      private static const ZOOM_MAXBLUR:uint = 20;
       
      
      private var urlGhostM:String;
      
      private var urlGhostF:String;
      
      private var urlGhostMShrinked:String;
      
      private var urlGhostFShrinked:String;
      
      private var screenshotbusy:Boolean = false;
      
      private var lastmainloopcall:Number = 0;
      
      private var controlbar:ControlBar;
      
      private var handContentTrash:HandContentTrash;
      
      private var markedIsoObjecContainer:IsoObjectContainer;
      
      private var keydown:Array;
      
      private var ldr:MyLoader;
      
      private var client:Client;
      
      private var room:Room;
      
      private var areaName:String;
      
      private var host:String;
      
      private var port:int;
      
      private var isoengine:IsoStar;
      
      private var amfApi:AmfApi;
      
      private var msgmanager:MessageManager;
      
      private var thisplayer:Player;
      
      private var animationmanager:AnimationManager;
      
      private var itemmenu:ItemMenu;
      
      private var exits:Array;
      
      private var networkJobQueue:JobQueue;
      
      private var centeredMsgManager:CenteredMessageManager;
      
      private var lasttime:int = -1;
      
      private var framedursum:int = 0;
      
      private var countedframes:int = 0;
      
      private var mainLoopTimer:Timer;
      
      private var layerManager:LayerManager;
      
      private var tooltipManager:TooltipManager;
      
      private var metroPlan:MetroPlan;
      
      private var metroPlanContainer:Sprite;
      
      private var roomHopPlan:RoomHopPlan;
      
      private var activeDialog:Dialog;
      
      private var walkdest:MyWalkDest;
      
      private var audioSystem:AudioSystem;
      
      private var spgm:SinglePlayerGameManager;
      
      private var debugbm:Bitmap;
      
      private var lastmouseeventat:Point;
      
      private var flag_mousedown:Boolean;
      
      private var inputModule:IInputModule;
      
      private var dragScrolling:Boolean = false;
      
      private var autoScroll:Boolean = true;
      
      private var queuedAnimations:Dictionary;
      
      private var isotargetlookup:Dictionary;
      
      private var trackidlookup:Dictionary;
      
      private var pendingIconUpdates:Array;
      
      private var pendingCarriedObjects:Dictionary;
      
      private var ffhStream:FFHStream;
      
      private var roomBanner:RoomBanner;
      
      private var levelDisplay:LevelDisplay;
      
      private var creditsDisplay:CreditsDisplay;
      
      private var flashCookies:FlashCookies;
      
      private var roomInited:Boolean;
      
      private var debugger:Debugger;
      
      private var clickThroughTarget:ClickthroughTarget;
      
      private var targetPicker:TargetPicker;
      
      private var inventoryNotifyTimers:Object;
      
      private var _zoom:Number = 1;
      
      private var ZOOM_OUT_VALUE:Number = 1;
      
      private var ZOOM_IN_VALUE:Number = 2;
      
      private var _zoommode:uint = 0;
      
      private var _zoomstarttime:int = 0;
      
      private var _zoomstartvalue:Number;
      
      private var _autowalkAnimation:AutowalkAnimation;
      
      private var _loadComplete:Boolean = false;
      
      private var _zoomIn:Boolean = false;
      
      private var notifyManager:NotifyManager;
      
      private var iconDropManager:IconDropManager;
      
      private var itemsToLoad:int = 0;
      
      private var USE_LIVESTATS:Boolean = false;
      
      private var STAT_UPDATEINTERVAL:uint = 60000;
      
      private var stat_frame_counter:int = 0;
      
      private var total_objects:int = 0;
      
      private var total_fps:Number = 0;
      
      private var stats_sent_at:uint = 0;
      
      private var logged_in_at:uint = 0;
      
      private var isoEnginePickedTarget:Boolean;
      
      private var mousePointer:MousePointer;
      
      public function RoomDisplay()
      {
         this.inventoryNotifyTimers = new Object();
         super();
         if(stage != null)
         {
            this.boot();
         }
         else
         {
            this.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         }
      }
      
      public static function dump(param1:Object, param2:String = "") : void
      {
         var _loc3_:* = null;
         if(!param1)
         {
            return;
         }
         if(param1 is Object)
         {
            for(_loc3_ in param1)
            {
               dump(param1[_loc3_],param2 + " ");
            }
         }
      }
      
      public static function getConfig() : Object
      {
         return param;
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         this.boot();
      }
      
      private function boot() : void
      {
         DisplayShortcuts.init();
         FilterShortcuts.init();
         IsoStar.DEBUG = 0;
         IsoStar.INTERLACEIDLEFRAMES = 3;
         stage.scaleMode = "noScale";
         stage.align = "TL";
         stage.frameRate = 30;
         param = stage.loaderInfo.parameters;
         this.amfApi = new AmfApi(param["amfgw"]);
         this.amfApi.connect();
         this.flashCookies = new FlashCookies();
         var _loc1_:uint = this.loginAllowed();
         if(_loc1_ != 0)
         {
            this.logout(_loc1_);
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < requiredparams.length)
         {
            if(param[requiredparams[_loc2_]] == null)
            {
               return;
            }
            _loc2_++;
         }
         if(param["medbaseurl"] == null)
         {
            param["medbaseurl"] = "";
         }
         this.host = param["host"];
         this.port = int(param["port"]);
         if(int(param["livestats"]) > 0)
         {
            this.USE_LIVESTATS = true;
            this.STAT_UPDATEINTERVAL = int(param["livestats"]);
         }
         this.init();
         stage.doubleClickEnabled = true;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleStageEvent);
         stage.addEventListener(Event.MOUSE_LEAVE,this.handleStageEvent);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleStageEvent);
         stage.addEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
         stage.addEventListener(Event.RESIZE,this.handleResize);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyboard);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyboard);
         stage.addEventListener(RequestActionEvent.EXECUTE,this.handleRequestActionEvent);
         InteractionManager.registerForMouse(stage,this.handleDrag);
      }
      
      private function drawBackground() : void
      {
         graphics.beginFill(0);
         graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         graphics.endFill();
      }
      
      private function logout(param1:uint = 0) : void
      {
         var reason:uint = param1;
         var flashLogout:Function = function():void
         {
            JSApi.logout(param["sessionid"],reason);
         };
         if(reason == 2)
         {
            this.remoteLog("ERROR","COOKIEJAR","User already logged in on system.",flashLogout);
         }
         else
         {
            flashLogout();
         }
      }
      
      private function loginAllowed() : uint
      {
         if(this.flashCookies.getCookie(FlashCookies.KEY_KICKED))
         {
            return 1;
         }
         return 0;
      }
      
      private function restoreSettings() : void
      {
         var _loc1_:Boolean = this.flashCookies.getCookieWithDefault(FlashCookies.KEY_ENABLE_MUSIC,true);
         var _loc2_:Boolean = this.flashCookies.getCookieWithDefault(FlashCookies.KEY_ENABLE_EFFECTS,true);
         var _loc3_:Boolean = this.flashCookies.getCookieWithDefault(FlashCookies.KEY_OPTIONS_VISIBLE,true);
         this.handleAudioToggled(_loc1_,SoundTrack.SOUND_TYPE_AMB);
         this.controlbar.optionsDelegate.setMusicActive(_loc1_);
         this.handleAudioToggled(_loc2_,SoundTrack.SOUND_TYPE_EFF);
         this.controlbar.optionsDelegate.setEffectsActive(_loc2_);
         this.controlbar.optionsDelegate.setOptionsVisible(_loc3_);
      }
      
      private function handleRequestActionEvent(param1:RequestActionEvent) : void
      {
         if(param1 is OpenUrlEvent)
         {
            navigateToURL(new URLRequest((param1 as OpenUrlEvent).url),(param1 as OpenUrlEvent).targetFrame);
         }
         else if(param1 is WalkToRoomEvent)
         {
            this.client.sendAutoWalkTo((param1 as WalkToRoomEvent).room_label);
            this.autoScroll = true;
         }
         else if(param1 is ShowBadgesEvent)
         {
            JSApi.showBadges();
         }
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc2_:int = getTimer();
         if(this.lasttime > -1)
         {
            this.framedursum = this.framedursum + (_loc2_ - this.lasttime);
            this.countedframes++;
         }
         var _loc3_:Number = -1;
         if(this.countedframes >= stage.frameRate)
         {
            _loc3_ = Math.round(1000 / (this.framedursum / this.countedframes));
            if(this.ldr == null && this.USE_LIVESTATS && this.isoengine && this.isoengine.sprites)
            {
               this.total_fps = this.total_fps + _loc3_;
               this.total_objects = this.total_objects + this.isoengine.sprites.length;
               this.stat_frame_counter++;
               if(_loc2_ - this.stats_sent_at > this.STAT_UPDATEINTERVAL)
               {
                  this.stats_sent_at = _loc2_;
                  _loc4_ = int((_loc2_ - this.logged_in_at) / 1000 + 0.5);
                  _loc5_ = int(this.total_fps / this.stat_frame_counter + 0.5);
                  _loc6_ = int(this.total_objects / this.stat_frame_counter + 0.5);
                  _loc7_ = "";
                  _loc8_ = JSApi.getBrowserInfo();
                  if(_loc8_ != null)
                  {
                     _loc7_ = _loc8_.browser + " " + _loc8_.version;
                  }
                  this.amfApi.call(AmfApi.SEND_STATS,null,null,[VERSION,_loc4_,_loc5_,_loc6_,Capabilities.os,Capabilities.version,_loc7_,this.isoengine.screenrect.width,this.isoengine.screenrect.height]);
                  this.stat_frame_counter = this.total_fps = this.total_objects = 0;
               }
            }
            this.framedursum = this.countedframes = 0;
         }
         if(_loc2_ - this.lastmainloopcall > LOOPEVERY)
         {
            this.mainLoop(_loc2_);
            this.lastmainloopcall = _loc2_;
         }
         this.lasttime = _loc2_;
      }
      
      private function handleResize(param1:Event) : void
      {
         var _loc2_:int = int(stage.stageWidth);
         var _loc3_:int = int(stage.stageHeight);
         this.drawBackground();
         this.layoutGUI();
         if(this.isoengine)
         {
            this.isoengine.handleResize(_loc2_ / this._zoom,_loc3_ / this._zoom);
            this.isoengine.mask.width = _loc2_;
            this.isoengine.mask.height = _loc3_;
         }
         this.msgmanager.handleResize(_loc2_,_loc3_);
         if(this.clickThroughTarget)
         {
            this.clickThroughTarget.handleResize(_loc2_,_loc3_);
         }
         if(this.ldr)
         {
            this.ldr.handleResize(_loc2_,_loc3_);
         }
         this.itemmenu.handleResize(_loc2_,_loc3_);
         this.centerOnAvatar();
      }
      
      private function layoutGUI() : void
      {
         var _loc4_:Rectangle = null;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle = null;
         var _loc1_:int = int(stage.stageWidth);
         var _loc2_:int = int(stage.stageHeight);
         if(this.roomHopPlan != null)
         {
            this.roomHopPlan.setScreenSize(_loc1_,_loc2_);
            this.roomHopPlan.x = (_loc1_ - this.roomHopPlan.width) / 2;
            this.roomHopPlan.y = (_loc2_ - this.roomHopPlan.height) / 2;
         }
         var _loc3_:int = 747;
         if(this.controlbar != null)
         {
            this.controlbar.x = _loc1_ - this.controlbar.background.width;
            this.controlbar.y = _loc2_ - this.controlbar.background.height;
            _loc3_ = this.controlbar.width;
         }
         if(this.handContentTrash != null)
         {
            this.handContentTrash.x = this.controlbar.x + this.controlbar.background.width - this.handContentTrash.width;
            this.handContentTrash.y = this.controlbar.y - this.handContentTrash.height;
         }
         if(this.activeDialog != null)
         {
            this.activeDialog.x = (_loc1_ - this.activeDialog.width) / 2;
            this.activeDialog.y = (_loc2_ - this.activeDialog.height) / 2;
         }
         if(this.creditsDisplay != null)
         {
            _loc4_ = this.creditsDisplay.getBounds(this.creditsDisplay);
            this.creditsDisplay.x = _loc1_ - this.creditsDisplay.width - _loc4_.x - 15;
            this.creditsDisplay.y = -_loc4_.y + 15;
         }
         if(this.levelDisplay != null)
         {
            _loc5_ = (!!this.creditsDisplay?_loc1_ - this.creditsDisplay.x:0) + 15;
            this.levelDisplay.resize(Math.max(_loc3_,_loc1_) - _loc5_ - 15);
            this.levelDisplay.x = _loc1_ - _loc5_ - this.levelDisplay.width;
            this.levelDisplay.y = 5;
            this.msgmanager.y = this.levelDisplay.y + this.levelDisplay.height + 7;
         }
         if(this.controlbar)
         {
            _loc6_ = this.controlbar.getBounds(this.msgmanager);
            _loc6_.x = 0;
            _loc6_.width = _loc1_;
            this.msgmanager.setUIRect(_loc6_);
         }
         if(this.roomBanner != null)
         {
            this.updateRoomBannerPosition();
         }
         if(this.metroPlan.visible)
         {
            this.centerMetroPlan();
         }
      }
      
      private function handleMenu(param1:MouseManagerData) : void
      {
         var _loc2_:MenuItem = null;
         if(param1.target == this.itemmenu.close && param1.type == MouseManagerData.CLICK)
         {
            this.select(null);
         }
         else if(param1.target is MenuItem)
         {
            _loc2_ = param1.target as MenuItem;
            if(param1.type == MouseManagerData.CLICK || param1.type == MouseManagerData.MOUSE_UP && param1.mouseDownAndHold)
            {
               _loc2_.execute();
               this.select(null);
               this.mark(null);
            }
            else if(param1.type == MouseManagerData.MOUSE_OVER)
            {
               _loc2_.enabled = true;
            }
            else if(param1.type == MouseManagerData.MOUSE_OUT)
            {
               _loc2_.enabled = false;
            }
         }
      }
      
      private function dropObject(param1:Player) : void
      {
         if(!param1)
         {
            param1 = this.thisplayer;
         }
         (param1.isoobj.sprite.content as IsoObjectSpriteContent).carryIcon = null;
         if(this.inputModule is IsoObjectPlacerInput && param1 == this.thisplayer)
         {
            InteractionManager.enableMouseForAll(true);
            InteractionManager.setMouseHandlerCallbackFor(this.clickThroughTarget,this.handleClickthroughMouseData);
            this.inputModule.cleanup();
            this.inputModule = null;
         }
      }
      
      private function pickUpObject(param1:Player, param2:int, param3:String, param4:int) : void
      {
         var iconUrl:String = null;
         var isoItemUrl:String = null;
         var player:Player = param1;
         var wobId:int = param2;
         var gui:String = param3;
         var defaultDir:int = param4;
         this.dropObject(player);
         var item:IsoItem = WOBRegistry.instance.getIsoItemByWobId(wobId);
         if(item && item.isoobj.animation != null && item.isoobj.media.hasFrame(item.isoobj.animation,item.isoobj.direction,item.isoobj.frame))
         {
            this.onCarriedObjectAvailable(player,item.isoobj,item.wobId);
         }
         else if(item != null && item.isoobj.animation != null)
         {
            if(!this.pendingCarriedObjects[wobId])
            {
               this.pendingCarriedObjects[wobId] = player.wobId;
            }
         }
         else
         {
            iconUrl = ResourceManager.instance.getPortableItemUrl(gui);
            if(iconUrl)
            {
               ResourceManager.instance.requestImageData(iconUrl,player,function(param1:Player, param2:BABitmapDataContainer, param3:ResourceRequest):void
               {
                  var _loc4_:CroppedBitmapDataContainer = new CroppedBitmapDataContainer(param2.bitmapData);
                  param1.setCarryIcon(new CarryIcon(_loc4_));
               },function(param1:Player, param2:Object, param3:ResourceRequest):void
               {
               });
            }
            if(player == this.thisplayer)
            {
               isoItemUrl = ResourceManager.instance.getIsoItemUrl(gui);
               ResourceManager.instance.requestDataPack(gui,player,function(param1:Player, param2:IsoObjectDataPack, param3:ResourceRequest):void
               {
                  var _loc4_:IsoObject = new IsoObject(param1.isoobj.uvz.clone());
                  _loc4_.animation = param2.defaultAnimation;
                  _loc4_.direction = defaultDir;
                  _loc4_.frame = param2.defaultFrame;
                  _loc4_.media.addDataPack(param2);
                  ResourceManager.instance.registerDataPackContainer(_loc4_.media,param2);
                  onCarriedObjectAvailable(param1,_loc4_,-1);
               },function(param1:Player, param2:Object, param3:ResourceRequest):void
               {
                  dropObject(param1);
                  cancelObjectPlacing();
               },BinaryDecodable.DEFAULT_DATAPACK,isoItemUrl,ResourceManager.PACK_TYPE_ISOPACK);
            }
         }
      }
      
      private function onCarriedObjectAvailable(param1:Player, param2:IsoObject, param3:int) : void
      {
         var _loc4_:IsoObjectPlacerInput = null;
         if(param3 > 0)
         {
            delete this.pendingCarriedObjects[param3];
         }
         if(!param1 || !param2)
         {
            return;
         }
         param1.setCarryIcon(new CarryIcon(param2.media.getFrame(param2.animation,param2.direction,param2.frame)));
         if(param1 == this.thisplayer)
         {
            if(this.inputModule != null)
            {
               this.inputModule.cleanup();
            }
            _loc4_ = new IsoObjectPlacerInput(this.isoengine,this.thisplayer);
            _loc4_.isoObject = param2;
            _loc4_.onPlaceIsoObject = this.placeIsoObject;
            _loc4_.onCancelPlace = this.cancelObjectPlacing;
            _loc4_.onPlayerChangeDirection = this.sendPlayerDirection;
            this.inputModule = _loc4_;
            if(this.itemmenu.selection)
            {
               this.select(null);
            }
            if(this.inputModule.isMouseHandler())
            {
               InteractionManager.disableMouseForAllExcept(this.clickThroughTarget,true);
               InteractionManager.setMouseHandlerCallbackFor(this.clickThroughTarget,this.handleClickthroughMouseData_placeItem);
            }
         }
      }
      
      private function sendPlayerDirection(param1:int) : void
      {
         param1 = (param1 % 8 + 8) % 8;
         if(this.thisplayer.isoobj.direction == param1)
         {
            return;
         }
         var _loc2_:CompositeAnimation = this.animationmanager.getCompositeAnimation(this.thisplayer.isoobj);
         if(_loc2_ != null && _loc2_.movement != null)
         {
            return;
         }
         this.client.sendDir(param1);
      }
      
      private function getCarrierOf(param1:uint) : Player
      {
         if(!this.pendingCarriedObjects[param1])
         {
            return null;
         }
         return WOBRegistry.instance.getPlayerByWobId(this.pendingCarriedObjects[param1]);
      }
      
      private function placeIsoObject(param1:Vector3D, param2:int) : void
      {
         if(this.inputModule is IsoObjectPlacerInput)
         {
            this.client.sendPlaceObjectCommand(param1.x,param1.y,param1.z,param2);
         }
      }
      
      private function attemptPickUp() : void
      {
         if(this.itemmenu.selection is IsoObjectContainer && (this.itemmenu.selection as IsoObjectContainer).isoobj == null)
         {
            return;
         }
         this.client.sendPickUpObject(this.itemmenu.selection.wobId);
      }
      
      private function cancelObjectPlacing() : void
      {
         if(this.thisplayer.isStateSet(Player.STATE_CARRYING))
         {
            this.client.sendDeleteStatus(Client.STAT_KEY_CARRYING);
         }
      }
      
      private function handleStageEvent(param1:Event) : void
      {
         var _loc2_:Vector3D = null;
         if(param1.type == MouseEvent.MOUSE_MOVE)
         {
            if(!this.mousePointer.mouseOnStage)
            {
               this.mousePointer.mouseOnStage = true;
               JSApi.onMouseFocusChanged(true);
               this.mousePointer.visible = true;
            }
            this.mousePointer.x = stage.mouseX;
            this.mousePointer.y = stage.mouseY;
            if(this.isoengine != null && this.targetPicker != null && this.targetPicker.customPointer != null)
            {
               if(!this.targetPicker.customPointer.visible)
               {
                  this.targetPicker.customPointer.visible = true;
               }
               _loc2_ = this.isoengine.getCurrentMouseIsoPosition();
               if(_loc2_ != null)
               {
                  this.targetPicker.customPointer.setIsoPosition(_loc2_.x,_loc2_.y,_loc2_.z);
               }
            }
         }
         else if(param1.type == Event.MOUSE_LEAVE)
         {
            this.mousePointer.mouseOnStage = false;
            this.mousePointer.visible = false;
            if(this.targetPicker != null && this.targetPicker.customPointer != null && this.targetPicker.customPointer.visible)
            {
               this.targetPicker.customPointer.visible = false;
            }
            JSApi.onMouseFocusChanged(false);
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            MouseManager.stageMouseUp();
         }
      }
      
      private function init() : void
      {
         var nitems:uint = 0;
         this.drawBackground();
         this.layerManager = new LayerManager();
         addChild(this.layerManager);
         this.logged_in_at = this.stats_sent_at = getTimer();
         this.isotargetlookup = new Dictionary(true);
         this.trackidlookup = new Dictionary(true);
         this.animationmanager = new AnimationManager();
         this.animationmanager.onComplete = this.__cb_am_onComplete;
         this.animationmanager.onTick = this.__cb_am_onTick;
         this.queuedAnimations = new Dictionary(true);
         this.networkJobQueue = new JobQueue(1);
         this.keydown = new Array();
         this.audioSystem = new AudioSystem();
         this.audioSystem.onTracksFinished = this.__cb_as_audioTracksFinished;
         ResourceManager.instance.configure(param);
         ResourceManager.instance.maxResourceAge = 120000;
         this.urlGhostM = param["imgfactory"] + "?" + RenderServerUtil.packageQueryString("human_m",64,BinaryDecodable.DEFAULT_DATAPACK,["body","head","ears"],[[0,0,0],[0,0,0],[0,0,0]]);
         ResourceManager.instance.requestDataPack(GHOST_M_RESOURCE_NAME,null,function(param1:Object, param2:Object, param3:Number):void
         {
         },null,BinaryDecodable.DEFAULT_DATAPACK,this.urlGhostM,ResourceManager.PACK_TYPE_ISOPACK,null,ResourceManager.RELEASE_NEVER);
         this.urlGhostF = param["imgfactory"] + "?" + RenderServerUtil.packageQueryString("human_f",64,BinaryDecodable.DEFAULT_DATAPACK,["body","head","ears"],[[0,0,0],[0,0,0],[0,0,0]]);
         ResourceManager.instance.requestDataPack(GHOST_F_RESOURCE_NAME,null,function(param1:Object, param2:Object, param3:Number):void
         {
         },null,BinaryDecodable.DEFAULT_DATAPACK,this.urlGhostF,ResourceManager.PACK_TYPE_ISOPACK,null,ResourceManager.RELEASE_NEVER);
         this.urlGhostMShrinked = param["imgfactory"] + "?" + RenderServerUtil.packageQueryString("human_m",64,BinaryDecodable.DEFAULT_DATAPACK,["body","head","ears"],[[0,0,0],[0,0,0],[0,0,0]],null,RenderServerUtil.DEFAULT_COLOR_COUNT,Player.SHRINKSCALE,Player.SHRINKSCALE,Player.SHRINKSCALE);
         ResourceManager.instance.requestDataPack(GHOST_M_SHRINK_RESOURCE_NAME,null,function(param1:Object, param2:Object, param3:Number):void
         {
         },null,BinaryDecodable.DEFAULT_DATAPACK,this.urlGhostMShrinked,ResourceManager.PACK_TYPE_ISOPACK,null,ResourceManager.RELEASE_NEVER);
         this.urlGhostFShrinked = param["imgfactory"] + "?" + RenderServerUtil.packageQueryString("human_f",64,BinaryDecodable.DEFAULT_DATAPACK,["body","head","ears"],[[0,0,0],[0,0,0],[0,0,0]],null,RenderServerUtil.DEFAULT_COLOR_COUNT,Player.SHRINKSCALE,Player.SHRINKSCALE,Player.SHRINKSCALE);
         ResourceManager.instance.requestDataPack(GHOST_F_SHRINK_RESOURCE_NAME,null,function(param1:Object, param2:Object, param3:Number):void
         {
         },null,BinaryDecodable.DEFAULT_DATAPACK,this.urlGhostFShrinked,ResourceManager.PACK_TYPE_ISOPACK,null,ResourceManager.RELEASE_NEVER);
         ResourceManager.instance.requestTextFile(param["property_cfg"],null,function(param1:Object, param2:String, param3:ResourceRequest):void
         {
            var config:Object = null;
            var target:Object = param1;
            var text:String = param2;
            var req:ResourceRequest = param3;
            try
            {
               config = JSON.decode(text);
               PropertyFactory.configure(config);
               return;
            }
            catch(err:Error)
            {
               return;
            }
         },function(param1:Object, param2:String, param3:ResourceRequest):void
         {
         });
         this.msgmanager = new MessageManager(stage.stageHeight - 10,stage.stageWidth);
         InteractionManager.registerForMouse(this.msgmanager,this.msgmanager.handleMouseManagerData,INTERACTION_GROUP_WIDGETS);
         this.msgmanager.x = this.msgmanager.y = 0;
         this.controlbar = new ControlBar();
         this.itemmenu = new ItemMenu();
         this.itemmenu.handleResize(stage.stageWidth,stage.stageHeight);
         InteractionManager.registerForMouse(this.itemmenu,this.handleMenu,INTERACTION_GROUP_WIDGETS);
         this.hideControls();
         this.controlbar.addEventListener(ControlsEvent.COMPOSING_START,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.COMPOSING_IDLE,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.COMPOSING_STOP,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.INPUT_COMPLETE,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.INPUT_COMPLETE,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.INV_CLICK,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.HOME_CLICK,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.METROPLAN_CLICK,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.CRAFTING_ICON_CLICK,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.HELPER_ICON_CLICK,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.SHOPPING_CLICK,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.SOUND_ACTIVATE,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.SOUND_DEACTIVATE,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.EFFECTS_ACTIVATE,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.EFFECTS_DEACTIVATE,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.OPTIONS_SHOW,this.handleControlsEvent);
         this.controlbar.addEventListener(ControlsEvent.OPTIONS_HIDE,this.handleControlsEvent);
         this.handContentTrash = new HandContentTrash();
         this.handContentTrash.x = this.controlbar.x + this.controlbar.background.width - this.handContentTrash.width;
         this.handContentTrash.y = this.controlbar.y - this.handContentTrash.height;
         this.handContentTrash.visible = false;
         this.notifyManager = new NotifyManager();
         this.notifyManager.filters = [new DropShadowFilter(2,95,0,0.75,4,4)];
         this.notifyManager.onAnyOpenCallback = function():void
         {
            JSApi.onScreenOpen;
            stage.focus = null;
         };
         this.notifyManager.onAllClosedCallback = JSApi.onScreenClose;
         this.iconDropManager = new IconDropManager();
         this.metroPlan = new MetroPlan();
         this.metroPlan.x = -this.metroPlan.width / 2;
         this.metroPlan.y = -this.metroPlan.height / 2;
         this.metroPlanContainer = new Sprite();
         this.metroPlanContainer.mouseEnabled = false;
         this.metroPlanContainer.addChild(this.metroPlan);
         InteractionManager.registerForMouse(this.metroPlan,this.metroPlan.handleMouseManagerData,INTERACTION_GROUP_WIDGETS);
         InteractionManager.disableMouseFor(this.metroPlan);
         this.metroPlan.onClose = this.metroPlanClosed;
         this.metroPlan.onGoto = this.metroPlanGoto;
         this.metroPlan.visible = false;
         this.roomBanner = new RoomBanner();
         this.roomBanner.onPrefsClick = this.roomBannerOnPrefsClick;
         this.roomBanner.onVoteClick = this.roomBannerOnVoteClick;
         this.roomBanner.onAvatarClick = this.roomBannerOnAvatarClick;
         this.roomBanner.onApartmentsButtonClick = this.roomBannerOnApartmentsButtonClick;
         InteractionManager.registerForMouse(this.roomBanner,this.roomBanner.handleMouseManagerData,INTERACTION_GROUP_WIDGETS);
         this.centeredMsgManager = new CenteredMessageManager();
         this.ffhStream = new FFHStream();
         this.showLoader();
         this.exits = new Array();
         this.spgm = new SinglePlayerGameManager(this);
         ExternalInterface.addCallback("startPlaying",this.startPlaying);
         ExternalInterface.addCallback("stopPlaying",this.stopPlaying);
         ExternalInterface.addCallback("selectFrom",this.pickTarget);
         ExternalInterface.addCallback("cancelSelectFrom",this.cancelTargetPicking);
         JSApi.writeConsole("",0,"[Client Version: " + VERSION + "]",0,"#990000");
         this.mousePointer = new MousePointer();
         this.mousePointer.onContentChange = this.__cb_mp_onContentChange;
         this.pendingIconUpdates = new Array();
         this.pendingCarriedObjects = new Dictionary();
         this.restoreSettings();
         this.client = new Client();
         this.client.addEventListener(Event.CONNECT,this.handleConnect);
         this.client.addEventListener(Event.CLOSE,this.handleClose);
         this.client.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         this.client.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
         this.client.onAutoReconnect = this.__cb_client_onAutoReconnect;
         this.connectClient();
         if(param["hasofferitems"] != null)
         {
            nitems = uint(param["hasofferitems"]);
            if(nitems > 0)
            {
               this.amfApi.call(AmfApi.GET_DAILY_OFFER,this.handleDailyOffer);
            }
         }
         this.layerManager.addLayerContent(LayerManager.LAYER_ITEM_MENU,this.itemmenu);
         this.layerManager.addLayerContent(LayerManager.LAYER_MESSAGES,this.msgmanager);
         this.layerManager.addLayerContent(LayerManager.LAYER_POPUPS,this.notifyManager);
         this.layerManager.addLayerContent(LayerManager.LAYER_CONTROLS,this.handContentTrash);
         this.layerManager.addLayerContent(LayerManager.LAYER_CONTROLS,this.controlbar);
         this.layerManager.addLayerContent(LayerManager.LAYER_MOUSE_POINTER,this.mousePointer);
         this.layerManager.addLayerContent(LayerManager.LAYER_METRO_MAP,this.metroPlanContainer);
         this.layerManager.addLayerContent(LayerManager.LAYER_CENTERED_MESSAGES,this.centeredMsgManager);
         this.layerManager.addLayerContent(LayerManager.LAYER_ROOM_BANNER,this.roomBanner);
         this.layerManager.addLayerContent(LayerManager.LAYER_ICON_DROP,this.iconDropManager);
         this.layerManager.getLayer(LayerManager.LAYER_ISO_ENGINE).doubleClickEnabled = true;
         this.layerManager.getLayer(LayerManager.LAYER_MOUSE_POINTER).mouseEnabled = false;
         this.layerManager.getLayer(LayerManager.LAYER_MOUSE_POINTER).mouseChildren = false;
         this.layerManager.getLayer(LayerManager.LAYER_ICON_DROP).mouseEnabled = false;
         this.layerManager.getLayer(LayerManager.LAYER_CENTERED_MESSAGES).mouseEnabled = false;
         this.layerManager.getLayer(LayerManager.LAYER_CENTERED_MESSAGES).mouseChildren = false;
         this.layoutGUI();
         MessageFilter.load("/filter");
      }
      
      private function startPlaying(param1:String) : void
      {
         JSApi.writeConsole(this.thisplayer.name,this.thisplayer.rights,"starts playing " + param1,1,"#3c3c3c");
         this.client.sendSetStatus(Client.STAT_KEY_PLAYING,[param1]);
      }
      
      private function stopPlaying(param1:String) : void
      {
         JSApi.writeConsole(this.thisplayer.name,this.thisplayer.rights,"stops playing " + param1,1,"#3c3c3c");
         this.client.sendDeleteStatus(Client.STAT_KEY_PLAYING);
      }
      
      private function pickTarget(param1:String, param2:Boolean, param3:Boolean, param4:Object) : void
      {
         var _loc6_:IsoDisplayObject = null;
         var _loc5_:uint = 0;
         if(param2)
         {
            _loc5_ = _loc5_ | TargetPicker.WOBID_ROOM;
         }
         if(param3)
         {
            _loc5_ = _loc5_ | TargetPicker.UVZ_FLOORED;
         }
         if(_loc5_ == 0)
         {
            return;
         }
         this.cancelTargetPicking();
         this.mousePointer.backupHandContent();
         this.mousePointer.setHandContent(param1,1,null,true);
         this.targetPicker = new TargetPicker(_loc5_,null,param4);
         if((this.targetPicker.selectionFlags & TargetPicker.UVZ_FLOORED) == TargetPicker.UVZ_FLOORED)
         {
            _loc6_ = new IsoDisplayObject(this.isoengine,16,16);
            _loc6_.displayObject = new TargetMarker();
            this.targetPicker.customPointer = _loc6_;
            this.targetPicker.customPointer.visible = false;
            _loc6_.mouseEnabled = _loc6_.mouseChildren = false;
            this.isoengine.addIsoFlatThing(_loc6_);
         }
         InteractionManager.disableMouseForGroup(INTERACTION_GROUP_EXITS);
         InteractionManager.disableMouseForGroup(INTERACTION_GROUP_WIDGETS);
      }
      
      private function cancelTargetPicking() : void
      {
         if(!this.targetPicker)
         {
            return;
         }
         this.mousePointer.restoreHandContent();
         if(this.targetPicker.customPointer)
         {
            if((this.targetPicker.selectionFlags & TargetPicker.UVZ_FLOORED) == TargetPicker.UVZ_FLOORED)
            {
               this.isoengine.removeIsoFlatThing(this.targetPicker.customPointer);
               if(this.targetPicker.customPointer.displayObject is Bitmap && (this.targetPicker.customPointer.displayObject as Bitmap).bitmapData)
               {
                  (this.targetPicker.customPointer.displayObject as Bitmap).bitmapData.dispose();
               }
            }
         }
         this.targetPicker = null;
         InteractionManager.enableMouseForGroup(INTERACTION_GROUP_EXITS);
         InteractionManager.enableMouseForGroup(INTERACTION_GROUP_WIDGETS);
      }
      
      private function showLoader() : void
      {
         this.layerManager.clearLayer(LayerManager.LAYER_LOADER_SCREEN);
         if(this.ldr)
         {
            this.ldr.removeEventListener(MyLoaderEvent.VISIBLE,this.handleLoaderState);
            this.ldr.removeEventListener(MyLoaderEvent.HIDDEN,this.handleLoaderState);
            this.ldr.cleanup();
            this.ldr = null;
         }
         this.ldr = new MyLoader(stage.stageWidth,stage.stageHeight);
         this.ldr.addEventListener(MyLoaderEvent.VISIBLE,this.handleLoaderState);
         this.ldr.addEventListener(MyLoaderEvent.HIDDEN,this.handleLoaderState);
         this.layerManager.addLayerContent(LayerManager.LAYER_LOADER_SCREEN,this.ldr);
         this.ldr.show();
      }
      
      private function handleLoaderState(param1:MyLoaderEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.type == MyLoaderEvent.VISIBLE)
         {
            this.ldr.removeEventListener(MyLoaderEvent.VISIBLE,this.handleLoaderState);
         }
         else if(param1.type == MyLoaderEvent.HIDDEN)
         {
            this.ldr.removeEventListener(MyLoaderEvent.VISIBLE,this.handleLoaderState);
            this.ldr.removeEventListener(MyLoaderEvent.HIDDEN,this.handleLoaderState);
            this.ldr.cleanup();
            this.ldr = null;
            this.layerManager.clearLayer(LayerManager.LAYER_LOADER_SCREEN);
         }
      }
      
      private function connectClient() : void
      {
         Security.loadPolicyFile("xmlsocket://" + this.host + ":843");
         this.networkJobQueue.start();
         if(this.client.connected)
         {
            this.client.disconnect();
         }
         this.client.connect(this.host,this.port);
      }
      
      private function handleClientEvent(param1:int, param2:int, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector3D = null;
         var _loc8_:Player = null;
         switch(param1)
         {
            case Client.COM_CONTEXT:
               this.networkJobQueue.addJob(new Job(this.__jobcb_com_context,[param2,param3]));
               break;
            case Client.COM_ENV:
               this.networkJobQueue.addJob(new Job(this.__jobcb_com_env,[param2,param3]));
               break;
            case Client.COM_TRANSFER:
               this.networkJobQueue.addJob(new Job(this.__jobcb_com_transfer,[param2,param3]));
               break;
            case Client.COM_CHAT:
               this.networkJobQueue.addJob(new Job(this.__jobcb_com_chat,[param2,param3]));
               break;
            case Client.COM_ACTION:
               this.networkJobQueue.addJob(new Job(this.__jobcb_com_action,[param2,param3]));
               break;
            case Client.COM_NOTIFY:
               this.networkJobQueue.addJob(new Job(this.__jobcb_com_notify,[param2,param3]));
               break;
            case Client.COM_LOGOUT:
               this.networkJobQueue.addJob(new Job(this.__jobcb_com_logout,[param3]));
               break;
            case Client.SET_HAND_HELD:
               this.networkJobQueue.addJob(new Job(this.__jobcb_hand_held,[param3]));
               break;
            case Client.CLEAR_HAND_HELD:
               this.networkJobQueue.addJob(new Job(this.__jobcb_hand_held,[param3]));
               break;
            case Client.OPEN_BUY_ITEM_VIEW:
               this.networkJobQueue.addJob(new Job(this.__jobcb_open_buy_item_view,[param3]));
               break;
            case Client.SHOW_TIMER_BAR:
               this.networkJobQueue.addJob(new Job(this.__jobcb_handle_timer_bar,[param3]));
               break;
            case Client.SHOW_ACTION_FEEDBACK:
               this.networkJobQueue.addJob(new Job(this.__jobcb_show_action_feedback,[param3]));
               break;
            case Client.COM_LOGIN:
               switch(param2)
               {
                  case 0:
                     break;
                  case 1:
               }
               break;
            case Client.SRV_OFFER_HINT:
               this.networkJobQueue.addJob(new Job(this.__jobcb_handle_hint,[Client.SRV_OFFER_HINT,param3]));
               break;
            case Client.SRV_SHOW_HINT:
               this.networkJobQueue.addJob(new Job(this.__jobcb_handle_hint,[Client.SRV_SHOW_HINT,param3]));
               break;
            case Client.CLOSE_ROOM_HOP_MENU:
               this.cleanupRoomHopPlan();
               if(this.ldr != null)
               {
                  this.ldr.hide();
               }
               if(this.centeredMsgManager != null)
               {
                  this.centeredMsgManager.removeCurrentMessage();
               }
               this.layerManager.clearLayer(LayerManager.LAYER_LOADER_SCREEN);
               break;
            case Client.OPEN_LIST_RECIPES_BY_INGREDIENT_VIEW:
               this.networkJobQueue.addJob(new Job(this.__jobcb_open_list_recipes_by_ingredient_view,[param3]));
               break;
            case Client.OPEN_CRAFT_RECIPE_VIEW:
               this.networkJobQueue.addJob(new Job(this.__jobcb_open_craft_recipe_view,[param3.recipe_id,param3.replace_item_id]));
               break;
            case Client.COM_MAY_VOTE:
               this.networkJobQueue.addJob(new Job(this.__jobcb_may_vote,[param3]));
               break;
            case Client.NOTIFY_CREDIT_ACCOUNT:
               this.networkJobQueue.addJob(new Job(this.__jobcb_notify_credit_account,[param3.credits_earned,param3.credits_bought]));
               break;
            case Client.OPEN_QUEST_VIEW:
               this.networkJobQueue.addJob(new Job(this.__jobcb_open_quest_view,[param3]));
               break;
            case Client.OPEN_QUEST_COMPLETED_VIEW:
               this.networkJobQueue.addJob(new Job(this.__jobcb_open_quest_completed_view,[param3.quest_label,param3.next_quest_label]));
               break;
            case Client.UPDATE_ROOMITEM_MENU:
               this.networkJobQueue.addJob(new Job(this.__jobcb_update_item_menu,[param3.wob_id,param3.interactions,param3.primary_interaction_label]));
         }
      }
      
      private function __jobcb_com_logout(param1:Object, param2:int, param3:int) : void
      {
         if(param1["reason"] == Client.REASON_KICKED)
         {
            this.flashCookies.setCookie(FlashCookies.KEY_KICKED,"true",new Date().valueOf() + FlashCookies.KICK_EXPIRE,true);
         }
         this.logout(param1["reason"]);
      }
      
      private function __jobcb_com_context(param1:int, param2:Cmd, param3:int, param4:int) : void
      {
         var serverData:CtxtServer = null;
         var roomData:CtxtRoom = null;
         var currentAreaName:String = null;
         var roomContextLabelOld:String = null;
         var subcommand:int = param1;
         var rawData:Cmd = param2;
         var jobAddedAt:int = param3;
         var jobProcessedAt:int = param4;
         if(subcommand == Client.CTXT_SERVER)
         {
            serverData = rawData as CtxtServer;
            this.host = serverData.host;
            this.port = serverData.port;
            this.connectClient();
         }
         else if(subcommand == Client.CTXT_ROOM)
         {
            roomData = rawData as CtxtRoom;
            this._loadComplete = false;
            if(this.levelDisplay != null)
            {
               this.layerManager.clearLayer(LayerManager.LAYER_LEVEL_PROGRESS);
               InteractionManager.removeForMouse(this.levelDisplay);
               this.levelDisplay = null;
               this.creditsDisplay = null;
            }
            if(this.activeDialog != null)
            {
               this.layerManager.clearLayer(LayerManager.LAYER_MESSAGE_DIALOG);
               WidgetManager.remove();
               WidgetManager.deactivateClickthrough();
               InteractionManager.removeForMouse(this.activeDialog);
               this.activeDialog = null;
            }
            this.hideControls();
            this.hideMetroPlan();
            currentAreaName = roomData.roomContextLabel.split(/\./)[0];
            roomContextLabelOld = !!this.room?this.room.roomContextLabel:null;
            if(this.areaName != null && currentAreaName != null && this.areaName != currentAreaName && roomData.showAnimation)
            {
               this._autowalkAnimation = new AutowalkAnimation(stage.stageWidth,stage.stageHeight,this.areaName,currentAreaName);
               this._autowalkAnimation.onDrawComplete = function():void
               {
                  layerManager.clearLayer(LayerManager.LAYER_METRO_ANIM);
                  _autowalkAnimation = null;
                  if(_loadComplete)
                  {
                     networkJobQueue.start();
                     client.sendRoomLoaded(room.gui,room.wobID);
                     JSApi.onRoomLoaded(false);
                  }
               };
               this.layerManager.addLayerContent(LayerManager.LAYER_METRO_ANIM,this._autowalkAnimation);
            }
            this.notifyManager.visible = false;
            this.notifyManager.closeOrRemoveCurrent();
            this.controlbar.universalHelper.reset();
            if(!this.ldr)
            {
               this.showLoader();
            }
            if(this.room)
            {
               this.cleanupRoom();
            }
            this.roomInited = false;
            this.areaName = currentAreaName;
            this.room = new Room(roomData.wobId);
            this.room.roomContextLabel = roomData.roomContextLabel;
            this.room.roomGui = roomData.roomGui;
            this.room.desc = roomData.desc;
            this.room.brightness = roomData.brightness;
            this.room.soundConfig = roomData.sounds;
            this.room.topic = roomData.topic;
            this.room.onBrightnessChange = this.loadRoomBackground;
            this.room.userOwnsRoom = roomData.userOwnsRoom;
            this.room.ownerUserId = roomData.ownerUserId;
            this.room.ownerUserName = roomData.ownerUserName;
            this.iconDropManager.removePendingIcons();
            this.roomBanner.reset();
            this.roomBanner.setTitle(this.room.desc);
            this.client.setRoomContextId(this.room.wobID);
            this.networkJobQueue.stop();
            this.loadRoomData();
            JSApi.onRoomUpdate(roomContextLabelOld != this.room.roomContextLabel);
         }
      }
      
      private function __jobcb_hand_held(param1:Object, param2:int, param3:int) : void
      {
         if(this.mousePointer == null)
         {
            return;
         }
         if(param1 != null)
         {
            this.mousePointer.setHandContent(param1["gui"],int(param1["count"]),param1["consumer_wobids"]);
         }
         else
         {
            this.mousePointer.removeHandContent();
         }
      }
      
      private function __jobcb_open_buy_item_view(param1:Object, param2:int, param3:int) : void
      {
         var _loc4_:uint = param1 as uint;
         if(_loc4_)
         {
            JSApi.openBuyItemView(_loc4_);
         }
      }
      
      private function __jobcb_handle_timer_bar(param1:Object, param2:int, param3:int) : void
      {
         var _loc5_:int = 0;
         var _loc4_:int = int(param1);
         if(_loc4_ == 0)
         {
            this.thisplayer.clearTimerBar();
         }
         else
         {
            _loc5_ = param3 - param2;
            if(_loc5_ < _loc4_)
            {
               this.thisplayer.setTimerBar(_loc4_ - _loc5_);
            }
         }
      }
      
      private function __jobcb_handle_hint(param1:int, param2:Object, param3:int, param4:int) : void
      {
         switch(param1)
         {
            case Client.SRV_OFFER_HINT:
               this.controlbar.universalHelper.notify(param2);
               break;
            case Client.SRV_SHOW_HINT:
               this.notifyManager.addNotify(new UniversalHelperScreen(param2 as String));
               this.controlbar.universalHelper.markAsRead();
         }
      }
      
      private function __jobcb_show_action_feedback(param1:Object, param2:int, param3:int) : void
      {
         var _loc4_:String = param1 as String;
         this.centeredMsgManager.addMessage(_loc4_);
      }
      
      private function __jobcb_open_list_recipes_by_ingredient_view(param1:uint, param2:int, param3:int) : void
      {
         JSApi.openListRecipesByIngredientItemView(param1);
      }
      
      private function __jobcb_open_craft_recipe_view(param1:int, param2:int, param3:int, param4:int) : void
      {
         JSApi.openCraftRecipeView(param1,param2);
      }
      
      private function __jobcb_may_vote(param1:MayVote, param2:int, param3:int) : void
      {
         this.roomBanner.setLikeCount(param1.voteCount,param1.mayVote);
      }
      
      private function __jobcb_notify_credit_account(param1:uint, param2:uint, param3:int, param4:int) : void
      {
         if(this.creditsDisplay == null)
         {
            this.creditsDisplay = new CreditsDisplay();
            this.creditsDisplay.onCoinsClick = JSApi.showCreditsExchange;
            this.creditsDisplay.onBillsClick = JSApi.showCreditsBillsBuy;
            InteractionManager.registerForMouse(this.creditsDisplay,this.creditsDisplay.handleMouseManagerData,INTERACTION_GROUP_WIDGETS);
            this.layerManager.addLayerContent(LayerManager.LAYER_LEVEL_PROGRESS,this.creditsDisplay);
            this.layoutGUI();
         }
         this.creditsDisplay.update(param1,param2);
         JSApi.updateCredits(param2,param1);
      }
      
      private function __jobcb_open_quest_view(param1:String, param2:int, param3:int) : void
      {
         JSApi.openQuestView(param1);
      }
      
      private function __jobcb_open_quest_completed_view(param1:String, param2:String, param3:int, param4:int) : void
      {
         JSApi.openQuestCompletedView(param1,param2);
      }
      
      private function __jobcb_update_item_menu(param1:int, param2:InteractionData, param3:String, param4:int, param5:int) : void
      {
         var _loc6_:IsoItem = WOBRegistry.instance.getObjectByWobID(param1) as IsoItem;
         _loc6_.removeInteractions();
         IsoItem.createInteractionMenu(_loc6_,param2,param3);
         this.addExamineInteraction(_loc6_);
         this.mousePointer.updateActionIcon();
      }
      
      private function loadRoomSounds() : void
      {
         var block:SoundBlock = null;
         var config:Array = this.room.soundConfig as Array;
         if(!config)
         {
            return;
         }
         for each(block in config)
         {
            block.fadeInValue = 5000;
            if(block.context != null)
            {
               ResourceManager.instance.requestSoundPack(param["medbaseurl"] + "." + block.context,block,this.handleRoomSoundLoaded,function(param1:Object, param2:ADataPack, param3:ResourceRequest):void
               {
               });
            }
            else if(ResourceManager.instance.isRegisteredResource(block["label"]))
            {
               ResourceManager.instance.requestSound(block.label,block,this.handleRoomSoundLoaded);
            }
         }
         this.room.soundConfig = null;
      }
      
      private function handleRoomSoundLoaded(param1:SoundBlock, param2:Object, param3:ResourceRequest) : void
      {
         var _loc4_:Sound = null;
         var _loc7_:SoundTrack = null;
         if(param2 is Sound)
         {
            _loc4_ = param2 as Sound;
         }
         else
         {
            _loc4_ = (param2 as ADataPack).getSound(param1.label);
         }
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:SoundConfig = Utils.getSoundConfig(param1);
         _loc5_.sound = _loc4_;
         var _loc6_:SoundLoop = new SoundLoop(_loc5_);
         if(this.room.audioTrackID < 0)
         {
            _loc7_ = new SoundTrack([_loc6_]);
            _loc7_.type = SoundTrack.SOUND_TYPE_AMB;
            this.room.audioTrackID = this.audioSystem.play(_loc7_,0,null);
         }
         else
         {
            _loc7_ = this.audioSystem.getTrack(this.room.audioTrackID);
            if(!_loc7_)
            {
               _loc7_ = new SoundTrack([_loc6_]);
               _loc7_.type = SoundTrack.SOUND_TYPE_AMB;
               this.room.audioTrackID = this.audioSystem.play(_loc7_,0,null);
            }
            else
            {
               _loc7_.addSoundLoop(_loc6_);
            }
         }
      }
      
      private function __jobcb_com_env(param1:int, param2:Object, param3:int, param4:int) : void
      {
         var list:Array = null;
         var container:IsoObjectContainer = null;
         var i:int = 0;
         var exit:Exit = null;
         var userData:EnvUser = null;
         var userIds:Array = null;
         var p:Player = null;
         var itemListData:EnvItem = null;
         var item:IsoItem = null;
         var miscData:EnvMisc = null;
         var wob:IsoObjectContainer = null;
         var playerData:IAvatarData = null;
         var itemInteraction:ItemInteraction = null;
         var itemData:ItemData = null;
         var request:ResourceRequest = null;
         var wobIds:Array = null;
         var subcommand:int = param1;
         var rawData:Object = param2;
         var jobAddedAt:int = param3;
         var jobProcessedAt:int = param4;
         var jobDelay:uint = 0;
         if(jobProcessedAt > jobAddedAt)
         {
            jobDelay = jobProcessedAt - jobAddedAt;
         }
         switch(subcommand)
         {
            case Client.ENV_EXIT:
               this.removeExits();
               list = rawData["exits"];
               i = 0;
               while(i < list.length)
               {
                  exit = new Exit(this.isoengine,list[i]["polygon"],list[i]["z"],list[i]["dir"],list[i]["gui"]);
                  InteractionManager.registerForMouse(exit,this.handleExitMouseData,INTERACTION_GROUP_EXITS);
                  this.isoengine.addIsoFlatThing(exit);
                  this.exits.push(exit);
                  i++;
               }
               break;
            case Client.ENV_USER:
               userData = rawData as EnvUser;
               userIds = new Array();
               for each(playerData in userData.getData())
               {
                  if(WOBRegistry.instance.getPlayerByWobId(int(playerData.wobId)) == null)
                  {
                     p = Player.createFromData(playerData);
                     p.isGhost = true;
                     p.onPropertiesChange = this.handleWOBPropertiesChanged;
                     if(p.name == param["username"])
                     {
                        this.thisplayer = p;
                        this.audioSystem.updateListenerLocation(p.isoobj.uvz);
                     }
                     itemInteraction = new ItemInteraction("SHOW_PROFILE",LocaleStrings.MENU_SHOW_PROFILE,ItemInteraction.TYPE_PRIMARY);
                     itemInteraction.callback = function(param1:Client, param2:ISelectable, param3:ItemInteraction, param4:Array = null):void
                     {
                        JSApi.showUser(param2.name);
                     };
                     p.interactions.push(itemInteraction);
                     WOBRegistry.instance.add(p);
                     this.updateWorldObjectData(playerData,true,jobDelay);
                     this.initWorldObjectStates(p,playerData.status as Array);
                     this.setPlayerGhostData(p);
                     userIds.push(p.userid);
                  }
               }
               this.requestRenderParts(userIds);
               break;
            case Client.ENV_ITEM:
               itemListData = rawData as EnvItem;
               if(!itemListData.add)
               {
                  this.removeItems();
               }
               list = itemListData.getData();
               if(!list || list.length == 0)
               {
                  break;
               }
               this.isoengine.enableGrouping = false;
               for each(itemData in list)
               {
                  item = WOBRegistry.instance.getObjectByWobID(itemData.wobId) as IsoItem;
                  if(item == null)
                  {
                     item = IsoItem.createFromData(itemData);
                     this.addExamineInteraction(item);
                     item.onPropertiesChange = this.handleWOBPropertiesChanged;
                     item.nstickies = 0;
                     WOBRegistry.instance.add(item);
                     this.updateWorldObjectData(itemData,true,jobDelay);
                     this.initWorldObjectStates(item,itemData.status);
                     if(!itemData.animation || !itemData.animation.datapack)
                     {
                        this.itemsToLoad++;
                        request = ResourceManager.instance.requestIsoItem(item,this.isoObjectLoaded);
                        if(request)
                        {
                           item.lastRequest = null;
                        }
                     }
                  }
               }
               if(this.itemsToLoad == 0)
               {
                  this.isoengine.enableGrouping = true;
               }
               this.amfApi.call(AmfApi.GET_STICKY_COUNT,this.handleStickyCount,null,WOBRegistry.instance.getWobIds());
               break;
            case Client.ENV_MISC:
               miscData = rawData as EnvMisc;
               this.room.soundConfig = miscData.sounds;
               this.loadRoomSounds();
               break;
            case Client.ENV_STAT:
               wob = WOBRegistry.instance.getObjectByWobID(int(rawData["wobid"]));
               if(!wob)
               {
                  return;
               }
               this.updateWorldObjectState(wob,int(rawData["status"]),rawData["value"],int(rawData["set"]) == 1);
               break;
            case Client.ENV_BRIGHTNESS:
               this.room.brightness = int(rawData["brightness"]);
               break;
            case Client.ENV_REMOVE_ITEMS:
               if(rawData["removeall"])
               {
                  this.removeItems();
               }
               else
               {
                  wobIds = rawData["wobids"] as Array;
                  i = 0;
                  while(i < wobIds.length)
                  {
                     container = WOBRegistry.instance.getObjectByWobID(wobIds[i]);
                     if(container)
                     {
                        WOBRegistry.instance.remove(container);
                        this.cleanupIsoObjectContainer(container);
                     }
                     i++;
                  }
               }
               break;
            case Client.ENV_ROOM_TOPIC:
               this.room.topic = rawData["topic"];
               this.roomBanner.setTopic(this.room.topic);
               break;
            case Client.ENV_WOB_PROPERTIES:
               container = WOBRegistry.instance.getObjectByWobID(int(rawData["wob_id"]));
               if(container != null)
               {
                  container.properties = PropertyFactory.createPropertyList(rawData["prop_map"]);
               }
         }
      }
      
      private function addExamineInteraction(param1:IsoItem) : void
      {
         var item:IsoItem = param1;
         var itemInteraction:ItemInteraction = new ItemInteraction("DETAILS",LocaleStrings.MENU_SHOW_DETAILS,ItemInteraction.TYPE_SECONDARY);
         itemInteraction.callback = function(param1:Client, param2:ISelectable, param3:ItemInteraction, param4:int):void
         {
            JSApi.showRoomItem(param2.wobId);
         };
         item.interactions.push(itemInteraction);
      }
      
      private function updateRoomBanner() : void
      {
         if(this.room.ownerUserId > 0)
         {
            this.roomBanner.setOwner(this.room.ownerUserName,this.room.userOwnsRoom);
            this.roomBanner.setTopic(this.room.topic);
            this.requestAvatarUpdate();
         }
      }
      
      private function requestAvatarUpdate() : void
      {
         this.amfApi.call(AmfApi.GET_RENDER_PARTS,this.handleRenderParts,null,[this.room.ownerUserId]);
      }
      
      private function updateRoomBannerPosition() : void
      {
         this.roomBanner.x = stage.stageWidth / 2;
         this.roomBanner.y = !!this.levelDisplay?Number(this.levelDisplay.y + this.levelDisplay.height):Number(7);
      }
      
      private function roomBannerOnPrefsClick() : void
      {
         if(!this.room.userOwnsRoom)
         {
            return;
         }
         JSApi.showHomeConfig(this.room.roomContextLabel);
      }
      
      private function roomBannerOnVoteClick() : void
      {
         this.client.sendVote();
      }
      
      private function roomBannerOnAvatarClick(param1:String) : void
      {
         JSApi.showUser(param1);
      }
      
      private function roomBannerOnApartmentsButtonClick() : void
      {
         JSApi.showApartments(this.room.roomContextLabel);
      }
      
      private function __jobcb_com_transfer(param1:int, param2:Cmd, param3:int, param4:int) : void
      {
         var player:Player = null;
         var joinData:TrRoomJoin = null;
         var leaveData:TrRoomLeave = null;
         var id:int = 0;
         var itemInteraction:ItemInteraction = null;
         var subcommand:int = param1;
         var rawData:Cmd = param2;
         var jobAddedAt:int = param3;
         var jobProcessedAt:int = param4;
         var jobDelay:uint = 0;
         if(jobProcessedAt > jobAddedAt)
         {
            jobDelay = jobProcessedAt - jobAddedAt;
         }
         switch(subcommand)
         {
            case Client.TR_ROOM_JOIN:
               joinData = rawData as TrRoomJoin;
               player = WOBRegistry.instance.getPlayerByWobId(joinData.wobId);
               if(!player)
               {
                  player = Player.createFromData(joinData);
                  WOBRegistry.instance.add(player);
                  player.isGhost = true;
                  player.onPropertiesChange = this.handleWOBPropertiesChanged;
                  itemInteraction = new ItemInteraction("SHOW_PROFILE",LocaleStrings.MENU_SHOW_PROFILE,ItemInteraction.TYPE_PRIMARY);
                  itemInteraction.callback = function(param1:Client, param2:ISelectable, param3:ItemInteraction, param4:Array = null):void
                  {
                     JSApi.showUser(param2.name);
                  };
                  player.interactions.push(itemInteraction);
               }
               this.updateWorldObjectData(joinData,true,jobDelay);
               this.initWorldObjectStates(player,joinData.status);
               this.requestRenderParts([player.userid]);
               if(player.isGhost)
               {
                  this.setPlayerGhostData(player);
               }
               break;
            case Client.TR_ROOM_LEAVE:
               leaveData = rawData as TrRoomLeave;
               id = int(leaveData.wobId);
               player = WOBRegistry.instance.getPlayerByWobId(leaveData.wobId);
               if(player == null)
               {
                  break;
               }
               ResourceManager.instance.increaseDataPackContainerAge(1,player.isoobj.media);
               this.removePlayer(leaveData.wobId);
               break;
         }
      }
      
      private function handleDailyOffer(param1:*) : void
      {
         var _loc3_:ShopItem = null;
         var _loc8_:Array = null;
         var _loc9_:* = null;
         var _loc2_:Array = new Array();
         var _loc4_:Date = new Date();
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeUTF(param["username"]);
         _loc5_.writeShort(_loc4_.getFullYear());
         _loc5_.writeShort(_loc4_.getMonth());
         _loc5_.writeShort(_loc4_.getDate());
         var _loc6_:String = MD5.hashBytes(_loc5_);
         var _loc7_:String = this.flashCookies.getCookie(FlashCookies.KEY_ITEMS_SEEN_KEY) as String;
         if(_loc7_ != null)
         {
            if(_loc7_ == _loc6_)
            {
               _loc8_ = this.flashCookies.getCookie(FlashCookies.KEY_ITEMS_SEEN) as Array;
            }
            else
            {
               this.flashCookies.removeCookie(FlashCookies.KEY_ITEMS_SEEN);
               this.flashCookies.removeCookie(FlashCookies.KEY_ITEMS_SEEN_KEY);
               this.flashCookies.flush();
            }
         }
         else
         {
            _loc8_ = this.flashCookies.getCookie(FlashCookies.KEY_ITEMS_SEEN) as Array;
         }
         if(_loc8_ == null)
         {
            _loc8_ = new Array();
         }
         for(_loc9_ in param1)
         {
            if(_loc9_ != null)
            {
               _loc3_ = ShopItem.createFromData(_loc9_,param1[_loc9_]);
               if(_loc3_ != null)
               {
                  if(_loc8_.indexOf(_loc3_.label) == -1)
                  {
                     _loc8_.push(_loc3_.label);
                     _loc2_.push(_loc3_);
                  }
               }
            }
         }
         if(_loc8_.length > 0)
         {
            this.flashCookies.setCookie(FlashCookies.KEY_ITEMS_SEEN,_loc8_);
            this.flashCookies.setCookie(FlashCookies.KEY_ITEMS_SEEN_KEY,_loc6_);
            this.flashCookies.flush();
         }
         if(_loc2_.length > 0 && !this.notifyManager.hasNotifyForClass("newShopItems"))
         {
            this.notifyManager.addNotify(new NewShopItemsScreen(_loc2_),new IconNew(),"newShopItems",0);
         }
      }
      
      private function handleStickyCount(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:IsoObjectContainer = null;
         if(!(param1 is Object))
         {
            return;
         }
         for(_loc2_ in param1)
         {
            _loc3_ = WOBRegistry.instance.getObjectByWobID(int(_loc2_));
            _loc3_.nstickies = int(param1[_loc2_]);
         }
      }
      
      private function __jobcb_com_chat(param1:int, param2:Cmd, param3:int, param4:int) : void
      {
         var chatUsrData:ChatUsr = null;
         var msgSender:IsoObjectContainer = null;
         var screenrect:Rectangle = null;
         var start:Point = null;
         var srvData:ChatSrv = null;
         var screenBounds:Rectangle = null;
         var tb:TextBar = null;
         var wobId:int = 0;
         var player:Player = null;
         var cls:Class = null;
         var emo:Sprite = null;
         var messageLocation:Point = null;
         var subcommand:int = param1;
         var rawData:Cmd = param2;
         var jobAddedAt:int = param3;
         var jobProcessedAt:int = param4;
         switch(subcommand)
         {
            case Client.CHAT_USR:
               chatUsrData = rawData as ChatUsr;
               msgSender = WOBRegistry.instance.getObjectByWobID(int(chatUsrData.wobId));
               if(!msgSender)
               {
                  return;
               }
               screenrect = this.isoengine.screenrect;
               if(msgSender.isoobj.sprite.isAdded)
               {
                  screenBounds = msgSender.isoobj.sprite.bounds.clone();
                  screenBounds.width = screenBounds.width * (msgSender.isoobj.sprite.isoparent as Sprite).scaleX;
                  screenBounds.height = screenBounds.height * (msgSender.isoobj.sprite.isoparent as Sprite).scaleY;
                  start = msgSender.isoobj.sprite.parent.localToGlobal(screenBounds.topLeft);
               }
               else
               {
                  start = new Point(0,screenrect.bottom);
               }
               switch(chatUsrData.type)
               {
                  case 0:
                     tb = new TextBar(msgSender,new FormattedMessage(StringUtil.normalizeCase(chatUsrData.message)),TextBar.MSG_USR,chatUsrData.mode);
                     if(msgSender.isoobj.sprite.isAdded)
                     {
                        start.x = start.x + (screenBounds.width - tb.width) / 2;
                     }
                     start.y = start.y - tb.height;
                     wobId = int(chatUsrData.wobId);
                     player = WOBRegistry.instance.getPlayerByWobId(wobId);
                     this.msgmanager.addMessage(0,msgSender,this.areaName + "/" + this.room.gui,tb,start,MessageManager.MODE_NORMAL,chatUsrData.overheard,function(param1:MouseManagerData, ... rest):void
                     {
                        var _loc3_:Player = null;
                        var _loc5_:RegExp = null;
                        var _loc6_:* = undefined;
                        var _loc7_:* = undefined;
                        var _loc8_:* = undefined;
                        var _loc4_:MessageContainer = param1.target as MessageContainer;
                        if(param1.type == MouseManagerData.CLICK)
                        {
                           JSApi.showUser(player.name);
                           _loc3_ = WOBRegistry.instance.getPlayerByWobId(wobId);
                           _loc5_ = /https?\:\/\/(www\.youtube\.com\/watch\?.*v=|youtu.be\/)([0-9a-z-_]*)/i;
                           if(_loc5_.test(chatUsrData.message))
                           {
                              _loc6_ = _loc5_.exec(chatUsrData.message)[2];
                              _loc7_ = "https://youtu.be/" + _loc6_;
                              _loc8_ = "freggersyoutube";
                              JSApi.openWindow(_loc7_,_loc8_);
                           }
                           if(_loc3_ != null)
                           {
                              addLocatorArrow(_loc3_.isoobj);
                           }
                        }
                        else if(param1.type == MouseManagerData.MOUSE_DOWN_AND_HOLD)
                        {
                           select(_loc4_);
                        }
                     },{
                        "interactions":player.interactions.slice(),
                        "name":player.name,
                        "wobId":player.wobId,
                        "icon":player.icon
                     });
                     JSApi.writeConsole(msgSender.name,msgSender is Player?uint((msgSender as Player).rights):uint(0),chatUsrData.message.replace("\\","\\\\"),chatUsrData.type,"#3c3c3c",!!chatUsrData.overheard?"#cecee8":"");
                     break;
                  case 1:
                     if(msgSender.isoobj.sprite.isAdded)
                     {
                        cls = smileys["Sml_" + chatUsrData.message];
                        emo = new cls();
                        emo.filters = [new DropShadowFilter(3,90,0,0.75,4,4,1,1)];
                        start.x = start.x + (screenBounds.width - emo.width) / 2;
                        this.msgmanager.addMessage(0,msgSender,this.areaName + "/" + this.room.gui,emo,start,MessageManager.MODE_EMOTICON,false);
                     }
               }
               break;
            case Client.CHAT_SRV:
               srvData = rawData as ChatSrv;
               if(this.room != null)
               {
                  if(!this.isoengine)
                  {
                     messageLocation = new Point(stage.stageWidth / 2,stage.stageHeight);
                  }
                  else
                  {
                     messageLocation = new Point(this.isoengine.screenrect.width / 2,this.isoengine.screenrect.height);
                  }
                  tb = new TextBar(null,new FormattedMessage(srvData.message),TextBar.MSG_SRV);
                  this.msgmanager.addMessage(0,null,this.areaName + "/" + this.room.gui,tb,messageLocation,MessageManager.MODE_NORMAL,false);
               }
               JSApi.writeConsole("",0,"[" + srvData.message + "]",0,"#3c3c3c");
         }
      }
      
      private function __jobcb_com_action(param1:int, param2:Object, param3:int, param4:int) : void
      {
         var updateData:ActionUpdateWob = null;
         var throwData:ActionThrow = null;
         var sourcelocation:Vector3D = null;
         var targetlocation:Vector3D = null;
         var ioc:IsoObjectContainer = null;
         var endeffectData:EffectData = null;
         var subcommand:int = param1;
         var rawData:Object = param2;
         var jobAddedAt:int = param3;
         var jobProcessedAt:int = param4;
         var jobDelay:uint = 0;
         if(jobProcessedAt > jobAddedAt)
         {
            jobDelay = jobProcessedAt - jobAddedAt;
         }
         switch(subcommand)
         {
            case Client.ACTION_SHOW_METROMAP:
               this.initMetroPlan(rawData as Array);
               this.showMetroPlan();
               break;
            case Client.ACTION_ROOM_HOP:
               this.hideMetroPlan();
               this.cleanupRoomHopPlan();
               this.roomHopPlan = new RoomHopPlan(this.areaName,rawData["hop room label"],rawData["exits"],new Point(stage.stageWidth,stage.stageHeight));
               this.roomHopPlan.onRoomHop = this.handleRoomHopSelection;
               this.roomHopPlan.onInitComplete = function():void
               {
                  layoutGUI();
               };
               this.roomHopPlan.onInitFailed = function():void
               {
                  cleanupRoomHopPlan();
               };
               this.roomHopPlan.onClose = this.cleanupRoomHopPlan;
               this.layerManager.addLayerContent(LayerManager.LAYER_ROOM_HOP_MAP,this.roomHopPlan);
               this.roomHopPlan.requestRoomData();
               InteractionManager.disableMouseForAll(true);
               break;
            case Client.ACTION_SPGAME:
               if(rawData["label"])
               {
                  JSApi.openGame(rawData["label"]);
               }
               break;
            case Client.ACTION_UPDATE_WOB:
               updateData = rawData as ActionUpdateWob;
               this.updateWorldObjectData(updateData,false,jobDelay);
               break;
            case Client.ACTION_OPEN_LOCKER:
               JSApi.showLocker(int(rawData["userid"]));
               break;
            case Client.ACTION_OPEN_SHOP:
               JSApi.showShop(int(rawData["shopid"]));
               break;
            case Client.ACTION_OPEN_APARTMENT_LIST:
               this.cleanupRoomHopPlan();
               JSApi.showApartments(rawData["label"]);
               break;
            case Client.ACTION_THROW:
               throwData = rawData as ActionThrow;
               sourcelocation = throwData.sourceAsVector3D();
               targetlocation = throwData.targetAsVector3D();
               if(sourcelocation == null)
               {
                  ioc = WOBRegistry.instance.getObjectByWobID(throwData.sourceAsInt());
                  if(ioc)
                  {
                     sourcelocation = ioc.isoobj.uvz.clone();
                     sourcelocation.z = ioc.isoobj.sprite.isoZ + ioc.isoobj.sprite.totalheight + 5;
                  }
               }
               if(targetlocation == null)
               {
                  ioc = WOBRegistry.instance.getObjectByWobID(throwData.targetAsInt());
                  if(ioc)
                  {
                     targetlocation = ioc.isoobj.uvz.clone();
                     targetlocation.z = ioc.isoobj.sprite.isoZ + ioc.isoobj.sprite.totalheight + 5;
                  }
               }
               if(sourcelocation && targetlocation && throwData.height && throwData.duration && throwData.gui)
               {
                  endeffectData = EffectData.fromNetEffectData(throwData.endEffectData);
                  this.throwItem(sourcelocation,targetlocation,throwData.height,throwData.duration,throwData.gui,throwData.ghosttrailData,endeffectData);
               }
         }
      }
      
      private function __jobcb_com_notify(param1:int, param2:Object, param3:int, param4:int) : void
      {
         var messageLocation:Point = null;
         var msg:String = null;
         var guiArray:Array = null;
         var url:String = null;
         var itemContainerId:int = 0;
         var INVENTORY_NOTIFY_TIMER_DELAY:Number = NaN;
         var coinsDelta:int = 0;
         var billsDelta:int = 0;
         var showMessage:Boolean = false;
         var source:Point = null;
         var target:Point = null;
         var dob:Sprite = null;
         var bigcoins:int = 0;
         var smallcoins:int = 0;
         var i:int = 0;
         var dobs:Array = null;
         var container:IsoObjectContainer = null;
         var itemcnt:IsoObjectContainer = null;
         var messageText:String = null;
         var receivedXp:uint = 0;
         var tb:TextBar = null;
         var bounds:Rectangle = null;
         var player:Player = null;
         var subcommand:int = param1;
         var data:Object = param2;
         var jobAddedAt:int = param3;
         var jobProcessedAt:int = param4;
         if(!this.isoengine)
         {
            messageLocation = new Point(stage.stageWidth / 2,stage.stageHeight);
         }
         else
         {
            messageLocation = new Point(this.isoengine.screenrect.width / 2,this.isoengine.screenrect.height);
         }
         switch(subcommand)
         {
            case Client.NOTIFY_ONL_STAT:
               switch(data["status"])
               {
                  case 0:
                     break;
                  case 1:
                     msg = StringUtil.formattedString(LocaleStrings.MSG_USER_NOWOFFLINE,[data["username"]]);
                     JSApi.writeConsole(data["username"],0,StringUtil.formattedString(LocaleStrings.MSG_USER_NOWOFFLINE,[""]),1,"#3c3c3c");
                     break;
                  case 2:
                     msg = StringUtil.formattedString(LocaleStrings.MSG_USER_NOWONLINE,[data["username"]]);
                     JSApi.writeConsole(data["username"],0,StringUtil.formattedString(LocaleStrings.MSG_USER_NOWONLINE,[""]),1,"#3c3c3c");
                     break;
                  case 3:
                     msg = StringUtil.formattedString(LocaleStrings.MSG_USER_AWAY,[data["username"]]);
                     JSApi.writeConsole(data["username"],0,StringUtil.formattedString(LocaleStrings.MSG_USER_AWAY,[""]),1,"#3c3c3c");
                     break;
                  case 4:
                     msg = StringUtil.formattedString(LocaleStrings.MSG_USER_RETURNED,[data["username"]]);
                     JSApi.writeConsole(data["username"],0,StringUtil.formattedString(LocaleStrings.MSG_USER_RETURNED,[""]),1,"#3c3c3c");
               }
               if(msg)
               {
                  tb = new TextBar(null,new FormattedMessage(msg),TextBar.MSG_SRV);
                  this.msgmanager.addMessage(0,null,this.areaName + "/" + this.room.gui,tb,messageLocation,MessageManager.MODE_NORMAL,false,function(param1:MouseManagerData):void
                  {
                     if(param1.type == MouseManagerData.CLICK)
                     {
                        JSApi.showUser(data["username"]);
                     }
                  });
               }
               JSApi.updateFriendStatus(data["userid"],data["status"]);
               break;
            case Client.NOTIFY_CREATE_ITEM:
               guiArray = (data["gui"] as String).split(":");
               if(guiArray.length > 1)
               {
                  url = "/img/" + data["template_id"] + "/" + data["dir"] + "/" + "item_drop.png?v=" + param["v"];
               }
               else
               {
                  url = ResourceManager.instance.getPortableItemUrl(data["gui"],"_l");
               }
               if(url != null)
               {
                  ResourceManager.instance.requestImageData(url,null,this.__cb_itemDropIconLoaded,this.__cb_itemDropIconLoadingFailed);
               }
               break;
            case Client.NOTIFY_INVENTORY:
               itemContainerId = data["item_container_id"];
               INVENTORY_NOTIFY_TIMER_DELAY = 300;
               if(!this.inventoryNotifyTimers[itemContainerId])
               {
                  this.inventoryNotifyTimers[itemContainerId] = new Timer(INVENTORY_NOTIFY_TIMER_DELAY,1);
                  this.inventoryNotifyTimers[itemContainerId].addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):void
                  {
                     JSApi.updateStuff(itemContainerId);
                  });
               }
               this.inventoryNotifyTimers[itemContainerId].stop();
               this.inventoryNotifyTimers[itemContainerId].reset();
               this.inventoryNotifyTimers[itemContainerId].start();
               break;
            case Client.NOTIFY_COINS_OR_BILLS:
               coinsDelta = int(data["coins_delta"]);
               billsDelta = int(data["bills_delta"]);
               showMessage = data["show_message"];
               if(showMessage)
               {
                  if(billsDelta > 0)
                  {
                     msg = StringUtil.formattedString(LocaleStrings.MSG_BILLS_RECEIVED,[billsDelta]);
                  }
                  else
                  {
                     msg = StringUtil.formattedString(LocaleStrings.MSG_COINS_FREE,[coinsDelta]);
                  }
                  tb = new TextBar(null,new FormattedMessage(msg),TextBar.MSG_SRV);
                  this.msgmanager.addMessage(0,null,this.areaName + "/" + this.room.gui,tb,messageLocation,MessageManager.MODE_NORMAL,false,function(param1:MouseManagerData):void
                  {
                     if(param1.type == MouseManagerData.CLICK)
                     {
                        if(billsDelta > 0)
                        {
                           JSApi.showCreditsBillsBuy();
                        }
                        else
                        {
                           JSApi.showCreditsExchange();
                        }
                     }
                  });
                  JSApi.writeConsole("",0,"[" + msg + "]",0,"#3c3c3c");
               }
               if(billsDelta > 0)
               {
                  return;
               }
               if(this.thisplayer != null)
               {
                  bounds = this.thisplayer.isoobj.sprite.getBounds(this.iconDropManager);
                  source = new Point(bounds.x + bounds.width / 2,bounds.y);
                  target = new Point(bounds.x + bounds.width / 2,bounds.y + bounds.height);
               }
               else
               {
                  source = this.iconDropManager.iconDropLayer.globalToLocal(new Point(stage.stageWidth / 2,stage.stageHeight / 3));
                  target = new Point(source.x,source.y + stage.stageHeight / 3);
               }
               bigcoins = coinsDelta / 5;
               smallcoins = coinsDelta - bigcoins * 5;
               i = 0;
               dobs = new Array();
               i = 0;
               while(i < bigcoins)
               {
                  dob = new IconDropMoreCoins();
                  dob.buttonMode = true;
                  dobs.push(dob);
                  i++;
               }
               i = 0;
               while(i < smallcoins)
               {
                  dob = new IconDropCoin();
                  dob.buttonMode = true;
                  dobs.push(dob);
                  i++;
               }
               for each(dob in dobs)
               {
                  dob.filters = [new GlowFilter(0,0.75,4,4,2)];
                  this.iconDropManager.addIconDropSprite(dob,source,target,this.creditsDisplay.coinsTarget,IconDropSprite.MOVEMENT_DIRECT);
               }
               break;
            case Client.NOTIFY_STREAM:
               JSApi.updateStream();
               break;
            case Client.NOTIFY_MAIL:
               msg = data["body"];
               if(msg != "")
               {
                  tb = new TextBar(null,new FormattedMessage(msg),TextBar.MSG_SRV);
                  this.msgmanager.addMessage(0,null,this.areaName + "/" + this.room.gui,tb,messageLocation,MessageManager.MODE_NORMAL,false,function(param1:MouseManagerData):void
                  {
                     if(param1.type == MouseManagerData.CLICK)
                     {
                        JSApi.showMails(data["userid"]);
                     }
                  });
                  JSApi.writeConsole("",0,"[" + msg + "]",0,"#3c3c3c");
               }
               JSApi.updateMails(data["userid"]);
               break;
            case Client.NOTIFY_ITEMUPDATE:
               container = WOBRegistry.instance.getObjectByWobID(int(data["wobid"]));
               if(container)
               {
                  if(container is Player)
                  {
                     player = container as Player;
                     this.requestRenderParts([player.userid]);
                     JSApi.updatePlayer(player.userid,data["wobid"]);
                  }
               }
               break;
            case Client.NOTIFY_STICKIES:
               itemcnt = WOBRegistry.instance.getObjectByWobID(int(data["wobid"]));
               if(itemcnt)
               {
                  itemcnt.nstickies = int(data["total"]);
               }
               break;
            case Client.NOTIFY_BADGE:
               messageText = data["message"];
               if(messageText != null)
               {
                  tb = new TextBar(null,new FormattedMessage(messageText),TextBar.MSG_SRV);
                  this.msgmanager.addMessage(0,null,null,tb,messageLocation,MessageManager.MODE_NORMAL,false,function(param1:MouseManagerData):void
                  {
                     if(param1.type == MouseManagerData.CLICK)
                     {
                        JSApi.showBadge(data["userid"],data["badgeid"]);
                     }
                  });
               }
               JSApi.updateBadge(data["userid"],data["badgeid"],data["stepComplete"]);
               break;
            case Client.NOTIFY_ITEM_INBOX:
               tb = new TextBar(null,new FormattedMessage(LocaleStrings.MSG_ITEM_IN_QUEUE,[],[FormattedMessage.STYLE_BOLD]),TextBar.MSG_SRV);
               this.msgmanager.addMessage(0,null,this.areaName + "/" + this.room.gui,tb,messageLocation,MessageManager.MODE_NORMAL,false,function(param1:MouseManagerData):void
               {
                  if(param1.type == MouseManagerData.CLICK)
                  {
                     JSApi.showStuff();
                  }
               });
               if(this.controlbar != null)
               {
               }
               JSApi.updateItemInbox();
               break;
            case Client.NOTIFY_MODEL_UPDATE:
               JSApi.onModelUpdate();
               break;
            case Client.NOTIFY_LEVEL:
               if(this.debugger != null)
               {
                  this.debugger.postMessage("Level notify: \'level\' = " + data["level"] + " \'xp until next level\' = " + data["xp_total"] + " \'current xp\' = " + data["xp_current"] + " \'xp cap\' = " + data["xp_cap"] + " \'xp delta\' = " + data["xp_delta"]);
               }
               if(this.levelDisplay == null)
               {
                  this.levelDisplay = new LevelDisplay();
                  this.levelDisplay.onClickCallback = JSApi.openLevelUpInfoScreen;
                  InteractionManager.registerForMouse(this.levelDisplay,this.levelDisplay.handleMouseManagerData);
                  this.layerManager.addLayerContent(LayerManager.LAYER_LEVEL_PROGRESS,this.levelDisplay);
                  this.layoutGUI();
               }
               receivedXp = data["xp_delta"];
               if(this.levelDisplay && this.levelDisplay.levelProgress && receivedXp > 0)
               {
                  this.dropIcons(receivedXp);
               }
               this.levelDisplay.update(new UserLevelProgress(int(data["level"]),int(data["xp_total"]),int(data["xp_current"]),int(data["xp_cap"])));
         }
      }
      
      private function dropIcons(param1:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc7_:Sprite = null;
         var _loc2_:uint = 20;
         _loc3_ = 100;
         var _loc4_:int = param1 / _loc3_;
         var _loc5_:int = (param1 - _loc4_ * _loc3_) / _loc2_;
         if(_loc5_ == 0 && _loc4_ == 0)
         {
            _loc5_ = 1;
         }
         var _loc6_:int = 0;
         var _loc8_:Array = new Array();
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = new IconDropMoreXp();
            _loc7_.buttonMode = true;
            _loc8_.push(_loc7_);
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = new IconDropXp();
            _loc7_.buttonMode = true;
            _loc8_.push(_loc7_);
            _loc6_++;
         }
         var _loc9_:Rectangle = this.thisplayer.isoobj.sprite.getBounds(this.iconDropManager);
         for each(_loc7_ in _loc8_)
         {
            _loc7_.filters = [new GlowFilter(0,0.75,4,4,2)];
            this.iconDropManager.addIconDropSprite(_loc7_,new Point(_loc9_.x + _loc9_.width / 2,_loc9_.y),new Point(_loc9_.x + _loc9_.width / 2,_loc9_.y + _loc9_.height),this.levelDisplay.progressBarTip,IconDropSprite.MOVEMENT_DIRECT);
         }
      }
      
      private function __cb_itemDropIconLoaded(param1:Object, param2:BABitmapDataContainer, param3:ResourceRequest) : void
      {
         var _loc7_:BitmapData = null;
         if(this.thisplayer == null)
         {
            return;
         }
         var _loc4_:Rectangle = this.thisplayer.isoobj.sprite.getBounds(this.iconDropManager);
         var _loc5_:BitmapData = BitmapDataUtils.crop(param2.bitmapData);
         if(_loc5_.width > 64 || _loc5_.height > 64)
         {
            _loc7_ = _loc5_;
            _loc5_ = BitmapDataUtils.scaleToSize(param2.bitmapData,64,64,true);
            _loc7_.dispose();
         }
         param2.bitmapData.dispose();
         var _loc6_:ShapedBitmap = new ShapedBitmap(_loc5_);
         _loc6_.buttonMode = true;
         _loc6_.filters = [IconDropSprite.OUTLINE];
         this.iconDropManager.addIconDropSprite(_loc6_,new Point(_loc4_.x + _loc4_.width / 2,_loc4_.y),new Point(_loc4_.x + _loc4_.width / 2,_loc4_.y + _loc4_.height),this.controlbar.icons.bag,IconDropSprite.MOVEMENT_BOUNCE);
      }
      
      private function __cb_itemDropIconLoadingFailed(param1:Object, param2:BABitmapDataContainer, param3:ResourceRequest) : void
      {
      }
      
      private function handleRoomHopSelection(param1:String) : void
      {
         this.client.sendRoomHopCommand(param1);
         this.roomHopPlan.cleanup();
      }
      
      private function removeExits() : void
      {
         var _loc1_:Exit = null;
         for each(_loc1_ in this.exits)
         {
            this.isoengine.removeIsoFlatThing(_loc1_);
            InteractionManager.removeForMouse(_loc1_);
         }
         this.exits.length = 0;
      }
      
      private function removeItems() : void
      {
         var _loc1_:IsoItem = null;
         var _loc2_:Array = WOBRegistry.instance.getIsoItems();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_])
            {
               _loc1_ = _loc2_[_loc3_] as IsoItem;
               this.cleanupIsoObjectContainer(_loc1_);
               WOBRegistry.instance.remove(_loc1_);
            }
            _loc3_++;
         }
      }
      
      private function removePlayer(param1:int) : void
      {
         var _loc2_:Player = WOBRegistry.instance.getPlayerByWobId(param1);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = this.pendingIconUpdates.indexOf(_loc2_);
         if(_loc3_ >= 0)
         {
            this.pendingIconUpdates.splice(_loc3_,1);
         }
         WOBRegistry.instance.remove(_loc2_);
         if(_loc2_ == this.thisplayer)
         {
            this.thisplayer = null;
         }
         this.cleanupIsoObjectContainer(_loc2_);
      }
      
      private function cleanupIsoObjectContainer(param1:IsoObjectContainer) : void
      {
         if(!param1)
         {
            return;
         }
         InteractionManager.removeForMouse(param1.isoobj.sprite.content as IsoObjectSpriteContent);
         if(this.tooltipManager != null && this.tooltipManager.target == param1)
         {
            this.tooltipManager.target = null;
         }
         var _loc2_:CompositeAnimation = this.animationmanager.getCompositeAnimation(param1.isoobj);
         if(_loc2_ != null)
         {
            this.animationmanager.remove(_loc2_);
         }
         if(!isNaN(param1.soundID))
         {
            delete this.trackidlookup[param1.soundID];
            this.audioSystem.stop(param1.soundID);
         }
         if(this.isotargetlookup[param1.isoobj.sprite])
         {
            delete this.isotargetlookup[param1.isoobj.sprite];
         }
         if(this.queuedAnimations[param1])
         {
            delete this.queuedAnimations[param1];
         }
         var _loc3_:Property = param1.getProperty("ffh_radio_state");
         if(_loc3_)
         {
            this.handlePropertyItemState(_loc3_,Property.ITEM_STATE_ACTION_DELETED);
         }
         ResourceManager.instance.unregisterDataPackContainer(param1.isoobj.media);
         this.isoengine.remove(param1.isoobj.sprite);
         ResourceManager.instance.cancelCallbacksFor(param1);
         param1.cleanup();
      }
      
      private function playAnimation(param1:IsoObjectContainer, param2:String, param3:Object) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         if(!param1.isoobj.media.hasAnimation(param2))
         {
            return;
         }
         param1.isoobj.animation = param2;
         var _loc4_:int = 1000;
         var _loc5_:int = 1;
         if(param3 is Array)
         {
            _loc8_ = param3 as Array;
            _loc9_ = 0;
            while(_loc9_ < _loc8_.length)
            {
               switch(_loc8_[_loc9_]["name"])
               {
                  case Client.ANIM_KEY_PLAY:
                     _loc7_ = _loc8_[_loc9_]["data"];
                     break;
                  case Client.ANIM_KEY_MILLIS:
                     _loc4_ = _loc8_[_loc9_]["data"];
                     break;
                  case Client.ANIM_KEY_MODE:
                     _loc5_ = _loc8_[_loc9_]["data"];
                     _loc6_ = _loc8_[_loc9_]["modifier"];
               }
               _loc9_++;
            }
         }
         this.animationmanager.animate(param1.isoobj,_loc4_,_loc5_,_loc6_,_loc7_,param1);
      }
      
      private function handleRenderParts(param1:*) : void
      {
         var player:Player = null;
         var userid:String = null;
         var pack:String = null;
         var base:int = 0;
         var getScale:Function = null;
         var result:* = param1;
         if(!result || result is String)
         {
            this.remoteLog("ERROR","AMF","AMF Error at handleRenderParts");
            return;
         }
         if(result[this.room.ownerUserId])
         {
            this.roomBanner.setAvatar(this.room.ownerUserId,result[this.room.ownerUserId]["version"]);
         }
         for(userid in result)
         {
            player = WOBRegistry.instance.getPlayerByUId(uint(userid));
            if(!(!player || !player.isoobj))
            {
               if(result[userid])
               {
                  if(result[userid]["prerendered"])
                  {
                     player.baseurl = param["npcbaseurl"];
                     player.prerendered = result[userid]["prerendered"];
                  }
                  else
                  {
                     player.baseurl = param["imgfactory"];
                     player.body = result[userid]["body"];
                     player.renderparts = result[userid]["renderparts"] as Array;
                     base = !!player.isStateSet(Player.STATE_SHRINKED)?int(Player.SHRINKSCALE):int(Player.DEFAULT_SCALE);
                     getScale = function():Number
                     {
                        var _loc1_:int = int(result[userid]["scale_x"]);
                        return !!_loc1_?Number(_loc1_ / 100):Number(1);
                     };
                     player.scalex = base * getScale(result[userid]["scale_x"]);
                     player.scaley = base * getScale(result[userid]["scale_y"]);
                     player.scalez = base * getScale(result[userid]["scale_z"]);
                     if(player.prerendered)
                     {
                        player.isGhost = false;
                     }
                  }
                  pack = !!player.prerendered?"init":BinaryDecodable.DEFAULT_DATAPACK;
                  this.loadPlayer(player,pack,true);
                  player.lastRequest = null;
                  if(this.queuedAnimations[player])
                  {
                     if(this.queuedAnimations[player]["hasmovement"] && !this.animationmanager.getMovement(player.isoobj))
                     {
                        delete this.queuedAnimations[player];
                     }
                     else
                     {
                        this.updateWOBAnimation(player,this.queuedAnimations[player]["animation"]);
                     }
                  }
               }
            }
         }
      }
      
      private function requestRenderParts(param1:Array) : void
      {
         this.amfApi.call(AmfApi.GET_RENDER_PARTS,this.handleRenderParts,null,param1);
      }
      
      private function setPlayerGhostData(param1:Player) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1.isGhost)
         {
            if(param1.body == null || param1.body == "human_m")
            {
               if(param1.isStateSet(Player.STATE_SHRINKED))
               {
                  _loc2_ = GHOST_M_SHRINK_RESOURCE_NAME;
                  _loc3_ = this.urlGhostMShrinked;
               }
               else
               {
                  _loc2_ = GHOST_M_RESOURCE_NAME;
                  _loc3_ = this.urlGhostM;
               }
            }
            else if(param1.isStateSet(Player.STATE_SHRINKED))
            {
               _loc2_ = GHOST_F_SHRINK_RESOURCE_NAME;
               _loc3_ = this.urlGhostFShrinked;
            }
            else
            {
               _loc2_ = GHOST_F_RESOURCE_NAME;
               _loc3_ = this.urlGhostF;
            }
         }
         ResourceManager.instance.requestDataPack(_loc2_,param1,this.playerGhostLoaded,null,BinaryDecodable.DEFAULT_DATAPACK,_loc3_,ResourceManager.PACK_TYPE_ISOPACK,null);
      }
      
      private function loadPlayer(param1:Player, param2:String = null, param3:Boolean = false) : void
      {
         var _loc4_:ResourceRequest = ResourceManager.instance.requestPlayer(param1,this.isoObjectLoaded,param2,param3,null);
         if(!_loc4_)
         {
            throw new Error("Resource request failed while requesting player " + param1.name + " " + param2);
         }
      }
      
      private function playerGhostLoaded(param1:Player, param2:ADataPack, param3:ResourceRequest) : void
      {
         if(param1.isGhost)
         {
            this.dataPackLoaded(param1,param2,param3,false);
         }
      }
      
      private function dataPackLoaded(param1:IsoObjectContainer, param2:ADataPack, param3:ResourceRequest, param4:Boolean = true) : void
      {
         var _loc5_:Player = null;
         param1.isoobj.media.addDataPack(param2);
         if(param4)
         {
            ResourceManager.instance.registerDataPackContainer(param1.isoobj.media,param2);
         }
         if(this.isoengine.isManaging(param1.isoobj.sprite))
         {
            param1.isoobj.forceUpdate();
         }
         else
         {
            this.addToIsoEngine(param1);
         }
         if(param1 is IsoItem)
         {
            if(this.pendingCarriedObjects[param1.wobId])
            {
               _loc5_ = this.getCarrierOf(param1.wobId);
               this.onCarriedObjectAvailable(_loc5_,param1.isoobj,param1.wobId);
            }
         }
      }
      
      private function addToIsoEngine(param1:IsoObjectContainer) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:InteractiveObject = null;
         if(!this.isoengine.isManaging(param1.isoobj.sprite))
         {
            _loc2_ = IsoSprite.FLAG_SHADOW;
            if(param1 is IsoItem)
            {
               _loc2_ = _loc2_ | IsoSortable.FLAG_GROUPABLE;
            }
            param1.isoobj.flags = _loc2_;
            _loc3_ = param1.isoobj.sprite.content as InteractiveObject;
            if(_loc3_ != null)
            {
               if(param1.interactive)
               {
                  InteractionManager.registerForMouse(_loc3_,this.handleIsoObjectSpriteContentMouseData,INTERACTION_GROUP_ISOSPRITE_CONTENTS);
               }
               else
               {
                  _loc3_.mouseEnabled = false;
                  if(_loc3_ is DisplayObjectContainer)
                  {
                     (_loc3_ as DisplayObjectContainer).mouseChildren = false;
                  }
               }
            }
            if(param1 is Player)
            {
               this.initPlayer(param1 as Player);
            }
            this.isoengine.add(param1.isoobj.sprite);
            this.isotargetlookup[param1.isoobj.sprite] = param1;
         }
      }
      
      private function isoObjectLoaded(param1:Object, param2:ADataPack, param3:ResourceRequest) : void
      {
         if(param1 is Player && (param1 as Player).isGhost)
         {
            (param1 as Player).isGhost = false;
            if(param1 == this.thisplayer)
            {
               if(this.debugger != null)
               {
                  this.debugger.currentIsoSprite = this.thisplayer.isoobj.sprite;
               }
               this.audioSystem.updateListenerLocation(this.thisplayer.isoobj.uvz);
            }
         }
         else if(param1 is IsoItem)
         {
            if(--this.itemsToLoad <= 0)
            {
               this.isoengine.enableGrouping = true;
               this.isoengine.rebuildGroups();
            }
         }
         this.dataPackLoaded(param1 as IsoObjectContainer,param2,param3);
      }
      
      private function mark(param1:IsoObjectContainer) : void
      {
         if(this.markedIsoObjecContainer != null && this.markedIsoObjecContainer.isoobj != null)
         {
            if(param1 == this.markedIsoObjecContainer)
            {
               return;
            }
            this.markedIsoObjecContainer.isoobj.displayflags = this.markedIsoObjecContainer.isoobj.displayflags & ~IsoObjectSpriteContent.FLAG_MARK;
            this.markedIsoObjecContainer = null;
         }
         if(param1 == null)
         {
            return;
         }
         param1.isoobj.displayflags = param1.isoobj.displayflags | IsoObjectSpriteContent.FLAG_MARK;
         this.markedIsoObjecContainer = param1;
      }
      
      private function select(param1:ISelectable, param2:Array = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ItemInteraction = null;
         var _loc7_:String = null;
         if(!this.thisplayer)
         {
            return;
         }
         if(!this.controlbar || !this.controlbar.visible || this.controlbar.alpha != 1)
         {
            return;
         }
         if(!this.itemmenu.selection && !param1)
         {
            return;
         }
         if(param1 != null && this.tooltipManager && this.tooltipManager.target != null)
         {
            this.tooltipManager.target = null;
         }
         if(this.itemmenu.selection == param1)
         {
            return;
         }
         this.itemmenu.hide();
         if(param1 == null)
         {
            InteractionManager.setMouseHandlerCallbackFor(this.clickThroughTarget,this.handleClickthroughMouseData);
         }
         if(this.itemmenu.selection != null && this.itemmenu.selection is IsoObjectContainer)
         {
            (this.itemmenu.selection as IsoObjectContainer).topHeightPosition = null;
         }
         this.itemmenu.selection = param1;
         this.itemmenu.clear();
         if(param1)
         {
            if(param1.interactions)
            {
               _loc3_ = new Array();
               _loc5_ = param1.interactions.length;
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  _loc6_ = param1.interactions[_loc4_];
                  if(_loc6_.name != null)
                  {
                     _loc3_.push(new MenuItem(_loc6_.name,_loc4_,_loc6_.callback,[this.client,param1,_loc6_,param2]));
                  }
                  _loc4_++;
               }
            }
         }
         if(param1 != this.thisplayer && (this.thisplayer.rights & (16 | 8)) != 0)
         {
            if(param1 is Player || param1 is MessageContainer)
            {
               if(_loc3_ == null)
               {
                  _loc3_ = new Array();
               }
               _loc5_ = SOP_MENU_EXTENSION.length;
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  _loc7_ = SOP_MENU_EXTENSION[_loc4_] as String;
                  if(_loc7_)
                  {
                     _loc3_.push(new MenuItem("[!]: " + _loc7_,-1,this.client.sendAdminCommand,[_loc7_ + " " + param1.name],true));
                  }
                  _loc4_++;
               }
            }
         }
         if(param1 is IsoObjectContainer)
         {
            (param1 as IsoObjectContainer).topHeightPosition = param2;
         }
         if(_loc3_ != null && _loc3_.length > 0)
         {
            InteractionManager.setMouseHandlerCallbackFor(this.clickThroughTarget,this.handleClickthroughMouseData_menuOpen);
            this.itemmenu.title = param1.name;
            this.itemmenu.items = _loc3_;
            this.itemmenu.show();
         }
      }
      
      private function showControls() : void
      {
         if(this.controlbar.visible)
         {
            return;
         }
         this.layoutGUI();
      }
      
      private function hideControls() : void
      {
         if(!this.controlbar.visible)
         {
            return;
         }
         this.itemmenu.hide();
      }
      
      private function showMILWKIT() : void
      {
         if(this.notifyManager.hasNotifyForClass("milwkit"))
         {
            return;
         }
         this.notifyManager.addNotify(new MILWKITScreen(param),null,"milwkit");
      }
      
      private function addLocatorArrow(param1:IsoObject) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:IsoObjectSpriteContent = param1.sprite.content as IsoObjectSpriteContent;
         var _loc3_:MyLocationArrow = new MyLocationArrow(param1.sprite);
         _loc3_.onAnimationFinished = this.removeLocatorArrow;
         _loc2_.locatorArrow = _loc3_;
      }
      
      private function removeLocatorArrow(param1:IsoSprite) : void
      {
         if(!param1 || !param1.content is IsoObjectSpriteContent)
         {
            return;
         }
         var _loc2_:IsoObjectSpriteContent = param1.content as IsoObjectSpriteContent;
         _loc2_.locatorArrow = null;
      }
      
      private function initPlayer(param1:Player) : void
      {
         var player:Player = param1;
         player.onscreen = true;
         player.isoobj.flags = IsoSortable.FLAG_NO_COLLISION;
         if(player == this.thisplayer)
         {
            player.isoobj.onSpriteAdded = function(param1:IsoObject):void
            {
               param1.onSpriteAdded = null;
               if(autoScroll)
               {
                  scrollToAvatar();
               }
               showControls();
               addLocatorArrow(thisplayer.isoobj);
            };
         }
         if(!this.isoengine.foregroundlayer.contains(player.isoIcons))
         {
            this.isoengine.foregroundlayer.addChild(player.isoIcons);
            this.pendingIconUpdates.push(player);
         }
      }
      
      private function cleanupRoom() : void
      {
         var _loc2_:uint = 0;
         if(this.debugger)
         {
            this.debugger.cleanupContext();
         }
         InteractionManager.removeForMouse(this.clickThroughTarget);
         if(this.tooltipManager != null)
         {
            this.tooltipManager.cleanup();
            this.tooltipManager = null;
         }
         this.msgmanager.removeHighlights();
         ResourceManager.instance.cancelCallbacks();
         ResourceManager.instance.increaseDataPackContainerAge(0.3);
         this.cleanupRoomHopPlan();
         this.itemmenu.selection = null;
         this.markedIsoObjecContainer = null;
         this.audioSystem.stopAll();
         this.animationmanager.stop();
         this.removeExits();
         var _loc1_:Array = WOBRegistry.instance.getPlayerIds();
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.removePlayer(_loc1_[_loc2_]);
            _loc2_++;
         }
         var _loc3_:Array = WOBRegistry.instance.getWobIds();
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            this.cleanupIsoObjectContainer(WOBRegistry.instance.getObjectByWobID(_loc3_[_loc2_]));
            _loc2_++;
         }
         WOBRegistry.instance.clear();
         if(this.walkdest)
         {
            this.walkdest.cleanup();
            this.walkdest = null;
         }
         MouseManager.stageMouseUp();
         if(this.mousePointer != null)
         {
            this.mousePointer.reset(true);
         }
         if(this.isoengine)
         {
            this.isoengine.cleanup();
            this.isoengine = null;
         }
         this.room.data = null;
         if(this.room.bg)
         {
            this.room.bg.cancelLoad();
            this.room.bg = null;
         }
         this.ffhStream.stopStream(true);
         this.autoScroll = true;
         this.isotargetlookup = new Dictionary(true);
         this.layerManager.clearLayer(LayerManager.LAYER_CLICKTHROUGHT);
         this.layerManager.clearLayer(LayerManager.LAYER_ISO_ENGINE);
         this.layerManager.clearLayer(LayerManager.LAYER_LEVEL_PROGRESS);
         this.layerManager.clearLayer(LayerManager.LAYER_ROOM_HOP_MAP);
         JSApi.onCleanupRoom();
      }
      
      private function loadRoomBackground() : void
      {
         var _loc1_:LevelBackground = new LevelBackground(this.areaName,this.room.gui,this.room.brightness,this.room.data.bounds.size);
         _loc1_.onIOError = this.handleLoaderError;
         _loc1_.onMediaContainerDecoded = this.backgroundDecoded;
         ResourceManager.instance.requestBackground(_loc1_,null,true);
      }
      
      private function initIsoEngine() : void
      {
         var _loc2_:Object = null;
         this.clickThroughTarget = new ClickthroughTarget(stage.stageWidth,stage.stageHeight,0);
         WidgetManager.clickThroughTarget = this.clickThroughTarget;
         this.isoengine = new IsoStar(this.room.bg,this.room.data,stage.stageWidth,stage.stageHeight);
         this.isoengine.onScreenOffestChange = this.onIsoEngineScreenOffsetChange;
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(153);
         _loc1_.graphics.drawRect(0,0,100,100);
         _loc1_.graphics.endFill();
         _loc1_.width = stage.stageWidth;
         _loc1_.height = stage.stageHeight;
         this.isoengine.mask = _loc1_;
         this.walkdest = new MyWalkDest(this.isoengine);
         this.animationmanager.start(getTimer());
         this.layerManager.addLayerContent(LayerManager.LAYER_CLICKTHROUGHT,this.clickThroughTarget);
         this.layerManager.addLayerContent(LayerManager.LAYER_ISO_ENGINE,this.isoengine);
         this.layerManager.addLayerContent(LayerManager.LAYER_ISO_ENGINE,_loc1_);
         this.ldr.hide();
         this.layerManager.clearLayer(LayerManager.LAYER_LOADER_SCREEN);
         this.isoengine.addIsoFlatThing(this.walkdest);
         if(this._autowalkAnimation == null)
         {
            this.networkJobQueue.start();
            this.client.sendRoomLoaded(this.room.gui,this.room.wobID);
            JSApi.onRoomLoaded(true);
         }
         this._loadComplete = true;
         if(this.debugger)
         {
            _loc2_ = new Object();
            _loc2_[Debugger.CFG_AUDIO_SYSTEM] = this.audioSystem;
            _loc2_[Debugger.CFG_ISO_ENGINE] = this.isoengine;
            _loc2_[Debugger.CFG_MESSAGE_MANAGER] = this.msgmanager;
            _loc2_[Debugger.CFG_CURRENT_ROOM] = this.room;
            this.debugger.init(_loc2_);
         }
         this.tooltipManager = new TooltipManager(this.layerManager.getLayer(LayerManager.LAYER_TOOLTIPS));
         this.remoteLog("OK","CLIENT","Client is ready to go");
         if(this._zoomIn)
         {
            this.zoom = this.ZOOM_IN_VALUE;
         }
         else
         {
            this.zoom = this.ZOOM_OUT_VALUE;
         }
         this.iconDropManager.scroll(-this.isoengine.screenrect.x,-this.isoengine.screenrect.y);
         this.notifyManager.visible = true;
         InteractionManager.registerForMouse(this.clickThroughTarget,this.handleClickthroughMouseData);
      }
      
      private function backgroundDecoded(param1:LevelBackground, param2:Boolean = false) : void
      {
         var bg:LevelBackground = param1;
         var isHires:Boolean = param2;
         this.room.bg = bg;
         if(bg.version == 2 && !isHires)
         {
            ResourceManager.instance.requestMediaPack(param["roombaseurl"] + "." + this.areaName + "." + this.room.gui + "." + this.room.gui + "_bg_" + this.room.brightness + "_med",this.room,function(param1:Room, param2:MediaDataPack, param3:ResourceRequest):void
            {
               var _loc4_:BitmapData = null;
               if(param1 == room)
               {
                  _loc4_ = param2.getImage("bghires");
                  if(_loc4_)
                  {
                     param1.bg.pixelData = _loc4_.getPixels(_loc4_.rect);
                     _loc4_.dispose();
                     _loc4_ = null;
                     ResourceManager.instance.addHiresBackgroundCache(param1.bg.clone());
                     if(isoengine.background != param1.bg)
                     {
                        isoengine.background = param1.bg;
                     }
                     else
                     {
                        isoengine.updateBackground();
                     }
                  }
               }
            },function(param1:Room, param2:MediaDataPack, param3:ResourceRequest):void
            {
            },null,ResourceManager.RELEASE_IMMEDIATELY);
         }
         else if(this.isoengine)
         {
            this.isoengine.background = this.room.bg;
         }
         if(!this.roomInited)
         {
            this.roomInited = true;
            this.initIsoEngine();
            this.updateRoomBanner();
         }
      }
      
      private function __cb_am_onComplete(param1:IChangeable) : void
      {
         if(param1 is Animation && param1.target)
         {
            param1.target.showDefaults();
         }
      }
      
      private function __cb_mp_onContentChange(param1:String, param2:int, param3:Array, param4:Boolean) : void
      {
         if(param2 > 0 && !param4)
         {
            this.handContentTrash.visible = true;
            InteractionManager.registerForMouse(this.handContentTrash,this.handleHandContentTrashMouseData);
         }
         else
         {
            this.handContentTrash.visible = false;
            InteractionManager.removeForMouse(this.handContentTrash);
         }
      }
      
      private function __cb_client_onAutoReconnect(param1:int) : void
      {
         var nextAttemptAt:int = param1;
         if(WidgetManager.hasClickThroughCallback())
         {
            return;
         }
         this.layerManager.clearLayer(LayerManager.LAYER_MESSAGE_DIALOG);
         this.activeDialog = new Dialog(StringUtil.formattedString(LocaleStrings.MSG_COULDNT_CONNECT,[]),Dialog.OPTION_OK);
         InteractionManager.registerForMouse(this.activeDialog,this.activeDialog.handleMouseManagerData,INTERACTION_GROUP_WIDGETS);
         WidgetManager.setWidget(this.activeDialog);
         this.activeDialog.onButtonClick = function(param1:int, param2:Object):void
         {
            WidgetManager.remove();
            InteractionManager.removeForMouse(activeDialog);
            activeDialog = null;
         };
         this.layoutGUI();
         this.layerManager.addLayerContent(LayerManager.LAYER_MESSAGE_DIALOG,this.activeDialog);
      }
      
      private function centerOnAvatar(param1:Number = 0, param2:Number = 0) : void
      {
         if(this.dragScrolling || !this.thisplayer || !this.thisplayer.isoobj.sprite.isAdded || this.isoengine.isScrolling)
         {
            return;
         }
         var _loc3_:Rectangle = this.thisplayer.isoobj.sprite.bounds;
         var _loc4_:Rectangle = this.isoengine.screenrect.clone();
         this.isoengine.setScreenOffset(_loc3_.x + this.isoengine.offset.x - (this.isoengine.screenrect.width - _loc3_.width) / 2 + param1,_loc3_.y + this.isoengine.offset.y - (this.isoengine.screenrect.height - _loc3_.height) / 2 + param2);
      }
      
      private function scrollToAvatar() : void
      {
         if(this.dragScrolling || !this.thisplayer || !this.thisplayer.isoobj.sprite.isAdded || this.isoengine.isScrolling)
         {
            return;
         }
         var _loc1_:Rectangle = this.thisplayer.isoobj.sprite.bounds;
         this.isoengine.scrollTo(_loc1_.x + this.isoengine.offset.x - (this.isoengine.screenrect.width - _loc1_.width) / 2,_loc1_.y + this.isoengine.offset.y - (this.isoengine.screenrect.height - _loc1_.height) / 2,500,"easeOutExpo");
      }
      
      private function __cb_am_onTick(param1:IChangeable) : void
      {
         var _loc2_:IsoObjectContainer = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param1 is Movement)
         {
            if(param1.ref is IsoSprite)
            {
               this.isoengine.checkGrouping(param1.ref as IsoSortable,true);
            }
            else if(param1.ref is IsoObjectContainer)
            {
               _loc2_ = param1.ref as IsoObjectContainer;
               if(_loc2_ == this.thisplayer)
               {
                  this.audioSystem.updateListenerLocation(this.thisplayer.isoobj.uvz);
               }
               else
               {
                  this.audioSystem.updateLocation(_loc2_.soundID,_loc2_.isoobj.uvz);
               }
               if(_loc2_.isoobj.sprite.isAdded)
               {
                  this.isoengine.checkGrouping(_loc2_.isoobj.sprite,true);
                  if(_loc2_ == this.thisplayer)
                  {
                     _loc3_ = this.isoengine.screenrect.clone();
                     _loc4_ = _loc3_.width / 6;
                     _loc5_ = _loc3_.height / 6;
                     _loc3_.x = _loc3_.x + (_loc4_ - this.isoengine.offset.x);
                     _loc3_.y = _loc3_.y + (_loc5_ - this.isoengine.offset.y);
                     _loc3_.width = _loc3_.width - 2 * _loc4_;
                     _loc3_.height = _loc3_.height - 2 * _loc5_;
                     if(!_loc3_.containsRect(_loc2_.isoobj.sprite.bounds) && this.autoScroll)
                     {
                        this.scrollToAvatar();
                     }
                  }
                  if(_loc2_ is Player)
                  {
                     (_loc2_ as Player).updateIsoOverlaysPosition();
                  }
               }
            }
         }
      }
      
      private function loadRoomData() : void
      {
         var _loc1_:Level = new Level(this.areaName,this.room.gui);
         _loc1_.onMediaContainerDecoded = this.dataDecoded;
         _loc1_.onLoadProgress = this.handleLoaderProgress;
         _loc1_.onIOError = this.handleLoaderError;
         if(this.room && this.room.gui)
         {
            ResourceManager.instance.requestLevel(_loc1_,null,false,true);
         }
      }
      
      private function dataDecoded(param1:Level) : void
      {
         this.room.data = param1;
         this.loadRoomBackground();
         this.loadRoomSounds();
      }
      
      private function handleControlsEvent(param1:ControlsEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:IsoObjectContainer = null;
         var _loc10_:Object = null;
         switch(param1.type)
         {
            case ControlsEvent.INV_CLICK:
               JSApi.showStuff();
               break;
            case ControlsEvent.HOME_CLICK:
               JSApi.openHomeScreen();
               break;
            case ControlsEvent.METROPLAN_CLICK:
               this.client.sendShowMetroMap();
               break;
            case ControlsEvent.COMPOSING_START:
               this.client.sendSetStatus(Client.STAT_KEY_COMPOSING,[1]);
               break;
            case ControlsEvent.COMPOSING_IDLE:
               this.client.sendSetStatus(Client.STAT_KEY_COMPOSING,[0]);
               break;
            case ControlsEvent.COMPOSING_STOP:
               this.client.sendDeleteStatus(Client.STAT_KEY_COMPOSING);
               break;
            case ControlsEvent.CRAFTING_ICON_CLICK:
               JSApi.showCrafting();
               break;
            case ControlsEvent.HELPER_ICON_CLICK:
               if(this.controlbar.universalHelper.hasNotify())
               {
                  this.client.sendRequestHint();
               }
               else
               {
                  this.showMILWKIT();
               }
               break;
            case ControlsEvent.SHOPPING_CLICK:
               JSApi.openShopScreen();
               break;
            case ControlsEvent.SOUND_ACTIVATE:
               this.handleAudioToggled(true,SoundTrack.SOUND_TYPE_AMB);
               break;
            case ControlsEvent.SOUND_DEACTIVATE:
               this.handleAudioToggled(false,SoundTrack.SOUND_TYPE_AMB);
               break;
            case ControlsEvent.EFFECTS_ACTIVATE:
               this.handleAudioToggled(true,SoundTrack.SOUND_TYPE_EFF);
               break;
            case ControlsEvent.EFFECTS_DEACTIVATE:
               this.handleAudioToggled(false,SoundTrack.SOUND_TYPE_EFF);
               break;
            case ControlsEvent.OPTIONS_SHOW:
               this.flashCookies.setCookie(FlashCookies.KEY_OPTIONS_VISIBLE,true);
               break;
            case ControlsEvent.OPTIONS_HIDE:
               this.flashCookies.setCookie(FlashCookies.KEY_OPTIONS_VISIBLE,false);
               break;
            case ControlsEvent.INPUT_COMPLETE:
               _loc2_ = this.controlbar.textInput.lastinput;
               if(_loc2_.length == 0)
               {
                  break;
               }
               _loc3_ = _loc2_.charAt(0);
               switch(_loc3_)
               {
                  case "/":
                     _loc5_ = _loc2_.substr(1).split(/\s+/);
                     _loc4_ = _loc5_.shift();
                     if(this.debugger && this.debugger.processCommand(_loc4_,_loc5_))
                     {
                        return;
                     }
                     switch(_loc4_)
                     {
                        case "me":
                           if(_loc5_.length > 0)
                           {
                              this.client.sendUserMessage(_loc5_.join(" "),1);
                           }
                           break;
                        case "think":
                           if(_loc5_.length > 0)
                           {
                              this.client.sendUserMessage(_loc5_.join(" "),2);
                           }
                           break;
                        case "shout":
                           if(_loc5_.length > 0)
                           {
                              this.client.sendUserMessage(_loc5_.join(" "),3);
                           }
                           break;
                        case "w":
                        case "whisper":
                           if(_loc5_.length > 0)
                           {
                              this.client.sendUserMessage(_loc5_.join(" "),4);
                           }
                           break;
                        case "away":
                           if(_loc5_.length > 0)
                           {
                              this.client.sendSetStatus(Client.STAT_KEY_AWAY,[_loc5_.join(" ")]);
                           }
                           else
                           {
                              this.client.sendDeleteStatus(Client.STAT_KEY_AWAY);
                           }
                           break;
                        case "debug":
                           if(this.thisplayer && (this.thisplayer.rights & 16) == 16)
                           {
                              if(this.debugger == null)
                              {
                                 this.debugger = new Debugger();
                                 _loc10_ = new Object();
                                 _loc10_[Debugger.CFG_AUDIO_SYSTEM] = this.audioSystem;
                                 _loc10_[Debugger.CFG_ISO_ENGINE] = this.isoengine;
                                 _loc10_[Debugger.CFG_MESSAGE_MANAGER] = this.msgmanager;
                                 _loc10_[Debugger.CFG_CURRENT_ROOM] = this.room;
                                 this.debugger.init(_loc10_);
                                 this.layerManager.addLayerContent(LayerManager.LAYER_DEBUGGER,this.debugger);
                                 this.debugger.postMessage("Debug mode ON");
                                 if(this.thisplayer != null && this.thisplayer.isoobj.sprite.isAdded)
                                 {
                                    this.debugger.currentIsoSprite = this.thisplayer.isoobj.sprite;
                                 }
                              }
                              else
                              {
                                 this.debugger.postMessage("Debug mode OFF");
                                 this.debugger.cleanup();
                                 this.layerManager.removeLayerContent(LayerManager.LAYER_DEBUGGER,this.debugger);
                                 this.debugger = null;
                              }
                           }
                           break;
                        default:
                           _loc5_.unshift(_loc4_);
                           this.client.sendUserCommand(StringUtil.trim(_loc5_.join(" ")));
                     }
                     break;
                  case "#":
                     if(_loc2_.length > 1)
                     {
                        this.client.sendAdminCommand(_loc2_.substring(1));
                     }
                     break;
                  default:
                     this.client.sendUserMessage(_loc2_,0);
               }
               break;
         }
      }
      
      private function handleLoaderProgress(param1:BinaryLoader, param2:Number, param3:Number) : void
      {
         if(!this.ldr)
         {
            return;
         }
         this.ldr.progress = param2 / param3;
      }
      
      private function handleLoaderError(param1:BinaryLoader, param2:IOErrorEvent) : void
      {
         this.remoteLog("ERROR","IO","IO Error at handleLoaderError");
      }
      
      private function handleConnect(param1:Event) : void
      {
         this.client.registerReceiveCallback(this.handleClientEvent);
         this.client.sendLogin(param["username"],param["sessionid"]);
         this.remoteLog("OK","CONNECTION","Connection established to " + this.host + ":" + this.port + " at handleConnect");
      }
      
      private function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         var e:SecurityErrorEvent = param1;
         this.remoteLog("ERROR","SECURITY","Security Error at handleSecurityError (" + e + ")");
         if(WidgetManager.hasClickThroughCallback())
         {
            return;
         }
         this.layerManager.clearLayer(LayerManager.LAYER_MESSAGE_DIALOG);
         this.activeDialog = new Dialog(StringUtil.formattedString(LocaleStrings.MSG_COULDNT_CONNECT,[]),Dialog.OPTION_OK);
         InteractionManager.registerForMouse(this.activeDialog,this.activeDialog.handleMouseManagerData,INTERACTION_GROUP_WIDGETS);
         WidgetManager.setWidget(this.activeDialog);
         this.layoutGUI();
         this.activeDialog.onButtonClick = function(param1:int, param2:Object):void
         {
            WidgetManager.remove();
            InteractionManager.removeForMouse(activeDialog);
            activeDialog = null;
            switch(param1)
            {
               case Dialog.OPTION_OK:
                  logout();
            }
         };
         this.layerManager.addLayerContent(LayerManager.LAYER_MESSAGE_DIALOG,this.activeDialog);
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         var e:IOErrorEvent = param1;
         this.remoteLog("ERROR","IO","IO Error at handleIOError (" + e + ")");
         if(WidgetManager.hasClickThroughCallback())
         {
            return;
         }
         this.layerManager.clearLayer(LayerManager.LAYER_MESSAGE_DIALOG);
         this.activeDialog = new Dialog(StringUtil.formattedString(LocaleStrings.MSG_COULDNT_CONNECT,[]),Dialog.OPTION_OK);
         InteractionManager.registerForMouse(this.activeDialog,this.activeDialog.handleMouseManagerData,INTERACTION_GROUP_WIDGETS);
         WidgetManager.setWidget(this.activeDialog);
         this.layoutGUI();
         this.activeDialog.onButtonClick = function(param1:int, param2:Object):void
         {
            WidgetManager.remove();
            InteractionManager.removeForMouse(activeDialog);
            activeDialog = null;
            switch(param1)
            {
               case Dialog.OPTION_OK:
                  logout();
            }
         };
         this.layerManager.addLayerContent(LayerManager.LAYER_MESSAGE_DIALOG,this.activeDialog);
      }
      
      private function handleClose(param1:Event) : void
      {
         var e:Event = param1;
         this.remoteLog("INFO","CONNECTION","Connection Closed at handleClose (" + e + ")");
         this.layerManager.clearLayer(LayerManager.LAYER_MESSAGE_DIALOG);
         JSApi.connectionLost();
         this.hideMetroPlan();
         if(!WidgetManager.hasClickThroughCallback())
         {
            this.activeDialog = new Dialog(LocaleStrings.MSG_LOST_CONNECTION,Dialog.OPTION_OK);
            InteractionManager.registerForMouse(this.activeDialog,this.activeDialog.handleMouseManagerData,INTERACTION_GROUP_WIDGETS);
            WidgetManager.setWidget(this.activeDialog);
            this.layoutGUI();
            this.activeDialog.onButtonClick = function(param1:int, param2:Object):void
            {
               WidgetManager.remove();
               InteractionManager.removeForMouse(activeDialog);
               activeDialog = null;
               switch(param1)
               {
                  case Dialog.OPTION_OK:
                     logout();
               }
            };
            this.layerManager.addLayerContent(LayerManager.LAYER_MESSAGE_DIALOG,this.activeDialog);
         }
      }
      
      private function remoteLog(param1:String, param2:String, param3:String, param4:Function = null) : void
      {
         if(param["logging"] != 1)
         {
            return;
         }
         this.amfApi.call(AmfApi.LOG,param4,param4,[param1,param2,param3,Capabilities.os,Capabilities.version,param["browser"]]);
      }
      
      private function mainLoop(param1:Number) : void
      {
         var _loc2_:Player = null;
         var _loc3_:IsoSprite = null;
         var _loc4_:Array = null;
         ResourceManager.instance.update(param1);
         this.animationmanager.update(param1);
         if(this.isoengine)
         {
            this.isoengine.update(param1);
         }
         if(this.pendingIconUpdates.length > 0)
         {
            while(this.pendingIconUpdates.length > 0)
            {
               _loc2_ = this.pendingIconUpdates.pop();
               _loc3_ = _loc2_.isoobj.sprite;
               if(_loc3_.isAdded && !_loc3_.bounds.isEmpty())
               {
                  if(!_loc2_.isoIcons.visible)
                  {
                     _loc2_.isoIcons.visible = true;
                  }
                  _loc2_.updateIsoOverlaysPosition();
               }
               else
               {
                  if(!_loc4_)
                  {
                     _loc4_ = new Array();
                  }
                  _loc4_.push(_loc2_);
               }
            }
            if(_loc4_ != null)
            {
               this.pendingIconUpdates = _loc4_;
            }
         }
         if(this.thisplayer != null && this.thisplayer.hasTimerBar())
         {
            this.thisplayer.updateTimerBar(param1);
         }
         if(this.controlbar)
         {
            this.controlbar.update(param1);
         }
         if(this.tooltipManager != null && this.tooltipManager.update(param1))
         {
            this.select(null);
         }
         if(this.ldr)
         {
            this.ldr.update(param1);
         }
         this.msgmanager.update(param1);
         if(this.networkJobQueue)
         {
            this.networkJobQueue.update(param1);
         }
         if(this.client)
         {
            this.client.update(param1);
         }
         if(this.debugger)
         {
            this.debugger.update(param1);
         }
      }
      
      private function onIsoEngineScreenOffsetChange(param1:Number, param2:Number) : void
      {
         if(param1 == 0 && param2 == 0)
         {
            return;
         }
         this.iconDropManager.scroll(-param1,-param2);
      }
      
      private function handleKeyboard(param1:KeyboardEvent) : void
      {
         if(param1.target != stage)
         {
            return;
         }
         if(this.inputModule != null && this.inputModule.isKeyboardHandler())
         {
            if(this.inputModule.handleKeyboardEvent(param1))
            {
               return;
            }
         }
         if(param1.type == KeyboardEvent.KEY_DOWN)
         {
            this.keyDown(param1);
            this.keydown[param1.keyCode] = param1;
         }
         else if(param1.type == KeyboardEvent.KEY_UP)
         {
            this.keyUp(param1);
            if(this.keydown[param1.keyCode] != null)
            {
               delete this.keydown[param1.keyCode];
               this.keyPressed(param1);
            }
         }
      }
      
      private function keyPressed(param1:KeyboardEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MenuItem = null;
         var _loc2_:int = param1.keyCode;
         if(this.thisplayer == null)
         {
            return;
         }
         if(param1.charCode == "+".charCodeAt(0))
         {
            this.handleZoom(!this._zoomIn);
         }
         if(_loc2_ >= 48 && _loc2_ <= 57)
         {
            _loc4_ = _loc2_ - 48;
            if(this.itemmenu.visible)
            {
               switch(_loc4_)
               {
                  case 0:
                     if(this.itemmenu.selection)
                     {
                        this.select(null);
                     }
                     break;
                  default:
                     _loc5_ = this.itemmenu.getMenuItemAt(_loc4_ - 1) as MenuItem;
                     if(_loc5_ && !_loc5_.skipshortcut)
                     {
                        _loc5_.execute();
                        this.select(null);
                     }
               }
            }
            else
            {
               switch(_loc4_)
               {
                  case 1:
                     this.client.sendUserCommand("whirl");
                     break;
                  case 2:
                     this.client.sendUserCommand("fever");
                     break;
                  case 3:
                     this.client.sendUserCommand("reality");
                     break;
                  case 4:
                     this.client.sendUserCommand("headbang");
                     break;
                  case 5:
                     this.client.sendUserCommand("arms");
                     break;
                  case 6:
                     this.client.sendUserCommand("pulp");
                     break;
                  case 7:
                     this.client.sendUserCommand("dance");
                     break;
                  case 8:
                     this.client.sendUserCommand("undecided");
                     break;
                  case 9:
                     this.client.sendUserCommand("box");
                     break;
                  case 0:
                     this.client.sendUserCommand("kick");
               }
            }
         }
         else if(_loc2_ == Keyboard.RIGHT)
         {
            this.sendPlayerDirection(this.thisplayer.isoobj.direction - 1);
         }
         else if(_loc2_ == Keyboard.LEFT)
         {
            this.sendPlayerDirection(this.thisplayer.isoobj.direction + 1);
         }
         else if(_loc2_ == Keyboard.UP)
         {
            this.client.sendUserCommand("jump");
         }
         else if(_loc2_ == Keyboard.DOWN)
         {
            this.client.sendUserCommand("sit");
         }
         else if(_loc2_ == 87)
         {
            this.client.sendUserCommand("wave");
         }
         else if(_loc2_ == 66)
         {
            this.client.sendUserCommand("bow");
         }
         else if(_loc2_ == 68)
         {
            this.client.sendUserCommand("dance");
         }
         else if(_loc2_ == 70)
         {
            this.client.sendUserCommand("fu");
         }
         else if(_loc2_ == 78)
         {
            this.client.sendUserCommand("no");
         }
         else if(_loc2_ == 80)
         {
            this.client.sendUserCommand("point");
         }
         else if(_loc2_ == 84)
         {
            this.client.sendUserCommand("tiptoe");
         }
         else if(_loc2_ == 88)
         {
            this.client.sendUserCommand("sit");
         }
         else if(_loc2_ == 89)
         {
            this.client.sendUserCommand("yes");
         }
         else if(_loc2_ == 83)
         {
            this.client.sendUserCommand("slap");
         }
         else if(_loc2_ == 85)
         {
            this.client.sendUserCommand("shrug");
         }
         else if(_loc2_ == 65)
         {
            this.client.sendUserCommand("applause");
         }
         else if(_loc2_ == 72)
         {
            this.client.sendUserCommand("scratchhead");
         }
         else if(_loc2_ == 77)
         {
            this.client.sendUserCommand("cast");
         }
         else if(_loc2_ == 73)
         {
            JSApi.showStuff();
         }
         else if(_loc2_ == Keyboard.ESCAPE)
         {
            if(this.targetPicker)
            {
               JSApi.onCancelSelectFrom();
               this.cancelTargetPicking();
               return;
            }
            if(this.roomHopPlan)
            {
               this.cleanupRoomHopPlan();
               return;
            }
            if(this.itemmenu.visible && this.itemmenu.selection != null)
            {
               this.select(null);
               return;
            }
            if(this.mousePointer.handContentCount > 0)
            {
               this.client.sendRequestClearHandHeld();
               return;
            }
            if(this.notifyManager.visible)
            {
               this.notifyManager.closeOrRemoveCurrent();
            }
            this.hideMetroPlan();
         }
         else if(_loc2_ == 67)
         {
            this.scrollToAvatar();
            this.autoScroll = true;
            if(this.thisplayer)
            {
               this.addLocatorArrow(this.thisplayer.isoobj);
            }
         }
      }
      
      private function keyDown(param1:KeyboardEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc2_:int = param1.keyCode;
         if(_loc2_ == Keyboard.SHIFT)
         {
            InteractionManager.disableMouseForGroup(INTERACTION_GROUP_ISOSPRITE_CONTENTS,true);
            _loc3_ = WOBRegistry.instance.getIsoItems();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               (_loc3_[_loc4_] as IsoItem).isoobj.displayflags = (_loc3_[_loc4_] as IsoItem).isoobj.displayflags | IsoObjectSpriteContent.FLAG_OUTLINE;
               _loc4_++;
            }
         }
      }
      
      private function keyUp(param1:KeyboardEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc2_:int = param1.keyCode;
         if(_loc2_ == Keyboard.ENTER)
         {
            if(stage.focus != this.controlbar.textInput.textField)
            {
               stage.focus = this.controlbar.textInput.textField;
            }
            else
            {
               stage.focus = null;
            }
         }
         else if(_loc2_ == Keyboard.SHIFT)
         {
            InteractionManager.enableMouseForGroup(INTERACTION_GROUP_ISOSPRITE_CONTENTS);
            _loc3_ = WOBRegistry.instance.getIsoItems();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               (_loc3_[_loc4_] as IsoItem).isoobj.displayflags = (_loc3_[_loc4_] as IsoItem).isoobj.displayflags & ~IsoObjectSpriteContent.FLAG_OUTLINE;
               _loc4_++;
            }
         }
      }
      
      private function keyIsDown(param1:int) : KeyboardEvent
      {
         if(param1 < 0 || param1 >= this.keydown.length)
         {
            return null;
         }
         return this.keydown[param1] as KeyboardEvent;
      }
      
      private function __cb_as_audioTracksFinished(param1:Array) : void
      {
         var _loc2_:IsoObjectContainer = null;
         if(!param1 || param1.length <= 0)
         {
            return;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = this.trackidlookup[param1[_loc3_]];
            delete this.trackidlookup[param1[_loc3_]];
            if(_loc2_)
            {
               _loc2_.soundID = NaN;
               _loc2_.isoobj.displayflags = _loc2_.isoobj.displayflags & ~IsoObjectSpriteContent.FLAG_ACTIVESOUND;
            }
            _loc3_++;
         }
      }
      
      private function handleIsoObjectSpriteContentMouseData(param1:MouseManagerData) : void
      {
         var _loc6_:IsoObject = null;
         var _loc7_:Number = NaN;
         var _loc8_:Vector3D = null;
         var _loc9_:Array = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:IsoItem = null;
         var _loc18_:ItemInteraction = null;
         var _loc19_:ItemInteraction = null;
         var _loc2_:IsoObjectSpriteContent = param1.currentTarget as IsoObjectSpriteContent;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:IsoObjectSprite = _loc2_.parent as IsoObjectSprite;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:IsoObjectContainer = this.isotargetlookup[_loc3_];
         if(_loc4_ == null)
         {
            return;
         }
         var _loc5_:String = param1.type;
         if(_loc5_ == MouseManagerData.ROLL_OVER)
         {
            if(this.targetPicker && (this.targetPicker.selectionFlags & TargetPicker.WOBID_ROOM) != TargetPicker.WOBID_ROOM)
            {
               return;
            }
            this.mousePointer.actionDataProvider = _loc4_;
            this.msgmanager.highlightMessagesOf(_loc4_);
            if(this.targetPicker)
            {
               _loc4_.isoobj.displayflags = _loc4_.isoobj.displayflags | IsoObjectSpriteContent.FLAG_TARGET;
               if(this.targetPicker.customPointer)
               {
                  this.targetPicker.customPointer.visible = false;
               }
            }
            if(this.itemmenu.selection != _loc4_)
            {
               this.mark(_loc4_);
               if(this.tooltipManager.target != _loc4_)
               {
                  this.tooltipManager.target = _loc4_;
               }
               this.select(null);
            }
         }
         else if(_loc5_ == MouseManagerData.ROLL_OUT)
         {
            if(this.targetPicker && (this.targetPicker.selectionFlags & TargetPicker.WOBID_ROOM) != TargetPicker.WOBID_ROOM)
            {
               return;
            }
            this.mousePointer.actionDataProvider = null;
            if(this.targetPicker)
            {
               _loc4_.isoobj.displayflags = _loc4_.isoobj.displayflags & ~IsoObjectSpriteContent.FLAG_TARGET;
               if(this.targetPicker.customPointer)
               {
                  this.targetPicker.customPointer.visible = true;
               }
            }
            this.msgmanager.removeHighlights();
            this.tooltipManager.target = null;
            if(this.itemmenu.selection != _loc4_ && !this.itemmenu.visible)
            {
               this.mark(null);
            }
         }
         else if(_loc5_ == MouseManagerData.CLICK)
         {
            if(this.targetPicker != null)
            {
               if(this.doPickTarget(TargetPicker.WOBID_ROOM,_loc4_.wobId))
               {
                  _loc4_.isoobj.displayflags = _loc4_.isoobj.displayflags & ~IsoObjectSpriteContent.FLAG_TARGET;
                  if(_loc4_ != this.thisplayer)
                  {
                     this.turnThisplayerToVector3D(_loc3_.getIsoPosition());
                  }
               }
            }
            else if(this.itemmenu.selection == null && !this.itemmenu.visible)
            {
               _loc6_ = _loc4_.isoobj;
               _loc7_ = _loc6_.sprite.topheight * COS30_1_D_SIN30_1_D_SQRT2;
               _loc8_ = this.isoengine.getCurrentMouseIsoPosition();
               _loc9_ = null;
               if(_loc8_ != null)
               {
                  _loc10_ = _loc6_.sprite.gripbounds.width / 2;
                  _loc11_ = _loc6_.sprite.gripbounds.height / 2;
                  _loc12_ = _loc8_.x + _loc7_;
                  _loc13_ = _loc8_.y + _loc7_;
                  _loc14_ = _loc6_.sprite.topheight + _loc6_.uvz.z;
                  _loc15_ = _loc12_ - _loc6_.uvz.x;
                  _loc16_ = _loc13_ - _loc6_.uvz.y;
                  if(_loc15_ >= -_loc10_ && _loc15_ <= _loc10_ && _loc16_ >= -_loc11_ && _loc16_ <= _loc11_)
                  {
                     _loc9_ = [_loc12_,_loc13_,_loc14_];
                  }
               }
               switch(this.mousePointer.actionMode)
               {
                  case MousePointer.MODE_EMPTY_HAND_WITH_CONTENT:
                  case MousePointer.MODE_EMPTY_HAND:
                     if(_loc4_ is IsoItem)
                     {
                        _loc17_ = _loc4_ as IsoItem;
                        _loc18_ = _loc17_.getPrimaryInteraction();
                        if(_loc18_ != null)
                        {
                           this.client.sendItemInteraction(_loc4_.wobId,_loc18_.label,_loc9_);
                        }
                        else
                        {
                           _loc19_ = _loc17_.getFirstSecondaryInteraction();
                           if(_loc19_ != null && _loc19_.label == "DETAILS")
                           {
                              JSApi.showRoomItem(_loc17_.wobId);
                           }
                        }
                     }
                     else if(_loc4_ is Player)
                     {
                        JSApi.showUser((_loc4_ as Player).name);
                     }
                     break;
                  case MousePointer.MODE_MULTIPLE_INTERACTIONS:
                     this.select(_loc4_,_loc9_);
                     break;
                  case MousePointer.MODE_USE_CONTENT_ON:
                     this.client.sendUseHandheldWith(_loc4_.wobId);
                     break;
                  case MousePointer.MODE_THROW_CONTENT_AT:
               }
            }
         }
         else if(_loc5_ == MouseManagerData.MOUSE_DOWN_AND_HOLD)
         {
            if(_loc4_ != null)
            {
               this.select(_loc4_);
               if(_loc4_ != this.thisplayer)
               {
                  this.turnThisplayerToVector3D(_loc3_.getIsoPosition());
               }
            }
         }
      }
      
      private function handleExitMouseData(param1:MouseManagerData) : void
      {
         var _loc2_:Exit = param1.currentTarget as Exit;
         if(this.isoengine == null || _loc2_ == null)
         {
            return;
         }
         var _loc3_:Vector3D = this.isoengine.getCurrentMouseIsoPosition();
         switch(param1.type)
         {
            case MouseManagerData.ROLL_OVER:
               this.mousePointer.actionDataProvider = _loc2_;
               _loc2_.highLight = true;
               break;
            case MouseManagerData.ROLL_OUT:
               this.mousePointer.actionDataProvider = null;
               _loc2_.highLight = false;
               break;
            case MouseManagerData.CLICK:
               this.dragScrolling = false;
               if(_loc3_ != null && this.targetPicker == null)
               {
                  this.sendMoveGroundTo(_loc3_);
                  this.select(null);
               }
         }
      }
      
      private function handleHandContentTrashMouseData(param1:MouseManagerData) : void
      {
         if(param1.currentTarget != this.handContentTrash)
         {
            return;
         }
         switch(param1.type)
         {
            case MouseManagerData.ROLL_OVER:
               this.mousePointer.actionDataProvider = this.handContentTrash;
               this.handContentTrash.highLight = true;
               break;
            case MouseManagerData.ROLL_OUT:
               this.mousePointer.actionDataProvider = null;
               this.handContentTrash.highLight = false;
               break;
            case MouseManagerData.CLICK:
               this.client.sendRequestClearHandHeld();
         }
      }
      
      private function handleClickthroughMouseData(param1:MouseManagerData) : void
      {
         if(this.isoengine == null)
         {
            return;
         }
         var _loc2_:Vector3D = this.isoengine.getCurrentMouseIsoPosition();
         switch(param1.type)
         {
            case MouseManagerData.ROLL_OVER:
               this.mousePointer.actionDataProvider = this.clickThroughTarget;
               break;
            case MouseManagerData.ROLL_OUT:
               this.mousePointer.actionDataProvider = null;
               break;
            case MouseManagerData.CLICK:
               this.dragScrolling = false;
               if(_loc2_ != null)
               {
                  if(this.targetPicker != null)
                  {
                     if(this.doPickTarget(TargetPicker.UVZ_FLOORED,[int(_loc2_.x),int(_loc2_.y),int(_loc2_.z)]) || this.doPickTarget(TargetPicker.UVZ,[int(_loc2_.x),int(_loc2_.y),int(_loc2_.z)]))
                     {
                        this.turnThisplayerToVector3D(_loc2_);
                     }
                  }
                  else
                  {
                     this.sendMoveGroundTo(_loc2_);
                  }
                  this.select(null);
               }
               break;
            case MouseManagerData.MOUSE_DOWN_AND_HOLD:
               if(_loc2_ != null)
               {
                  this.turnThisplayerToVector3D(_loc2_);
                  this.dragScrolling = false;
                  this.select(null);
               }
               break;
            case MouseManagerData.MOUSE_DOWN_AND_HOLD_ACTION:
               if(_loc2_ != null)
               {
                  this.sendMoveGroundTo(_loc2_);
                  this.dragScrolling = false;
                  this.select(null);
               }
         }
      }
      
      private function handleDrag(param1:MouseManagerData) : void
      {
         if(param1.type == MouseManagerData.MOUSE_MOVE)
         {
            return;
         }
         if(param1.type != MouseManagerData.START_DRAG && param1.type != MouseManagerData.DRAG && param1.type != MouseManagerData.STOP_DRAG)
         {
            return;
         }
         switch(param1.type)
         {
            case MouseManagerData.START_DRAG:
               if(!param1.mouseDownAndHold)
               {
                  this.mousePointer.scrollMode = true;
                  this.dragScrolling = true;
                  this.autoScroll = false;
                  return;
               }
               break;
            case MouseManagerData.STOP_DRAG:
               if(!param1.mouseDownAndHold)
               {
                  this.mousePointer.scrollMode = false;
                  this.dragScrolling = false;
                  return;
               }
               break;
            case MouseManagerData.DRAG:
               if(!param1.mouseDownAndHold && this.dragScrolling)
               {
                  this.isoengine.setScreenOffset(this.isoengine.screenrect.x - param1.deltaX / this._zoom,this.isoengine.screenrect.y - param1.deltaY / this._zoom,100,100);
                  return;
               }
               break;
         }
      }
      
      private function handleClickthroughMouseData_placeItem(param1:MouseManagerData) : void
      {
         if(!(this.inputModule is IsoObjectPlacerInput))
         {
            return;
         }
         var _loc2_:IsoObjectPlacerInput = this.inputModule as IsoObjectPlacerInput;
         switch(param1.type)
         {
            case MouseManagerData.MOUSE_MOVE:
               _loc2_.updatePlacerPosition();
               break;
            case MouseManagerData.CLICK:
               _loc2_.placeItem();
         }
      }
      
      private function handleClickthroughMouseData_menuOpen(param1:MouseManagerData) : void
      {
         if(param1.currentTarget != this.clickThroughTarget)
         {
            return;
         }
         switch(param1.type)
         {
            case MouseManagerData.CLICK:
               this.select(null);
         }
      }
      
      private function handleClickthroughMouseData_metroPlan(param1:MouseManagerData) : void
      {
         if(param1.type == MouseManagerData.CLICK)
         {
            this.metroPlanClosed();
         }
      }
      
      private function handleUniversalHelperMouseManagerData(param1:MouseManagerData) : void
      {
         if(param1.type == MouseManagerData.CLICK)
         {
            if(this.controlbar.universalHelper.hasNotify())
            {
               this.client.sendRequestHint();
            }
            else
            {
               this.showMILWKIT();
            }
         }
      }
      
      private function turnThisplayerToVector3D(param1:Vector3D) : void
      {
         if(this.thisplayer.isoobj == null)
         {
            return;
         }
         var _loc2_:Vector3D = param1.subtract(this.thisplayer.isoobj.uvz);
         this.sendPlayerDirection(IsoStar.computeDirection(_loc2_));
      }
      
      private function doPickTarget(param1:uint, param2:*) : Boolean
      {
         if(this.targetPicker && (this.targetPicker.selectionFlags & param1) != 0)
         {
            JSApi.onSelectTarget(param2,this.room.roomContextLabel,this.targetPicker.passthroughData);
            this.cancelTargetPicking();
            return true;
         }
         return false;
      }
      
      private function sendMoveGroundTo(param1:Vector3D) : void
      {
         if(!this.thisplayer)
         {
            return;
         }
         if(param1.x >= this.room.data.bounds.width || param1.y >= this.room.data.bounds.height || param1.z >= this.room.data.maxz)
         {
            return;
         }
         if(this.walkdest)
         {
            this.walkdest.setIsoPosition(param1.x,param1.y,param1.z);
            this.walkdest.playGoto();
         }
         this.client.sendMoveOnGroundTo(param1.x,param1.y,param1.z);
         this.autoScroll = true;
      }
      
      private function cleanupRoomHopPlan() : void
      {
         if(this.roomHopPlan)
         {
            this.layerManager.clearLayer(LayerManager.LAYER_ROOM_HOP_MAP);
            this.roomHopPlan.cleanup();
            this.roomHopPlan = null;
            InteractionManager.enableMouseForAll(true);
         }
      }
      
      private function initMetroPlan(param1:Array) : void
      {
         var _loc2_:Object = null;
         this.metroPlan.reset();
         this.metroPlan.walkToLocation = this.walkdest.getIsoPosition();
         for each(_loc2_ in param1)
         {
            this.metroPlan.addAreaSelector(_loc2_["context"],_loc2_["label"],_loc2_["name"],int(_loc2_["usercount"]));
         }
         this.metroPlan.setCurrentLocation(this.thisplayer,param1[0]["context"],param1[0]["label"]);
      }
      
      private function hideMetroPlan() : void
      {
         if(!this.metroPlan.visible)
         {
            return;
         }
         JSApi.onScreenClose();
         this.notifyManager.visible = true;
         Tweener.addTween(this.metroPlanContainer,{
            "_autoAlpha":0,
            "scaleX":0.125,
            "scaleY":0.125,
            "time":0.5,
            "onComplete":function():void
            {
               metroPlan.visible = false;
               metroPlan.reset();
               InteractionManager.disableMouseFor(metroPlan);
               WidgetManager.remove();
               WidgetManager.deactivateClickthrough();
            }
         });
      }
      
      private function centerMetroPlan() : void
      {
         this.metroPlanContainer.x = stage.stageWidth / 2;
         this.metroPlanContainer.y = stage.stageHeight / 2;
      }
      
      private function showMetroPlan() : void
      {
         if(this.metroPlan.visible || WidgetManager.hasClickThroughCallback())
         {
            return;
         }
         this.hideControls();
         this.cleanupRoomHopPlan();
         JSApi.onScreenOpen();
         this.notifyManager.visible = false;
         this.centerMetroPlan();
         this.metroPlan.visible = true;
         stage.focus = null;
         this.metroPlanContainer.scaleX = this.metroPlanContainer.scaleY = 0.125;
         this.metroPlanContainer.alpha = 0;
         InteractionManager.enableMouseFor(this.metroPlan);
         WidgetManager.setWidget(this.metroPlan);
         WidgetManager.activateClickthrough(this.handleClickthroughMouseData_metroPlan);
         Tweener.addTween(this.metroPlanContainer,{
            "_autoAlpha":1,
            "scaleX":1,
            "scaleY":1,
            "time":0.5,
            "transition":"easeOutBack"
         });
      }
      
      private function metroPlanClosed() : void
      {
         this.hideMetroPlan();
         this.showControls();
      }
      
      private function metroPlanGoto(param1:String, param2:Boolean) : void
      {
         this.client.sendAutoWalkTo(param1,false,param2);
         this.metroPlanClosed();
      }
      
      private function handleAudioToggled(param1:Boolean, param2:int) : void
      {
         this.audioSystem.setVolume(!!param1?Number(1):Number(0),param2);
         switch(param2)
         {
            case SoundTrack.SOUND_TYPE_EFF:
               if(this.ffhStream)
               {
                  this.ffhStream.setVolume(!!param1?Number(1):Number(0));
               }
               if(this.client != null)
               {
                  if(!param1)
                  {
                     this.client.sendSetStatus(Client.STAT_KEY_NOSOUND,null);
                  }
                  else
                  {
                     this.client.sendDeleteStatus(Client.STAT_KEY_NOSOUND);
                  }
               }
               this.flashCookies.setCookie(FlashCookies.KEY_ENABLE_EFFECTS,param1);
               break;
            case SoundTrack.SOUND_TYPE_AMB:
               this.flashCookies.setCookie(FlashCookies.KEY_ENABLE_MUSIC,param1);
         }
      }
      
      public function stageEnded(param1:String, param2:String, param3:String, param4:int, param5:Number) : void
      {
         this.amfApi.call(AmfApi.HANDLE_GAME_ENDED,null,null,[param1,param2,param3,param4,param5]);
      }
      
      private function updateWorldObjectData(param1:IWOBStatus, param2:Boolean, param3:uint) : void
      {
         var wob:IsoObjectContainer = null;
         var position:Position = null;
         var anim:CompositeAnimation = null;
         var path:Path = null;
         var wayPoints:Array = null;
         var wayPoint:WayPoint = null;
         var sound:SoundBlock = null;
         var coordsInRoom:Vector3D = null;
         var snd:Sound = null;
         var loopConfig:SoundConfig = null;
         var context:String = null;
         var flagargs:Object = null;
         var data:IWOBStatus = param1;
         var force:Boolean = param2;
         var delayedByMillis:uint = param3;
         wob = WOBRegistry.instance.getObjectByWobID(data.wobId);
         if(!wob)
         {
            return;
         }
         if(data.position)
         {
            anim = this.animationmanager.getCompositeAnimation(wob.isoobj);
            if(anim != null)
            {
               anim.movement = null;
            }
            position = data.position;
            wob.isoobj.uvz = new Vector3D(position.u,position.v,position.z);
            wob.isoobj.direction = position.direction;
            this.audioSystem.updateLocation(wob.soundID,wob.isoobj.uvz);
            if(wob.isoobj.sprite.isAdded)
            {
               this.isoengine.checkGrouping(wob.isoobj.sprite,true);
            }
            if(wob is Player)
            {
               (wob as Player).updateIsoOverlaysPosition();
            }
         }
         else if(data.path)
         {
            if(wob == this.thisplayer)
            {
               this.cleanupRoomHopPlan();
               this.hideMetroPlan();
               this.showControls();
            }
            path = data.path;
            wayPoints = path.wayPoints;
            if(path.age < path.duration)
            {
               position = path.startPosition;
               wob.isoobj.uvz = new Vector3D(position.u,position.v,position.z);
               this.audioSystem.updateLocation(wob.soundID,wob.isoobj.uvz);
               this.animationmanager.moveground(wob.isoobj,Utils.getMovementWayPoints(path),path.duration,path.age,this.room.data,wob);
               if(wob.isoobj.sprite.isAdded)
               {
                  this.isoengine.checkGrouping(wob.isoobj.sprite,true);
               }
            }
            else
            {
               wayPoint = wayPoints[wayPoints.length - 1];
               wob.isoobj.uvz = new Vector3D(wayPoint.position.u,wayPoint.position.v,wayPoint.position.z);
            }
         }
         else if(force)
         {
            if(this.animationmanager.getMovement(wob.isoobj))
            {
               this.animationmanager.getCompositeAnimation(wob.isoobj).movement = null;
            }
            else
            {
               wob.isoobj.uvz = new Vector3D();
               if(wob.isoobj.sprite.isAdded)
               {
                  this.isoengine.checkGrouping(wob.isoobj.sprite,true);
               }
               this.audioSystem.updateLocation(wob.soundID,wob.isoobj.uvz);
            }
         }
         if(data.animation)
         {
            if(wob is Player && (!(wob as Player).prerendered && !(wob as Player).renderparts))
            {
               wob.isoobj.animation = data.animation.name;
               this.queuedAnimations[wob] = {
                  "animation":data.animation,
                  "hasmovement":data.path != null,
                  "delayedByMillis":delayedByMillis,
                  "loadingStartedAt":getTimer()
               };
            }
            else
            {
               this.updateWOBAnimation(wob,data.animation,delayedByMillis);
            }
         }
         else if(force)
         {
            anim = this.animationmanager.getCompositeAnimation(wob.isoobj);
            if(anim)
            {
               anim.animation = null;
            }
            else
            {
               wob.isoobj.showDefaults();
            }
         }
         if(data.sound)
         {
            sound = data.sound;
            coordsInRoom = sound.coordsInRoom;
            if(coordsInRoom == null)
            {
               coordsInRoom = wob.isoobj.uvz;
            }
            if(sound.context == null)
            {
               snd = wob.isoobj.media.getSound(sound.label);
               if(snd)
               {
                  loopConfig = Utils.getSoundConfig(sound);
                  loopConfig.sound = snd;
                  this.playWOBSound(wob,loopConfig,coordsInRoom);
               }
            }
            else
            {
               ResourceManager.instance.requestSoundPack(param["medbaseurl"] + "." + sound.context,wob,function(param1:IsoObjectContainer, param2:MediaDataPack, param3:ResourceRequest):void
               {
                  var _loc4_:Sound = param2.getSound(sound.label);
                  if(!_loc4_)
                  {
                     return;
                  }
                  var _loc5_:SoundConfig = Utils.getSoundConfig(sound);
                  _loc5_.sound = _loc4_;
                  playWOBSound(wob,_loc5_,coordsInRoom);
               },function(param1:*, param2:*, param3:ResourceRequest):void
               {
               });
            }
         }
         else if(force)
         {
            if(!isNaN(wob.soundID))
            {
               delete this.trackidlookup[wob.soundID];
               this.audioSystem.stop(wob.soundID);
               wob.soundID = NaN;
            }
         }
         if(data.lightmap)
         {
            if(data.lightmap.intensities[0] == 0)
            {
               anim = this.animationmanager.getCompositeAnimation(wob.isoobj);
               if(anim != null && anim.lightAnimation)
               {
                  anim.lightAnimation = null;
               }
               wob.isoobj.lightmap = null;
            }
            else
            {
               context = data.lightmap.context;
               if(context != null && !wob.isoobj.media.hasDataPack(context))
               {
                  ResourceManager.instance.requestMediaPack(param["medbaseurl"] + "." + context,wob,function(param1:IsoObjectContainer, param2:MediaDataPack, param3:ResourceRequest):void
                  {
                     param1.isoobj.media.addDataPack(param2);
                     ResourceManager.instance.registerDataPackContainer(param1.isoobj.media,param2);
                     updateWOBLightmap(param1,data.lightmap);
                  },null);
               }
               else
               {
                  this.updateWOBLightmap(wob,data.lightmap);
               }
            }
         }
         if(data.effect)
         {
            this.loadAndCreateEffect(EffectData.fromNetEffectData(data.effect),wob.isoobj.sprite);
         }
         if(data.ghostTrail != null)
         {
            if(data.ghostTrail is GhosttrailData)
            {
               flagargs = new Object();
               flagargs[IsoGhost.STARTALPHA] = data.ghostTrail.startAlpha;
               flagargs[IsoGhost.ENDALPHA] = data.ghostTrail.endAlpha;
               flagargs[IsoGhost.DURATION] = data.ghostTrail.duration;
               flagargs[IsoGhost.STEPS] = data.ghostTrail.steps;
               flagargs[IsoGhost.COLOR] = data.ghostTrail.color;
               flagargs[IsoGhost.BLUR] = data.ghostTrail.blur;
               flagargs[IsoGhost.MODE] = data.ghostTrail.mode;
               flagargs[IsoGhost.UPDATEINTERVAL] = data.ghostTrail.updateInterval;
               wob.isoobj.setFlagArgs(IsoSprite.FLAG_GHOSTTRAIL,flagargs);
               wob.isoobj.flags = wob.isoobj.flags | IsoSprite.FLAG_GHOSTTRAIL;
            }
         }
      }
      
      private function loadAndCreateEffect(param1:EffectData, param2:IsoSprite) : void
      {
         var effectData:EffectData = param1;
         var target:IsoSprite = param2;
         var effectUrl:String = param["overlaybaseurl"] + "/effects/" + effectData.gui;
         if(!ResourceManager.instance.isLibraryLoaded(effectData.gui))
         {
            ResourceManager.instance.requestSwfLibrary(effectUrl,effectData.gui,function(param1:String, param2:DisplayObject, param3:ResourceRequest):void
            {
               createIsoSpriteEffect(effectData,target);
            },function(param1:String, param2:DisplayObject, param3:ResourceRequest):void
            {
            });
         }
         else
         {
            this.createIsoSpriteEffect(effectData,target);
         }
      }
      
      private function createIsoSpriteEffect(param1:EffectData, param2:IsoSprite) : void
      {
         var _loc4_:IsoEffectConfig = null;
         var _loc3_:IsoSpriteEffect = InstanceFactory.createInstanceOf("de.freggers.effects::" + param1.gui,IsoSpriteEffect) as IsoSpriteEffect;
         if(_loc3_ != null)
         {
            _loc4_ = param1.createConfig();
            param2.content.effects.add(param1.effectId,_loc3_,_loc4_);
            if(param2.isAdded)
            {
               param2.content.effects.initEffect(param1.effectId,param2.content);
               param2.content.effects.startEffect(param1.effectId);
            }
         }
      }
      
      private function playWOBSound(param1:IsoObjectContainer, param2:SoundConfig, param3:Vector3D) : void
      {
         var _loc4_:SoundLoop = new SoundLoop(param2);
         var _loc5_:SoundTrack = new SoundTrack([_loc4_],SoundTrack.SOUND_TYPE_EFF);
         _loc5_.type = SoundTrack.SOUND_TYPE_EFF;
         if(!isNaN(param1.soundID))
         {
            this.audioSystem.stop(param1.soundID);
            delete this.trackidlookup[param1.soundID];
            param1.soundID = NaN;
            if(param1 is Player)
            {
               param1.isoobj.displayflags = param1.isoobj.displayflags & ~IsoObjectSpriteContent.FLAG_ACTIVESOUND;
            }
         }
         param1.soundID = this.audioSystem.play(_loc5_,0,param3);
         this.trackidlookup[param1.soundID] = param1;
         if(param1 is Player && param1 != this.thisplayer)
         {
            param1.isoobj.displayflags = param1.isoobj.displayflags | IsoObjectSpriteContent.FLAG_ACTIVESOUND;
         }
      }
      
      private function updateWOBAnimation(param1:IsoObjectContainer, param2:AnimationData, param3:uint = 0) : void
      {
         var hadMovement:Boolean = false;
         var callback:Function = null;
         var request:ResourceRequest = null;
         var wob:IsoObjectContainer = param1;
         var animation:AnimationData = param2;
         var delayedByMillis:uint = param3;
         if(wob)
         {
         }
         hadMovement = false;
         if(this.queuedAnimations[wob] && this.queuedAnimations[wob]["hasmovement"])
         {
            hadMovement = true;
         }
         if(!(wob is Player) || !(wob as Player).isGhost)
         {
            ResourceManager.instance.cancel(wob.lastRequest);
         }
         delete this.queuedAnimations[wob];
         if(!wob.isoobj.media.hasDataPack(animation.datapack))
         {
            callback = function(param1:IsoObjectContainer, param2:ADataPack, param3:ResourceRequest):void
            {
               dataPackLoaded(param1,param2,param3);
               if(!hadMovement || animationmanager.getMovement(param1.isoobj))
               {
                  playAnimation(param1,animation.name,animation.keys);
               }
            };
            if(wob is Player)
            {
               request = ResourceManager.instance.requestPlayer(wob as Player,callback,animation.datapack,false);
            }
            else
            {
               request = ResourceManager.instance.requestIsoItem(wob as IsoItem,callback,animation.datapack);
            }
            if(request)
            {
            }
         }
         else
         {
            this.playAnimation(wob,animation.name,animation.keys);
         }
      }
      
      private function updateWOBLightmap(param1:IsoObjectContainer, param2:LightmapData) : void
      {
         param1.isoobj.lightmap = param2.label;
         if(param2.intensities.length == 1)
         {
            param1.isoobj.lightintensity = param2.intensities[0];
         }
         else
         {
            this.animationmanager.animateLight(param1.isoobj,param2.intensities,param2.durations,param2.loops,param2.mode,this.handleLightAnimationComplete);
         }
      }
      
      private function handleLightAnimationComplete(param1:IChangeable) : void
      {
         (param1.target as IsoObject).lightmap = null;
      }
      
      private function updateWorldObjectState(param1:IsoObjectContainer, param2:int, param3:Object, param4:Boolean, param5:Boolean = false) : void
      {
         var _loc7_:Object = null;
         if(!param1)
         {
            return;
         }
         param1.setState(param2,param4,param3);
         if(!(param1 is Player))
         {
            return;
         }
         var _loc6_:Player = param1 as Player;
         switch(param2)
         {
            case Client.STAT_KEY_NOSOUND:
               if(param1 == this.thisplayer && param4)
               {
               }
               break;
            case Client.STAT_KEY_SHRINK:
               if(!param5)
               {
                  this.requestRenderParts([_loc6_.userid]);
               }
               break;
            case Client.STAT_KEY_CARRYING:
               if(param4)
               {
                  _loc7_ = _loc6_.getState(Player.STATE_CARRYING);
                  this.pickUpObject(_loc6_,int(_loc7_["wobid"]),_loc7_["gui"],int(_loc7_["dir"]));
               }
               else
               {
                  this.dropObject(_loc6_);
               }
         }
      }
      
      private function handleWOBPropertiesChanged(param1:IsoObjectContainer, param2:Array, param3:Array) : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:Property = null;
         var _loc9_:Property = null;
         var _loc10_:* = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:EffectData = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         var _loc18_:Boolean = false;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Property = null;
         if(this.tooltipManager.target == param1)
         {
            this.tooltipManager.target = param1;
         }
         var _loc4_:Object = new Object();
         var _loc5_:Object = new Object();
         var _loc6_:Object = new Object();
         for each(_loc8_ in param2)
         {
            _loc7_ = false;
            for each(_loc9_ in param3)
            {
               if(_loc8_.name == _loc9_.name)
               {
                  if(_loc6_[_loc8_.name] == null)
                  {
                     _loc6_[_loc8_.name] = _loc8_.type == Property.TYPE_ITEM_STATE?_loc8_:_loc9_;
                  }
                  _loc7_ = true;
                  break;
               }
            }
            if(!_loc7_)
            {
               if(_loc4_[_loc8_.name] == null)
               {
                  _loc4_[_loc8_.name] = _loc8_;
               }
            }
         }
         for each(_loc9_ in param3)
         {
            _loc7_ = false;
            for each(_loc8_ in param2)
            {
               if(_loc8_.name == _loc9_.name)
               {
                  _loc7_ = true;
                  break;
               }
            }
            if(!_loc7_)
            {
               if(_loc5_[_loc9_.name] == null)
               {
                  _loc5_[_loc9_.name] = _loc9_;
               }
            }
         }
         _loc13_ = 0;
         for(_loc10_ in _loc5_)
         {
            _loc8_ = _loc5_[_loc10_];
            if(_loc8_.type == Property.TYPE_EFFECT)
            {
               param1.isoobj.sprite.content.effects.removeAndCancelLoading(_loc8_.effectId,_loc8_.effectGui);
            }
            else if(_loc8_.type == Property.TYPE_ITEM_STATE)
            {
               this.handlePropertyItemState(_loc8_,Property.ITEM_STATE_ACTION_DELETED);
            }
         }
         _loc15_ = 0;
         _loc16_ = 30;
         _loc18_ = false;
         _loc19_ = getTimer() * 1000;
         _loc20_ = 0;
         for(_loc10_ in _loc6_)
         {
            _loc8_ = _loc6_[_loc10_];
            if(_loc8_.type == Property.TYPE_EFFECT)
            {
               _loc11_ = PropertyConfig.displayStringToObject(_loc8_.display);
               _loc15_ = 0;
               _loc16_ = 30;
               _loc17_ = null;
               _loc18_ = false;
               if(_loc11_["_duration_"] != null)
               {
                  _loc15_ = int(_loc11_["_duration_"]);
                  delete _loc11_["_duration_"];
               }
               if(_loc11_["_updateInterval_"] != null)
               {
                  _loc15_ = int(_loc11_["_updateInterval_"]);
                  delete _loc11_["_updateInterval_"];
               }
               if(_loc11_["_gui_"] != null)
               {
                  _loc17_ = _loc11_["_gui_"];
                  delete _loc11_["_gui_"];
               }
               if(_loc11_["_loop_"] != null && _loc11_["_loop_"] == "true")
               {
                  _loc18_ = true;
                  delete _loc11_["_loop_"];
               }
               _loc21_ = param1.getProperty(_loc10_);
               if(_loc8_.value == _loc21_.value)
               {
                  _loc21_.setEffectIdentity(_loc8_.effectId,_loc8_.effectGui);
               }
               else
               {
                  param1.isoobj.sprite.content.effects.removeAndCancelLoading(_loc8_.effectId,_loc8_.effectGui);
                  _loc14_ = new EffectData(_loc17_,_loc15_,_loc16_,_loc18_);
                  _loc14_.effectId = _loc19_ + _loc20_;
                  _loc11_["__propertyValue__"] = _loc21_.value;
                  _loc14_.userData = _loc11_;
                  _loc21_.setEffectIdentity(_loc14_.effectId,_loc14_.gui);
                  this.loadAndCreateEffect(_loc14_,param1.isoobj.sprite);
                  _loc20_++;
               }
            }
            else if(_loc8_.type == Property.TYPE_ITEM_STATE)
            {
               this.handlePropertyItemState(_loc8_,Property.ITEM_STATE_ACTION_KEEP);
            }
         }
         for(_loc10_ in _loc4_)
         {
            _loc8_ = _loc4_[_loc10_];
            if(_loc8_.type == Property.TYPE_EFFECT)
            {
               _loc11_ = PropertyConfig.displayStringToObject(_loc8_.display);
               _loc15_ = 0;
               _loc16_ = 30;
               _loc17_ = null;
               _loc18_ = false;
               if(_loc11_["_duration_"] != null)
               {
                  _loc15_ = int(_loc11_["_duration_"]);
                  delete _loc11_["_duration_"];
               }
               if(_loc11_["_updateInterval_"] != null)
               {
                  _loc15_ = int(_loc11_["_updateInterval_"]);
                  delete _loc11_["_updateInterval_"];
               }
               if(_loc11_["_gui_"] != null)
               {
                  _loc17_ = _loc11_["_gui_"];
                  delete _loc11_["_gui_"];
               }
               if(_loc11_["_loop_"] != null && _loc11_["_loop_"] == "true")
               {
                  _loc18_ = true;
                  delete _loc11_["_loop_"];
               }
               _loc14_ = new EffectData(_loc17_,_loc15_,_loc16_,_loc18_);
               _loc14_.effectId = _loc19_ + _loc20_;
               param1.getProperty(_loc10_).setEffectIdentity(_loc14_.effectId,_loc14_.gui);
               _loc11_["__propertyValue__"] = _loc8_.value;
               _loc14_.userData = _loc11_;
               this.loadAndCreateEffect(_loc14_,param1.isoobj.sprite);
               _loc20_++;
            }
            else if(_loc8_.type == Property.TYPE_ITEM_STATE)
            {
               this.handlePropertyItemState(_loc8_,Property.ITEM_STATE_ACTION_CREATED);
            }
         }
      }
      
      private function initWorldObjectStates(param1:IsoObjectContainer, param2:Array) : void
      {
         if(!param1 || !param2)
         {
            return;
         }
         param1.clearStates();
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_])
            {
               this.updateWorldObjectState(param1,_loc3_,param2[_loc3_],true,true);
            }
            _loc3_++;
         }
         param1.applyStates();
      }
      
      private function handlePropertyItemState(param1:Property, param2:String = "keep") : void
      {
         if(param1 && param1.type == Property.TYPE_ITEM_STATE)
         {
            if(param1.name == "ffh_radio_state")
            {
               if(this.ffhStream)
               {
                  if(param2 == Property.ITEM_STATE_ACTION_DELETED && param1.value == "on" || param2 == Property.ITEM_STATE_ACTION_KEEP && param1.value == "off")
                  {
                     this.ffhStream.stopStream();
                  }
                  else if(param1.value == "on")
                  {
                     this.ffhStream.startStream();
                  }
               }
            }
         }
      }
      
      private function throwItem(param1:Vector3D, param2:Vector3D, param3:uint, param4:uint, param5:String, param6:GhosttrailData = null, param7:EffectData = null) : void
      {
         if(!param2 || !param1)
         {
            return;
         }
         var _loc8_:String = ResourceManager.instance.getPortableItemUrl(param5,"_t");
         var _loc9_:ThrowData = new ThrowData(param1,param2,param3,param4,param5,param6,param7);
         if(_loc8_)
         {
            ResourceManager.instance.requestImageData(_loc8_,_loc9_,this.__cb_throwItem_iconLoaded,this.__cb_ti_iconLoadingFailed);
         }
      }
      
      private function __cb_throwItem_iconLoaded(param1:ThrowData, param2:BABitmapDataContainer, param3:ResourceRequest) : void
      {
         var end:Function = null;
         var flagargs:Object = null;
         var throwData:ThrowData = param1;
         var imageContainer:BABitmapDataContainer = param2;
         var request:ResourceRequest = param3;
         if(throwData.endeffect)
         {
            end = function(param1:IChangeable):void
            {
               var amm:IChangeable = param1;
               amm.ref.flags = amm.ref.flags & ~IsoSprite.FLAG_SKIP_GROUPCHECK;
               isoengine.checkGrouping(amm.ref as IsoSortable,true);
               amm.ref.content.displayObject.visible = false;
               amm.ref.shadow.visible = false;
               var effecturl:String = param["overlaybaseurl"] + "/effects/" + throwData.endeffect.gui;
               var isoSprite:IsoSprite = amm.ref;
               throwData.endeffect.userData = isoSprite;
               throwData.endeffect.onCompleteCallback = function(param1:IsoSpriteEffect):void
               {
                  isoengine.remove(param1.userData);
               };
               loadAndCreateEffect(throwData.endeffect,isoSprite);
            };
         }
         else
         {
            end = function(param1:IChangeable):void
            {
               isoengine.remove(param1.ref);
            };
         }
         var bmd:BitmapData = imageContainer.bitmapData;
         var content:IsoSpriteBitmapDataContent = new IsoSpriteBitmapDataContent(bmd);
         var side_units:uint = Math.ceil(bmd.width * IsoGrid.upt / IsoGrid.tile_width);
         var height_units:uint = Math.ceil(IsoGrid.height2units(bmd.height));
         var missile:AnimationSprite = new AnimationSprite(content,side_units,side_units,height_units,function():void
         {
            var _loc1_:* = throwData.targetlocation;
            animationmanager.moveThrowHorizontal(this,[new MovementWayPoint(this.isoU,this.isoV,this.isoZ,0),new MovementWayPoint(this.isoU,this.isoV,this.isoZ + throwData.height,throwData.duration / 2),new MovementWayPoint(_loc1_.x,_loc1_.y,_loc1_.z,throwData.duration / 2)],throwData.duration,null,this,end);
         });
         missile.isoparent = this.isoengine;
         var flags:uint = IsoSprite.FLAG_SHADOW | IsoSprite.FLAG_SKIP_GROUPCHECK | IsoSortable.FLAG_NO_COLLISION;
         if(throwData.ghosttrail)
         {
            flags = flags | IsoSprite.FLAG_GHOSTTRAIL;
            flagargs = new Object();
            flagargs[IsoGhost.STARTALPHA] = throwData.ghosttrail.startAlpha;
            flagargs[IsoGhost.ENDALPHA] = throwData.ghosttrail.endAlpha;
            flagargs[IsoGhost.DURATION] = throwData.ghosttrail.duration;
            flagargs[IsoGhost.STEPS] = throwData.ghosttrail.steps;
            flagargs[IsoGhost.COLOR] = throwData.ghosttrail.color;
            flagargs[IsoGhost.BLUR] = throwData.ghosttrail.blur;
            flagargs[IsoGhost.MODE] = throwData.ghosttrail.mode;
            flagargs[IsoGhost.UPDATEINTERVAL] = throwData.ghosttrail.updateInterval;
            missile.setFlagArgs(IsoSprite.FLAG_GHOSTTRAIL,flagargs);
         }
         missile.flags = flags;
         missile.setIsoPosition(throwData.sourcelocation.x,throwData.sourcelocation.y,throwData.sourcelocation.z);
         this.isoengine.add(missile);
      }
      
      private function __cb_ti_iconLoadingFailed(param1:Object, param2:BABitmapDataContainer, param3:ResourceRequest) : void
      {
      }
      
      private function handleZoom(param1:Boolean) : void
      {
         if(param1)
         {
            this.zoomIn();
         }
         else
         {
            this.zoomOut();
         }
      }
      
      public function set zoom(param1:Number) : void
      {
         if(this.isoengine == null)
         {
            return;
         }
         var _loc2_:Rectangle = this.isoengine.screenrect;
         var _loc3_:Number = _loc2_.x;
         var _loc4_:Number = _loc2_.y;
         var _loc5_:Number = _loc3_ + _loc2_.width / 2;
         var _loc6_:Number = _loc4_ + _loc2_.height / 2;
         this._zoom = param1;
         this.isoengine.handleResize(stage.stageWidth / this._zoom,stage.stageHeight / this._zoom);
         var _loc7_:Number = _loc5_ - this.isoengine.screenrect.width / 2;
         var _loc8_:Number = _loc6_ - this.isoengine.screenrect.height / 2;
         this.isoengine.scaleX = this.isoengine.scaleY = this._zoom;
         var _loc9_:Number = _loc7_ - _loc3_;
         var _loc10_:Number = _loc8_ - _loc4_;
         this.isoengine.setScreenOffset(_loc7_,_loc8_);
      }
      
      public function get zoom() : Number
      {
         return this._zoom;
      }
      
      private function zoomIn() : void
      {
         this._zoommode = ZOOM_IN;
         Tweener.addTween(this,{
            "zoom":this.ZOOM_IN_VALUE,
            "time":ZOOM_DURATION / 1000,
            "transition":"easeOutBack",
            "onComplete":this.__zoomInComplete,
            "skipUpdates":2
         });
      }
      
      private function zoomOut() : void
      {
         this._zoommode = ZOOM_OUT;
         Tweener.addTween(this,{
            "zoom":this.ZOOM_OUT_VALUE,
            "time":ZOOM_DURATION / 1000,
            "transition":"easeOutCirc",
            "onComplete":this.__zoomOutComplete,
            "skipUpdates":2
         });
      }
      
      private function toggleZoom() : void
      {
         if(this.isoengine == null)
         {
            return;
         }
         if(this._zoom == this.ZOOM_OUT_VALUE || this._zoommode == ZOOM_OUT)
         {
            this.zoomIn();
         }
         else if(this._zoom == this.ZOOM_IN_VALUE || this._zoommode == ZOOM_IN)
         {
            this.zoomOut();
         }
      }
      
      private function __zoomInComplete() : void
      {
         this._zoomIn = true;
         this._zoommode = ZOOM_DONE;
      }
      
      private function __zoomOutComplete() : void
      {
         this._zoomIn = false;
         this._zoommode = ZOOM_DONE;
      }
   }
}
