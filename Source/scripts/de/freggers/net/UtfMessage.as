package de.freggers.net
{
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   public class UtfMessage implements IUtfMessage
   {
      
      public static const MAX_SIZE:int = 8193;
      
      public static const TYPE_UNKNOWN:int = -1;
      
      public static const TYPE_RECORD:int = 0;
      
      public static const TYPE_CHARS:int = 1;
      
      public static const TYPE_SHORTINT:int = 2;
      
      public static const TYPE_LONGINT:int = 3;
      
      public static const TYPE_NULL:int = 4;
      
      public static const TYPE_BOOLTRUE:int = 5;
      
      public static const TYPE_BOOLFALSE:int = 6;
      
      public static const TYPE_INT:int = 8;
      
      public static const TYPE_BOOLEAN:int = 9;
       
      
      private var arg_type_list:Array;
      
      private var arg_list:Array;
      
      private var flag_prepared:Boolean = false;
      
      private var read_buffer:int = 0;
      
      private var read_expected:int;
      
      private var data_pos:int = 0;
      
      private var data_expected:int = 0;
      
      private var data:ByteArray;
      
      public function UtfMessage()
      {
         super();
         this.arg_type_list = new Array();
         this.arg_list = new Array();
         this.data = new ByteArray();
      }
      
      public static function as_hash(param1:IUtfMessage) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:int = param1.get_arg_count();
         var _loc6_:Object = new Object();
         if(_loc2_ % 2 != 0)
         {
            return null;
         }
         var _loc7_:uint = 0;
         while(_loc7_ < _loc2_)
         {
            _loc3_ = param1.get_arg_type(_loc7_);
            if(_loc3_ != TYPE_CHARS)
            {
               return null;
            }
            _loc5_ = param1.get_string_arg(_loc7_);
            _loc3_ = param1.get_arg_type(_loc7_ + 1);
            switch(_loc3_)
            {
               case TYPE_CHARS:
                  _loc6_[_loc5_] = param1.get_string_arg(_loc7_ + 1);
                  break;
               case TYPE_INT:
                  _loc4_ = param1.get_int_list_arg(_loc7_ + 1);
                  if(_loc4_.length == 1)
                  {
                     _loc6_[_loc5_] = _loc4_[0];
                  }
                  else
                  {
                     _loc6_[_loc5_] = _loc4_;
                  }
                  break;
               case TYPE_BOOLEAN:
                  _loc6_[_loc5_] = param1.get_boolean_arg(_loc7_ + 1);
                  break;
               case TYPE_RECORD:
               case TYPE_NULL:
            }
            _loc7_ = _loc7_ + 2;
         }
         return _loc6_;
      }
      
      public static function as_array(param1:IUtfMessage) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:int = param1.get_arg_count();
         var _loc5_:Array = new Array(_loc2_);
         var _loc6_:uint = 0;
         while(_loc6_ < _loc2_)
         {
            _loc3_ = param1.get_arg_type(_loc6_);
            switch(_loc3_)
            {
               case TYPE_RECORD:
                  _loc5_[_loc6_] = UtfMessage.as_array(param1.get_message_arg(_loc6_));
                  break;
               case TYPE_CHARS:
                  _loc5_[_loc6_] = param1.get_string_arg(_loc6_);
                  break;
               case TYPE_INT:
                  _loc4_ = param1.get_int_list_arg(_loc6_);
                  if(_loc4_.length == 1)
                  {
                     _loc5_[_loc6_] = _loc4_[0];
                  }
                  else
                  {
                     _loc5_[_loc6_] = _loc4_;
                  }
                  break;
               case TYPE_BOOLEAN:
                  _loc5_[_loc6_] = param1.get_boolean_arg(_loc6_);
                  break;
               case TYPE_NULL:
               default:
                  _loc5_[_loc6_] = null;
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public static function gen_header(param1:int, param2:int) : int
      {
         return param2 << 3 & 65528 | param1 & 7;
      }
      
      public static function header_type(param1:int) : int
      {
         return param1 & 7;
      }
      
      public static function header_size(param1:int) : int
      {
         return param1 >> 3 & 8191;
      }
      
      public function add_message_arg(param1:IUtfMessage) : IUtfMessage
      {
         this.arg_type_list.push(TYPE_RECORD);
         this.arg_list.push(param1);
         this.flag_prepared = false;
         return this;
      }
      
      public function add_string_arg(param1:String) : IUtfMessage
      {
         this.arg_type_list.push(TYPE_CHARS);
         this.arg_list.push(param1);
         this.flag_prepared = false;
         return this;
      }
      
      public function add_int_arg(param1:int) : IUtfMessage
      {
         var _loc2_:Array = [param1];
         this.arg_type_list.push(TYPE_INT);
         this.arg_list.push(_loc2_);
         this.flag_prepared = false;
         return this;
      }
      
      public function add_int_list_arg(param1:Array) : IUtfMessage
      {
         this.arg_type_list.push(TYPE_INT);
         this.arg_list.push(param1);
         this.flag_prepared = false;
         return this;
      }
      
      public function add_null_arg() : IUtfMessage
      {
         this.arg_type_list.push(TYPE_NULL);
         this.arg_list.push(null);
         this.flag_prepared = false;
         return this;
      }
      
      public function add_boolean_arg(param1:Boolean) : IUtfMessage
      {
         this.arg_type_list.push(TYPE_BOOLEAN);
         this.arg_list.push(param1);
         this.flag_prepared = false;
         return this;
      }
      
      public function get_arg_count() : int
      {
         this.flag_prepared = false;
         return this.arg_list.length;
      }
      
      public function get_arg_type(param1:int) : int
      {
         return this.arg_type_list[param1];
      }
      
      public function estimate() : int
      {
         var _loc2_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc1_:int = 1;
         var _loc3_:int = 0;
         while(_loc3_ < this.arg_type_list.length)
         {
            _loc2_ = this.arg_list[_loc3_];
            switch(this.arg_type_list[_loc3_])
            {
               case TYPE_RECORD:
                  _loc1_ = _loc1_ + IUtfMessage(_loc2_).estimate();
                  break;
               case TYPE_CHARS:
                  _loc1_ = _loc1_ + (1 + String(_loc2_).length);
                  break;
               case TYPE_INT:
                  _loc4_ = 0;
                  _loc5_ = _loc2_ as Array;
                  _loc6_ = 0;
                  while(_loc6_ < _loc2_.length)
                  {
                     _loc4_ = Math.max(Math.abs(_loc5_[_loc6_]),_loc4_);
                     _loc6_++;
                  }
                  if(_loc4_ < 32768)
                  {
                     _loc1_ = _loc1_ + (1 + (_loc2_ as Array).length);
                  }
                  else
                  {
                     _loc1_ = _loc1_ + (1 + 2 * (_loc2_ as Array).length);
                  }
                  break;
               case TYPE_NULL:
               case TYPE_BOOLEAN:
                  _loc1_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function freespace() : int
      {
         return MAX_SIZE - this.estimate();
      }
      
      public function get_message_arg(param1:int) : IUtfMessage
      {
         if(this.arg_type_list[param1] == TYPE_RECORD)
         {
            return IUtfMessage(this.arg_list[param1]);
         }
         return null;
      }
      
      public function get_string_arg(param1:int) : String
      {
         if(this.arg_type_list[param1] == TYPE_CHARS)
         {
            return String(this.arg_list[param1]);
         }
         return null;
      }
      
      public function get_int_arg(param1:int) : int
      {
         if(this.arg_type_list[param1] == TYPE_INT)
         {
            return int((this.arg_list[param1] as Array)[0]);
         }
         return -1;
      }
      
      public function get_int_list_arg(param1:int) : Array
      {
         if(this.arg_type_list[param1] == TYPE_INT)
         {
            return this.arg_list[param1] as Array;
         }
         return null;
      }
      
      public function get_null_arg(param1:int) : Object
      {
         return null;
      }
      
      public function get_boolean_arg(param1:int) : Boolean
      {
         if(this.arg_type_list[param1] == TYPE_BOOLEAN)
         {
            return Boolean(this.arg_list[param1]);
         }
         return false;
      }
      
      public function reset(param1:Boolean) : void
      {
         this.arg_type_list.length = 0;
         this.arg_list.length = 0;
         this.flag_prepared = false;
         if(param1)
         {
            this.data_pos = 0;
            this.data = new ByteArray();
            this.data_expected = 0;
            this.flag_prepared = true;
         }
      }
      
      public function add_data_to(param1:IUtfMessage) : int
      {
         param1.add_data(this.data,0,this.data_pos);
         return this.data_pos;
      }
      
      public function add_data(param1:ByteArray, param2:int, param3:int) : void
      {
         this.flag_prepared = false;
         this.data.writeBytes(param1,param2 * 2,param3 * 2);
         this.data_pos = this.data_pos + param3;
      }
      
      public function set_data(param1:ByteArray, param2:int) : void
      {
         if(this.flag_prepared)
         {
            this.reset(true);
         }
         this.data = param1;
         this.data_pos = param2;
         this.flag_prepared = false;
      }
      
      public function extract_data_to(param1:int, param2:int, param3:IUtfMessage) : int
      {
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeBytes(this.data,param1 * 2,param2 * 2);
         param3.set_data(_loc4_,param2);
         return param1 + param2;
      }
      
      public function copy_data_to(param1:IUtfMessage, param2:int) : int
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeBytes(this.data,param2 * 2,this.data_pos * 2);
         param1.set_data(_loc3_,this.data_pos);
         return this.data_pos;
      }
      
      public function get_arg(param1:int) : Object
      {
         return this.arg_list[param1];
      }
      
      public function pack() : Boolean
      {
         var arg:Object = null;
         var buffer:String = null;
         var k:int = 0;
         var bval:Boolean = false;
         var list:Array = null;
         var mark_pos:int = 0;
         var sb:String = null;
         var max:int = 0;
         var int_type:int = 0;
         var flag_success:Boolean = true;
         this.data = new ByteArray();
         this.data.writeShort(0);
         this.data_pos = 1;
         var i:int = 0;
         while(i < this.arg_list.length && flag_success)
         {
            arg = this.arg_list[i];
            switch(this.arg_type_list[i])
            {
               case TYPE_RECORD:
                  if(UtfMessage(arg).pack())
                  {
                     this.data_pos = this.data_pos + UtfMessage(arg).add_data_to(this);
                  }
                  else
                  {
                     flag_success = false;
                  }
                  break;
               case TYPE_CHARS:
                  sb = String(arg);
                  this.data.writeShort(gen_header(TYPE_CHARS,sb.length));
                  k = 0;
                  while(k < sb.length)
                  {
                     this.data.writeShort(sb.charCodeAt(k));
                     k++;
                  }
                  break;
               case TYPE_INT:
                  max = 0;
                  list = arg as Array;
                  list.forEach(function(param1:int, param2:int, param3:Array):void
                  {
                     max = Math.max(max,Math.abs(param1));
                  });
                  int_type = max < 32768?int(TYPE_SHORTINT):int(TYPE_LONGINT);
                  if(int_type == TYPE_SHORTINT)
                  {
                     this.data.writeShort(gen_header(int_type,list.length));
                     list.forEach(function(param1:int, param2:int, param3:Array):void
                     {
                        data.writeShort(param1 + 65536 & 65535);
                     });
                  }
                  else
                  {
                     this.data.writeShort(gen_header(int_type,list.length * 2));
                     list.forEach(function(param1:int, param2:int, param3:Array):void
                     {
                        data.writeInt(param1);
                     });
                  }
                  break;
               case TYPE_NULL:
                  this.data.writeShort(gen_header(TYPE_NULL,0));
                  break;
               case TYPE_BOOLEAN:
                  this.data.writeShort(gen_header(!!Boolean(arg)?int(TYPE_BOOLTRUE):int(TYPE_BOOLFALSE),0));
                  break;
               default:
                  flag_success = false;
            }
            this.data_pos = this.data.length / 2;
            i++;
         }
         this.data.position = 0;
         this.data.writeShort(gen_header(TYPE_RECORD,this.data_pos - 1));
         this.data.position = this.data_pos * 2;
         if(flag_success)
         {
            this.flag_prepared = true;
         }
         return flag_success;
      }
      
      public function unpack() : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:UtfMessage = null;
         var _loc11_:String = null;
         var _loc1_:Boolean = true;
         this.data.position = 0;
         var _loc2_:* = this.data.readShort() & 65535;
         if(header_type(_loc2_) != TYPE_RECORD)
         {
            return false;
         }
         var _loc3_:int = header_size(_loc2_);
         while(this.data.position < (_loc3_ + 1) * 2 && _loc1_)
         {
            _loc6_ = null;
            _loc2_ = this.data.readShort() & 65535;
            _loc4_ = header_type(_loc2_);
            _loc5_ = header_size(_loc2_);
            switch(_loc4_)
            {
               case TYPE_RECORD:
                  _loc10_ = new UtfMessage();
                  this.data.position = 2 * this.extract_data_to(this.data.position / 2 - 1,_loc5_ + 1,_loc10_);
                  if(_loc10_.unpack())
                  {
                     _loc6_ = _loc10_;
                  }
                  else
                  {
                     _loc1_ = false;
                  }
                  break;
               case TYPE_CHARS:
                  _loc11_ = new String("");
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_)
                  {
                     _loc11_ = _loc11_ + String.fromCharCode(this.data.readShort() & 65535);
                     _loc8_++;
                  }
                  _loc6_ = _loc11_;
                  break;
               case TYPE_SHORTINT:
                  _loc7_ = new Array();
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_)
                  {
                     _loc7_.push(this.data.readShort() & 65535);
                     if(_loc7_[_loc8_] >= 32768)
                     {
                        _loc7_[_loc8_] = _loc7_[_loc8_] - 65536;
                     }
                     _loc8_++;
                  }
                  _loc6_ = _loc7_;
                  _loc4_ = TYPE_INT;
                  break;
               case TYPE_LONGINT:
                  _loc7_ = new Array();
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_)
                  {
                     _loc7_.push(this.data.readInt());
                     _loc8_ = _loc8_ + 2;
                  }
                  _loc6_ = _loc7_;
                  _loc4_ = TYPE_INT;
                  break;
               case TYPE_NULL:
                  _loc6_ = null;
                  break;
               case TYPE_BOOLTRUE:
                  _loc6_ = true;
                  _loc4_ = TYPE_BOOLEAN;
                  break;
               case TYPE_BOOLFALSE:
                  _loc6_ = false;
                  _loc4_ = TYPE_BOOLEAN;
                  break;
               default:
                  _loc4_ = TYPE_UNKNOWN;
                  _loc6_ = new Array();
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_)
                  {
                     (_loc6_ as Array).push(this.data.readShort());
                     _loc8_++;
                  }
            }
            this.arg_type_list.push(_loc4_);
            this.arg_list.push(_loc6_);
         }
         this.data_pos = this.data.position / 2;
         if(_loc1_)
         {
            this.flag_prepared = true;
         }
         return this.flag_prepared;
      }
      
      public function dump(param1:String = "") : String
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(!this.flag_prepared)
         {
            this.unpack();
         }
         var _loc2_:* = param1 + "{  # RECORD " + this.arg_list.length + " args\n";
         var _loc3_:int = 0;
         while(_loc3_ < this.arg_list.length)
         {
            _loc4_ = this.arg_list[_loc3_];
            _loc2_ = _loc2_ + (param1 + _loc3_ + ": ");
            switch(this.arg_type_list[_loc3_])
            {
               case TYPE_RECORD:
                  _loc2_ = _loc2_ + _loc4_.dump(param1 + "    ");
                  break;
               case TYPE_CHARS:
                  _loc2_ = _loc2_ + ("\"" + _loc4_ + "\"  # STRING length " + _loc4_.length + "\n");
                  break;
               case TYPE_INT:
                  _loc2_ = _loc2_ + "[";
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.length)
                  {
                     if(_loc5_ > 0)
                     {
                        _loc2_ = _loc2_ + ",";
                     }
                     _loc2_ = _loc2_ + _loc4_[_loc5_].toString(10);
                     _loc5_++;
                  }
                  _loc2_ = _loc2_ + ("]  # INT " + _loc4_.length + " args\n");
                  break;
               case TYPE_NULL:
                  _loc2_ = _loc2_ + "NULL\n";
                  break;
               case TYPE_BOOLEAN:
                  _loc2_ = _loc2_ + (!!Boolean(_loc4_)?"true":"false");
                  break;
               case TYPE_UNKNOWN:
                  _loc2_ = _loc2_ + ("UNKNOWN \'" + _loc4_ + "\'\n");
            }
            _loc3_++;
         }
         _loc2_ = _loc2_ + (param1 + "}  # end RECORD data_pos=" + this.data_pos + " chunks: " + this.data.length + "\n");
         return _loc2_;
      }
      
      public function is_prepared() : Boolean
      {
         return this.flag_prepared;
      }
      
      public function getLength() : int
      {
         if(!this.flag_prepared)
         {
            this.pack();
         }
         return this.data.position / 2;
      }
      
      public function read(param1:Socket) : Boolean
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         loop0:
         while(true)
         {
            if(param1.bytesAvailable <= 0)
            {
               return false;
            }
            _loc2_ = param1.readByte() & 255;
            switch(_loc2_ >> 4 & 15)
            {
               case 8:
               case 9:
               case 10:
               case 11:
                  this.read_buffer = this.read_buffer << 6 | _loc2_ & 63;
                  if(--this.read_expected < 0)
                  {
                     break loop0;
                  }
                  break;
               case 12:
               case 13:
                  this.read_buffer = _loc2_ & 31;
                  this.read_expected = 1;
                  break;
               case 14:
                  this.read_buffer = _loc2_ & 15;
                  this.read_expected = 2;
                  break;
               case 15:
                  this.read_buffer = _loc2_ & 7;
                  this.read_expected = 3;
                  break;
               default:
                  this.read_buffer = _loc2_ & 127;
                  this.read_expected = 0;
            }
            if(this.read_expected == 0)
            {
               this.data.writeShort(this.read_buffer & 65535);
               this.data_pos++;
               if(this.data_pos == 1 && this.read_buffer == 0)
               {
                  this.flag_prepared = true;
                  return true;
               }
               this.read_buffer = 0;
               if(this.data_expected == 0)
               {
                  _loc3_ = this.data.position;
                  this.data.position = 0;
                  _loc4_ = this.data.readShort() & 65535;
                  this.data.position = _loc3_;
                  if(header_type(_loc4_) != TYPE_RECORD)
                  {
                     this.data_expected = 0;
                     this.flag_prepared = true;
                     return true;
                  }
                  this.data_expected = header_size(_loc4_) + 1;
               }
               if(this.data_pos >= this.data_expected)
               {
                  if(this.data_pos > this.data_expected)
                  {
                     return true;
                  }
                  this.reset(false);
                  this.unpack();
                  return true;
               }
            }
         }
         this.read_buffer = 0;
         return false;
      }
      
      public function data_dump(param1:Array) : String
      {
         return "";
      }
      
      public function send(param1:Socket) : int
      {
         var _loc3_:* = 0;
         var _loc4_:ByteArray = null;
         if(!param1.connected)
         {
            return -1;
         }
         var _loc2_:int = 0;
         if(!this.flag_prepared)
         {
            this.pack();
         }
         this.data.position = 0;
         while(this.data.bytesAvailable > 0)
         {
            _loc3_ = this.data.readShort() & 65535;
            if(_loc3_ == 0)
            {
               param1.writeByte(0);
               _loc2_++;
            }
            else
            {
               _loc4_ = this.encodeToUTF8(_loc3_);
               _loc2_ = _loc2_ + _loc4_.length;
               param1.writeBytes(_loc4_);
            }
         }
         param1.flush();
         return _loc2_;
      }
      
      private function encodeToUTF8(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         if(param1 >= 0 && param1 <= 127)
         {
            _loc2_.writeByte(param1 & 127);
         }
         else if(param1 > 2047)
         {
            _loc2_.writeByte(224 | param1 >> 12 & 15);
            _loc2_.writeByte(128 | param1 >> 6 & 63);
            _loc2_.writeByte(128 | param1 & 63);
         }
         else
         {
            _loc2_.writeByte(192 | param1 >> 6 & 31);
            _loc2_.writeByte(128 | param1 & 63);
         }
         return _loc2_;
      }
      
      public function hexDump() : void
      {
         var _loc2_:String = null;
         if(!this.data || this.data.length == 0)
         {
         }
         this.data.position = 0;
         var _loc1_:String = "Binary data: ";
         while(this.data.bytesAvailable > 0)
         {
            _loc2_ = (this.data.readShort() & 65535).toString(16);
            while(_loc2_.length < 4)
            {
               _loc2_ = "0" + _loc2_;
            }
            _loc1_ = _loc1_ + (_loc2_ + " ");
         }
      }
      
      public function clone() : UtfMessage
      {
         var _loc1_:UtfMessage = new UtfMessage();
         if(this.arg_list)
         {
            _loc1_.arg_list = this.arg_list.slice();
         }
         if(this.arg_type_list)
         {
            _loc1_.arg_type_list = this.arg_type_list.slice();
         }
         _loc1_.flag_prepared = this.flag_prepared;
         _loc1_.data_expected = this.data_expected;
         _loc1_.data_pos = this.data_pos;
         if(this.data)
         {
            _loc1_.data = new ByteArray();
            _loc1_.data.readBytes(this.data);
         }
         _loc1_.read_expected = this.read_expected;
         _loc1_.read_buffer = this.read_buffer;
         return _loc1_;
      }
   }
}
