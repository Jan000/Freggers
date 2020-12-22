package de.freggers.audio
{
   import flash.events.Event;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class SoundLoop
   {
       
      
      private var _pan:Number;
      
      var _config:SoundConfig;
      
      private var _loopsPlayed:uint = 0;
      
      private var _soundDelay:uint = 0;
      
      private var _soundPlaying:Boolean = false;
      
      private var _playingChannel:SoundChannel;
      
      private var _volume:Number;
      
      private var _loopEndAt:Number;
      
      private var _loopStartAt:Number = -1;
      
      private var _touched:Boolean = false;
      
      public function SoundLoop(param1:SoundConfig, param2:Number = 0)
      {
         super();
         if(!param1.sound)
         {
            throw new Error("Cannot play sound loop without a sound");
         }
         this._config = param1;
         this._volume = param1.volume;
         this._pan = param2;
         this._soundDelay = this.generateDelay();
      }
      
      public function get finished() : Boolean
      {
         if(this._config.loopCount == 0)
         {
            return false;
         }
         return this._loopsPlayed >= this._config.loopCount;
      }
      
      public function get isInfinite() : Boolean
      {
         return this._config.loopCount < 1;
      }
      
      public function get hasChannel() : Boolean
      {
         return this._playingChannel != null;
      }
      
      public function playSoundAt(param1:Number) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:SoundTransform = null;
         var _loc4_:SoundChannel = null;
         if(!this.finished && !this._soundPlaying)
         {
            if(this._loopStartAt < 0)
            {
               this._loopStartAt = param1;
               this._loopEndAt = this._loopStartAt + this._soundDelay + this._config.sound.length;
            }
            if(param1 - this._loopStartAt < this._soundDelay)
            {
               return false;
            }
            this._soundPlaying = true;
            _loc2_ = this._config.volume;
            if(param1 < this._config.fadeInTime)
            {
               _loc2_ = _loc2_ * AudioUtil.clampVolume(param1 / this._config.fadeInTime);
            }
            _loc3_ = new SoundTransform(_loc2_,this._pan);
            _loc4_ = this._config.sound.play(0,0,_loc3_);
            _loc4_.addEventListener(Event.SOUND_COMPLETE,this.soundComplete);
            this._playingChannel = _loc4_;
            return true;
         }
         return false;
      }
      
      public function update(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:SoundTransform = null;
         if(param1 > this._config.fadeInTime && !this._touched)
         {
            return;
         }
         if(this._playingChannel)
         {
            _loc2_ = 1;
            if(this._config.fadeInTime > param1)
            {
               _loc2_ = AudioUtil.clampVolume(param1 / this._config.fadeInTime);
            }
            _loc3_ = this._config.volume * _loc2_;
            this._touched = false;
            _loc4_ = this._playingChannel.soundTransform;
            if(_loc3_ == _loc4_.volume && _loc4_.pan == this._pan)
            {
               return;
            }
            _loc4_.volume = _loc3_;
            _loc4_.pan = this._pan;
            this._playingChannel.soundTransform = _loc4_;
         }
      }
      
      function setVolume(param1:Number) : void
      {
         this._config.volume = param1 * this._volume;
         this._touched = true;
      }
      
      function setPanning(param1:Number) : void
      {
         this._pan = param1;
         this._touched = true;
      }
      
      function stop() : void
      {
         if(this._playingChannel)
         {
            this._playingChannel.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
            this._playingChannel.stop();
            this._playingChannel = null;
         }
      }
      
      private function generateDelay() : uint
      {
         if(this._config.loopMode == SoundConfig.LOOP_MODE_NORMAL || this._config.minDelay == this._config.maxDelay)
         {
            return this._config.minDelay;
         }
         return this._config.minDelay + Math.random() * (this._config.maxDelay - this._config.minDelay);
      }
      
      private function soundComplete(param1:Event) : void
      {
         var _loc2_:SoundChannel = param1.target as SoundChannel;
         _loc2_.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         this._playingChannel = null;
         this._loopsPlayed++;
         this._soundDelay = this.generateDelay();
         this._loopStartAt = -1;
         this._soundPlaying = false;
      }
   }
}
