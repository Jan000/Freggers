package de.freggers.roomdisplay
{
   import de.freggers.audio.AudioSystem;
   import de.freggers.audio.SoundTrack;
   import de.freggers.data.MapDataV1;
   import de.freggers.isostar.IsoGrid;
   import de.freggers.isostar.IsoSortable;
   import de.freggers.isostar.IsoSortableGroup;
   import de.freggers.isostar.IsoSprite;
   import de.freggers.isostar.IsoStar;
   import de.freggers.roomlib.IsoItem;
   import de.freggers.roomlib.IsoObjectContainer;
   import de.freggers.roomlib.Room;
   import de.freggers.roomlib.util.ResourceManager;
   import de.freggers.roomlib.util.WOBRegistry;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import de.freggers.util.Stats;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.system.System;
   import flash.utils.Dictionary;
   
   public class Debugger extends Sprite
   {
      
      private static const SIN30_div_COS30_mult_SQRT2:Number = IsoGrid.SIN30 * Math.SQRT2 / IsoGrid.COS30;
      
      public static const CFG_MESSAGE_MANAGER:String = "messageManager";
      
      public static const CFG_AUDIO_SYSTEM:String = "audioSystem";
      
      public static const CFG_ISO_ENGINE:String = "isoEngine";
      
      public static const CFG_CURRENT_ROOM:String = "currentRoom";
      
      private static const MAP_TYPE_NONE:int = -1;
      
      private static const MAP_TYPE_COLLISION:int = 0;
      
      private static const MAP_TYPE_LIGHT:int = 1;
      
      private static const MAP_TYPE_HEIGHTSLICE:int = 2;
      
      private static const MAP_TYPE_HEAT:int = 3;
      
      private static const MIN_UPDATE_INTERVAL:int = 33;
       
      
      private var _commandTree:Dictionary;
      
      private var _config:Object;
      
      private var _stats:Stats;
      
      private var _currentMap:Bitmap;
      
      private var _currentMapType:int = -1;
      
      private var _mapData:BitmapData;
      
      private var _lastUpdateAt:int = 0;
      
      private var _currentIsoSprite:IsoSprite;
      
      private var pointEquals:Function;
      
      public function Debugger()
      {
         this.pointEquals = function(param1:Point, param2:int, param3:Vector.<Point>):Boolean
         {
            return (this as Point).equals(param1);
         };
         super();
         this.initCommands();
      }
      
      public static function booleanValue(param1:String) : Boolean
      {
         if(param1 == "0" || param1 == "false")
         {
            return false;
         }
         return true;
      }
      
      private function initCommands() : void
      {
         this._commandTree = new Dictionary();
         var _loc1_:Dictionary = new Dictionary();
         this._commandTree["set"] = _loc1_;
         var _loc2_:Dictionary = new Dictionary();
         _loc1_["shadow"] = _loc2_;
         _loc2_["color"] = new CommandDef("shadow",null,this.setShadowColor);
         _loc2_["alpha"] = new CommandDef("shadow",null,this.setShadowAlpha);
         _loc2_["scale"] = new CommandDef("shadow",null,this.setShadowScale);
         _loc1_["hardshadow"] = new CommandDef("hardshadow",null,this.setHardShadow);
         _loc1_["volume"] = new CommandDef("volume",null,this.setGlobalVolume);
         _loc2_ = new Dictionary();
         _loc1_["map"] = _loc2_;
         _loc2_["scale"] = new CommandDef("map",null,this.setMapScale);
         _loc2_ = new Dictionary();
         _loc1_["item"] = _loc2_;
         _loc2_["alpha"] = new CommandDef("item",null,this.setItemAlpha);
         _loc2_["light"] = new CommandDef("light",null,this.setLightsEnabled);
         _loc2_["lightmap"] = new CommandDef("item",null,this.setItemLightmap);
         _loc2_ = new Dictionary();
         _loc1_["daylight"] = new CommandDef("brightness",null,this.setRoomBrightness);
         var _loc3_:Dictionary = new Dictionary();
         this._commandTree["show"] = _loc3_;
         _loc3_["version"] = new CommandDef("version",null,this.showVersion);
         _loc3_["collisionmap"] = new CommandDef("collisionmap",null,this.showCollisionMap);
         _loc3_["resstats"] = new CommandDef("resstats",null,this.showResourceStats);
         _loc3_["stats"] = new CommandDef("stats",null,this.showStats);
         _loc3_["lightmap"] = new CommandDef("lightmap",null,this.showLightmap);
         _loc3_["heightslicemap"] = new CommandDef("heightslicemap",null,this.showHeightSliceMap);
         _loc3_["heatmap"] = new CommandDef("heatmap",null,this.showHeatMap);
         var _loc4_:Dictionary = new Dictionary();
         this._commandTree["call"] = _loc4_;
         _loc4_["gc"] = new CommandDef("gc",null,this.callGC);
      }
      
      public function cleanupContext() : void
      {
         this._config = null;
      }
      
      public function init(param1:Object) : void
      {
         var _loc2_:IsoStar = null;
         this._config = param1;
         if(this._currentMapType != MAP_TYPE_NONE)
         {
            _loc2_ = this._config[CFG_ISO_ENGINE];
            if(_loc2_)
            {
               switch(this._currentMapType)
               {
                  case MAP_TYPE_COLLISION:
                     this.prepareCollisionMap(_loc2_);
                     this.showMap(this._mapData,MAP_TYPE_COLLISION);
                     break;
                  case MAP_TYPE_LIGHT:
                     this.showMap(_loc2_.lightmapData,this._currentMapType);
               }
            }
         }
      }
      
      public function set currentIsoSprite(param1:IsoSprite) : void
      {
         this._currentIsoSprite = param1;
      }
      
      public function cleanup() : void
      {
         if(this._stats)
         {
            removeChild(this._stats);
            this._stats = null;
         }
         if(this._currentMap)
         {
            removeChild(this._currentMap);
            this._currentMap = null;
         }
         if(this._mapData)
         {
            this._mapData.dispose();
            this._mapData = null;
         }
         this.cleanupContext();
      }
      
      public function postMessage(param1:String, param2:String = "Debug") : Boolean
      {
         var _loc4_:TextBar = null;
         var _loc3_:MessageManager = this._config[CFG_MESSAGE_MANAGER];
         if(_loc3_)
         {
            _loc4_ = new TextBar(null,new FormattedMessage("{0} {1}",[param2,param1],[FormattedMessage.STYLE_LINK,FormattedMessage.STYLE_NORMAL]),TextBar.MSG_SRV);
            _loc3_.addMessage(0,null,"DEBUGGER",_loc4_,new Point(_loc3_.stage.stageWidth / 2,_loc3_.stage.stageHeight),MessageManager.MODE_NORMAL,false);
            return true;
         }
         return false;
      }
      
      private function getCommandDef(param1:String, param2:Array) : CommandDef
      {
         if(!param1 || !param2)
         {
            return null;
         }
         var _loc3_:CommandDef = null;
         var _loc4_:Object = this._commandTree[param1];
         if(_loc4_ is CommandDef)
         {
            return _loc4_ as CommandDef;
         }
         if(!_loc4_)
         {
            return null;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            _loc4_ = _loc4_[param2[_loc5_]];
            if(!_loc4_)
            {
               break;
            }
            if(_loc4_ is CommandDef)
            {
               _loc3_ = _loc4_ as CommandDef;
               break;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function processCommand(param1:String, param2:Array) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         if(!this._config)
         {
            return false;
         }
         var _loc3_:CommandDef = this.getCommandDef(param1,param2);
         if(_loc3_)
         {
            _loc4_ = param1 + " " + param2.join(" ");
            _loc5_ = _loc3_.execute(param2);
            this.postMessage(_loc4_ + " " + (!!_loc5_?"[success]":"[failed]"));
            return _loc5_;
         }
         return false;
      }
      
      private function showVersion(param1:Array) : Boolean
      {
         return this.postMessage("Client version " + RoomDisplay.VERSION);
      }
      
      private function setGlobalVolume(param1:Array) : Boolean
      {
         var _loc2_:AudioSystem = this._config[CFG_AUDIO_SYSTEM];
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:Number = Number(param1[1]);
         if(!isNaN(_loc3_))
         {
            _loc2_.setVolume(_loc3_,SoundTrack.SOUND_TYPE_AMB | SoundTrack.SOUND_TYPE_EFF);
            return true;
         }
         return false;
      }
      
      private function setShadowColor(param1:Array) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:IsoObjectContainer = null;
         var _loc2_:Array = WOBRegistry.instance.getWobIds();
         var _loc3_:int = parseInt(param1[2],16);
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = WOBRegistry.instance.getObjectByWobID(_loc4_);
            if(_loc5_.isoobj.sprite.isAdded && _loc5_.isoobj.sprite.shadow != null)
            {
               _loc5_.isoobj.sprite.shadow.color = _loc3_;
            }
         }
         return true;
      }
      
      private function setShadowAlpha(param1:Array) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:IsoObjectContainer = null;
         var _loc2_:Array = WOBRegistry.instance.getWobIds();
         var _loc3_:Number = Number(param1[2]);
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = WOBRegistry.instance.getObjectByWobID(_loc4_);
            if(_loc5_.isoobj.sprite.isAdded && _loc5_.isoobj.sprite.shadow != null)
            {
               _loc5_.isoobj.sprite.shadow.brightness = _loc3_;
            }
         }
         return true;
      }
      
      private function setShadowScale(param1:Array) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:IsoObjectContainer = null;
         var _loc2_:Array = WOBRegistry.instance.getWobIds();
         var _loc3_:Number = Number(param1[2]);
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = WOBRegistry.instance.getObjectByWobID(_loc4_);
            if(_loc5_.isoobj.sprite.isAdded && _loc5_.isoobj.sprite.shadow != null)
            {
               _loc5_.isoobj.sprite.shadow.scale = _loc3_;
            }
         }
         return true;
      }
      
      private function setHardShadow(param1:Array) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:IsoObjectContainer = null;
         var _loc2_:Array = WOBRegistry.instance.getWobIds();
         var _loc3_:Boolean = booleanValue(param1[1]);
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = WOBRegistry.instance.getObjectByWobID(_loc4_);
            if(_loc5_.isoobj.sprite.isAdded && _loc5_.isoobj.sprite.shadow != null)
            {
               _loc5_.isoobj.sprite.shadow.isHard = _loc3_;
            }
         }
         return true;
      }
      
      private function setLightsEnabled(param1:Array) : Boolean
      {
         var _loc2_:IsoStar = this._config[CFG_ISO_ENGINE];
         if(!_loc2_)
         {
            return false;
         }
         _loc2_.lightsEnabled = booleanValue(param1[2]);
         return true;
      }
      
      private function setItemAlpha(param1:Array) : Boolean
      {
         var _loc2_:Number = Number(param1[2]);
         var _loc3_:Array = WOBRegistry.instance.getIsoItems();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            (_loc3_[_loc4_] as IsoItem).isoobj.alpha = _loc2_;
            _loc4_++;
         }
         return true;
      }
      
      private function setItemLightmap(param1:Array) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:IsoObjectContainer = null;
         var _loc2_:String = param1[2];
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:String = param1[3];
         if(!_loc3_ || _loc3_ == "none")
         {
            _loc3_ = null;
         }
         var _loc4_:Array = WOBRegistry.instance.getWobIds();
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = WOBRegistry.instance.getObjectByWobID(_loc5_);
            if(_loc6_.gui && _loc6_.gui.indexOf(_loc2_) >= 0)
            {
               _loc6_.isoobj.lightmap = _loc3_;
               _loc6_.isoobj.lightintensity = !!_loc3_?Number(100):Number(0);
            }
         }
         return true;
      }
      
      private function setRoomBrightness(param1:Array) : Boolean
      {
         var _loc3_:Room = null;
         var _loc2_:int = int(param1[1]);
         if(this._config[CFG_CURRENT_ROOM])
         {
            _loc3_ = this._config[CFG_CURRENT_ROOM] as Room;
         }
         if(_loc3_ != null)
         {
            _loc3_.brightness = _loc2_;
            return true;
         }
         return false;
      }
      
      private function showCollisionMap(param1:Array) : Boolean
      {
         var _loc2_:IsoStar = this._config[CFG_ISO_ENGINE];
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:Boolean = booleanValue(param1[1]) && this._currentMapType != MAP_TYPE_COLLISION;
         if(_loc3_)
         {
            this.prepareCollisionMap(_loc2_);
            this.showMap(this._mapData,MAP_TYPE_COLLISION);
            return true;
         }
         if(this._currentMapType == MAP_TYPE_COLLISION)
         {
            this.showMap(null,MAP_TYPE_NONE);
            this._mapData.dispose();
            this._mapData = null;
            return true;
         }
         return false;
      }
      
      private function prepareCollisionMap(param1:IsoStar) : void
      {
         if(this._mapData)
         {
            this._mapData.dispose();
         }
         this._mapData = new BitmapData(param1.level.bounds.width,param1.level.bounds.height,true,0);
      }
      
      private function prepareHeightSliceMap() : void
      {
         if(this._mapData)
         {
            this._mapData.dispose();
            this._mapData = null;
         }
         this._mapData = new BitmapData(1,1,false,0);
      }
      
      private function updateCollisionMap() : void
      {
         var _loc3_:IsoSprite = null;
         var _loc4_:uint = 0;
         var _loc6_:IsoSortable = null;
         var _loc8_:BitmapData = null;
         if(!this._mapData || !this._config)
         {
            return;
         }
         var _loc1_:IsoStar = this._config[CFG_ISO_ENGINE];
         if(!_loc1_)
         {
            return;
         }
         this._mapData.fillRect(this._mapData.rect,0);
         var _loc2_:Vector.<IsoSortable> = _loc1_.sprites;
         var _loc5_:Rectangle = new Rectangle();
         var _loc7_:BitmapData = _loc1_.level.collisionmap;
         this._mapData.copyPixels(_loc7_,_loc7_.rect,_loc7_.rect.topLeft);
         this.drawGrid(_loc1_);
         this.drawIsoSortableGroup(_loc1_,this._mapData);
         for each(_loc6_ in _loc2_)
         {
            _loc3_ = _loc6_ as IsoSprite;
            if(_loc3_)
            {
               _loc5_.x = _loc3_.min_u;
               _loc5_.y = _loc3_.min_v;
               _loc5_.width = _loc3_.subgripbounds.width;
               _loc5_.height = _loc3_.subgripbounds.height;
               if((_loc3_.flags & IsoSortable.FLAG_NO_COLLISION) != 0)
               {
                  _loc4_ = 1442840320;
               }
               else
               {
                  _loc4_ = 1442775040;
               }
               _loc8_ = new BitmapData(_loc5_.width,_loc5_.height,true,0);
               _loc8_.fillRect(_loc8_.rect,_loc4_);
               this._mapData.copyPixels(_loc8_,_loc8_.rect,_loc5_.topLeft,null,null,true);
               _loc8_.dispose();
            }
         }
         for each(_loc6_ in _loc2_)
         {
            _loc3_ = _loc6_ as IsoSprite;
            if(_loc3_)
            {
               _loc5_.x = _loc3_.min_u - _loc3_.subgripbounds.x;
               _loc5_.y = _loc3_.min_v - _loc3_.subgripbounds.y;
               _loc5_.width = _loc3_.gripbounds.width;
               _loc5_.height = _loc3_.gripbounds.height;
               if((_loc3_.flags & IsoSortable.FLAG_NO_COLLISION) != 0)
               {
                  _loc4_ = 4288256256;
               }
               else
               {
                  _loc4_ = 4288217088;
               }
               _loc8_ = _loc3_.grip.clone();
               _loc8_.threshold(_loc8_,_loc8_.rect,_loc8_.rect.topLeft,"!=",0,_loc4_);
               this._mapData.copyPixels(_loc8_,_loc8_.rect,_loc5_.topLeft,null,null,true);
               _loc8_.dispose();
            }
         }
         this.drawRoomMaskMap(_loc1_);
         this.drawCurrentIsoSprite();
      }
      
      private function showHeatMap(param1:Array) : Boolean
      {
         var _loc2_:IsoStar = this._config[CFG_ISO_ENGINE];
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:Boolean = booleanValue(param1[1]) && this._currentMapType != MAP_TYPE_HEAT;
         if(_loc3_)
         {
            this.prepareHeatMap(_loc2_);
            this.showMap(this._mapData,MAP_TYPE_HEAT);
            return true;
         }
         if(this._currentMapType == MAP_TYPE_HEAT)
         {
            this.showMap(null,MAP_TYPE_NONE);
            this._mapData.dispose();
            this._mapData = null;
            return true;
         }
         return false;
      }
      
      private function prepareHeatMap(param1:IsoStar) : void
      {
         if(this._mapData)
         {
            this._mapData.dispose();
         }
         this._mapData = new BitmapData(param1.level.bounds.width,param1.level.bounds.height,false,0);
         var _loc2_:BitmapData = param1.level.collisionmap;
         _loc2_.threshold(_loc2_,_loc2_.rect,_loc2_.rect.topLeft,"==",4278190080,4282137660);
         this._mapData.copyPixels(_loc2_,_loc2_.rect,_loc2_.rect.topLeft);
      }
      
      private function updateHeatMap() : void
      {
         var _loc3_:IsoSortable = null;
         var _loc4_:IsoSprite = null;
         var _loc9_:BitmapData = null;
         if(!this._mapData || !this._config)
         {
            return;
         }
         var _loc1_:IsoStar = this._config[CFG_ISO_ENGINE];
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Vector.<IsoSortable> = _loc1_.sprites;
         var _loc5_:Point = new Point();
         var _loc6_:uint = 10;
         var _loc7_:Shape = new Shape();
         _loc7_.graphics.beginFill(16711680,0.05);
         _loc7_.graphics.drawCircle(3,3,3);
         _loc7_.graphics.endFill();
         var _loc8_:BitmapData = new BitmapData(_loc7_.width,_loc7_.height,true,0);
         _loc8_.draw(_loc7_);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ is IsoSprite)
            {
               _loc4_ = _loc3_ as IsoSprite;
               if((_loc4_.flags & IsoSortable.FLAG_NO_COLLISION) != 0)
               {
                  _loc5_.x = _loc4_.isoU - 1;
                  _loc5_.y = _loc4_.isoV - 1;
                  this._mapData.copyPixels(_loc8_,_loc8_.rect,_loc5_,null,null,true);
               }
               else
               {
                  _loc9_ = _loc4_.grip.clone();
                  _loc9_.threshold(_loc9_,_loc9_.rect,_loc9_.rect.topLeft,"==",4278190080,100663040);
                  _loc5_.x = _loc4_.isoU - _loc4_.gripbounds.width / 2;
                  _loc5_.y = _loc4_.isoV - _loc4_.gripbounds.height / 2;
                  this._mapData.copyPixels(_loc9_,_loc9_.rect,_loc5_,null,null,true);
                  _loc9_.dispose();
               }
            }
         }
         _loc8_.dispose();
      }
      
      private function drawIsoSortableGroup(param1:IsoSortableGroup, param2:BitmapData) : void
      {
         if(!param2 || !param1)
         {
            return;
         }
         var _loc3_:Rectangle = new Rectangle(param1.min_u,param1.min_v,param1.max_u - param1.min_u + 1,param1.max_v - param1.min_v + 1);
         var _loc4_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height,true,0);
         _loc4_.fillRect(_loc4_.rect,570425344);
         param2.copyPixels(_loc4_,_loc4_.rect,_loc3_.topLeft,null,null,true);
         _loc4_.dispose();
         _loc4_ = null;
         var _loc5_:Vector.<IsoSortable> = param1.isosortablegroups;
         if(!_loc5_ || _loc5_.length == 0)
         {
            return;
         }
         for each(param1 in _loc5_)
         {
            this.drawIsoSortableGroup(param1,param2);
         }
      }
      
      private function showResourceStats(param1:Array) : Boolean
      {
         ResourceManager.instance.dumpStats();
         this.postMessage("Resource statistics written on the debug output.");
         return true;
      }
      
      private function showStats(param1:Array) : Boolean
      {
         var _loc2_:IsoStar = this._config[CFG_ISO_ENGINE];
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:Boolean = booleanValue(param1[1]) && this._stats == null;
         if(_loc3_)
         {
            this._stats = new Stats();
            addChild(this._stats);
         }
         else
         {
            this._stats.cleanup();
            removeChild(this._stats);
            this._stats = null;
         }
         return true;
      }
      
      private function showLightmap(param1:Array) : Boolean
      {
         var _loc2_:IsoStar = this._config[CFG_ISO_ENGINE];
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:Boolean = booleanValue(param1[1]) && this._currentMapType != MAP_TYPE_LIGHT;
         if(_loc3_)
         {
            this.showMap(_loc2_.lightmapData,MAP_TYPE_LIGHT);
            return true;
         }
         if(this._currentMapType == MAP_TYPE_LIGHT)
         {
            this.showMap(null,MAP_TYPE_NONE);
            return true;
         }
         return false;
      }
      
      private function setMapScale(param1:Array) : Boolean
      {
         if(!this._currentMap)
         {
            return false;
         }
         var _loc2_:Number = Number(param1[2]);
         if(!isNaN(_loc2_) && _loc2_ > 0)
         {
            this._currentMap.scaleX = _loc2_;
            this._currentMap.scaleY = _loc2_;
         }
         return false;
      }
      
      private function showMap(param1:BitmapData, param2:int) : void
      {
         if(!param1)
         {
            if(param2 != MAP_TYPE_NONE)
            {
               this.postMessage("Failed to display map: no map data is currently available");
            }
            if(this._currentMap)
            {
               removeChild(this._currentMap);
               this._currentMap = null;
            }
            this._currentMapType = MAP_TYPE_NONE;
         }
         else
         {
            if(!this._currentMap)
            {
               this._currentMap = new Bitmap();
               addChild(this._currentMap);
            }
            this._currentMap.opaqueBackground = 12829635;
            this._currentMap.bitmapData = param1;
            this._currentMapType = param2;
         }
      }
      
      private function showHeightSliceMap(param1:Array) : Boolean
      {
         var _loc2_:IsoStar = this._config[CFG_ISO_ENGINE];
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:Boolean = booleanValue(param1[1]);
         if(_loc3_)
         {
            this.prepareHeightSliceMap();
            this.showMap(this._mapData,MAP_TYPE_HEIGHTSLICE);
            return true;
         }
         if(this._currentMapType == MAP_TYPE_HEIGHTSLICE)
         {
            this.showMap(null,MAP_TYPE_NONE);
            this._mapData.dispose();
            this._mapData = null;
            return true;
         }
         return false;
      }
      
      private function drawGrid(param1:IsoStar) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:Rectangle = new Rectangle();
         var _loc4_:int = Math.ceil(param1.level.bounds.width);
         var _loc5_:int = Math.ceil(param1.level.bounds.height);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_.x = _loc2_;
            _loc3_.y = 0;
            _loc3_.width = 1;
            _loc3_.height = _loc5_;
            this._mapData.fillRect(_loc3_,4282137660);
            _loc2_ = _loc2_ + IsoGrid.upt;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_.x = 0;
            _loc3_.y = _loc2_;
            _loc3_.width = _loc4_;
            _loc3_.height = 1;
            this._mapData.fillRect(_loc3_,4282137660);
            _loc2_ = _loc2_ + IsoGrid.upt;
         }
      }
      
      private function drawCurrentIsoSprite() : void
      {
         var _loc2_:BitmapData = null;
         if(this._currentIsoSprite == null)
         {
            return;
         }
         var _loc1_:Rectangle = new Rectangle();
         _loc1_.x = this._currentIsoSprite.min_u - this._currentIsoSprite.subgripbounds.x;
         _loc1_.y = this._currentIsoSprite.min_v - this._currentIsoSprite.subgripbounds.y;
         _loc1_.width = this._currentIsoSprite.gripbounds.width;
         _loc1_.height = this._currentIsoSprite.gripbounds.height;
         _loc2_ = this._currentIsoSprite.grip.clone();
         _loc2_.threshold(_loc2_,_loc2_.rect,_loc2_.rect.topLeft,"!=",0,4278255615);
         this._mapData.copyPixels(_loc2_,_loc2_.rect,_loc1_.topLeft,null,null,true);
         _loc2_.dispose();
      }
      
      private function drawRoomMaskMap(param1:IsoStar) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:ICroppedBitmapDataContainer = null;
         var _loc9_:BitmapData = null;
         var _loc10_:Rectangle = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Vector.<uint> = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc18_:uint = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc6_:int = Math.ceil(param1.level.bounds.width / IsoGrid.upt);
         var _loc7_:int = Math.ceil(param1.level.bounds.height / IsoGrid.upt);
         var _loc16_:Point = new Point();
         var _loc17_:Vector.<Point> = this.getActiveMasks();
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc6_)
            {
               _loc8_ = param1.level.getMask(_loc2_,_loc3_,IsoGrid.MODE_MAIN);
               if(_loc8_ != null)
               {
                  _loc16_.x = _loc2_;
                  _loc16_.y = _loc3_;
                  if(_loc17_.some(this.pointEquals,_loc16_))
                  {
                     _loc18_ = 4278255360;
                  }
                  else
                  {
                     _loc18_ = 4294901760;
                  }
                  _loc9_ = _loc8_.bitmapData;
                  _loc10_ = _loc9_.getColorBoundsRect(4294967295,4294967295,true);
                  _loc11_ = new BitmapData(IsoGrid.upt,IsoGrid.upt,true,0);
                  _loc12_ = new Vector.<uint>(IsoGrid.upt * IsoGrid.upt,true);
                  _loc13_ = _loc10_.x / IsoGrid.PIXELS_PER_DIAGONAL_UNIT;
                  _loc14_ = (_loc10_.x + _loc10_.width) / IsoGrid.PIXELS_PER_DIAGONAL_UNIT;
                  _loc15_ = _loc13_ * IsoGrid.upt / IsoGrid.DIAGONAL_UNITS;
                  _loc4_ = _loc14_ * IsoGrid.upt / IsoGrid.DIAGONAL_UNITS;
                  _loc5_ = _loc15_;
                  while(_loc5_ <= _loc4_)
                  {
                     _loc12_[int((IsoGrid.upt - 1 - _loc5_) * IsoGrid.upt + _loc5_)] = _loc18_;
                     _loc5_++;
                  }
                  _loc11_.setVector(_loc11_.rect,_loc12_);
                  _loc16_.x = _loc16_.x * IsoGrid.upt;
                  _loc16_.y = _loc16_.y * IsoGrid.upt;
                  this._mapData.copyPixels(_loc11_,_loc11_.rect,_loc16_,null,null,true);
               }
               _loc2_++;
            }
            _loc3_++;
         }
      }
      
      private function getActiveMasks() : Vector.<Point>
      {
         var _loc5_:Point = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Point = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Point = null;
         var _loc1_:Vector.<Point> = new Vector.<Point>();
         if(this._currentIsoSprite == null)
         {
            return _loc1_;
         }
         var _loc2_:Rectangle = this._currentIsoSprite.gripbounds;
         var _loc3_:int = this._currentIsoSprite.isoU;
         var _loc4_:int = this._currentIsoSprite.isoV;
         var _loc6_:Point = new Point();
         var _loc10_:Vector.<Point> = new Vector.<Point>();
         _loc13_ = Math.floor((_loc3_ - _loc2_.width / 2) / IsoGrid.upt);
         _loc14_ = Math.ceil((_loc3_ + _loc2_.width / 2) / IsoGrid.upt);
         _loc15_ = Math.floor((_loc4_ - _loc2_.height / 2) / IsoGrid.upt);
         _loc16_ = Math.ceil((_loc4_ + _loc2_.height / 2) / IsoGrid.upt);
         _loc11_ = _loc13_;
         while(_loc11_ <= _loc14_)
         {
            _loc10_.push(new Point(_loc11_,_loc16_));
            _loc11_++;
         }
         _loc12_ = _loc16_ - 1;
         while(_loc12_ >= _loc15_)
         {
            _loc10_.push(new Point(_loc14_,_loc12_));
            _loc12_--;
         }
         _loc13_ = Math.ceil((_loc3_ - _loc2_.width / 2) / IsoGrid.upt);
         _loc14_ = Math.floor((_loc3_ + _loc2_.width / 2) / IsoGrid.upt);
         _loc15_ = Math.ceil((_loc4_ - _loc2_.height / 2) / IsoGrid.upt);
         _loc16_ = Math.floor((_loc4_ + _loc2_.height / 2) / IsoGrid.upt);
         _loc11_ = _loc13_;
         while(_loc11_ <= _loc14_)
         {
            _loc5_ = new Point(_loc11_,_loc16_);
            if(!_loc10_.some(this.pointEquals,_loc5_))
            {
               _loc10_.push(_loc5_);
            }
            _loc11_++;
         }
         _loc12_ = _loc16_ - 1;
         while(_loc12_ >= _loc15_)
         {
            _loc5_ = new Point(_loc14_,_loc12_);
            if(!_loc10_.some(this.pointEquals,_loc5_))
            {
               _loc10_.push(_loc5_);
            }
            _loc12_--;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc10_.length)
         {
            _loc9_ = _loc10_[_loc7_] as Point;
            if(_loc9_)
            {
               _loc8_ = 0;
               while(_loc8_ < IsoStar.BACKGROUNDMASK_SEARCHDEPTH)
               {
                  _loc17_ = _loc9_.clone();
                  _loc17_.x = _loc17_.x + _loc8_;
                  _loc17_.y = _loc17_.y + _loc8_;
                  if(!(_loc17_.x < 0 || _loc17_.y < 0))
                  {
                     if(!_loc1_.some(this.pointEquals,_loc17_))
                     {
                        _loc1_.push(_loc17_);
                     }
                  }
                  _loc8_++;
               }
            }
            _loc7_++;
         }
         return _loc1_;
      }
      
      private function updateHeightSliceMap() : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:* = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Number = NaN;
         var _loc21_:BitmapData = null;
         if(!this._config)
         {
            return;
         }
         var _loc1_:IsoStar = this._config[CFG_ISO_ENGINE];
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:int = _loc1_.level.bounds.width;
         var _loc3_:int = _loc1_.level.bounds.height;
         var _loc4_:Point = _loc1_.getAbsoluteMousePosition();
         var _loc5_:Vector3D = IsoGrid.xyztouvz(_loc4_.x,_loc4_.y,0);
         _loc5_.x = int(_loc5_.x + 0.5);
         _loc5_.y = int(_loc5_.y + 0.5);
         if(_loc5_.x >= _loc2_ || _loc5_.y >= _loc3_)
         {
            return;
         }
         var _loc6_:int = _loc2_ - _loc5_.x;
         var _loc7_:int = _loc3_ - _loc5_.y;
         var _loc8_:int = _loc6_ < _loc7_?int(_loc6_):int(_loc7_);
         var _loc9_:int = _loc1_.level.map.length;
         var _loc15_:Shape = new Shape();
         var _loc16_:Rectangle = new Rectangle(0,0,1,1);
         var _loc17_:int = -1;
         _loc10_ = _loc8_ - 1;
         while(_loc10_ >= 0)
         {
            _loc13_ = _loc5_.x + _loc10_;
            _loc14_ = _loc5_.y + _loc10_;
            if(!(_loc13_ < 0 || _loc14_ < 0))
            {
               _loc11_ = _loc14_ * _loc2_ + _loc13_;
               _loc12_ = _loc1_.level.map[_loc11_] >> MapDataV1.HEIGHT_OFFSET & MapDataV1.HEIGHT_MAX;
               _loc15_.graphics.lineStyle(1,16777215);
               _loc15_.graphics.moveTo(_loc10_,300 - (_loc12_ + 1));
               _loc15_.graphics.lineTo(_loc10_,300);
               _loc19_ = SIN30_div_COS30_mult_SQRT2 * _loc10_;
               if(_loc19_ <= _loc12_ && _loc17_ == -1)
               {
                  _loc17_ = _loc10_;
                  _loc18_ = int(_loc19_ + 0.5);
               }
               _loc15_.graphics.lineStyle();
               _loc15_.graphics.beginFill(16776960);
               _loc15_.graphics.drawCircle(_loc10_,300 - (_loc19_ + 1),1);
               _loc15_.graphics.endFill();
            }
            _loc10_--;
         }
         _loc15_.graphics.lineStyle(1,16711680);
         _loc15_.graphics.moveTo(_loc17_,0);
         _loc15_.graphics.lineTo(_loc17_,300);
         var _loc20_:BitmapData = new BitmapData(_loc8_,300,false,0);
         _loc20_.draw(_loc15_);
         if(this._currentMap)
         {
            _loc21_ = this._currentMap.bitmapData;
            this._currentMap.bitmapData = _loc20_;
            if(_loc21_ != null)
            {
               _loc21_.dispose();
            }
         }
      }
      
      private function callGC(param1:Array) : Boolean
      {
         System.gc();
         return true;
      }
      
      public function update(param1:int) : void
      {
         if(param1 - this._lastUpdateAt <= MIN_UPDATE_INTERVAL)
         {
            return;
         }
         this._lastUpdateAt = param1;
         if(this._currentMapType == MAP_TYPE_COLLISION)
         {
            this.updateCollisionMap();
         }
         else if(this._currentMapType == MAP_TYPE_HEIGHTSLICE)
         {
            this.updateHeightSliceMap();
         }
         else if(this._currentMapType == MAP_TYPE_HEAT)
         {
            this.updateHeatMap();
         }
      }
   }
}

class CommandDef
{
    
   
   private var _commandName:String;
   
   private var _params:CommandParams;
   
   private var _callback:Function;
   
   function CommandDef(param1:String, param2:CommandParams, param3:Function)
   {
      super();
      this._callback = param3;
      this._commandName = param1;
      this._params = param2;
   }
   
   public function cleanup() : void
   {
      this._callback = null;
   }
   
   public function execute(param1:Array) : Boolean
   {
      var params:Array = param1;
      if(this._callback != null)
      {
         try
         {
            return this._callback(params);
         }
         catch(err:Error)
         {
         }
      }
      return false;
   }
}

class CommandParams
{
    
   
   private var paramNames:Array;
   
   private var paramTypes:Array;
   
   private var paramDefaults:Array;
   
   function CommandParams(param1:Array, param2:Array, param3:Array)
   {
      super();
      this.paramNames = param1;
      this.paramTypes = param2;
      this.paramDefaults = param3;
   }
}
