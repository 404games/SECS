package io.nfg.secs {
  import io.nfg.secs.core.EntityListManager;
  import io.nfg.secs.core.secs_internal;
  import io.nfg.secs.EntityList;
  import io.nfg.secs.core.interfaces.ISystem;
  import flash.utils.Dictionary;
  
  /**
   * Engine class provides an easy way to manage and update all systems
   * @author NotFoundGames
   */
  public class Engine {
    use namespace secs_internal;
    
    private static var _lists:EntityListManager = new EntityListManager();
    private static var _systems:Dictionary = new Dictionary();
    private static var _resources:Dictionary = new Dictionary();
    
    public function Engine() {
      throw new Error("You can't create an instance of type Engine");
    }
    
    static public function getList(components:Array):EntityList {
      return Engine._lists.getList(components);
    }
    
    /**
     * Updates all systems
     * @param ms
     */
    static public function update(ms:uint):void {
    
    if( ms == 0 ) return;
    
    var system:ISystem;
      for each( system in Engine._systems) {
        system.update(ms);
      }
    }
    
    /**
     * Adds a new system to the engine
     * @param system
     */
    static public function addSystem(system:Object):void {
      var systemClass:Class = Class(system.constructor);
      if(systemClass != null) {
        if(Engine._systems[systemClass] == null) {
          Engine._systems[systemClass] = system as ISystem;
          //system.secs::setEntityListManager( Engine._lists );
          //system.setup();
        } else {
          throw new Error('[SECS] system "' + flash.utils.getQualifiedClassName(systemClass) + " can't be added twice");
        }
      }
    }
    
    /**
     * Returns a system of give type
     * @param systemClass
     * @return  Object of type System or null if such system doesn't exist
     */
    static public function getSystem(systemClass:Class):ISystem {
      if(Engine._systems[systemClass] != null)
        return Engine._systems[systemClass];
      else
        throw new Error('[SECS] No System found for class "' + systemClass + '"');
    }
    
    /**
     * Adds a global reference to a resource
     * @param name
     * @param resource
     */
    static public function addResource(name:String, resource:Object):void {
      Engine._resources[name] = resource;
    }
    
    /**
     * Retrives a global reference to a give resource
     * @param name
     */
    static public function getResource(name:String):Object {
      if(Engine._resources[name] != null)
        return Engine._resources[name];
      else
        throw new Error('[SECS] No Resource found for key "' + name + '"');
    }
    
    static public function addEntity( entity:Entity ) : void {
      
      entity.secs_internal::_inEngine = true;
      
      var k:String;
      for( k in Engine._lists.secs_internal::list) {
      if( Engine._lists.secs_internal::list[k].secs_internal::doesEntityMatch( entity ) )
        Engine._lists.secs_internal::list[k].secs_internal::addEntity( entity );
      }
    }
    
    static public function removeEntity(entity:Entity) : void {
      var k:String;
      
      for( k in Engine._lists.secs_internal::list)
        Engine._lists.secs_internal::list[k].secs_internal::removeEntity( entity );
      
      entity.secs_internal::_inEngine = false;
    }
    
    static secs_internal function updateEntity( entity:Entity ) : void {
      var k:String;
      for( k in Engine._lists.secs_internal::list ) {
        if( entity._lists.indexOf( Engine._lists.secs_internal::list[k] ) == -1
        && Engine._lists.secs_internal::list[k].secs_internal::doesEntityMatch( entity ) )
          Engine._lists.secs_internal::list[k].secs_internal::addEntity( entity );
      }
    }
  }
}
