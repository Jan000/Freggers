package de.freggers.net.data
{
   public interface IAvatarData extends IWOBStatus
   {
       
      
      function get userId() : int;
      
      function get userName() : String;
      
      function get rights() : int;
      
      function get status() : Array;
   }
}
