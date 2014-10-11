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
        $this->entityManager = ServiceUtil::getService('doctrine.entitymanager');
        $this->request = ServiceUtil::getService('request');
        // hooks do not autoload the bootstrap for the module
        $helper = ServiceUtil::getService('doctrine_extensions');
        $helper->getListener('sluggable');
    }

    public function uiView(Zikula_DisplayHook $hook)
    {
        // Security check
        if (!SecurityUtil::checkPermission('MUFiles::', '::', ACCESS_READ)) {
            return;
        }
        // get data from $event
        $module = $hook->getCaller();
        $objectId = $hook->getId();
        $areaId = $hook->getAreaId();

        if (!$objectId) {
            return;
        }

        $hookObject = $this->entityManager->getRepository('MUFiles_Entity_Hookobject')->findBy(array('hookedModule' => $module, 'hookedObject' => 'collectionfile', 'areaId' => $areaId, 'objectId' => $objectId));

        $collectionrepository = MUFiles_Util_Model::getCollectionsRepository();

        $collections[] = $hookObject[0]['collectionhook'];
        $files[] = $hookObject[0]['filehook'];

        $this->view->assign('collections', $collections);
        $this->view->assign('files', $files);

        // add this response to the event stack
        $area = 'provider.mufiles.ui_hooks.service';
        $hook->setResponse(new Zikula_Response_DisplayHook($area, $this->view, 'hooks/view.tpl'));
    }

    /**
     * Display a checkbox for choose to create an album or not
     *
     * @param Zikula_DisplayHook $hook
     */
    public function uiEdit(Zikula_DisplayHook $hook)
    {
        // Security check
        if (!SecurityUtil::checkPermission('Tag::', '::', ACCESS_ADD)) {
            return;
        }
        $module = $hook->getCaller();
        $hookObjectId = $hook->getId();
        $objectId = isset($hookObjectId) ? $hookObjectId : 0;
        $areaId = $hook->getAreaId();

        // we get a collection repository
        $collectionrepository = MUFiles_Util_Model::getCollectionsRepository();
        // we get a file repository
        $filerepository = MUFiles_Util_Model::getFilesRepository();
        // we get a hookobject repository
        $hookobjectrepository = MUFiles_Util_Model::getHookedObjectRepository();
        // we get all collections
        $collections = $collectionrepository->selectWhere();
        //we check for hooked collection object
        $where = 'tbl.hookedModule = \'' . DataUtil::formatForStore($module) . '\'';
        $where .= ' AND ';
        $where .= 'tbl.objectId = \'' . DataUtil::formatForStore($objectId) . '\'';
        $where .= ' AND ';
        $where .= 'tbl.areaId = \'' . DataUtil::formatForStore($areaId) . '\'';
        $where .= ' AND ';
        $where .= 'tbl.hookedObject = \'' . DataUtil::formatForStore('collection') . '\'';

        $hookObject = $hookobjectrepository->selectWhere($where);
        if (!is_array($hookObject)) {

        } else {

        }
        // we get all files
        $files = $filerepository->selectWhere();
        // assign all collections
        $this->view->assign('collections', $collections);
        $this->view->assign('files', $files);


        $hook->setResponse(new Zikula_Response_DisplayHook('provider.mufiles.ui_hooks.service', $this->view, 'hooks/edit.tpl'));
    }

    /**
     * validation handler for validate_edit hook type.
     *
     * @param Zikula_ValidationHook $hook
     *
     * @return void
     */
    public function validateEdit(Zikula_ValidationHook $hook)
    {
        // get data from post
        $data = $this->request->query->get('mufilescollection', null);

        // create a new hook validation object and assign it to $this->validation
        $this->validation = new Zikula_Hook_ValidationResponse('data', $data);

        $hook->setValidator('provider.mufiles.ui_hooks.service', $this->validation);
    }

    /**
     * process edit hook handler.
     *
     * @param Zikula_ProcessHook $hook
     *
     * @return void
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
                'url' => $hook->getUrl(),
                'hookdata' => $this->validation->getObject(),
        );
        ModUtil::apiFunc('MUFiles', 'user', 'hookedObject', $args);
    }
}
