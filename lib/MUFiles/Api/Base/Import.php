<?php
/**
 * MUFiles.
 *
 * @copyright Michael Ueberschaer (MU)
 * @license http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
 * @package MUFiles
 * @author Michael Ueberschaer <kontakt@webdesign-in-bremen.com>.
 * @link http://webdesign-in-bremen.com
 * @link http://zikula.org
 * @version Generated by ModuleStudio 0.7.0 (http://modulestudio.de).
 */

/**
 * Import api base class.
 */
class MUFiles_Api_Base_Import extends Zikula_AbstractApi
{
    /**
     * Return an array of items to show in the your account panel.
     *
     * @param array $args List of arguments.
     *
     * @return array List of collected account items
     */
    public function importCats()
    {
        $args['module'] = 'Downloads';

        $message = $this->insertDatas($args);

        // return message
        return LogUtil::registerStatus($message);
    }

    /**
     *
     * @param array $args
     * return string $status
     */
    public function insertDatas($args)
    {
        $module = $args['module'];

        $dom = ZLanguage::getModuleDomain($this->name);
        $status = '';

        $collectionsRepository = MUFiles_Util_Model::getCollectionsRepository();
        $filesRepository = MUFiles_Util_Model::getFilesRepository();

        $results = $this->getCategories($module);

        if ($results) {
            foreach ($results as $result) {
                $categories[] = $result;
            }
        }

        // we get an entity manager
        $serviceManager = ServiceUtil::getManager();
        $entityManager = $serviceManager->getService('doctrine.entitymanager');

        // we get a workflow helper
        $workflowHelper = new Zikula_Workflow('standard', 'MUFiles');

        if (is_array($categories)) {

            foreach ($categories as $category) {

                $data = $this->buildArrayForCollection($module, $category);
                $data[0]['name'] = $data[0]['id'] . '-' . $data[0]['name'];

                // we build new collection
                $newCollection = new MUFiles_Entity_Collection();

                $newCollection->setName($data[0]['name']);
                $newCollection->setDescription($data[0]['description']);
                $newCollection->setWorkflowState('approved');

                $entityManager->persist($newCollection);
                $success = $entityManager->flush();

                if ($success) {
                    $status .= __('Collection', $dom) . ' ' . $collectionName . ' ' . __('created', $dom) . '<br />';
                }
            }

            foreach ($categories as $category) {
                // we get the just created new collection with the relevant name
                $searchTerm = $category['cid'] . '-' . $category['title'];
                $where = 'tbl.name = \'' . DataUtil::formatForStore($searchTerm) . '\'';

                $thisNewCollection = $collectionsRepository->selectWhere($where);
                if ($thisNewCollection) {
                    $thisNewCollectionObject = $collectionsRepository->selectById($thisNewCollection[0]['id']);

                    if ($category['pid'] > 0) {
                        $parentCollections = $this->getParentCollection($module, $category['pid']);
                        if ($parentCollections) {
                            foreach ($parentCollections as $parentCollection) {
                                $oneParentCollection[] = $parentCollection;
                            }

                            $searchTerm2 = $category['pid'] . '-' . $oneParentCollection[0]['title'];
                            unset($oneParentCollection);
                            $where2 = 'tbl.name = \'' . DataUtil::formatForStore($searchTerm2) . '\'';
                            $thisParentCollection = $collectionsRepository->selectWhere($where2);
                            if ($thisParentCollection) {
                                $thisParentCollectionObject = $collectionsRepository->selectById($thisParentCollection[0]['id']);

                                $thisNewCollectionObject->setParent($thisParentCollectionObject);
                                $entityManager->flush();
                            }
                        }
                    }
                }
            }
        }
        else {
            $status = __('There is no category of downloads module to import!', $dom);
            return $status;
        }

        // we set all new collections into workflow table
        $collections = $collectionsRepository->selectWhere();
        foreach ($collections as $collection) {
            $collectionObject = $collectionsRepository->selectById($collection['id']);
            $workflowState = WorkflowUtil::getWorkflowState($collectionObject, 'mufiles_collection');
            if ($workflowState == 'initial' || $workflowState === false) {
                // we set the datas into the workflow table
                $obj['__WORKFLOW__']['obj_table'] = 'collection';
                $obj['__WORKFLOW__']['obj_idcolumn'] = 'id';
                $obj['id'] = $collection['id'];
                $workflowHelper->registerWorkflow($obj, 'approved');
            }
        }

        $downloads = $this->getFiles($module);
        if ($downloads) {
            // we create placeholder collection
            $placeholderCollection = new MUFiles_Entity_Collection();

            $placeholderCollection->setName(__('Placeholder', $dom));
            $placeholderCollection->setDescription(__('This collection is for items having no category or a category that not exists.', $dom));
            $placeholderCollection->setWorkflowState('approved');
            $entityManager->persist($placeholderCollection);
            $entityManager->flush();

            // we get the just created new collection with the relevant name
            $searchTerm3 = __('Placeholder', $dom);
            $where3 = 'tbl.name = \'' . DataUtil::formatForStore($searchTerm3) . '\'';

            $thisPlaceholderCollection = $collectionsRepository->selectWhere($where3);
            if ($thisPlaceholderCollection) {
                $thisPlaceholderCollectionObject = $collectionsRepository->selectById($thisPlaceholderCollection[0]['id']);
                // we set the datas into the workflow table
                $obj['__WORKFLOW__']['obj_table'] = 'collection';
                $obj['__WORKFLOW__']['obj_idcolumn'] = 'id';
                $obj['id'] = $thisPlaceholderCollectionObject['id'];
                $workflowHelper->registerWorkflow($obj, 'approved');
            }

            // we create file for each download
            foreach ($downloads as $download) {
                $files[] = $download;
            }

            if (is_array($files)) {
                $uploadHandler = new MUFiles_UploadHandler();

                $serviceManager = ServiceUtil::getManager();
                $controllerHelper = new MUFiles_Util_Controller($serviceManager);

                $basePath = $controllerHelper->getFileBaseFolder('file', 'fileUpload');

                foreach ($files as $file) {

                        $data2 = $this->buildArrayForFile($module, $file);

                        //handle upload
                        $fileNameParts = explode('.', $data2[0]['uploadFile']);
                        $extension = strtolower($fileNameParts[count($fileNameParts) - 1]);
                        $allowedExtensions = explode(',', ModUtil::getVar($this->name, 'allowedExtensions'));
                        if (count($allowedExtensions) > 0) {
                            if (!in_array($extension, $allowedExtensions)) {
                                continue;
                            }
                        }

                        $objectType = 'file';
                        $fieldName = 'uploadFile';
                        $fileName = $data2[0]['uploadFile'];
                        $fileName = str_replace('userdata/Downloads/', '', $fileName);

                        // detect fileName
                        $backupFileName = $fileName;

                        $namingScheme = 0;

                        switch ($objectType) {
                            case 'file':
                                $namingScheme = 0;
                                break;
                        }


                        $iterIndex = -1;
                        do {
                            if ($namingScheme == 0) {
                                // original file name
                                $fileNameCharCount = strlen($fileName);
                                for ($y = 0; $y < $fileNameCharCount; $y++) {
                                    if (preg_match('/[^0-9A-Za-z_\.]/', $fileName[$y])) {
                                        $fileName[$y] = '_';
                                    }
                                }
                                // append incremented number
                                if ($iterIndex > 0) {
                                    // strip off extension
                                    $fileName = str_replace('.' . $extension, '', $backupFileName);
                                    // add iterated number
                                    $fileName .= (string) ++$iterIndex;
                                    // readd extension
                                    $fileName .= '.' . $extension;
                                } else {
                                    $iterIndex++;
                                }
                            } elseif ($namingScheme == 1) {
                                // md5 name
                                $fileName = md5(uniqid(mt_rand(), TRUE)) . '.' . $extension;
                            } elseif ($namingScheme == 2) {
                                // prefix with random number
                                $fileName = $fieldName . mt_rand(1, 999999) . '.' . $extension;
                            }
                        }
                        while (file_exists($basePath . $fileName)); // repeat until we have a new name

                        $source = $data2[0]['uploadFile'];
                        $destination = $basePath . $fileName;

                        copy($source, $destination);
                        $uploadHandler = new MUFiles_UploadHandler();
                        $metaData = $uploadHandler->readMetaDataForFile($fileName, $basePath . $fileName);
                        $metaData['originalName'] = $backupFileName;

                        if (!is_array($metaData)) {
                            continue;
                        }

                        // we build new collection
                        $newFile = new MUFiles_Entity_File();

                        $newFile->setTitle($data2[0]['title']);
                        $newFile->setDescription($data2[0]['description']);
                        $newFile->setWorkflowState('approved');
                        //$newFile->setCreatedDate($data2[0]['createdDate']);
                        //$newFile->setUpdatedDate($data2[0]['updatedDate']);
                        $newFile->setUploadFile($fileName);
                        $newFile->setUploadFileMeta($metaData);

                        if ($file['cid'] > 0) {
                            $parentCollections = $this->getParentCollection($module, $file['cid']);
                            if ($parentCollections) {
                                foreach ($parentCollections as $parentCollection) {
                                    $oneParentCollection[] = $parentCollection;
                                }

                                $searchTerm4 = $file['cid'] . '-' . $oneParentCollection[0]['title'];
                                unset($oneParentCollection);
                                $where4 = 'tbl.name = \'' . DataUtil::formatForStore($searchTerm4) . '\'';
                                $thisParentCollection = $collectionsRepository->selectWhere($where4);
                                if ($thisParentCollection) {
                                    $thisParentCollectionObject = $collectionsRepository->selectById($thisParentCollection[0]['id']);

                                    $newFile->setAliascollection($thisParentCollectionObject);

                                } else {
                                    $newFile->setAliascollection($thisPlaceholderCollectionObject);
                                }
                            }
                        }

                        $entityManager->persist($newFile);
                        $entityManager->flush();
                    
                }
            }

            // we set all new files into workflow table
            $files = $filesRepository->selectWhere();
            foreach ($files as $file) {
                $fileObject = $filesRepository->selectById($file['id']);
                $workflowState = WorkflowUtil::getWorkflowState($fileObject, 'mufiles_file');
                if ($workflowState == 'initial' || $workflowState === false) {
                    // we set the datas into the workflow table
                    $obj['__WORKFLOW__']['obj_table'] = 'file';
                    $obj['__WORKFLOW__']['obj_idcolumn'] = 'id';
                    $obj['id'] = $file['id'];
                    $workflowHelper->registerWorkflow($obj, 'approved');
                }
            }
        }
        
        // we set the name to the original
        foreach ($collections as $collection) {
            $collectionObject = $collectionsRepository->selectById($collection['id']);
            $positionOfChar = strpos($collection['name'], '-');
            $newName = substr($collection['name'], $positionOfChar + 1);
            $newName = html_entity_decode($newName);            
            $collectionObject->setName($newName);
            $entityManager->flush();
        }

        return $status;
    }

