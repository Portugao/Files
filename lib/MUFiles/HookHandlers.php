<?php
/**
 * MUFiles.
 *
 * @copyright Michael Ueberschaer
 * @license http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
 * @package MUFiles
 * @author Michael Ueberschaer <kontakt@webdesign-in-bremen.com>.
 * @link http://www.webdesign-in-bremen.com
 * @link http://zikula.org
 * @version at Thur May 8
 */

/**
 * HookHandler class
 */
class MUFiles_HookHandlers extends Zikula_Hook_AbstractHandler
{

    /**
     * Zikula_View instance
     * @var object
     */
    private $view;

    /**
     * Post constructor hook.
     */
    public function setup()
    {
        $this->view = Zikula_View::getInstance("MUFiles");
    }
    
    public function uiView(Zikula_DisplayHook $hook)
    {
        $mod = $hook->getCaller();
        $objectid = $hook->getId();
    }

    /**
     * Display a checkbox for choose to create an album or not
     *
     * @param Zikula_DisplayHook $hook
     */
    public function uiEdit(Zikula_DisplayHook $hook)
    {
        // we get the calling module
        $request = new Zikula_Request_Http();
        $module = $request->query->filter('module', '', FILTER_SANITIZE_STRING);
        // News module
        if($module == 'News') {
            $albumrepository = MUImage_Util_Model::getAlbumRepository();
            $where = 'tbl.parent_id IS NULL';
            $albums = $albumrepository->selectWhere($where);

            $where2 = 'tbl.parent_id IS NOT NULL';
            $subalbums = $albumrepository->selectWhere($where2);

            // assign the albums to template
            $this->view->assign('albums', $albums);
            // assign the subalbums to template
            $this->view->assign('subalbums', $subalbums);
        } else { // other modules
            // we get a collection repository
            $collectionrepository = MUFiles_Util_Model::getCollectionsRepository();
            // we get a file repository
            $filerepository = MUFiles_Util_Model::getFilesRepository();
            // we get all collections
            $collections = $collectionrepository->selectWhere();
            // we get all files
            $files = $filerepository->selectWhere();
            // assign all collections
            $this->view->assign('collections', $collections);
            $this->view->assign('files', $files);
        }

        $hook->setResponse(new Zikula_Response_DisplayHook('provider.mufiles.ui_hooks.service', $this->view, 'hook/edit.tpl'));
    }

    /**
     * Display a collection and provide interface for their use in an edit object form
     *
     * @param Zikula_DisplayHook $hook
     */
    public function processEdit(Zikula_ProcessHook $hook)
    {

        // check for validation here
        if (!$this->validation) {
            return;
        }
        
        $args = array(
                'hookedModule' => $hook->getCaller(),
                'objectId' => $hook->getId(),
                'areaId' => $hook->getAreaId(),
                'objUrl' => $hook->getUrl(),
                'urlObject' => $this->validation->getObject(),
        );
        ModUtil::apiFunc('MUFiles', 'user', 'hookedObject', $args);
    }
}
