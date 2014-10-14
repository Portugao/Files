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

        $hookObject = $this->entityManager->getRepository('MUFiles_Entity_Hookobject')->findOneBy(array('hookedModule' => $module, 'hookedObject' => 'collectionfile', 'areaId' => $areaId, 'objectId' => $objectId));

        $collectionrepository = MUFiles_Util_Model::getCollectionsRepository();

        if (is_object($hookObject['collectionhook'])) {
        $collections[] = $hookObject['collectionhook'];
        } else {
            $collections = '';
        }
        if (is_object($hookObject['filehook'])) {
        $files[] = $hookObject['filehook'];
        } else {
            $files = '';
        }

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

        $modelHelper = new MUFiles_Util_Model($this->view->getServicemanager());
        // we get a collection repository
        $collectionrepository = $modelHelper->getCollectionsRepository();
        // we get a file repository
        $filerepository = $modelHelper->getFilesRepository();
        // we get a hookobject repository
        $hookobjectrepository = $modelHelper->getHookedObjectRepository();
        // we get all collections
        $collections = $collectionrepository->selectWhere();
        // we get all files
        $files = $filerepository->selectWhere();

        //we check for hooked collectionfile object
        $where = 'tbl.hookedModule = \'' . DataUtil::formatForStore($module) . '\'';
        $where .= ' AND ';
        $where .= 'tbl.objectId = \'' . $hookObjectId . '\'';
        $where .= ' AND ';
        $where .= 'tbl.areaId = \'' . $areaId . '\'';
        $where .= ' AND ';
        $where .= 'tbl.hookedObject = \'' . DataUtil::formatForStore('collectionfile') . '\'';

        // we look if there is a hookoobject saved for this object
        $hookObject = $hookobjectrepository->selectWhere($where);

        // instanciate vars
        $selectedCollectionIds = '';
        $selectedFileIds = '';

        // we build array of selected collections ids if there
        // else we set this var to false
        $selectedCollections = $hookObject[0]['collectionhook'];

        if (is_object($selectedCollections) === true) {
            foreach ($selectedCollections as $selectedSingleCollection) {
                LogUtil::registerStatus($selectedSingleCollection['id']);
                $selectedCollectionIds[] = $selectedSingleCollection['id'];
            }
        } else {
            $selectedCollectionIds = false;
        }

        // we build array of selected files ids if there
        // else we set this var to false        
        $selectedFiles = $hookObject[0]['filehook'];
        
        if (is_object($selectedFiles) === true) {
            foreach ($selectedFiles as $selectedSingleFile) {
                $selectedFileIds[] = $selectedSingleFile['id'];
            }
        } else {         
                $selectedFileIds = false;           
        }

        // instanciate var
        $collectionout = "";
        foreach ($collections as $collection) {
            $selected = "";
            if (is_array($selectedCollectionIds)) {
                if (in_array($collection['id'], $selectedCollectionIds)) {
                    $collectionout .= "<option selected=selected value=" . $collection['id'] . ">" . $collection['name'] . "</option>";
                } else {
                    $collectionout .= "<option value=" . $collection['id'] . ">" . $collection['name'] . "</option>";
                }
            } else {
                $collectionout .= "<option value=" . $collection['id'] . ">" . $collection['name'] . "</option>";

            }
        }

        // instanciate var
        $fileout = "";
        foreach ($files as $file) {
            $selected = "";
            if (is_array($selectedFileIds)) {
                if (in_array($file['id'], $selectedFileIds)) {
                    $fileout .= "<option selected=selected value=" . $file['id'] . ">" . $file['title'] . "</option>";
                } else {
                    $fileout .= "<option value=" . $file['id'] . ">" . $file['title'] . "</option>";
                }
            } else {
                $fileout .= "<option value=" . $file['id'] . ">" . $file['title'] . "</option>";
            }
        }

        // assign all collections and files
        $this->view->assign('collections', $collectionout);
        $this->view->assign('files', $fileout);

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