    /**
     *
     * Get categories of module
     * @param string $module    the module to work with
     *
     * @return an array of categories
     */
    private function getCategories($module)
    {
        $table = $this->getTableForCategory($module);

        //$moduletable = $this->getPraefix(). $table;

        $connect = $this->getDBConnection();

        // ask the DB for entries in the module table
        // handle the access to the module category table
        // build sql
        $query = "SELECT * FROM " . $table . " ORDER by cid";

        // prepare the sql query
        $sql = $connect->query($query);

        $connect = null;

        return $sql;
    }

    /**
     *
     * Get files of module
     * @param string $module    the module to work with
     *
     * @return an array of files
     */
    private function getFiles($module)
    {
        $table = $this->getTableForFile($module);

        //$moduletable = $this->getPraefix(). $table;

        $connect = $this->getDBConnection();

        // ask the DB for entries in the module table
        // handle the access to the module file table
        // build sql
        $query = "SELECT * FROM " . $table . " ORDER by lid";

        // prepare the sql query
        $sql = $connect->query($query);

        $connect = null;

        return $sql;
    }

    /**
     *
     * Get the parent album with the relevant id
     * @param string $module    the module to work with
     * @param int    $id     id of the album
     * @return an array of parent albums
     */
    private function getParentCollection($module, $id)
    {
        $table = $this->getTableForCategory($module);

        //$moduletable = $this->getPraefix(). $table;

        $connect = $this->getDBConnection();

        // ask the DB for entries in the module table
        // handle the access to the module album table
        // build sql
        $query = "SELECT * FROM $table WHERE cid = $id";

        // prepare the sql query
        $sql = $connect->query($query);


        $connect = null;

        return $sql;
    }

