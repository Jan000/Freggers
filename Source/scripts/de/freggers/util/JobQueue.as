package de.freggers.util
{
   import flash.utils.getTimer;
   
   public class JobQueue
   {
       
      
      private var _maxProcessingJobs:int = 0;
      
      private var _queuedJobs:Array;
      
      private var _running:Boolean = false;
      
      public function JobQueue(param1:int = 0)
      {
         super();
         this._queuedJobs = new Array();
         this._maxProcessingJobs = param1;
      }
      
      public function addJob(param1:IJob) : void
      {
         if(this._queuedJobs.indexOf(param1) != -1)
         {
            return;
         }
         param1.addedAt = getTimer();
         this._queuedJobs.push(param1);
      }
      
      public function set maxSimultaneousJobs(param1:int) : void
      {
         this._maxProcessingJobs = param1;
      }
      
      public function update(param1:int) : void
      {
         if(!this._running || this._queuedJobs.length == 0)
         {
            return;
         }
         this.cleanupQueue();
         if(this._queuedJobs.length == 0)
         {
            return;
         }
         this.processQueue();
      }
      
      private function processQueue() : void
      {
         var _loc1_:Array = null;
         if(this._maxProcessingJobs > 0)
         {
            _loc1_ = this._queuedJobs.filter(this.filterWaitingJobs);
            _loc1_ = _loc1_.slice(0,this._maxProcessingJobs);
            _loc1_.forEach(this.processJob);
         }
         else
         {
            this._queuedJobs.forEach(this.processJob);
         }
      }
      
      private function cleanupQueue() : void
      {
         this._queuedJobs = this._queuedJobs.filter(this.filterUnprocessedJobs);
      }
      
      protected function filterUnprocessedJobs(param1:IJob, param2:int, param3:Array) : Boolean
      {
         if(param1 && param1.flags != Job.PROCESSED)
         {
            return true;
         }
         return false;
      }
      
      protected function filterWaitingJobs(param1:IJob, param2:int, param3:Array) : Boolean
      {
         if(param1 && param1.flags == Job.WAITING)
         {
            return true;
         }
         return false;
      }
      
      protected function processJob(param1:IJob, param2:int, param3:Array) : void
      {
         if(!param1 || param1.flags != Job.WAITING)
         {
            return;
         }
         param1.flags = Job.PROCESSING;
         param1.process(getTimer());
         param1.flags = Job.PROCESSED;
      }
      
      public function start() : void
      {
         this._running = true;
      }
      
      public function stop() : void
      {
         this._running = false;
      }
   }
}
