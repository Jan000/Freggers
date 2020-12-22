package de.freggers.net
{
   import de.freggers.net.command.ActionThrow;
   import de.freggers.net.command.ActionUpdateWob;
   import de.freggers.net.command.ChatSrv;
   import de.freggers.net.command.ChatUsr;
   import de.freggers.net.command.CtxtRoom;
   import de.freggers.net.command.CtxtServer;
   import de.freggers.net.command.EnvItem;
   import de.freggers.net.command.EnvMisc;
   import de.freggers.net.command.EnvUser;
   import de.freggers.net.command.ListCmd;
   import de.freggers.net.command.MayVote;
   import de.freggers.net.command.TrRoomJoin;
   import de.freggers.net.command.TrRoomLeave;
   import de.freggers.net.command.TrRoomReject;
   import de.freggers.net.data.InteractionData;
   import de.freggers.roomlib.util.MessageFilter;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.getTimer;
   
   public class Client extends EventDispatcher
   {
      
      public static const TOUCH_INTERVAL:int = 300000;
      
      public static const AUTO_RECONNECT_TIME:int = 10000;
      
      public static var DEBUG:Boolean = false;
      
      public static const PING:int = 256;
      
      public static const COM_LOGOUT:int = 0;
      
      public static const COM_LOGIN:int = 1;
      
      public static const COM_CONTEXT:int = 160;
      
      public static const COM_ENV:int = 10;
      
      public static const COM_TRANSFER:int = 3;
      
      public static const COM_MOVE:int = 4;
      
      public static const USER_COMMAND_WRAPPER:int = 5;
      
      public static const COM_CHAT:int = 16;
      
      public static const COM_MAND:int = 17;
      
      public static const COM_ACTION:int = 18;
      
      public static const COM_NOTIFY:int = 19;
      
      public static const COM_DATA:int = 208;
      
      public static const COM_MAY_VOTE:int = 106;
      
      public static const COM_VOTE:int = 105;
      
      public static const SET_HAND_HELD:int = 80;
      
      public static const CLEAR_HAND_HELD:int = 81;
      
      public static const USE_HAND_HELD_WITH:int = 82;
      
      public static const REQUEST_CLEAR_HAND_HELD:int = 83;
      
      public static const OPEN_BUY_ITEM_VIEW:int = 84;
      
      public static const SHOW_TIMER_BAR:int = 85;
      
      public static const SHOW_ACTION_FEEDBACK:int = 86;
      
      public static const SRV_OFFER_HINT:int = 87;
      
      public static const SRV_SHOW_HINT:int = 88;
      
      public static const REQUEST_HINT:int = 89;
      
      public static const CLOSE_ROOM_HOP_MENU:int = 96;
      
      public static const OPEN_LIST_RECIPES_BY_INGREDIENT_VIEW:int = 99;
      
      public static const OPEN_CRAFT_RECIPE_VIEW:int = 104;
      
      public static const NOTIFY_CREDIT_ACCOUNT:int = 109;
      
      public static const OPEN_QUEST_VIEW:int = 110;
      
      public static const OPEN_QUEST_COMPLETED_VIEW:int = 111;
      
      public static const UPDATE_ROOMITEM_MENU:int = 112;
      
      public static const CTXT_ROOM:int = 1;
      
      public static const CTXT_SERVER:int = 15;
      
      public static const ENV_USER:int = 0;
      
      public static const ENV_EXIT:int = 1;
      
      public static const ENV_ITEM:int = 2;
      
      public static const ENV_MISC:int = 3;
      
      public static const ENV_BRIGHTNESS:int = 4;
      
      public static const ENV_REMOVE_ITEMS:int = 5;
      
      public static const ENV_ROOM_TOPIC:int = 6;
      
      public static const ENV_WOB_PROPERTIES:int = 7;
      
      public static const ENV_STAT:int = 15;
      
      public static const TR_ROOM_JOIN:int = 0;
      
      public static const TR_ROOM_LEAVE:int = 1;
      
      public static const TR_ROOM_REJECT:int = 2;
      
      public static const CHAT_USR:int = 0;
      
      public static const CHAT_SRV:int = 15;
      
      private static const MOVE_DIR:int = 0;
      
      private static const MOVE_WALKTO:int = 1;
      
      private static const MOVE_AUTOWALK:int = 2;
      
      private static const MOVE_AUTOWALK_EXACT:int = 3;
      
      private static const MOVE_POSUPD:int = 15;
      
      public static const MAND_USER:int = 0;
      
      public static const MAND_REFRESHIGNORES:int = 16;
      
      public static const MAND_ADMIN:int = 15;
      
      public static const ACTION_INTERACT:int = 3;
      
      public static const ACTION_SELDEFMENU:int = 2;
      
      public static const ACTION_SHOW_METROMAP:int = 10;
      
      public static const ACTION_ROOM_HOP:int = 11;
      
      public static const ACTION_OPEN_LOCKER:int = 13;
      
      public static const ACTION_OPEN_SHOP:int = 14;
      
      public static const ACTION_SPGAME:int = 15;
      
      public static const ACTION_THROW:int = 35;
      
      public static const ACTION_UPDATE_WOB:int = 48;
      
      public static const ACTION_LIFT_OBJ:int = 64;
      
      public static const ACTION_PLACE_OBJ:int = 65;
      
      public static const ACTION_OPEN_APARTMENT_LIST:int = 174;
      
      public static const COMPOSING_IDLE:int = 0;
      
      public static const COMPOSING_WRITING:int = 1;
      
      public static const STAT_KEY_COMPOSING:int = 0;
      
      public static const STAT_KEY_IDLE:int = 1;
      
      public static const STAT_KEY_AWAY:int = 2;
      
      public static const STAT_KEY_SHRINK:int = 4;
      
      public static const STAT_KEY_SIT:int = 5;
      
      public static const STAT_KEY_NOSOUND:int = 6;
      
      public static const STAT_KEY_PLAYING:int = 7;
      
      public static const STAT_KEY_CARRYING:int = 8;
      
      public static const STAT_KEY_GHOST:int = 9;
      
      public static const STAT_KEY_CLOAK:int = 10;
      
      public static const STAT_KEY_SPOOK:int = 11;
      
      public static const STAT_KEY_MODEL:int = 12;
      
      public static const STAT_KEY_QUICK_LIGHT:int = 13;
      
      public static const STAT_KEY_QUICK_STRONG:int = 14;
      
      public static const STAT_KEY_WITCHBROOM:int = 15;
      
      public static const STAT_KEY_PRANKED:int = 16;
      
      public static const DATA_GENERAL:int = 0;
      
      public static const ANIM_PLAYER:int = 0;
      
      public static const ANIM_OBJECT:int = 1;
      
      public static const NOTIFY_ONL_STAT:int = 0;
      
      public static const NOTIFY_STREAM:int = 1;
      
      public static const NOTIFY_MAIL:int = 2;
      
      public static const NOTIFY_INVENTORY:int = 3;
      
      public static const NOTIFY_COINS_OR_BILLS:int = 4;
      
      public static const NOTIFY_ITEMUPDATE:int = 5;
      
      public static const NOTIFY_STICKIES:int = 6;
      
      public static const NOTIFY_BADGE:int = 7;
      
      public static const NOTIFY_LEVEL:int = 8;
      
      public static const NOTIFY_CREATE_ITEM:int = 9;
      
      public static const NOTIFY_ITEM_INBOX:int = 10;
      
      public static const NOTIFY_MODEL_UPDATE:int = 11;
      
      public static const REASON_NORMAL:int = 0;
      
      public static const REASON_KICKED:int = 1;
      
      public static const REASON_THROWN_OUT_BY_COPY:int = 2;
      
      public static const ANIM_KEYVAL_PLAY:int = 1;
      
      public static const ANIM_KEYVAL_MODE:int = 2;
      
      public static const ANIM_KEYVAL_MILLIS:int = 3;
      
      public static const ANIM_KEY_PLAY:String = "play";
      
      public static const ANIM_KEY_MODE:String = "mode";
      
      public static const ANIM_KEY_MILLIS:String = "millis";
      
      public static const COMPONENT_INIT:int = 0;
      
      public static const COMPONENT_MCALL:int = 1;
      
      public static const COMPONENT_TYPE_ROOM:int = 0;
      
      public static const COMPONENT_TYPE_OBJ:int = 1;
      
      public static const COMPONENT_TYPE_OVRL:int = 2;
       
      
      private var _host:String;
      
      private var _port:int = -1;
      
      private var sock:Socket;
      
      private var inmsg:UtfMessage;
      
      private var listbuffers:Array;
      
      private var expectDisconnect:Boolean = false;
      
      private var lastClientSend:int = 0;
      
      private var flagAutoReconnect:Boolean = false;
      
      private var nextReconnectAttempt:int = 0;
      
      private var receiveCallback:Function;
      
      public var onAutoReconnect:Function;
      
      private var _roomContextId:int = 0;
      
      public function Client()
      {
         super();
         this.init();
      }
      
      public static function getObjectStatusData(param1:UtfMessage) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:UtfMessage = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = param1.get_arg_count() / 2;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.get_int_arg(_loc4_ * 2);
            switch(_loc5_)
            {
               case STAT_KEY_AWAY:
                  _loc2_[_loc5_] = param1.get_string_arg(_loc4_ * 2 + 1);
                  break;
               case STAT_KEY_COMPOSING:
               case STAT_KEY_IDLE:
                  _loc2_[_loc5_] = param1.get_int_arg(_loc4_ * 2 + 1);
                  break;
               case STAT_KEY_NOSOUND:
               case STAT_KEY_PLAYING:
               case STAT_KEY_SHRINK:
               case STAT_KEY_SIT:
               case STAT_KEY_GHOST:
               case STAT_KEY_CLOAK:
               case STAT_KEY_SPOOK:
               case STAT_KEY_MODEL:
               case STAT_KEY_QUICK_LIGHT:
               case STAT_KEY_QUICK_STRONG:
               case STAT_KEY_PRANKED:
                  _loc2_[_loc5_] = 1;
                  break;
               case STAT_KEY_CARRYING:
                  _loc6_ = param1.get_message_arg(_loc4_ * 2 + 1) as UtfMessage;
                  if(!_loc6_)
                  {
                     _loc2_[STAT_KEY_CARRYING] = null;
                  }
                  else
                  {
                     _loc2_[STAT_KEY_CARRYING] = new Object();
                     _loc2_[STAT_KEY_CARRYING]["wobid"] = _loc6_.get_int_arg(0);
                     _loc2_[STAT_KEY_CARRYING]["gui"] = _loc6_.get_string_arg(1);
                  }
                  break;
               case STAT_KEY_WITCHBROOM:
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function init() : void
      {
         this.listbuffers = new Array();
         this.inmsg = new UtfMessage();
         this.sock = new Socket();
         this.sock.timeout = 10000;
         this.sock.addEventListener(Event.CONNECT,this.handleEvent);
         this.sock.addEventListener(IOErrorEvent.IO_ERROR,this.handleEvent);
         this.sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleEvent);
         this.sock.addEventListener(ProgressEvent.SOCKET_DATA,this.handleData);
         this.sock.addEventListener(Event.CLOSE,this.handleEvent);
      }
      
      public function connect(param1:String, param2:int) : void
      {
         this._host = param1;
         this._port = param2;
         this.sock.connect(this._host,this._port);
      }
      
      public function get connected() : Boolean
      {
         if(!this.sock)
         {
            return false;
         }
         return this.sock.connected;
      }
      
      public function disconnect() : void
      {
         this.closeSocket();
         this.inmsg.reset(true);
      }
      
      private function send(param1:IUtfMessage) : int
      {
         return this.sendRaw(new UtfMessage().add_int_list_arg([USER_COMMAND_WRAPPER,this._roomContextId]).add_message_arg(param1));
      }
      
      private function sendRaw(param1:IUtfMessage) : int
      {
         var _loc2_:int = param1.send(this.sock);
         if(_loc2_ > 0)
         {
            this.lastClientSend = getTimer();
         }
         return _loc2_;
      }
      
      public function setRoomContextId(param1:int) : void
      {
         this._roomContextId = param1;
      }
      
      public function cleanup() : void
      {
         this.closeSocket();
         this.sock = null;
         this.inmsg = null;
         this._host = null;
         this._port = -1;
         this.receiveCallback = null;
         this.listbuffers = null;
      }
      
      private function closeSocket() : void
      {
         this.setRoomContextId(0);
         if(!this.sock || !this.sock.connected)
         {
            return;
         }
         this.sock.flush();
         try
         {
            this.sock.close();
            return;
         }
         catch(error:IOError)
         {
            return;
         }
      }
      
      private function autoReconnect() : void
      {
         this.nextReconnectAttempt = getTimer() + AUTO_RECONNECT_TIME;
         this.flagAutoReconnect = true;
         if(this.onAutoReconnect != null)
         {
            try
            {
               this.onAutoReconnect(this.nextReconnectAttempt);
               return;
            }
            catch(e:ArgumentError)
            {
               return;
            }
         }
      }
      
      private function handleEvent(param1:Event) : void
      {
         param1.stopPropagation();
         if(param1.type == Event.CLOSE)
         {
            if(this.expectDisconnect)
            {
               this.closeSocket();
            }
            else
            {
               this.autoReconnect();
            }
            return;
         }
         if(param1.type == IOErrorEvent.IO_ERROR)
         {
            this.autoReconnect();
            return;
         }
         dispatchEvent(param1);
      }
      
      private function handleData(param1:ProgressEvent) : void
      {
         var _loc2_:UtfMessage = null;
         while(this.sock.connected && this.sock.bytesAvailable)
         {
            _loc2_ = this.inmsg;
            if(_loc2_.read(this.sock))
            {
               this.inmsg = new UtfMessage();
               this.handleMessage(_loc2_.clone());
            }
         }
      }
      
      public function update(param1:int) : void
      {
         if(param1 - this.lastClientSend >= TOUCH_INTERVAL && this.connected)
         {
            this.sendTouch();
         }
         if(this.flagAutoReconnect && param1 > this.nextReconnectAttempt)
         {
            this.flagAutoReconnect = false;
            this.connect(this._host,this._port);
         }
      }
      
      private function getExitData(param1:UtfMessage) : Object
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:Object = new Object();
         _loc2_["polygon"] = param1.get_int_list_arg(0);
         var _loc3_:Array = param1.get_int_list_arg(1);
         _loc2_["z"] = _loc3_[0];
         _loc2_["dir"] = _loc3_[1];
         _loc2_["wobid"] = _loc3_[2];
         if(param1.get_arg_count() > 2)
         {
            _loc2_["gui"] = param1.get_string_arg(2);
         }
         return _loc2_;
      }
      
      private function parseHopExitData(param1:UtfMessage) : Object
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:Object = new Object();
         _loc2_["polygon"] = param1.get_int_list_arg(0);
         var _loc3_:Array = param1.get_int_list_arg(1);
         _loc2_["z"] = _loc3_[0];
         _loc2_["dir"] = _loc3_[1];
         _loc2_["label"] = param1.get_string_arg(2);
         return _loc2_;
      }
      
      private function handleEnvMessage(param1:UtfMessage) : Boolean
      {
         var _loc2_:Array = param1.get_int_list_arg(0);
         if(_loc2_[0] != COM_ENV)
         {
         }
         if(!this.listbuffers[_loc2_[1]])
         {
            this.listbuffers[_loc2_[1]] = new Array();
         }
         this.listbuffers[_loc2_[1]].push(param1.clone());
         return _loc2_[2] == 2 || _loc2_[2] == 3;
      }
      
      private function processListCmd(param1:UtfMessage, param2:Class) : ListCmd
      {
         var _loc3_:int = param1.get_int_list_arg(0)[1];
         var _loc4_:ListCmd = this.listbuffers[_loc3_];
         if(_loc4_ == null)
         {
            _loc4_ = new param2();
            this.listbuffers[_loc3_] = _loc4_;
         }
         _loc4_.feed(param1);
         if(_loc4_.isComplete())
         {
            this.listbuffers[_loc3_] = null;
            return _loc4_;
         }
         this.listbuffers[_loc3_] = _loc4_;
         return null;
      }
      
      private function processExitList() : Object
      {
         var _loc3_:int = 0;
         var _loc4_:UtfMessage = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:Object = new Object();
         var _loc2_:Array = new Array();
         if(this.listbuffers[ENV_EXIT])
         {
            _loc3_ = this.listbuffers[ENV_EXIT].length;
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc4_ = this.listbuffers[ENV_EXIT][_loc5_];
               _loc6_ = _loc4_.get_arg_count();
               _loc7_ = 2;
               while(_loc7_ < _loc6_)
               {
                  _loc2_.push(this.getExitData(_loc4_.get_message_arg(_loc7_) as UtfMessage));
                  _loc7_++;
               }
               _loc5_++;
            }
            _loc1_["room"] = _loc4_.get_string_arg(1);
         }
         this.listbuffers[ENV_EXIT] = null;
         _loc1_["exits"] = _loc2_;
         return _loc1_;
      }
      
      private function handleMessage(param1:UtfMessage) : void
      {
         var data:Object = null;
         var o:Object = null;
         var arr:Array = null;
         var info:Array = null;
         var i:int = 0;
         var n:int = 0;
         var com:Array = null;
         var ttl:int = 0;
         var result:int = 0;
         var name:String = null;
         var prop_map:Object = null;
         var carryMsg:UtfMessage = null;
         var prop:int = 0;
         var prop_msg:IUtfMessage = null;
         var nodes_msg:UtfMessage = null;
         var nodes:Array = null;
         var count:int = 0;
         var list:Array = null;
         var node:UtfMessage = null;
         var label:String = null;
         var enabled:Boolean = false;
         var usercount:int = 0;
         var userid_action:Array = null;
         var msg:UtfMessage = param1;
         if(!DEBUG)
         {
         }
         var command:int = -1;
         var subcommand:int = -1;
         var flag_handle:Boolean = false;
         this.expectDisconnect = false;
         var recievedAt:int = getTimer();
         if(msg.is_prepared())
         {
            if(msg.get_arg_count() > 0)
            {
               com = msg.get_int_list_arg(0);
               command = com[0];
               if(com.length > 1)
               {
                  subcommand = com[1];
               }
               switch(command)
               {
                  case PING:
                     ttl = msg.get_int_arg(1);
                     if(ttl > 0)
                     {
                        this.sendRaw(new UtfMessage().add_int_arg(PING).add_int_arg(ttl - 1));
                     }
                     break;
                  case COM_LOGOUT:
                     data = {"reason":msg.get_int_arg(1)};
                     this.expectDisconnect = true;
                     flag_handle = true;
                     break;
                  case COM_LOGIN:
                     result = msg.get_int_arg(1);
                     if(result == 0)
                     {
                        subcommand = result;
                        flag_handle = true;
                     }
                     data = {"wobid":msg.get_int_arg(2)};
                     break;
                  case COM_CONTEXT:
                     switch(subcommand)
                     {
                        case CTXT_SERVER:
                           data = new CtxtServer(msg);
                           this.setRoomContextId(0);
                           this.expectDisconnect = true;
                           flag_handle = true;
                           break;
                        case CTXT_ROOM:
                           data = new CtxtRoom(msg);
                           flag_handle = true;
                     }
                     break;
                  case COM_ENV:
                     switch(subcommand)
                     {
                        case ENV_USER:
                           data = this.processListCmd(msg,EnvUser);
                           flag_handle = data != null;
                           break;
                        case ENV_EXIT:
                           if(this.handleEnvMessage(msg))
                           {
                              data = this.processExitList();
                              flag_handle = true;
                           }
                           break;
                        case ENV_ITEM:
                           data = this.processListCmd(msg,EnvItem);
                           flag_handle = data != null;
                           break;
                        case ENV_STAT:
                           info = msg.get_int_list_arg(1);
                           data = new Object();
                           data["wobid"] = info[0];
                           data["userid"] = info[1];
                           data["rights"] = info[2];
                           data["set"] = com[2];
                           data["status"] = msg.get_int_arg(2);
                           if(msg.get_arg_count() == 4)
                           {
                              switch(data["status"])
                              {
                                 case STAT_KEY_AWAY:
                                    data["value"] = msg.get_string_arg(3);
                                    break;
                                 case STAT_KEY_CARRYING:
                                    carryMsg = msg.get_message_arg(3) as UtfMessage;
                                    if(!carryMsg)
                                    {
                                       data["value"] = null;
                                    }
                                    else
                                    {
                                       data["value"] = new Object();
                                       data["value"]["wobid"] = carryMsg.get_int_arg(0);
                                       data["value"]["gui"] = carryMsg.get_string_arg(1);
                                       data["value"]["dir"] = carryMsg.get_int_arg(2);
                                    }
                                    break;
                                 case STAT_KEY_COMPOSING:
                                 case STAT_KEY_GHOST:
                                 case STAT_KEY_CLOAK:
                                 case STAT_KEY_SPOOK:
                                 case STAT_KEY_MODEL:
                                 case STAT_KEY_IDLE:
                                 case STAT_KEY_NOSOUND:
                                 case STAT_KEY_PLAYING:
                                 case STAT_KEY_SHRINK:
                                 case STAT_KEY_SIT:
                                 case STAT_KEY_QUICK_LIGHT:
                                 case STAT_KEY_QUICK_STRONG:
                                 case STAT_KEY_PRANKED:
                                    data["value"] = msg.get_int_arg(3);
                              }
                           }
                           flag_handle = true;
                           break;
                        case ENV_MISC:
                           data = new EnvMisc(msg);
                           flag_handle = true;
                           break;
                        case ENV_BRIGHTNESS:
                           data = {"brightness":msg.get_int_arg(1)};
                           flag_handle = true;
                           break;
                        case ENV_REMOVE_ITEMS:
                           data = new Object();
                           data["removeall"] = com[3] == 1;
                           if(!data["removeall"])
                           {
                              data["wobids"] = msg.get_int_list_arg(1);
                           }
                           flag_handle = true;
                           break;
                        case ENV_ROOM_TOPIC:
                           data = new Object();
                           data["topic"] = msg.get_string_arg(1);
                           flag_handle = true;
                           break;
                        case ENV_WOB_PROPERTIES:
                           data = new Object();
                           data["wob_id"] = msg.get_int_arg(1);
                           prop_map = {};
                           prop = 2;
                           while(prop < msg.get_arg_count())
                           {
                              prop_msg = msg.get_message_arg(prop);
                              prop_map[prop_msg.get_string_arg(0)] = prop_msg.get_string_arg(1);
                              prop++;
                           }
                           data["prop_map"] = prop_map;
                           flag_handle = true;
                     }
                     break;
                  case COM_TRANSFER:
                     switch(subcommand)
                     {
                        case TR_ROOM_JOIN:
                           data = new TrRoomJoin(msg);
                           flag_handle = true;
                           break;
                        case TR_ROOM_LEAVE:
                           data = new TrRoomLeave(msg);
                           flag_handle = true;
                           break;
                        case TR_ROOM_REJECT:
                           data = new TrRoomReject(msg);
                           flag_handle = true;
                     }
                     break;
                  case COM_CHAT:
                     switch(subcommand)
                     {
                        case CHAT_USR:
                           data = new ChatUsr(msg);
                           flag_handle = true;
                           break;
                        case CHAT_SRV:
                           data = new ChatSrv(msg);
                           flag_handle = true;
                     }
                     break;
                  case COM_ACTION:
                     switch(com[1])
                     {
                        case ACTION_SHOW_METROMAP:
                           nodes_msg = msg.get_message_arg(1) as UtfMessage;
                           if(!nodes_msg)
                           {
                              return;
                           }
                           n = nodes_msg.get_arg_count();
                           nodes = new Array(n);
                           i = 0;
                           while(i < n)
                           {
                              node = UtfMessage(nodes_msg.get_message_arg(i));
                              label = node.get_string_arg(0);
                              name = node.get_string_arg(1);
                              enabled = node.get_int_arg(2) == 0?false:true;
                              usercount = node.get_int_arg(3);
                              nodes[i] = {
                                 "label":label,
                                 "name":name,
                                 "enabled":enabled,
                                 "usercount":usercount,
                                 "context":node.get_string_arg(4)
                              };
                              i++;
                           }
                           data = nodes;
                           flag_handle = true;
                           break;
                        case ACTION_ROOM_HOP:
                           data = new Object();
                           data["hop room label"] = msg.get_string_arg(1);
                           count = msg.get_arg_count();
                           list = new Array();
                           i = 2;
                           while(i < count)
                           {
                              list.push(this.parseHopExitData(msg.get_message_arg(i) as UtfMessage));
                              i++;
                           }
                           data["exits"] = list;
                           flag_handle = true;
                           break;
                        case ACTION_SPGAME:
                           data = {"label":msg.get_string_arg(1)};
                           flag_handle = true;
                           break;
                        case ACTION_UPDATE_WOB:
                           data = new ActionUpdateWob(msg);
                           flag_handle = true;
                           break;
                        case ACTION_OPEN_LOCKER:
                           data = new Object();
                           data["userid"] = msg.get_int_arg(1);
                           flag_handle = true;
                           break;
                        case ACTION_OPEN_SHOP:
                           data = new Object();
                           data["shopid"] = msg.get_int_arg(1);
                           flag_handle = true;
                           break;
                        case ACTION_OPEN_APARTMENT_LIST:
                           data = new Object();
                           data["label"] = msg.get_string_arg(1);
                           flag_handle = true;
                           break;
                        case ACTION_THROW:
                           data = new ActionThrow(msg);
                           flag_handle = true;
                     }
                     break;
                  case COM_NOTIFY:
                     switch(com[1])
                     {
                        case NOTIFY_ONL_STAT:
                           arr = msg.get_int_list_arg(1);
                           data = {
                              "userid":arr[0],
                              "status":arr[1],
                              "wobid":arr[2],
                              "username":msg.get_string_arg(2)
                           };
                           flag_handle = true;
                           break;
                        case NOTIFY_CREATE_ITEM:
                           data = {
                              "gui":msg.get_string_arg(1),
                              "template_id":msg.get_int_arg(2),
                              "dir":msg.get_int_arg(3)
                           };
                           flag_handle = true;
                           break;
                        case NOTIFY_INVENTORY:
                           data = {
                              "item_container_id":msg.get_int_arg(1),
                              "item_id":msg.get_int_arg(2),
                              "type":msg.get_int_arg(3)
                           };
                           flag_handle = true;
                           break;
                        case NOTIFY_COINS_OR_BILLS:
                           data = {
                              "coins_delta":msg.get_int_list_arg(1)[0],
                              "bills_delta":msg.get_int_list_arg(1)[1],
                              "show_message":msg.get_boolean_arg(2)
                           };
                           flag_handle = true;
                           break;
                        case NOTIFY_STREAM:
                           data = null;
                           flag_handle = true;
                           break;
                        case NOTIFY_MAIL:
                           data = {
                              "userid":msg.get_int_arg(1),
                              "sender":msg.get_string_arg(2),
                              "body":msg.get_string_arg(3)
                           };
                           flag_handle = true;
                           break;
                        case NOTIFY_ITEMUPDATE:
                           data = {"wobid":msg.get_int_arg(1)};
                           flag_handle = true;
                           break;
                        case NOTIFY_STICKIES:
                           data = {
                              "wobid":msg.get_int_arg(1),
                              "delta":msg.get_int_list_arg(2)[0],
                              "total":msg.get_int_list_arg(2)[1]
                           };
                           flag_handle = true;
                           break;
                        case NOTIFY_BADGE:
                           data = {
                              "userid":msg.get_int_list_arg(1)[0],
                              "badgeid":msg.get_int_list_arg(1)[1],
                              "message":msg.get_string_arg(2),
                              "stepComplete":msg.get_boolean_arg(3)
                           };
                           flag_handle = true;
                           break;
                        case NOTIFY_LEVEL:
                           arr = msg.get_int_list_arg(1);
                           data = {
                              "level":arr[0],
                              "xp_total":arr[1],
                              "xp_current":arr[2],
                              "xp_cap":arr[3],
                              "xp_delta":arr[4]
                           };
                           flag_handle = true;
                           break;
                        case NOTIFY_ITEM_INBOX:
                        case NOTIFY_MODEL_UPDATE:
                           data = null;
                           flag_handle = true;
                     }
                     break;
                  case COM_DATA:
                     switch(com[1])
                     {
                        case DATA_GENERAL:
                           data = {
                              "objid":msg.get_int_arg(1),
                              "datamsg":UtfMessage(msg.get_message_arg(2))
                           };
                           flag_handle = true;
                     }
                     break;
                  case COM_MAND:
                     switch(com[1])
                     {
                        case MAND_REFRESHIGNORES:
                           userid_action = msg.get_int_list_arg(1);
                           data = {
                              "userid":userid_action[0],
                              "action":userid_action[1],
                              "username":msg.get_string_arg(2)
                           };
                           flag_handle = true;
                     }
                     break;
                  case SET_HAND_HELD:
                     data = {
                        "gui":msg.get_string_arg(1),
                        "count":msg.get_int_arg(2),
                        "consumer_wobids":msg.get_int_list_arg(3)
                     };
                     flag_handle = true;
                     break;
                  case CLEAR_HAND_HELD:
                     data = null;
                     flag_handle = true;
                     break;
                  case OPEN_BUY_ITEM_VIEW:
                     data = msg.get_int_arg(1);
                     flag_handle = true;
                     break;
                  case SHOW_TIMER_BAR:
                     data = msg.get_int_arg(1);
                     flag_handle = true;
                     break;
                  case SHOW_ACTION_FEEDBACK:
                     data = msg.get_string_arg(1);
                     flag_handle = true;
                     break;
                  case SRV_OFFER_HINT:
                     data = msg.get_boolean_arg(1);
                     flag_handle = true;
                     break;
                  case SRV_SHOW_HINT:
                     data = msg.get_string_arg(1);
                     flag_handle = true;
                     break;
                  case CLOSE_ROOM_HOP_MENU:
                     flag_handle = true;
                     break;
                  case OPEN_LIST_RECIPES_BY_INGREDIENT_VIEW:
                     data = msg.get_int_arg(1);
                     flag_handle = true;
                     break;
                  case OPEN_CRAFT_RECIPE_VIEW:
                     data = {
                        "recipe_id":msg.get_int_arg(1),
                        "replace_item_id":msg.get_int_arg(2)
                     };
                     flag_handle = true;
                     break;
                  case COM_MAY_VOTE:
                     data = new MayVote(msg);
                     flag_handle = true;
                     break;
                  case NOTIFY_CREDIT_ACCOUNT:
                     data = {
                        "credits_earned":msg.get_int_list_arg(1)[0],
                        "credits_bought":msg.get_int_list_arg(1)[1]
                     };
                     flag_handle = true;
                     break;
                  case OPEN_QUEST_VIEW:
                     data = msg.get_string_arg(1);
                     flag_handle = true;
                     break;
                  case OPEN_QUEST_COMPLETED_VIEW:
                     data = {
                        "quest_label":msg.get_string_arg(1),
                        "next_quest_label":msg.get_string_arg(2)
                     };
                     flag_handle = true;
                     break;
                  case UPDATE_ROOMITEM_MENU:
                     data = {
                        "wob_id":msg.get_int_arg(1),
                        "interactions":new InteractionData(msg.get_message_arg(2) as UtfMessage),
                        "primary_interaction_label":msg.get_string_arg(3)
                     };
                     flag_handle = true;
               }
               if(flag_handle && command != -1)
               {
                  if(this.receiveCallback == null)
                  {
                     return;
                  }
                  try
                  {
                     this.receiveCallback(command,subcommand,data);
                     return;
                  }
                  catch(e:ArgumentError)
                  {
                     return;
                  }
               }
            }
         }
      }
      
      public function registerReceiveCallback(param1:Function) : void
      {
         this.receiveCallback = param1;
      }
      
      public function sendLogin(param1:String, param2:String) : void
      {
         this.sendRaw(new UtfMessage().add_int_arg(COM_LOGIN).add_string_arg(param1).add_string_arg(param2));
      }
      
      public function sendPing() : void
      {
         this.sendRaw(new UtfMessage().add_int_arg(PING).add_int_arg(10));
      }
      
      public function sendTouch() : void
      {
         this.sendRaw(new UtfMessage());
      }
      
      public function sendRoomLoaded(param1:String, param2:uint) : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_CONTEXT,CTXT_ROOM]).add_string_arg(param1).add_int_arg(param2));
      }
      
      public function sendUserMessage(param1:String, param2:int) : void
      {
         if(param1.length > 255)
         {
            param1 = param1.substring(0,252) + "...";
         }
         var _loc3_:String = MessageFilter.filter(param1);
         var _loc4_:IUtfMessage = new UtfMessage().add_int_list_arg([COM_CHAT,CHAT_USR,0]).add_string_arg(param1).add_int_arg(param2);
         if(_loc3_ != null)
         {
            _loc4_.add_string_arg(_loc3_);
         }
         this.send(_loc4_);
      }
      
      public function sendUserCommand(param1:String) : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_MAND,MAND_USER]).add_string_arg(param1));
      }
      
      public function sendAdminCommand(param1:String) : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_MAND,MAND_ADMIN]).add_string_arg(param1));
      }
      
      public function sendSetStatus(param1:int, param2:Array) : void
      {
         var _loc3_:IUtfMessage = new UtfMessage().add_int_list_arg([COM_ENV,ENV_STAT,1]).add_int_arg(param1);
         if(param2 != null && param2.length > 0)
         {
            if(param1 == STAT_KEY_COMPOSING || param1 == STAT_KEY_IDLE)
            {
               _loc3_.add_int_arg(param2[0]);
            }
            else if(STAT_KEY_AWAY)
            {
               _loc3_.add_string_arg(param2[0]);
            }
         }
         this.send(_loc3_);
      }
      
      public function sendDeleteStatus(param1:int) : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_ENV,ENV_STAT,0]).add_int_arg(param1));
      }
      
      public function sendDir(param1:int) : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_MOVE,MOVE_DIR]).add_int_arg(param1));
      }
      
      public function sendMoveOnGroundTo(param1:int, param2:int, param3:int, param4:String = null) : void
      {
         var _loc5_:IUtfMessage = new UtfMessage().add_int_list_arg([COM_MOVE,MOVE_WALKTO]).add_int_list_arg([param1,param2,param3]);
         if(param4)
         {
            _loc5_.add_string_arg(param4);
         }
         this.send(_loc5_);
      }
      
      public function sendAutoWalkTo(param1:String, param2:Boolean = true, param3:Boolean = false) : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_MOVE,!!param3?MOVE_AUTOWALK_EXACT:MOVE_AUTOWALK]).add_string_arg(param1).add_boolean_arg(param2));
      }
      
      public function sendLogout() : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_LOGOUT]));
      }
      
      public function sendUseHandheldWith(param1:int) : void
      {
         this.send(new UtfMessage().add_int_list_arg([USE_HAND_HELD_WITH]).add_int_arg(param1));
      }
      
      public function sendRequestClearHandHeld() : void
      {
         this.send(new UtfMessage().add_int_list_arg([REQUEST_CLEAR_HAND_HELD]));
      }
      
      public function sendPickUpObject(param1:uint) : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_ACTION,ACTION_LIFT_OBJ]).add_int_list_arg([param1]));
      }
      
      public function sendPlaceObjectCommand(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_ACTION,ACTION_PLACE_OBJ]).add_int_list_arg([param1,param2,param3,param4]));
      }
      
      public function sendRoomHopCommand(param1:String) : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_ACTION,ACTION_ROOM_HOP]).add_string_arg(param1));
      }
      
      public function sendShowMetroMap() : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_ACTION,ACTION_SHOW_METROMAP]));
      }
      
      public function sendItemInteraction(param1:int, param2:String, param3:Array = null) : void
      {
         var _loc4_:IUtfMessage = new UtfMessage().add_int_list_arg([COM_ACTION,ACTION_INTERACT]).add_int_arg(param1).add_string_arg(param2);
         if(param3 != null && param3.length == 3)
         {
            _loc4_.add_int_list_arg(param3);
         }
         this.send(_loc4_);
      }
      
      public function sendRequestHint() : void
      {
         this.send(new UtfMessage().add_int_list_arg([REQUEST_HINT]));
      }
      
      public function sendVote() : void
      {
         this.send(new UtfMessage().add_int_list_arg([COM_VOTE]));
      }
   }
}
