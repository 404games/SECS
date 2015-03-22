package io.nfg.secs {
  import io.nfg.secs.core.secs_internal;
  
  /**
   * @author 
   */
  public class EntityList {
    private var _entities:Vector.<Entity>;
    
    private var _componentsCount:uint;
    public var _componentsNeeded:Vector.<Class>;
    
    private var _onEntityAddedFlag:Boolean = false;
    private var _onEntityRemovedFlag:Boolean = false;
    
    private var _onEntityAdded:Function = function(e:Entity):void {};
    private var _onEntityRemoved:Function = function(e:Entity):void {};
    
    public function EntityList(components:Array) {
      
      this._entities = new Vector.<Entity>();
      this._componentsNeeded = new Vector.<Class> ();
      
      this._componentsCount = components.length;
      
      for (var i:int = 0; i < this._componentsCount; i++)
        this._componentsNeeded.push ( components[i] ); 
    }
    
    public function get list():Vector.<Entity> {
      return this._entities;
    }
    public function get length():uint {
      return this._entities.length;
    }
    
    public function set onEntityAdded(value:Function):void {
      
      if ( this._onEntityAddedFlag )
        throw new Error('[SECS] "onEntityAdded" can\'t be defined twice');
      
      this._onEntityAdded = value;
      this._onEntityAddedFlag = true
    }
    
    public function set onEntityRemoved(value:Function):void {
      
      if ( this._onEntityRemovedFlag )
        throw new Error('[SECS] "onEntityRemoved" can\'t be defined twice');
      
      this._onEntityRemoved = value;
      this._onEntityRemovedFlag = true;
    }
    
    secs_internal function addEntity(entity:Entity):void {
      entity.secs_internal::_addedToEntitiesList ( this );
      this._onEntityAdded(entity);
      this._entities.push(entity);
    }
    
    secs_internal function removeEntity(entity:Entity, checkMatch:Boolean = true):void {    
      if ( checkMatch && !secs_internal::doesEntityMatch(entity) )
        return;
      
      this._onEntityRemoved(entity);
      this._entities.splice(this._entities.indexOf(entity), 1);
    }
    
    secs_internal function doesEntityMatch(entity:Entity):Boolean {
      
      for (var i:int = 0; i < this._componentsCount; i++)
        if ( entity.hasComponent ( this._componentsNeeded[i] ) == false )
          return false;
      
      return true;
    }
    
    public function toString():String {
      return "EntityList " + this._componentsNeeded.toString();
    }
  }
}
