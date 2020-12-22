package de.freggers.net
{
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   public interface IUtfMessage
   {
       
      
      function add_message_arg(param1:IUtfMessage) : IUtfMessage;
      
      function add_string_arg(param1:String) : IUtfMessage;
      
      function add_int_arg(param1:int) : IUtfMessage;
      
      function add_int_list_arg(param1:Array) : IUtfMessage;
      
      function add_null_arg() : IUtfMessage;
      
      function add_boolean_arg(param1:Boolean) : IUtfMessage;
      
      function get_arg_count() : int;
      
      function get_arg_type(param1:int) : int;
      
      function estimate() : int;
      
      function freespace() : int;
      
      function get_message_arg(param1:int) : IUtfMessage;
      
      function get_string_arg(param1:int) : String;
      
      function get_int_arg(param1:int) : int;
      
      function get_int_list_arg(param1:int) : Array;
      
      function get_null_arg(param1:int) : Object;
      
      function get_boolean_arg(param1:int) : Boolean;
      
      function reset(param1:Boolean) : void;
      
      function add_data_to(param1:IUtfMessage) : int;
      
      function add_data(param1:ByteArray, param2:int, param3:int) : void;
      
      function set_data(param1:ByteArray, param2:int) : void;
      
      function copy_data_to(param1:IUtfMessage, param2:int) : int;
      
      function dump(param1:String = "") : String;
      
      function is_prepared() : Boolean;
      
      function data_dump(param1:Array) : String;
      
      function pack() : Boolean;
      
      function unpack() : Boolean;
      
      function read(param1:Socket) : Boolean;
      
      function send(param1:Socket) : int;
   }
}
