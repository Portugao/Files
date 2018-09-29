<?php
/**
 * Files.
 *
 * @copyright Michael Ueberschaer (MU)
 * @license http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
 * @author Michael Ueberschaer <info@homepages-mit-zikula.de>.
 * @link https://homepages-mit-zikula.de
 * @link https://ziku.la
 * @version Generated by ModuleStudio (https://modulestudio.de).
 */

namespace MU\FilesModule\Base;

use MU\FilesModule\Listener\EntityLifecycleListener;

/**
 * Events definition base class.
 */
abstract class AbstractFilesEvents
{
    /**
     * The mufilesmodule.itemactionsmenu_pre_configure event is thrown before the item actions
     * menu is built in the menu builder.
     *
     * The event listener receives an
     * MU\FilesModule\Event\ConfigureItemActionsMenuEvent instance.
     *
     * @see MU\FilesModule\Menu\MenuBuilder::createItemActionsMenu()
     * @var string
     */
    const MENU_ITEMACTIONS_PRE_CONFIGURE = 'mufilesmodule.itemactionsmenu_pre_configure';
    
    /**
     * The mufilesmodule.itemactionsmenu_post_configure event is thrown after the item actions
     * menu has been built in the menu builder.
     *
     * The event listener receives an
     * MU\FilesModule\Event\ConfigureItemActionsMenuEvent instance.
     *
     * @see MU\FilesModule\Menu\MenuBuilder::createItemActionsMenu()
     * @var string
     */
    const MENU_ITEMACTIONS_POST_CONFIGURE = 'mufilesmodule.itemactionsmenu_post_configure';
    /**
     * The mufilesmodule.collection_post_load event is thrown when collections
     * are loaded from the database.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterCollectionEvent instance.
     *
     * @see EntityLifecycleListener::postLoad()
     * @var string
     */
    const COLLECTION_POST_LOAD = 'mufilesmodule.collection_post_load';
    
    /**
     * The mufilesmodule.collection_pre_persist event is thrown before a new collection
     * is created in the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterCollectionEvent instance.
     *
     * @see EntityLifecycleListener::prePersist()
     * @var string
     */
    const COLLECTION_PRE_PERSIST = 'mufilesmodule.collection_pre_persist';
    
    /**
     * The mufilesmodule.collection_post_persist event is thrown after a new collection
     * has been created in the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterCollectionEvent instance.
     *
     * @see EntityLifecycleListener::postPersist()
     * @var string
     */
    const COLLECTION_POST_PERSIST = 'mufilesmodule.collection_post_persist';
    
    /**
     * The mufilesmodule.collection_pre_remove event is thrown before an existing collection
     * is removed from the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterCollectionEvent instance.
     *
     * @see EntityLifecycleListener::preRemove()
     * @var string
     */
    const COLLECTION_PRE_REMOVE = 'mufilesmodule.collection_pre_remove';
    
    /**
     * The mufilesmodule.collection_post_remove event is thrown after an existing collection
     * has been removed from the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterCollectionEvent instance.
     *
     * @see EntityLifecycleListener::postRemove()
     * @var string
     */
    const COLLECTION_POST_REMOVE = 'mufilesmodule.collection_post_remove';
    
    /**
     * The mufilesmodule.collection_pre_update event is thrown before an existing collection
     * is updated in the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterCollectionEvent instance.
     *
     * @see EntityLifecycleListener::preUpdate()
     * @var string
     */
    const COLLECTION_PRE_UPDATE = 'mufilesmodule.collection_pre_update';
    
    /**
     * The mufilesmodule.collection_post_update event is thrown after an existing new collection
     * has been updated in the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterCollectionEvent instance.
     *
     * @see EntityLifecycleListener::postUpdate()
     * @var string
     */
    const COLLECTION_POST_UPDATE = 'mufilesmodule.collection_post_update';
    
    /**
     * The mufilesmodule.file_post_load event is thrown when files
     * are loaded from the database.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterFileEvent instance.
     *
     * @see EntityLifecycleListener::postLoad()
     * @var string
     */
    const FILE_POST_LOAD = 'mufilesmodule.file_post_load';
    
    /**
     * The mufilesmodule.file_pre_persist event is thrown before a new file
     * is created in the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterFileEvent instance.
     *
     * @see EntityLifecycleListener::prePersist()
     * @var string
     */
    const FILE_PRE_PERSIST = 'mufilesmodule.file_pre_persist';
    
    /**
     * The mufilesmodule.file_post_persist event is thrown after a new file
     * has been created in the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterFileEvent instance.
     *
     * @see EntityLifecycleListener::postPersist()
     * @var string
     */
    const FILE_POST_PERSIST = 'mufilesmodule.file_post_persist';
    
    /**
     * The mufilesmodule.file_pre_remove event is thrown before an existing file
     * is removed from the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterFileEvent instance.
     *
     * @see EntityLifecycleListener::preRemove()
     * @var string
     */
    const FILE_PRE_REMOVE = 'mufilesmodule.file_pre_remove';
    
    /**
     * The mufilesmodule.file_post_remove event is thrown after an existing file
     * has been removed from the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterFileEvent instance.
     *
     * @see EntityLifecycleListener::postRemove()
     * @var string
     */
    const FILE_POST_REMOVE = 'mufilesmodule.file_post_remove';
    
    /**
     * The mufilesmodule.file_pre_update event is thrown before an existing file
     * is updated in the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterFileEvent instance.
     *
     * @see EntityLifecycleListener::preUpdate()
     * @var string
     */
    const FILE_PRE_UPDATE = 'mufilesmodule.file_pre_update';
    
    /**
     * The mufilesmodule.file_post_update event is thrown after an existing new file
     * has been updated in the system.
     *
     * The event listener receives an
     * MU\FilesModule\Event\FilterFileEvent instance.
     *
     * @see EntityLifecycleListener::postUpdate()
     * @var string
     */
    const FILE_POST_UPDATE = 'mufilesmodule.file_post_update';
    
}
