package de.freggers.util
{
   import flash.utils.Dictionary;
   
   public class LRUCache
   {
       
      
      private var cache:Dictionary;
      
      private var currentSize:uint;
      
      private var maxSize:uint;
      
      private var head:LRUCacheEntry;
      
      private var tail:LRUCacheEntry;
      
      public function LRUCache(param1:uint)
      {
         super();
         this.cache = new Dictionary();
         this.maxSize = param1;
         this.currentSize = 0;
      }
      
      public function put(param1:Object, param2:Object) : void
      {
         var _loc3_:LRUCacheEntry = new LRUCacheEntry(param1,param2);
         if(this.cache[param1] == null)
         {
            this.currentSize++;
         }
         this.cache[param1] = _loc3_;
         this.setMostRecentlyUsed(_loc3_);
         if(this.tail == null)
         {
            this.tail = _loc3_;
         }
         if(this.currentSize > this.maxSize)
         {
            this.purgeLRUElements();
         }
      }
      
      public function get(param1:Object) : Object
      {
         var _loc2_:LRUCacheEntry = this.cache[param1];
         if(_loc2_ != null)
         {
            this.setMostRecentlyUsed(_loc2_);
            return _loc2_.value;
         }
         return null;
      }
      
      public function remove(param1:Object) : void
      {
         var _loc2_:LRUCacheEntry = this.cache[param1];
         delete this.cache[param1];
         if(_loc2_ != null)
         {
            if(_loc2_ == this.head)
            {
               this.head = _loc2_.next;
            }
            if(_loc2_ == this.tail)
            {
               this.tail = _loc2_.prev;
            }
            if(_loc2_.prev != null)
            {
               _loc2_.prev.next = _loc2_.next;
            }
            if(_loc2_.next != null)
            {
               _loc2_.next.prev = _loc2_.prev;
            }
         }
         this.currentSize--;
      }
      
      private function purgeLRUElements() : void
      {
         while(this.currentSize > this.maxSize)
         {
            this.remove(this.tail.key);
         }
      }
      
      private function setMostRecentlyUsed(param1:LRUCacheEntry) : void
      {
         if(param1 == this.head)
         {
            return;
         }
         if(param1.prev != null)
         {
            param1.prev.next = param1.next;
            if(param1 == this.tail)
            {
               this.tail = param1.prev;
               this.tail.next = null;
            }
         }
         if(param1.next != null)
         {
            param1.next.prev = param1.prev;
         }
         param1.next = this.head;
         param1.prev = null;
         if(this.head != null)
         {
            this.head.prev = param1;
         }
         this.head = param1;
      }
   }
}

class LRUCacheEntry
{
    
   
   public var prev:LRUCacheEntry;
   
   public var next:LRUCacheEntry;
   
   public var key:Object;
   
   public var value:Object;
   
   function LRUCacheEntry(param1:Object, param2:Object)
   {
      super();
      this.key = param1;
      this.value = param2;
   }
}
