package de.freggers.roomlib
{
   import de.freggers.net.Client;
   import de.freggers.property.Property;
   import de.freggers.roomlib.util.ResourceRequest;
   import de.freggers.ui.ISelectable;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import flash.display.BitmapData;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Vector3D;
   
   public class IsoObjectContainer implements ISelectable
   {
      
      public static const ICONSCALE:Number = 0.5;
      
      private static const GHOST_ALPHA:Number = 0.5;
       
      
      private var _isoobj:IsoObject;
      
      public var onscreen:Boolean = false;
      
      public var lastRequest:ResourceRequest = null;
      
      private var _name:String;
      
      protected var _gui:String;
      
      public var topHeightPosition:Array;
      
      public var nstickies:int = 0;
      
      protected var _stateValues:Array;
      
      protected var _setStates:Array;
      
      private var _wobID:int;
      
      public var soundID:Number;
      
      protected var _interactions:Vector.<ItemInteraction>;
      
      private var _properties:Array;
      
      private var _propertiesChangedHandler:Function;
      
      public var interactive:Boolean = true;
      
      public function IsoObjectContainer(param1:int)
      {
         this._properties = new Array();
         super();
         this._wobID = param1;
         this._isoobj = new IsoObject(new Vector3D());
         this._stateValues = new Array();
         this._setStates = new Array();
         this._interactions = new Vector.<ItemInteraction>();
      }
      
      public function get isoobj() : IsoObject
      {
         return this._isoobj;
      }
      
      public function set gui(param1:String) : void
      {
         this._gui = param1;
      }
      
      public function get gui() : String
      {
         return this._gui;
      }
      
      public function get wobId() : int
      {
         return this._wobID;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         if(param1 == this._name)
         {
            return;
         }
         this._name = param1;
      }
      
      public function url(param1:Object) : String
      {
         return "";
      }
      
      public function setState(param1:uint, param2:Boolean, param3:Object) : void
      {
         this._setStates[param1] = param2;
         if(param2)
         {
            this._stateValues[param1] = param3;
         }
         else
         {
            this._stateValues[param1] = null;
         }
         this.applyState(param1);
      }
      
      public function clearStates() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._stateValues.length)
         {
            this._stateValues[_loc1_] = null;
            this._setStates[_loc1_] = false;
            this.applyState(this._stateValues[_loc1_]);
            _loc1_++;
         }
      }
      
      public function applyStates() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._stateValues.length)
         {
            this.applyState(this._stateValues[_loc1_]);
            _loc1_++;
         }
      }
      
      private function applyState(param1:uint) : void
      {
         switch(param1)
         {
            case Client.STAT_KEY_GHOST:
               this._isoobj.filters = !!this._setStates[param1]?[new ColorMatrixFilter([0.5,0.5,0.5,0,0,0.5,0.5,0.5,0,0,0.5,0.5,0.5,0,0,0,0,0,GHOST_ALPHA,0])]:null;
               break;
            case Client.STAT_KEY_SPOOK:
               if(this._setStates[param1])
               {
                  this._isoobj.displayflags = this._isoobj.displayflags | IsoObjectSpriteContent.FLAG_SPOOK;
               }
               else
               {
                  this._isoobj.displayflags = this._isoobj.displayflags & ~IsoObjectSpriteContent.FLAG_SPOOK;
               }
               break;
            case Client.STAT_KEY_MODEL:
               if(this._setStates[param1])
               {
                  this._isoobj.displayflags = this._isoobj.displayflags | IsoObjectSpriteContent.FLAG_MODEL;
               }
               else
               {
                  this._isoobj.displayflags = this._isoobj.displayflags & ~IsoObjectSpriteContent.FLAG_MODEL;
               }
         }
      }
      
      public function isStateSet(param1:uint) : Boolean
      {
         if(param1 < this._setStates.length)
         {
            return this._setStates[param1];
         }
         return false;
      }
      
      public function getState(param1:uint) : Object
      {
         if(param1 < this._stateValues.length)
         {
            return this._stateValues[param1];
         }
         return null;
      }
      
      public function cleanup() : void
      {
         if(this._isoobj)
         {
            this._isoobj.cleanup();
         }
         this._interactions.length = 0;
         this._isoobj = null;
         this._stateValues = null;
         this._setStates = null;
         this._propertiesChangedHandler = null;
         this._properties = null;
      }
      
      public function set onPropertiesChange(param1:Function) : void
      {
         this._propertiesChangedHandler = param1;
      }
      
      public function set properties(param1:Array) : void
      {
         var _loc2_:Array = this._properties;
         this._properties = param1 == null?new Array():param1.concat();
         if(this._propertiesChangedHandler != null)
         {
            this._propertiesChangedHandler(this,this._properties.concat(),_loc2_);
         }
      }
      
      public function get properties() : Array
      {
         if(this._properties == null)
         {
            return null;
         }
         return this._properties.concat();
      }
      
      public function getProperty(param1:String) : Property
      {
         var _loc2_:Property = null;
         for each(_loc2_ in this.properties)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get interactions() : Vector.<ItemInteraction>
      {
         return this._interactions;
      }
      
      public function set interactions(param1:Vector.<ItemInteraction>) : void
      {
         if(this._interactions == param1)
         {
            return;
         }
         this._interactions = param1;
      }
      
      public function getInteraction(param1:String) : ItemInteraction
      {
         var _loc2_:int = 0;
         if(this._interactions == null)
         {
            return null;
         }
         var _loc3_:int = this._interactions.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._interactions[_loc2_].label == param1)
            {
               return this._interactions[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getInteractionAt(param1:int) : ItemInteraction
      {
         if(this._interactions == null && param1 >= this._interactions.length)
         {
            return null;
         }
         return this._interactions[param1];
      }
      
      public function addInteraction(param1:String, param2:String) : void
      {
         var _loc3_:int = 0;
         if(this._interactions == null)
         {
            this._interactions = new Vector.<ItemInteraction>();
         }
         var _loc4_:int = this._interactions.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this._interactions[_loc3_].label == param1)
            {
               this._interactions[_loc3_].name = param2;
               return;
            }
            _loc3_++;
         }
         this._interactions.push(new ItemInteraction(param1,param2));
      }
      
      public function removeInteraction(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this._interactions == null)
         {
            return;
         }
         var _loc3_:int = this._interactions.length;
         var _loc4_:int = -1;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._interactions[_loc2_].label == param1)
            {
               _loc4_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         if(_loc4_ != -1)
         {
            this._interactions.splice(_loc4_,1);
         }
         if(this._interactions.length == 0)
         {
            this._interactions = null;
         }
      }
      
      public function removeInteractions() : void
      {
         this._interactions.length = 0;
         this._interactions = null;
      }
      
      public function hasInteraction(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         if(this._interactions == null)
         {
            return false;
         }
         var _loc3_:int = this._interactions.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._interactions[_loc2_].label == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function getPrimaryInteraction() : ItemInteraction
      {
         var _loc1_:ItemInteraction = null;
         for each(_loc1_ in this._interactions)
         {
            if(_loc1_.type == ItemInteraction.TYPE_PRIMARY)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getFirstSecondaryInteraction() : ItemInteraction
      {
         var _loc1_:ItemInteraction = null;
         for each(_loc1_ in this._interactions)
         {
            if(_loc1_.type == ItemInteraction.TYPE_SECONDARY)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function hasInteractions(param1:int = -1) : Boolean
      {
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         if(param1 == -1)
         {
            param1 = ItemInteraction.TYPE_PRIMARY | ItemInteraction.TYPE_SECONDARY;
         }
         var _loc3_:int = this._interactions.length;
         var _loc4_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this._interactions[_loc2_].type;
            if((int(param1) && int(_loc5_)) == _loc5_)
            {
               _loc4_++;
            }
            _loc2_++;
         }
         return _loc4_ > 0;
      }
      
      public function get isThrowTarget() : Boolean
      {
         return true;
      }
      
      public function get isTrash() : Boolean
      {
         return false;
      }
      
      public function get icon() : BitmapData
      {
         var _loc1_:ICroppedBitmapDataContainer = this._isoobj.media.getFrame(this._isoobj.animation,this._isoobj.direction,this._isoobj.frame);
         if(_loc1_.isvirtual)
         {
            return _loc1_.bitmapData;
         }
         return _loc1_.bitmapData.clone();
      }
   }
}
