package de.freggers.audio
{
   import flash.media.SoundChannel;
   
   public class SoundTrack
   {
      
      public static const SOUND_TYPE_EFF:int = 1;
      
      public static const SOUND_TYPE_AMB:int = 2;
       
      
      private var _loops:Vector.<SoundLoop>;
      
      private var _finished:Boolean;
      
      private var _type:int;
      
      private var _volume:Number = 1;
      
      private var _pan:Number = 0;
      
      private var _positionalCfg:PositionalConfig;
      
      public function SoundTrack(param1:Array, param2:int = 1)
      {
         super();
         this._loops = Vector.<SoundLoop>(param1);
         this._type = param2;
         this._positionalCfg = new PositionalConfig();
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function set pan(param1:Number) : void
      {
         var _loc3_:SoundLoop = null;
         this._pan = param1;
         var _loc2_:int = this._loops.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._loops[_loc4_];
            param1 = AudioUtil.clampPanning(this._pan + this._positionalCfg.panDistance / _loc3_._config.range);
            _loc3_.setPanning(param1);
            _loc4_++;
         }
      }
      
      public function get pan() : Number
      {
         return this._pan;
      }
      
      public function get finished() : Boolean
      {
         return this._finished;
      }
      
      public function get positionalCfg() : PositionalConfig
      {
         return this._positionalCfg;
      }
      
      public function addSoundLoop(param1:SoundLoop) : void
      {
         param1.setVolume(this._volume);
         param1.setPanning(this._pan);
         this._loops.push(param1);
      }
      
      public function set volume(param1:Number) : void
      {
         var _loc3_:SoundLoop = null;
         this._volume = param1;
         var _loc2_:int = this._loops.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._loops[_loc4_];
            _loc3_.setVolume(param1 * (1 - this._positionalCfg.distance / _loc3_._config.range));
            _loc4_++;
         }
      }
      
      public function updatePositionalInfo() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc5_:SoundLoop = null;
         var _loc3_:Number = Math.abs(this._positionalCfg.panDistance);
         var _loc4_:int = this._loops.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = this._loops[_loc6_];
            if(this._positionalCfg.distance <= _loc5_._config.range)
            {
               _loc1_ = this._volume * (1 - this._positionalCfg.distance / _loc5_._config.range);
               if(_loc3_ <= _loc5_._config.range)
               {
                  _loc2_ = AudioUtil.clampPanning(this._pan + this._positionalCfg.panDistance / _loc5_._config.range);
               }
               else
               {
                  _loc2_ = 0;
               }
            }
            else
            {
               _loc1_ = 0;
               _loc2_ = 0;
            }
            _loc5_.setVolume(_loc1_);
            _loc5_.setPanning(_loc2_);
            _loc6_++;
         }
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function playAt(param1:Number, param2:uint) : uint
      {
         var _loc3_:uint = 0;
         var _loc4_:SoundChannel = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:SoundLoop = null;
         if(param2 == 0)
         {
            return null;
         }
         if(!this._finished)
         {
            _loc3_ = param2;
            _loc5_ = false;
            _loc6_ = this._loops.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = this._loops[_loc7_];
               if(!_loc8_.finished)
               {
                  _loc5_ = true;
                  _loc8_.update(param1);
                  if(_loc3_ <= AudioUtil.MAX_CHANNELS && _loc3_ > 0)
                  {
                     if(_loc8_.playSoundAt(param1))
                     {
                        _loc3_--;
                     }
                  }
                  else
                  {
                     break;
                  }
               }
               _loc7_++;
            }
            this._finished = !_loc5_;
            return param2 - _loc3_;
         }
         return 0;
      }
      
      public function get channelCount() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:int = this._loops.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._loops[_loc3_].hasChannel)
            {
               _loc1_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function stop() : void
      {
         this._finished = true;
         var _loc1_:int = this._loops.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._loops[_loc2_].stop();
            _loc2_++;
         }
      }
   }
}
