package de.freggers.audio
{
   import flash.events.TimerEvent;
   import flash.geom.Vector3D;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class AudioSystem
   {
      
      public static const DEFAULT_ACCURACY:Number = 50;
      
      public static const DEFAULT_VOLUME:Number = 1;
       
      
      public var onTracksFinished:Function;
      
      private var timer:Timer;
      
      private var tracks:Array;
      
      private var trackIds:Array;
      
      private var trackStarts:Array;
      
      private var soundLocations:Array;
      
      private var changedLocations:Array;
      
      private var timestamp:Number;
      
      private var delta:Number;
      
      private var playing:Boolean;
      
      private var _volume:Number = 1;
      
      private var _ambientVolume:Number = 1;
      
      private var _effectsVolume:Number = 1;
      
      private var _listenerLoc:Vector3D = null;
      
      private var _listenerLocChanged:Boolean = false;
      
      public function AudioSystem(param1:Number = 50)
      {
         super();
         this.tracks = new Array();
         this.trackIds = new Array();
         this.trackStarts = new Array();
         this.soundLocations = new Array();
         this.changedLocations = new Array();
         this.delta = 0;
         this.timestamp = -1;
         this.playing = false;
         this.timer = new Timer(param1);
         this.timer.addEventListener(TimerEvent.TIMER,this.playTracks,false,0,true);
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(param1:Number) : void
      {
         this._volume = param1;
         this.setVolume(param1,SoundTrack.SOUND_TYPE_AMB | SoundTrack.SOUND_TYPE_EFF);
      }
      
      public function get ambientVolume() : Number
      {
         return this._ambientVolume;
      }
      
      public function set ambientVolume(param1:Number) : void
      {
         this.setVolume(param1 * this._volume,SoundTrack.SOUND_TYPE_AMB);
      }
      
      public function get effectsVolume() : Number
      {
         return this._effectsVolume;
      }
      
      public function set effectsVolume(param1:Number) : void
      {
         this.setVolume(param1 * this._volume,SoundTrack.SOUND_TYPE_EFF);
      }
      
      public function setVolume(param1:Number, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:SoundTrack = null;
         if((param2 & SoundTrack.SOUND_TYPE_AMB) != 0)
         {
            this._ambientVolume = param1;
         }
         if((param2 & SoundTrack.SOUND_TYPE_EFF) != 0)
         {
            this._effectsVolume = param1;
         }
         param1 = this._volume * param1;
         _loc3_ = 0;
         while(_loc3_ < this.tracks.length)
         {
            _loc4_ = this.tracks[_loc3_];
            if((_loc4_.type & param2) != 0)
            {
               _loc4_.volume = param1;
            }
            _loc3_++;
         }
      }
      
      public function playTracks(param1:TimerEvent) : void
      {
         var track:SoundTrack = null;
         var i:uint = 0;
         var evt:TimerEvent = param1;
         if(!this.playing)
         {
            this.timer.stop();
            return;
         }
         if(this.tracks.length == 0)
         {
            this.timestamp = -1;
            this.playing = false;
            this.timer.stop();
            return;
         }
         var availChannels:uint = AudioUtil.MAX_CHANNELS;
         for each(track in this.tracks)
         {
            availChannels = availChannels - track.channelCount;
         }
         if(availChannels == 0)
         {
            return;
         }
         this.timestamp = getTimer();
         var count:uint = this.tracks.length;
         i = 0;
         while(i < count && availChannels > 0)
         {
            track = this.tracks[i] as SoundTrack;
            if(!track.finished)
            {
               if(this._listenerLoc && (this._listenerLocChanged || this.changedLocations[i]) && this.soundLocations[i])
               {
                  AudioUtil.updatePositionalConfig(this.soundLocations[i] as Vector3D,this._listenerLoc,track.positionalCfg);
                  track.updatePositionalInfo();
                  this.changedLocations[i] = false;
               }
               availChannels = availChannels - track.playAt(this.timestamp - this.trackIds[i] + this.trackStarts[i],availChannels);
            }
            i++;
         }
         this._listenerLocChanged = false;
         var finished:Array = new Array();
         i = 0;
         while(i < count)
         {
            if((this.tracks[i] as SoundTrack).finished)
            {
               finished.push(this.trackIds[i]);
            }
            i++;
         }
         count = finished.length;
         i = 0;
         while(i < count)
         {
            this.stop(finished[i]);
            i++;
         }
         if(finished.length > 0 && this.onTracksFinished != null)
         {
            try
            {
               this.onTracksFinished(finished);
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      public function get isPlaying() : Boolean
      {
         return this.playing;
      }
      
      public function play(param1:SoundTrack, param2:Number, param3:Vector3D) : Number
      {
         switch(param1.type)
         {
            case SoundTrack.SOUND_TYPE_AMB:
               param1.volume = this._volume * this._ambientVolume;
               break;
            case SoundTrack.SOUND_TYPE_EFF:
               param1.volume = this._volume * this._effectsVolume;
         }
         this.tracks.push(param1);
         var _loc4_:Number = getTimer();
         this.trackIds.push(_loc4_);
         this.trackStarts.push(param2);
         this.soundLocations.push(param3);
         this.changedLocations.push(param3 != null);
         this.playing = true;
         if(!this.timer.running)
         {
            this.timer.start();
         }
         return _loc4_;
      }
      
      public function stopAll() : void
      {
         var track:SoundTrack = null;
         var finished:Array = null;
         this.playing = false;
         this.timer.stop();
         for each(track in this.tracks)
         {
            track.stop();
         }
         finished = this.trackIds.concat();
         this.trackIds.length = 0;
         this.tracks.length = 0;
         this.trackStarts.length = 0;
         this.soundLocations.length = 0;
         this.changedLocations.length = 0;
         this.timestamp = -1;
         if(finished.length > 0 && this.onTracksFinished != null)
         {
            try
            {
               this.onTracksFinished(finished);
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      public function stop(param1:Number) : void
      {
         var _loc2_:int = this.trackIds.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         var _loc3_:SoundTrack = this.tracks[_loc2_];
         if(_loc3_)
         {
            _loc3_.stop();
         }
         this.trackIds.splice(_loc2_,1);
         this.tracks.splice(_loc2_,1);
         this.trackStarts.splice(_loc2_,1);
         this.soundLocations.splice(_loc2_,1);
         this.changedLocations.splice(_loc2_,1);
      }
      
      public function getTrack(param1:Number) : SoundTrack
      {
         var _loc2_:int = this.trackIds.indexOf(param1);
         if(_loc2_ < 0)
         {
            return null;
         }
         return this.tracks[_loc2_];
      }
      
      public function updateListenerLocation(param1:Vector3D) : void
      {
         if(!param1)
         {
            return;
         }
         if(this._listenerLoc != null && param1.equals(this._listenerLoc))
         {
            return;
         }
         this._listenerLoc = param1.clone();
         this._listenerLocChanged = true;
      }
      
      public function updateLocation(param1:Number, param2:Vector3D) : void
      {
         if(isNaN(param1))
         {
            return;
         }
         var _loc3_:int = this.trackIds.indexOf(param1);
         if(_loc3_ < 0)
         {
            return;
         }
         if(this.soundLocations[_loc3_] && (this.soundLocations[_loc3_] as Vector3D).equals(param2))
         {
            return;
         }
         this.soundLocations[_loc3_] = param2;
         this.changedLocations[_loc3_] = true;
      }
   }
}