    /**
     *
     * Build data array for creating collection
     * @param array $result
     * @return array of values
     */
    private function buildArrayForCollection($module , $result)
    {
        if ($module == 'Downloads') {
            $result['title'] = utf8_encode($result['title']);
            $result['title'] = html_entity_decode($result['title'], ENT_COMPAT);
            $result['description'] = utf8_encode($result['description']);
            $data[] = array('id' => $result['cid'],
                    'parent_id' => $result['pid'],
                    'inFrontend' => 1,
                    'name' => $result['title'],
                    'description' => $result['description']);
        }
        return $data;
    }

    /**
     *
     * Build data array for creating collection
     * @param array $result
     * @return array of values
     */
    private function buildArrayForFile($module , $result)
    {
        if ($module == 'Downloads') {
            $result['title'] = utf8_encode($result['title']);
            $result['description'] = utf8_encode($result['description']);
            $data[] = array('id' => $result['lid'],
                    'collection' => $result['cid'],
                    'title' => $result['title'],
                    'description' => $result['description'],
                    'createdDate' => $result['date'],
                    'updatedDate' => $result['update'],
                    'uploadFile' => $result['url']);
        }
        return $data;
    }

    /**
     *
     * Get relevant table for category
     * @param string $module
     * @return string as table
     */
    private function getTableForCategory($module)
    {
        if ($module == 'Downloads') {
            $table = 'downloads_categories';
        }

        return $table;

    }

    /**
     *
     * Get relevant table for downloads
     * @param string $module
     * @return string as table
     */
    private function getTableForFile($module)
    {
        if ($module == 'Downloads') {
            $table = 'downloads_downloads';
        }

        return $table;

    }

    /**
     * Get a connection to DB
     *
     * @return a connection
     */
    private function getDBConnection()
    {
        //get host, db, user and pw
        $databases = ServiceUtil::getManager()->getArgument('databases');
        $connName = Doctrine_Manager::getInstance()->getCurrentConnection()->getName();
        $host = $databases[$connName]['host'];
        $dbname = $databases[$connName]['dbname'];
        $dbuser = $databases[$connName]['user'];
        $dbpassword = $databases[$connName]['password'];

        try {
            $connect = new PDO("mysql:host=$host;dbname=$dbname", $dbuser, $dbpassword);
        }

        catch (PDOException $e) {
            $this->__('Connection to database failed');
        }

        if (is_object($connect)) {
            return $connect;
        } else {
        	return false;
        }
        
    }
}
