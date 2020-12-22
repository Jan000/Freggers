package de.freggers.roomlib.util
{
   import com.adobe.crypto.MD5;
   import de.freggers.data.BinaryDecodable;
   import de.freggers.data.Level;
   import de.freggers.data.LevelBackground;
   import de.freggers.roomlib.IsoItem;
   import de.freggers.roomlib.Player;
   import de.freggers.util.BABitmapDataContainer;
   import de.freggers.util.Job;
   import de.freggers.util.JobQueue;
   import de.freggers.util.LRUCache;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class ResourceManager
   {
      
      public static const PARAM_ROOM_BASE_URL:String = "roombaseurl";
      
      public static const PARAM_PORTABLE_BASE_URL:String = "portablebaseurl";
      
      public static const PARAM_NPC_BASE_URL:String = "npcbaseurl";
      
      public static const PARAM_ITEM_BASE_URL:String = "itembaseurl";
      
      public static const PARAM_SOUND_BASE_URL:String = "soundbaseurl";
      
      public static const PARAM_MED_BASE_URL:String = "medbaseurl";
      
      public static const PARAM_OVERLAY_BASE_URL:String = "overlaybaseurl";
      
      public static const PARAM_IMG_FACTORY:String = "imgfactory";
      
      public static const RELEASE_IMMEDIATELY:uint = 0;
      
      public static const RELEASE_WHEN_EXPIRED:uint = 1;
      
      public static const RELEASE_NEVER:uint = 2;
      
      public static const RELEASE_ON_LEVEL_LOAD:uint = 3;
      
      public static const PACK_TYPE_MEDIAPACK:String = "MED";
      
      public static const PACK_TYPE_ISOPACK:String = "ISO";
      
      private static const LOAD_SUCCESS:String = "success";
      
      private static const LOAD_FAILED:String = "failure";
      
      public static var verboseMode:Boolean = false;
      
      private static var _instance:ResourceManager = null;
       
      
      private var cacheBuster:String = "";
      
      private var imageBuster:String = "";
      
      private var jobQueue:JobQueue;
      
      private var config:Object;
      
      private var inited:Boolean = false;
      
      private var loaderCallbacks:Dictionary;
      
      private var processingObjects:Dictionary;
      
      private var resourceIds:Array;
      
      private var resourceData:Array;
      
      private var resourceNames:Array;
      
      private var callbackLists:Array;
      
      private var failCallbackLists:Array;
      
      private var progressCallbacks:Dictionary;
      
      private var dataPackLookup:Dictionary;
      
      private var levelCache:LRUCache;
      
      private var backgroundCache:LRUCache;
      
      private var lastResId:Number = 0;
      
      private var lastReqId:Number = 0;
      
      private var maxResAge:Number = 0;
      
      private var totalDecoded:int = 0;
      
      private var failedDecoding:int = 0;
      
      private var failedLoading:int = 0;
      
      public function ResourceManager(param1:SingletonEnforcer#27)
      {
         this.levelCache = new LRUCache(10);
         this.backgroundCache = new LRUCache(10);
         super();
         if(getQualifiedClassName(this) != "de.freggers.roomlib.util::ResourceManager")
         {
            throw new Error("Invalid singleton access. Use ResourceManager.getInstance() instead");
         }
         this.resourceData = new Array();
         this.resourceIds = new Array();
         this.resourceNames = new Array();
         this.callbackLists = new Array();
         this.failCallbackLists = new Array();
         this.progressCallbacks = new Dictionary(true);
         this.loaderCallbacks = new Dictionary(true);
         this.processingObjects = new Dictionary(false);
         this.dataPackLookup = new Dictionary(true);
         this.jobQueue = new JobQueue();
         this.jobQueue.start();
      }
      
      public static function get instance() : ResourceManager
      {
         if(_instance == null)
         {
            _instance = new ResourceManager(new SingletonEnforcer#27());
         }
         return _instance;
      }
      
      public static function generateObjectResourceName(param1:String, param2:String) : String
      {
         if(!param1)
         {
            return null;
         }
         param1 = param1.replace("area.","");
         if(param2)
         {
            param2.replace("area.","");
         }
         else
         {
            param2 = BinaryDecodable.DEFAULT_DATAPACK;
         }
         return param1 + ":" + param2;
      }
      
      public function configure(param1:Object) : void
      {
         if(!param1)
         {
            throw new Error("No valid configuration provided.");
         }
         if(param1["v"])
         {
            this.cacheBuster = "?v=" + param1["v"];
         }
         if(param1["imgv"])
         {
            this.imageBuster = "?v=" + param1["imgv"];
         }
         this.config = param1;
         this.inited = true;
      }
      
      public function set maxResourceAge(param1:Number) : void
      {
         this.maxResAge = param1;
      }
      
      public function increaseDataPackContainerAge(param1:Number, param2:DataPackContainer = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ADataPack = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:ResourceData = null;
         var _loc3_:int = getTimer();
         if(param2 != null)
         {
            _loc7_ = param2.getDataPacks();
            for each(_loc5_ in _loc7_)
            {
               _loc6_ = _loc5_.getAge(_loc3_);
               _loc4_ = (this.maxResAge - _loc5_.getAge(_loc3_)) * param1;
               _loc5_.increaseAgeBy(_loc4_);
            }
         }
         else
         {
            for each(_loc8_ in this.resourceData)
            {
               if(_loc8_.cacheMode == RELEASE_WHEN_EXPIRED && _loc8_._resource is ADataPack)
               {
                  _loc5_ = _loc8_._resource as ADataPack;
                  _loc6_ = _loc5_.getAge(_loc3_);
                  _loc4_ = (this.maxResAge - _loc5_.getAge(_loc3_)) * param1;
                  _loc5_.increaseAgeBy(_loc4_);
               }
            }
         }
      }
      
      public function update(param1:int) : void
      {
         var _loc2_:ResourceCallbackData = null;
         var _loc3_:ResourceData = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc8_:ResourceData = null;
         var _loc9_:Number = NaN;
         this.jobQueue.update(param1);
         var _loc6_:int = 0;
         while(_loc6_ < this.callbackLists.length)
         {
            _loc3_ = this.resourceData[_loc6_] as ResourceData;
            if(_loc3_.available && this.callbackLists[_loc6_])
            {
               this.executeCallbacks(_loc6_,_loc3_);
            }
            _loc6_++;
         }
         var _loc7_:uint = 0;
         while(_loc7_ < this.resourceData.length)
         {
            _loc8_ = this.resourceData[_loc7_];
            if(!_loc8_.available)
            {
               _loc7_++;
               continue;
            }
            switch(_loc8_.cacheMode)
            {
               case RELEASE_NEVER:
               case RELEASE_ON_LEVEL_LOAD:
                  _loc7_++;
                  continue;
               case RELEASE_IMMEDIATELY:
                  if(false && verboseMode)
                  {
                  }
                  this.removeResource(_loc7_);
                  continue;
               case RELEASE_WHEN_EXPIRED:
                  if(_loc8_._resource is ADataPack)
                  {
                     _loc9_ = (_loc8_._resource as ADataPack).getAge(param1);
                  }
                  else
                  {
                     _loc9_ = _loc8_.age(param1);
                  }
                  if(_loc9_ >= this.maxResAge)
                  {
                     if(false && verboseMode)
                     {
                     }
                     this.removeResource(_loc7_);
                  }
                  else
                  {
                     _loc7_++;
                  }
                  continue;
               default:
                  continue;
            }
         }
      }
      
      private function executeFailCallbacks(param1:int) : void
      {
         var i:int = 0;
         var idx:int = param1;
         if(idx < 0 || idx >= this.failCallbackLists.length)
         {
            return;
         }
         var callbacks:Array = this.failCallbackLists[idx];
         if(callbacks && callbacks.length > 0)
         {
            i = 0;
            while(i < callbacks.length)
            {
               if(callbacks[i])
               {
                  try
                  {
                     (callbacks[i] as ResourceCallbackData).execute(null);
                  }
                  catch(err:ArgumentError)
                  {
                  }
               }
               i++;
            }
            callbacks.length = 0;
         }
      }
      
      public function isRegisteredResource(param1:String) : Boolean
      {
         return this.resourceNames.indexOf(param1) >= 0;
      }
      
      public function isLibraryLoaded(param1:String) : Boolean
      {
         var _loc2_:int = this.resourceNames.indexOf(param1);
         if(_loc2_ < 0)
         {
            return false;
         }
         var _loc3_:ResourceData = this.resourceData[_loc2_] as ResourceData;
         return _loc3_._isLibrary && _loc3_._available;
      }
      
      public function requestSwfLibrary(param1:String, param2:String, param3:Function, param4:Function, param5:Boolean = false) : void
      {
         if(param5)
         {
            param1 = this.config[PARAM_OVERLAY_BASE_URL] + "/" + param1;
         }
         this.loadSwfFile(param1,param2,param3,param4,true);
      }
      
      public function requestSwf(param1:String, param2:Object, param3:Function, param4:Function = null) : void
      {
         this.loadSwfFile(param1,param2,param3,param4,false);
      }
      
      private function loadSwfFile(param1:String, param2:Object, param3:Function, param4:Function, param5:Boolean) : void
      {
         var resourceId:Number = NaN;
         var resName:String = null;
         var swfCacheMode:int = 0;
         var successCallbacks:Array = null;
         var failCallbacks:Array = null;
         var loader:Loader = null;
         var loaderContext:LoaderContext = null;
         var url:String = param1;
         var target:Object = param2;
         var callback:Function = param3;
         var failCallback:Function = param4;
         var loadClasses:Boolean = param5;
         if(url.match(/.*\.swf$/i) == null)
         {
            url = url + ".swf";
         }
         var resourceIndex:int = -1;
         if(!loadClasses)
         {
            resourceId = ++this.lastResId;
            resName = url + ":" + resourceId;
            swfCacheMode = RELEASE_IMMEDIATELY;
         }
         else
         {
            resName = String(target);
            resourceIndex = this.resourceNames.indexOf(resName);
            if(resourceIndex < 0)
            {
               resourceId = ++this.lastResId;
            }
            else
            {
               resourceId = this.resourceIds[resourceIndex];
            }
            swfCacheMode = RELEASE_NEVER;
         }
         var request:ResourceRequest = new ResourceRequest(resourceId,++this.lastReqId);
         if(resourceIndex < 0)
         {
            this.resourceIds.push(resourceId);
            this.resourceNames.push(resName);
            this.resourceData.push(new ResourceData(swfCacheMode,loadClasses));
            successCallbacks = new Array();
            this.callbackLists.push(successCallbacks);
            failCallbacks = new Array();
            this.failCallbackLists.push(failCallbacks);
         }
         else
         {
            successCallbacks = this.callbackLists[resourceIndex];
            failCallbacks = this.failCallbackLists[resourceIndex];
         }
         successCallbacks.push(new ResourceCallbackData(target,callback,request));
         if(failCallback != null)
         {
            failCallbacks.push(new ResourceCallbackData(target,failCallback,request));
         }
         else
         {
            failCallbacks.push(null);
         }
         if(resourceIndex > 0)
         {
            return;
         }
         loader = new Loader();
         try
         {
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.displayObjectLoadingComplete);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.displayObjectLoadingFailed);
            this.processingObjects[loader.contentLoaderInfo] = resName;
            loaderContext = null;
            if(loadClasses)
            {
               loaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
            }
            loader.load(new URLRequest(url + this.cacheBuster),loaderContext);
            return;
         }
         catch(e:Error)
         {
            delete processingObjects[loader.contentLoaderInfo];
            removeResource(resourceNames.indexOf(resName));
            return;
         }
      }
      
      private function displayObjectLoadingComplete(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.displayObjectLoadingComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.displayObjectLoadingFailed);
         var _loc3_:String = this.processingObjects[_loc2_];
         if(_loc3_)
         {
            delete this.processingObjects[_loc2_];
            _loc4_ = this.resourceNames.indexOf(_loc3_);
            if(_loc4_ >= 0)
            {
               this.addResource(param1.target.content,this.resourceIds[_loc4_]);
               (this.failCallbackLists[_loc4_] as Array).length = 0;
            }
         }
      }
      
      private function displayObjectLoadingFailed(param1:IOErrorEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.displayObjectLoadingComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.displayObjectLoadingFailed);
         var _loc3_:String = this.processingObjects[_loc2_];
         if(_loc3_)
         {
            delete this.processingObjects[_loc2_];
            _loc4_ = this.resourceNames.indexOf(_loc3_);
            this.executeFailCallbacks(_loc4_);
            this.removeResource(_loc4_);
         }
      }
      
      public function requestImageData(param1:String, param2:Object, param3:Function, param4:Function = null) : ResourceRequest
      {
         var request:ResourceRequest = null;
         var callList:Array = null;
         var resId:Number = NaN;
         var loader:Loader = null;
         var url:String = param1;
         var target:Object = param2;
         var callback:Function = param3;
         var failCallback:Function = param4;
         if(!this.inited)
         {
            throw new Error("Attempted to use the resource manager without initializing it first.");
         }
         var idx:int = this.resourceNames.indexOf(url);
         if(idx >= 0)
         {
            request = new ResourceRequest(this.resourceIds[idx],++this.lastReqId);
            callList = this.callbackLists[idx];
            callList.push(new ResourceCallbackData(target,callback,request));
            callList = this.failCallbackLists[idx];
            if(failCallback != null)
            {
               callList.push(new ResourceCallbackData(target,failCallback,request));
            }
            else
            {
               callList.push(null);
            }
            (this.resourceData[idx] as ResourceData).touch();
         }
         else
         {
            resId = ++this.lastResId;
            request = new ResourceRequest(resId,++this.lastReqId);
            this.resourceIds.push(resId);
            this.resourceNames.push(url);
            this.resourceData.push(new ResourceData(RELEASE_WHEN_EXPIRED));
            callList = new Array();
            callList.push(new ResourceCallbackData(target,callback,request));
            this.callbackLists.push(callList);
            callList = new Array();
            if(failCallback != null)
            {
               callList.push(new ResourceCallbackData(target,failCallback,request));
            }
            else
            {
               callList.push(null);
            }
            this.failCallbackLists.push(callList);
            loader = new Loader();
            try
            {
               loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.imageLoadingComplete);
               loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.imageLoadingFailed);
               this.processingObjects[loader.contentLoaderInfo] = url;
               loader.load(new URLRequest(url + this.imageBuster));
            }
            catch(e:Error)
            {
               resourceIds.length--;
               resourceNames.length--;
               resourceData.length--;
               callbackLists.length--;
               failCallbackLists.length--;
               delete processingObjects[loader.contentLoaderInfo];
            }
         }
         return request;
      }
      
      private function imageLoadingComplete(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc5_:BABitmapDataContainer = null;
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.imageLoadingComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.imageLoadingFailed);
         var _loc3_:String = this.processingObjects[_loc2_];
         if(_loc3_)
         {
            delete this.processingObjects[_loc2_];
            _loc4_ = this.resourceNames.indexOf(_loc3_);
            (this.failCallbackLists[_loc4_] as Array).length = 0;
            _loc5_ = new BABitmapDataContainer((param1.target.content as Bitmap).bitmapData);
            if(_loc4_ >= 0)
            {
               this.addResource(_loc5_,this.resourceIds[_loc4_]);
            }
         }
      }
      
      private function imageLoadingFailed(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.imageLoadingComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.imageLoadingFailed);
         var _loc3_:String = this.processingObjects[_loc2_];
         if(_loc3_)
         {
            delete this.processingObjects[_loc2_];
            _loc4_ = this.resourceNames.indexOf(_loc3_);
            this.executeFailCallbacks(_loc4_);
            this.removeResource(_loc4_);
         }
      }
      
      public function requestLevel(param1:Level, param2:Function = null, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc6_:Level = null;
         var _loc7_:uint = 0;
         var _loc8_:ResourceData = null;
         if(!this.inited)
         {
            throw new Error("Attempted to use the resource manager without initializing it first.");
         }
         if(param4)
         {
            _loc6_ = this.levelCache.get(param1.identifier) as Level;
            if(_loc6_)
            {
               param1.onMediaContainerDecoded(_loc6_.clone());
               return;
            }
         }
         if(!param3)
         {
            _loc7_ = 0;
            while(_loc7_ < this.resourceData.length)
            {
               _loc8_ = this.resourceData[_loc7_];
               if(_loc8_.cacheMode == RELEASE_ON_LEVEL_LOAD)
               {
                  if(false && verboseMode)
                  {
                  }
                  this.removeResource(_loc7_);
               }
               else
               {
                  _loc7_++;
               }
            }
         }
         var _loc5_:Object = new Object();
         _loc5_[LOAD_SUCCESS] = param1.onMediaContainerDecoded;
         _loc5_[LOAD_FAILED] = param2;
         this.loaderCallbacks[param1] = _loc5_;
         param1.onMediaContainerDecoded = this.loadLevelComplete;
         param1.onMediaContainerDecodeError = this.loadLevelFailed;
         param1.onIOError = this.loadLevelFailed;
         param1.onSecurityError = this.loadLevelFailed;
         this.jobQueue.addJob(new Job(this.loadLevel,[param1]));
      }
      
      public function addHiresBackgroundCache(param1:LevelBackground) : void
      {
         this.backgroundCache.put(param1.identifier,param1);
      }
      
      public function requestBackground(param1:LevelBackground, param2:Function = null, param3:Boolean = false) : void
      {
         var _loc5_:LevelBackground = null;
         if(!this.inited)
         {
            throw new Error("Attempted to use the resource manager without initializing it first.");
         }
         if(param3)
         {
            _loc5_ = this.backgroundCache.get(param1.identifier) as LevelBackground;
            if(_loc5_)
            {
               param1.onMediaContainerDecoded(_loc5_.clone(),true);
               return;
            }
         }
         var _loc4_:Object = new Object();
         _loc4_[LOAD_SUCCESS] = param1.onMediaContainerDecoded;
         _loc4_[LOAD_FAILED] = param2;
         this.loaderCallbacks[param1] = _loc4_;
         param1.onMediaContainerDecoded = this.loadBackgroundComplete;
         param1.onMediaContainerDecodeError = this.loadBackgroundFailed;
         param1.onIOError = this.loadBackgroundFailed;
         param1.onSecurityError = this.loadBackgroundFailed;
         this.jobQueue.addJob(new Job(this.loadBackground,[param1]));
      }
      
      public function requestPlayer(param1:Player, param2:Function, param3:String = null, param4:Boolean = false, param5:Function = null, param6:Function = null) : ResourceRequest
      {
         if(!this.inited)
         {
            throw new Error("Attempted to use the resource manager without initializing it first.");
         }
         if(param2 == null)
         {
            throw new Error("No callback provided when attempting to load player.");
         }
         if(!param3)
         {
            param3 = BinaryDecodable.DEFAULT_DATAPACK;
         }
         var _loc7_:String = generateObjectResourceName(MD5.hash(param1.gui),param3);
         if(false && verboseMode)
         {
         }
         if(!param1.baseurl)
         {
            if(param1.prerendered)
            {
               param1.baseurl = this.config[PARAM_NPC_BASE_URL];
            }
            else
            {
               param1.baseurl = this.config[PARAM_IMG_FACTORY];
            }
            if(!param1.baseurl)
            {
               return null;
            }
         }
         var _loc8_:String = param1.url({"datapack":param3});
         if(!param1.isoobj)
         {
            throw new Error("Attempted to load player without an iso object");
         }
         if(param4)
         {
            this.discardDataPacks(param1.isoobj.media,param3);
         }
         if(param1.prerendered)
         {
            _loc8_ = _loc8_ + this.imageBuster;
         }
         var _loc9_:ResourceRequest = this.requestDataPack(_loc7_,param1,param2,param6,param3,_loc8_,PACK_TYPE_ISOPACK,param5);
         param1.lastRequest = _loc9_;
         return _loc9_;
      }
      
      public function getPortableItemUrl(param1:String, param2:String = "_s") : String
      {
         if(!this.config[PARAM_PORTABLE_BASE_URL])
         {
            return null;
         }
         if(!param1)
         {
            return null;
         }
         if(!param2 || param2 != "_l" && param2 != "_s" && param2 != "_t")
         {
            param2 = "_s";
         }
         var _loc3_:* = escape(param1);
         _loc3_ = _loc3_.replace("area.","");
         _loc3_ = _loc3_.replace("item.","");
         _loc3_ = this.config[PARAM_PORTABLE_BASE_URL] + "/" + _loc3_.replace(/\./g,"/") + param2 + ".png";
         return _loc3_;
      }
      
      public function getIsoItemUrl(param1:String) : String
      {
         if(!param1)
         {
            return null;
         }
         if(!this.inited || !this.config[PARAM_ITEM_BASE_URL])
         {
            throw new Error("Attempted to use the resource manager without initializing it first.");
         }
         var _loc2_:* = escape(param1);
         _loc2_ = _loc2_.replace("area.","");
         _loc2_ = _loc2_.replace("item.","");
         _loc2_ = this.config[PARAM_ITEM_BASE_URL] + "/" + _loc2_.replace(/\./g,"/") + ".bin";
         return _loc2_;
      }
      
      public function requestIsoItem(param1:IsoItem, param2:Function, param3:String = null, param4:Function = null) : ResourceRequest
      {
         var _loc5_:String = null;
         if(!param3)
         {
            param3 = BinaryDecodable.DEFAULT_DATAPACK;
         }
         if(!this.inited || !this.config[PARAM_ITEM_BASE_URL])
         {
            throw new Error("Attempted to use the resource manager without initializing it first.");
         }
         if(param2 == null)
         {
            throw new Error("Invalid callback provided when attempting to load item.");
         }
         if(param3 == BinaryDecodable.DEFAULT_DATAPACK)
         {
            _loc5_ = this.getIsoItemUrl(param1.gui);
         }
         else
         {
            _loc5_ = this.getIsoItemUrl(param3);
         }
         if(!_loc5_)
         {
            return null;
         }
         _loc5_ = _loc5_ + this.imageBuster;
         var _loc6_:String = generateObjectResourceName(param1.gui,param3);
         var _loc7_:ResourceRequest = this.requestDataPack(_loc6_,param1,param2,param4,param3,_loc5_,PACK_TYPE_ISOPACK);
         param1.lastRequest = _loc7_;
         return _loc7_;
      }
      
      public function getMediaPackUrl(param1:String, param2:String) : String
      {
         if(!this.inited)
         {
            throw new Error("Attempted to use the resource manager without initializing it first.");
         }
         var _loc3_:* = escape(param1);
         _loc3_ = _loc3_.replace("area.","");
         _loc3_ = _loc3_.replace(/\./g,"/") + ".bin";
         return _loc3_ + param2;
      }
      
      public function requestSoundPack(param1:String, param2:Object, param3:Function, param4:Function, param5:Function = null, param6:uint = 1) : ResourceRequest
      {
         var _loc7_:String = this.getMediaPackUrl(param1,this.cacheBuster);
         return this.requestDataPack(param1,param2,param3,param4,param1,_loc7_,PACK_TYPE_MEDIAPACK,param5,param6);
      }
      
      public function requestMediaPack(param1:String, param2:Object, param3:Function, param4:Function, param5:Function = null, param6:uint = 1) : ResourceRequest
      {
         var _loc7_:String = this.getMediaPackUrl(param1,this.imageBuster);
         return this.requestDataPack(param1,param2,param3,param4,param1,_loc7_,PACK_TYPE_MEDIAPACK,param5,param6);
      }
      
      public function requestSound(param1:String, param2:Object, param3:Function, param4:Function = null) : ResourceRequest
      {
         var _loc5_:ResourceRequest = null;
         var _loc7_:ResourceData = null;
         var _loc8_:Number = NaN;
         var _loc9_:Array = null;
         var _loc10_:* = null;
         var _loc11_:Sound = null;
         if(!this.inited)
         {
            throw new Error("Attempted to use the resource manager without initializing it first.");
         }
         if(!param1 || param3 == null)
         {
            throw new Error("Resource request initiated with invalid data.");
         }
         var _loc6_:int = this.resourceNames.indexOf(param1);
         if(_loc6_ >= 0)
         {
            _loc5_ = new ResourceRequest(this.resourceIds[_loc6_],++this.lastReqId);
            _loc7_ = this.resourceData[_loc6_] as ResourceData;
            (this.callbackLists[_loc6_] as Array).push(new ResourceCallbackData(param2,param3,_loc5_));
            if(param4 != null)
            {
               (this.failCallbackLists[_loc6_] as Array).push(new ResourceCallbackData(param2,param4,_loc5_));
            }
            else
            {
               (this.failCallbackLists[_loc6_] as Array).push(null);
            }
            _loc7_.touch();
         }
         else
         {
            _loc8_ = ++this.lastResId;
            this.resourceIds.push(_loc8_);
            this.resourceNames.push(param1);
            this.resourceData.push(new ResourceData(RELEASE_WHEN_EXPIRED));
            _loc5_ = new ResourceRequest(_loc8_,++this.lastReqId);
            _loc9_ = new Array();
            _loc9_.push(new ResourceCallbackData(param2,param3,_loc5_));
            this.callbackLists.push(_loc9_);
            _loc9_ = new Array();
            if(param4 != null)
            {
               _loc9_.push(new ResourceCallbackData(param2,param4,_loc5_));
            }
            else
            {
               _loc9_.push(null);
            }
            this.failCallbackLists.push(_loc9_);
            _loc10_ = (!!this.config[PARAM_SOUND_BASE_URL]?this.config[PARAM_SOUND_BASE_URL] + "/":"") + param1 + ".mp3";
            _loc11_ = new Sound();
            this.processingObjects[_loc11_] = param1;
            _loc11_.addEventListener(IOErrorEvent.IO_ERROR,this.soundLoadingFailed,false,0,true);
            _loc11_.addEventListener(Event.COMPLETE,this.soundLoadingComplete,false,0,true);
            _loc11_.load(new URLRequest(_loc10_ + this.imageBuster));
         }
         return _loc5_;
      }
      
      private function soundLoadingFailed(param1:IOErrorEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:Sound = param1.target as Sound;
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.soundLoadingFailed);
         _loc2_.removeEventListener(Event.COMPLETE,this.soundLoadingComplete);
         var _loc3_:String = this.processingObjects[_loc2_];
         if(_loc3_)
         {
            delete this.processingObjects[_loc2_];
            _loc4_ = this.resourceNames.indexOf(_loc3_);
            if(_loc4_ >= 0)
            {
               if(false && verboseMode)
               {
               }
               this.executeFailCallbacks(_loc4_);
               this.removeResource(_loc4_);
            }
         }
      }
      
      private function soundLoadingComplete(param1:Event) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:Sound = param1.target as Sound;
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.soundLoadingFailed);
         _loc2_.removeEventListener(Event.COMPLETE,this.soundLoadingComplete);
         var _loc3_:String = this.processingObjects[_loc2_];
         if(_loc3_)
         {
            delete this.processingObjects[_loc2_];
            _loc4_ = this.resourceNames.indexOf(_loc3_);
            if(_loc4_ >= 0)
            {
               this.addResource(_loc2_,this.resourceIds[_loc4_]);
            }
         }
      }
      
      private function loadDataPack(param1:ADataPack, param2:String, param3:String, param4:int, param5:int) : void
      {
         var stream:URLStream = null;
         var pack:ADataPack = param1;
         var url:String = param2;
         var resName:String = param3;
         var jobAddedAt:int = param4;
         var jobProcessedAt:int = param5;
         if(!url)
         {
            pack.removeCallbacks();
            if(resName)
            {
               this.removeResource(this.resourceNames.indexOf(resName));
            }
            return;
         }
         stream = new URLStream();
         try
         {
            if(false && verboseMode)
            {
            }
            stream.addEventListener(Event.COMPLETE,this.loadDataPackComplete);
            stream.addEventListener(IOErrorEvent.IO_ERROR,this.loadDataPackFailed);
            stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadDataPackFailed);
            stream.addEventListener(ProgressEvent.PROGRESS,this.updateDataPackProgress);
            this.processingObjects[stream] = resName;
            stream.load(new URLRequest(url));
            return;
         }
         catch(e:Error)
         {
            delete processingObjects[stream];
            removeResource(resourceNames.indexOf(resName));
            return;
         }
      }
      
      private function loadDataPackComplete(param1:Event) : void
      {
         var _loc2_:String = this.processingObjects[param1.target];
         delete this.processingObjects[param1.target];
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = this.resourceNames.indexOf(_loc2_);
         if(_loc3_ < 0)
         {
            return;
         }
         var _loc4_:ADataPack = (this.resourceData[_loc3_] as ResourceData)._resource as ADataPack;
         delete this.progressCallbacks[_loc4_];
         this.processingObjects[_loc4_] = _loc2_;
         var _loc5_:URLStream = param1.target as URLStream;
         var _loc6_:ByteArray = new ByteArray();
         _loc5_.readBytes(_loc6_,0,_loc5_.bytesAvailable);
         _loc5_.close();
         _loc4_.decodeBytes(_loc6_);
      }
      
      private function updateDataPackProgress(param1:ProgressEvent) : void
      {
         var idx:int = 0;
         var dataPack:ADataPack = null;
         var callbacks:Array = null;
         var i:int = 0;
         var evt:ProgressEvent = param1;
         var resName:String = this.processingObjects[evt.target];
         if(resName)
         {
            idx = this.resourceNames.indexOf(resName);
            if(idx < 0)
            {
               return;
            }
            dataPack = (this.resourceData[idx] as ResourceData)._resource as ADataPack;
            callbacks = this.progressCallbacks[dataPack];
            i = 0;
            while(i < callbacks.length)
            {
               if(callbacks[i] != null)
               {
                  try
                  {
                     (callbacks[i] as ProgressCallbackData).execute(evt.bytesLoaded,evt.bytesTotal);
                  }
                  catch(err:ArgumentError)
                  {
                     callbacks[i] = null;
                  }
               }
               i++;
            }
         }
      }
      
      private function loadLevel(param1:Level, param2:int, param3:int) : void
      {
         if(!this.inited || !this.config[PARAM_ROOM_BASE_URL])
         {
         }
         param1.load(this.config[PARAM_ROOM_BASE_URL] + "/" + param1.areaName + "/" + param1.roomName + "/" + param1.roomName + ".bin" + this.imageBuster);
      }
      
      private function loadBackground(param1:LevelBackground, param2:int, param3:int) : void
      {
         if(!this.inited || !this.config[PARAM_ROOM_BASE_URL])
         {
         }
         param1.load(this.config[PARAM_ROOM_BASE_URL] + "/" + param1.areaName + "/" + param1.roomName + "/" + param1.roomName + "_bg_" + param1.brightness + ".bin" + this.imageBuster);
      }
      
      private function loadLevelComplete(param1:Level) : void
      {
         var resId:Number = NaN;
         var sounds:Object = null;
         var soundLabel:String = null;
         var data:ResourceData = null;
         var level:Level = param1;
         var callbacks:Object = this.loaderCallbacks[level];
         delete this.loaderCallbacks[level];
         var callback:Function = callbacks[LOAD_SUCCESS];
         this.levelCache.put(level.identifier,level.clone());
         if(callback != null)
         {
            sounds = level.getAllSoundData();
            if(sounds)
            {
               for(soundLabel in sounds)
               {
                  this.resourceNames.push(soundLabel);
                  resId = ++this.lastResId;
                  this.resourceIds.push(resId);
                  data = new ResourceData(RELEASE_ON_LEVEL_LOAD);
                  data.resource = sounds[soundLabel]["Sound"];
                  data._available = true;
                  this.resourceData.push(data);
                  this.callbackLists.push(new Array());
                  this.failCallbackLists.push(new Array());
               }
            }
            level.discardAdditionalData();
            try
            {
               callback(level);
            }
            catch(err:ArgumentError)
            {
            }
         }
      }
      
      private function loadLevelFailed(param1:Level, param2:ErrorEvent = null) : void
      {
         var level:Level = param1;
         var err:ErrorEvent = param2;
         var callbacks:Object = this.loaderCallbacks[level];
         delete this.loaderCallbacks[level];
         var callback:Function = callbacks[LOAD_FAILED];
         if(callback != null)
         {
            try
            {
               callback(level);
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      private function loadBackgroundFailed(param1:LevelBackground, param2:ErrorEvent = null) : void
      {
         var background:LevelBackground = param1;
         var err:ErrorEvent = param2;
         var callbacks:Object = this.loaderCallbacks[background];
         delete this.loaderCallbacks[background];
         var callback:Function = callbacks[LOAD_FAILED];
         if(callback != null)
         {
            try
            {
               callback(background);
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      private function loadBackgroundComplete(param1:LevelBackground) : void
      {
         var background:LevelBackground = param1;
         var callbacks:Object = this.loaderCallbacks[background];
         delete this.loaderCallbacks[background];
         var callback:Function = callbacks[LOAD_SUCCESS];
         if(callback != null)
         {
            try
            {
               callback(background);
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      private function executeCallbacks(param1:int, param2:ResourceData) : void
      {
         var callbackData:ResourceCallbackData = null;
         var idx:int = param1;
         var resData:ResourceData = param2;
         var callbacks:Array = this.callbackLists[idx];
         var failCallbacks:Array = this.failCallbackLists[idx];
         var j:int = 0;
         while(j < callbacks.length)
         {
            callbackData = callbacks[j] as ResourceCallbackData;
            try
            {
               callbackData.execute(resData.resource);
            }
            catch(err:Error)
            {
            }
            callbacks.splice(j,1);
            if(failCallbacks)
            {
               failCallbacks.splice(j,1);
            }
         }
      }
      
      private function decodeDataPackComplete(param1:ADataPack) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ResourceData = null;
         this.totalDecoded++;
         var _loc2_:String = this.processingObjects[param1];
         if(_loc2_)
         {
            delete this.processingObjects[param1];
            _loc3_ = this.resourceNames.indexOf(_loc2_);
            if(_loc3_ >= 0)
            {
               delete this.progressCallbacks[param1];
               _loc4_ = this.resourceData[_loc3_] as ResourceData;
               if(!_loc4_.available)
               {
                  this.executeCallbacks(_loc3_,_loc4_);
                  this.addResource(param1,this.resourceIds[_loc3_]);
               }
               else if(false && verboseMode)
               {
               }
            }
         }
         param1.removeCallbacks();
      }
      
      private function loadDataPackFailed(param1:ErrorEvent) : void
      {
         var _loc4_:ResourceData = null;
         this.failedLoading++;
         var _loc2_:String = this.processingObjects[param1.target];
         delete this.processingObjects[param1.target];
         var _loc3_:int = this.resourceNames.indexOf(_loc2_);
         if(_loc3_ >= 0)
         {
            this.executeFailCallbacks(_loc3_);
            _loc4_ = this.resourceData[_loc3_] as ResourceData;
            this.cleanupDataPack(_loc4_._resource as ADataPack,_loc2_);
         }
      }
      
      private function decodeDataPackFailed(param1:ADataPack) : void
      {
         this.failedDecoding++;
         var _loc2_:String = this.processingObjects[param1];
         var _loc3_:int = this.resourceNames[_loc2_];
         if(_loc3_ >= 0)
         {
            this.executeFailCallbacks(_loc3_);
         }
         this.cleanupDataPack(param1,_loc2_);
      }
      
      private function cleanupDataPack(param1:ADataPack, param2:String) : void
      {
         param1.removeCallbacks();
         delete this.progressCallbacks[param1];
         delete this.processingObjects[param1];
         this.removeResource(this.resourceNames.indexOf(param2));
      }
      
      public function requestDataPack(param1:String, param2:Object, param3:Function, param4:Function, param5:String, param6:String, param7:String, param8:Function = null, param9:uint = 1) : ResourceRequest
      {
         var _loc11_:ResourceRequest = null;
         var _loc12_:ADataPack = null;
         var _loc13_:ResourceData = null;
         var _loc14_:ResourceCallbackData = null;
         var _loc15_:Number = NaN;
         var _loc16_:Array = null;
         if(!param1 || param3 == null)
         {
            throw new Error("Resource request initiated with invalid data.");
         }
         var _loc10_:int = this.resourceNames.indexOf(param1);
         if(_loc10_ >= 0)
         {
            _loc11_ = new ResourceRequest(this.resourceIds[_loc10_],++this.lastReqId);
            _loc13_ = this.resourceData[_loc10_] as ResourceData;
            _loc12_ = _loc13_._resource as ADataPack;
            _loc13_.touch();
            _loc14_ = new ResourceCallbackData(param2,param3,_loc11_);
            if(!_loc13_.available)
            {
               if(!this.progressCallbacks[_loc12_])
               {
                  this.progressCallbacks[_loc12_] = new Array();
               }
               if(param8 != null)
               {
                  (this.progressCallbacks[_loc12_] as Array).push(new ProgressCallbackData(param2,param8));
               }
               (this.callbackLists[_loc10_] as Array).push(_loc14_);
               if(param4 != null)
               {
                  (this.failCallbackLists[_loc10_] as Array).push(new ResourceCallbackData(param2,param4,_loc11_));
               }
               else
               {
                  (this.failCallbackLists[_loc10_] as Array).push(null);
               }
            }
            else
            {
               _loc14_.execute(_loc13_._resource);
            }
         }
         else
         {
            _loc15_ = ++this.lastResId;
            this.resourceIds.push(_loc15_);
            this.resourceNames.push(param1);
            _loc13_ = new ResourceData(param9);
            this.resourceData.push(_loc13_);
            _loc11_ = new ResourceRequest(_loc15_,++this.lastReqId);
            _loc16_ = new Array();
            _loc16_.push(new ResourceCallbackData(param2,param3,_loc11_));
            this.callbackLists.push(_loc16_);
            _loc16_ = new Array();
            if(param4 != null)
            {
               _loc16_.push(new ResourceCallbackData(param2,param4,_loc11_));
            }
            else
            {
               _loc16_.push(null);
            }
            this.failCallbackLists.push(_loc16_);
            switch(param7)
            {
               case PACK_TYPE_MEDIAPACK:
                  _loc12_ = new MediaDataPack(param5);
                  break;
               case PACK_TYPE_ISOPACK:
                  _loc12_ = new IsoObjectDataPack(param5);
                  break;
               default:
                  throw new Error("Invalid data pack type provided");
            }
            _loc13_._resource = _loc12_;
            _loc12_.onMediaContainerDecoded = this.decodeDataPackComplete;
            _loc12_.onMediaContainerDecodeError = this.decodeDataPackFailed;
            this.jobQueue.addJob(new Job(this.loadDataPack,[_loc12_,param6,param1]));
            if(!this.progressCallbacks[_loc12_])
            {
               this.progressCallbacks[_loc12_] = new Array();
            }
            if(param8 != null)
            {
               (this.progressCallbacks[_loc12_] as Array).push(new ProgressCallbackData(param2,param8));
            }
         }
         return _loc11_;
      }
      
      public function requestTextFile(param1:String, param2:Object, param3:Function, param4:Function = null) : void
      {
         var resName:String = null;
         var urlLoader:URLLoader = null;
         var url:String = param1;
         var target:Object = param2;
         var callback:Function = param3;
         var failCallback:Function = param4;
         var resId:Number = ++this.lastResId;
         var request:ResourceRequest = new ResourceRequest(resId,++this.lastReqId);
         this.resourceIds.push(resId);
         resName = url + ":" + resId;
         this.resourceNames.push(resName);
         this.resourceData.push(new ResourceData(RELEASE_IMMEDIATELY));
         var callList:Array = new Array();
         callList.push(new ResourceCallbackData(target,callback,request));
         this.callbackLists.push(callList);
         callList = new Array();
         if(failCallback != null)
         {
            callList.push(new ResourceCallbackData(target,failCallback,request));
         }
         else
         {
            callList.push(null);
         }
         this.failCallbackLists.push(callList);
         urlLoader = new URLLoader();
         try
         {
            urlLoader.addEventListener(Event.COMPLETE,this.textFileLoadingComplete);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.textFileLoadingFailed);
            this.processingObjects[urlLoader] = resName;
            urlLoader.load(new URLRequest(url + this.cacheBuster));
            return;
         }
         catch(e:Error)
         {
            delete processingObjects[urlLoader];
            removeResource(resourceNames.indexOf(resName));
            return;
         }
      }
      
      private function textFileLoadingComplete(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc2_:URLLoader = param1.target as URLLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.textFileLoadingComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.textFileLoadingFailed);
         var _loc3_:String = this.processingObjects[_loc2_];
         if(_loc3_)
         {
            delete this.processingObjects[_loc2_];
            _loc4_ = this.resourceNames.indexOf(_loc3_);
            if(_loc4_ >= 0)
            {
               this.addResource(_loc2_.data,this.resourceIds[_loc4_]);
               (this.failCallbackLists[_loc4_] as Array).length = 0;
            }
         }
      }
      
      private function textFileLoadingFailed(param1:IOErrorEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:URLLoader = param1.target as URLLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.textFileLoadingComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.textFileLoadingFailed);
         var _loc3_:String = this.processingObjects[_loc2_];
         if(_loc3_)
         {
            delete this.processingObjects[_loc2_];
            _loc4_ = this.resourceNames.indexOf(_loc3_);
            this.executeFailCallbacks(_loc4_);
            this.removeResource(_loc4_);
         }
      }
      
      public function cancelCallbacksFor(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:ResourceData = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < this.callbackLists.length)
         {
            _loc4_ = this.callbackLists[_loc6_];
            _loc5_ = this.resourceData[_loc6_];
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               if((_loc4_[_loc3_] as ResourceCallbackData).callTarget == param1)
               {
                  _loc4_.splice(_loc3_,1);
                  if(this.progressCallbacks[_loc5_._resource])
                  {
                     (this.progressCallbacks[_loc5_._resource] as Array).splice(_loc3_,1);
                  }
                  (this.failCallbackLists[_loc6_] as Array).splice(_loc3_,1);
                  _loc2_++;
               }
               else
               {
                  _loc3_++;
               }
            }
            _loc6_++;
         }
         if(_loc2_ > 0)
         {
            if(false && verboseMode)
            {
            }
         }
      }
      
      public function cancel(param1:ResourceRequest) : void
      {
         var _loc3_:ResourceData = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc2_:int = this.resourceIds.indexOf(param1.resourceID);
         if(_loc2_ >= 0)
         {
            _loc3_ = this.resourceData[_loc2_];
            _loc4_ = this.callbackLists[_loc2_];
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if((_loc4_[_loc5_] as ResourceCallbackData).invalidated || (_loc4_[_loc5_] as ResourceCallbackData).requestID == param1.requestID)
               {
                  (_loc4_[_loc5_] as ResourceCallbackData).cleanup();
                  _loc4_.splice(_loc5_,1);
                  (this.failCallbackLists[_loc2_] as Array).splice(_loc5_,1);
                  if(this.progressCallbacks[_loc3_._resource])
                  {
                     (this.progressCallbacks[_loc3_._resource] as Array).splice(_loc5_,1);
                  }
                  break;
               }
               _loc5_++;
            }
         }
      }
      
      public function cancelCallbacks() : void
      {
         var _loc1_:ResourceData = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.callbackLists.length)
         {
            if(this.callbackLists[_loc2_])
            {
               (this.callbackLists[_loc2_] as Array).length = 0;
            }
            if(this.failCallbackLists[_loc2_])
            {
               (this.failCallbackLists[_loc2_] as Array).length = 0;
            }
            _loc1_ = this.resourceData[_loc2_];
            if(this.progressCallbacks[_loc1_._resource])
            {
               (this.progressCallbacks[_loc1_._resource] as Array).length = 0;
            }
            _loc2_++;
         }
      }
      
      private function addResource(param1:Object, param2:Number) : void
      {
         var _loc3_:int = this.resourceIds.indexOf(param2);
         if(_loc3_ >= 0 && !(this.resourceData[_loc3_] as ResourceData).available)
         {
            (this.resourceData[_loc3_] as ResourceData).resource = param1;
            (this.resourceData[_loc3_] as ResourceData)._available = true;
         }
      }
      
      private function removeResource(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         this.resourceIds.splice(param1,1);
         var _loc2_:ResourceData = this.resourceData[param1];
         this.resourceData.splice(param1,1);
         this.resourceNames.splice(param1,1);
         this.callbackLists.splice(param1,1);
         this.failCallbackLists.splice(param1,1);
         if(_loc2_)
         {
            if(_loc2_._resource is ADataPack)
            {
               this.unregisterDataPack(_loc2_._resource as ADataPack);
            }
         }
      }
      
      private function unregisterDataPack(param1:ADataPack) : void
      {
         var _loc3_:DataPackContainer = null;
         if(!this.dataPackLookup[param1] || !param1)
         {
            return;
         }
         var _loc2_:Array = this.dataPackLookup[param1];
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_)
            {
               _loc3_.removeDataPack(param1);
            }
         }
         delete this.dataPackLookup[param1];
      }
      
      private function discardDataPacks(param1:DataPackContainer, param2:String) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:Array = param1.getDataPacks();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if((_loc3_[_loc4_] as ADataPack).name != param2)
            {
               param1.removeDataPack(_loc3_[_loc4_]);
            }
            _loc4_++;
         }
      }
      
      public function unregisterDataPackContainer(param1:DataPackContainer) : void
      {
         var _loc4_:Array = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:Array = param1.getDataPacks();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = this.dataPackLookup[_loc2_[_loc3_]];
            if(!(_loc4_ == null || _loc4_.indexOf(param1) < 0))
            {
               _loc4_.splice(_loc4_.indexOf(param1),1);
               if(_loc4_.length == 0)
               {
                  delete this.dataPackLookup[_loc2_[_loc3_]];
               }
            }
            _loc3_++;
         }
      }
      
      public function registerDataPackContainer(param1:DataPackContainer, param2:ADataPack) : void
      {
         if(!param2 || !param1)
         {
            return;
         }
         var _loc3_:Array = this.dataPackLookup[param2];
         if(!_loc3_)
         {
            _loc3_ = new Array();
            this.dataPackLookup[param2] = _loc3_;
         }
         if(_loc3_.indexOf(param1) > 0)
         {
            return;
         }
         _loc3_.push(param1);
      }
      
      public function dumpStats() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         for each(_loc2_ in this.dataPackLookup)
         {
            _loc1_++;
         }
      }
   }
}

class SingletonEnforcer#27
{
    
   
   function SingletonEnforcer#27()
   {
      super();
   }
}
