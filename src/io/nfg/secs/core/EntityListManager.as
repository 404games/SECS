package io.nfg.secs.core {
  import io.nfg.secs.core.secs_internal;
  import io.nfg.secs.EntityList;
  
  /**
   * @author
   */
  public class EntityListManager {
    
    use namespace secs_internal;
    
    private var _list:Object;
    
    public function EntityListManager() {
      this._list = new Object();
    }
    
    /**
     *
     * @param components
     * @return
     */
    public function getList(components:Array):EntityList {
      
      var name:String = this.secs_internal::_generateListName(components);
      
      if (this._list.hasOwnProperty(name) && this._list[name] != null)
        return this._list[name];
      else
        return this.secs_internal::_setupList(components);
    }
    
    /**
     *
     * @param components
     * @return
     */
    secs_internal function _setupList(components:Array):EntityList {
      var name:String = this.secs_internal::_generateListName(components);
      this._list[name] = new EntityList(components);
      
      return this._list[name];
    }
    
    /**
     *
     * @param components
     * @return
     */
    secs_internal function _generateListName(components:Array):String {
      var name:String, names:Array = [];
      
      for (var i:int = 0; i < components.length; i++)
        names.push(components[i].toString());
      
      names.sort();
      
      name = names.join("");
      return name.replace('object ', '.');
    }
    
    secs_internal function get list():Object {
      return _list;
    }
  }
}
