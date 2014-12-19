<?php
/**
 * MUFiles.
 *
 * @copyright Michael Ueberschaer (MU)
 * @license
 * @package MUFiles
 * @author Michael Ueberschaer <kontakt@webdesign-in-bremen.com>.
 * @link http://webdesign-in-bremen.com
 * @link http://zikula.org
 * @version Generated by ModuleStudio 0.6.2 (http://modulestudio.de).
 */

/**
 * This is the User api helper class.
 */
class MUFiles_Api_User extends MUFiles_Api_Base_User
{
    /**
     * Returns available user panel links.
     *
     * @return array Array of user links.
     */
    public function getlinks()
    {
        $links = array();

        if (SecurityUtil::checkPermission($this->name . '::', '::', ACCESS_ADMIN)) {
            $links[] = array('url' => ModUtil::url($this->name, 'admin', 'main'),
                    'text' => $this->__('Backend'),
                    'title' => $this->__('Switch to administration area.'),
                    'class' => 'z-icon-es-options');
        }

        $controllerHelper = new MUFiles_Util_Controller($this->serviceManager);
        $utilArgs = array('api' => 'user', 'action' => 'getlinks');
        $allowedObjectTypes = $controllerHelper->getObjectTypes('api', $utilArgs);

        if (in_array('collection', $allowedObjectTypes)
                && SecurityUtil::checkPermission($this->name . ':Collection:', '::', ACCESS_READ)) {
            $links[] = array('url' => ModUtil::url($this->name, 'user', 'view', array('ot' => 'collection')),
                    'text' => $this->__('Collections'),
                    'title' => $this->__('Collection list'));
        }
        if (in_array('file', $allowedObjectTypes)
                && SecurityUtil::checkPermission($this->name . ':File:', '::', ACCESS_READ)) {
            $links[] = array('url' => ModUtil::url($this->name, 'user', 'view', array('ot' => 'file')),
                    'text' => $this->__('Files'),
                    'title' => $this->__('File list'));
        }
        /* if (in_array('hookobject', $allowedObjectTypes)
         && SecurityUtil::checkPermission($this->name . ':Hookobject:', '::', ACCESS_READ)) {
        $links[] = array('url' => ModUtil::url($this->name, 'user', 'view', array('ot' => 'hookobject')),
                'text' => $this->__('Hookobjects'),
                'title' => $this->__('Hookobject list'));
        } */

        return $links;
    }

    /**
     * 
     * @param array $args
     * @return boolean
     */
    public function hookedObject(array $args)
    {
        $module = $args['hookedModule'];
        $objectid = $args['objectId'];
        $areaid = $args['areaId'];
        $url = $args['url'];
        $urlObject = $args['urlObject'];
        $hookdata = $args['hookdata'];
        $hookdata = DataUtil::cleanVar($hookdata);
        
        $workflowHelper = new Zikula_Workflow('none', 'MUFiles');

        $mufilescollections = $this->request->request->filter('mufilescollection', '');
        $mufilesfiles = $this->request->request->filter('mufilesfile', '');

        // we look if there in an entry for this object
        $hookObject = $this->isHookedObject($args);

        // if there is an entry and form fields are empty we delete the entry
        if ($hookObject && $mufilescollections == '' && $mufilesfiles == '') {
            $collectionHooks = $hookObject->getCollectionhook();
            foreach ($collectionHooks as $collectionHook) {
                $hookObject->removeCollectionHook($collectionHook);
            }
            $fileHooks = $hookObject->getFilehook();
            foreach ($fileHooks as $fileHook) {
                $hookObject->removeFileHook($fileHook);
            }
            $this->entityManager->flush();           
            $this->entityManager->remove($hookObject);
            $this->entityManager->flush();

        } else {
             
            if ($mufilescollections != '' || $mufilesfiles != '') {
                if (!$hookObject) {
                $hookedObject = new MUFiles_Entity_Hookobject('approved', $urlObject);
                $hookedObject->setObjectId($objectid);
                $hookedObject->setAreaId($areaid);
                $hookedObject->setHookedModule($module);
                $hookedObject->setHookedObject('collectionfile');
                $hookedObject->setUrl($urlObject->getUrl(null, null, false, false));
                $hookedObject->initWorkflow(true);
                } else {
                    $hookedObject = $hookObject;
                    $selectedCollections = $hookedObject->getCollectionhook();
                    foreach ($selectedCollections as $selectedSingleCollection) {
                        $hookedObject->removeCollectionhook($selectedSingleCollection);
                    }
                    $selectedFiles = $hookedObject->getFilehook();
                    foreach ($selectedFiles as $selectedSingleFiles) {
                        $hookedObject->removeFilehook($selectedSingleFiles);
                    }
                    $this->entityManager->flush();
                }

                if (is_array($mufilescollections)) {
                    foreach ($mufilescollections as $mufilescollection) {
                        $collection = $this->entityManager
                        ->getRepository('MUFiles_Entity_Collection')
                        ->findOneBy(array('id' => $mufilescollection));
                        $hookcollections[] = $collection;
                    }
                }
                if (is_array($mufilesfiles)) {
                    foreach ($mufilesfiles as $mufilesfile) {
                        $file = $this->entityManager
                        ->getRepository('MUFiles_Entity_File')
                        ->findOneBy(array('id' => $mufilesfile));
                        $hookfiles[] = $file;
                    }
                }
                $hookedObject->setCollectionhook($hookcollections);
                $hookedObject->setFilehook($hookfiles);
                $this->entityManager->persist($hookedObject);
                $this->entityManager->flush();                
            }
            return true;
        }
    }
    
    /**
     * 
     * @param array $args
     * @return object|boolean
     */  
    private function isHookedObject(array $args)
    {
        $module = $args['hookedModule'];
        $objectid = $args['objectId'];
        $areaid = $args['areaId'];
        $url = $args['url'];
        $hookdata = $args['hookdata'];

        $hookobjectrepository = MUFiles_Util_Model::getHookedObjectRepository();
        $hookObject = $this->entityManager->getRepository('MUFiles_Entity_Hookobject')->findOneBy(array('hookedModule' => $module, 'hookedObject' => 'collectionfile', 'areaId' => $areaid, 'objectId' => $objectid));


        if (is_object($hookObject)) {
            return $hookObject;
        } else {
            return false;
        }
    }
}
