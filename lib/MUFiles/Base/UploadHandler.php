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
 * @version Generated by ModuleStudio 0.6.1 (http://modulestudio.de).
 */

/**
 * Upload handler base class.
 */
class MUFiles_Base_UploadHandler
{
    /**
     * @var array List of object types with upload fields.
     */
    protected $allowedObjectTypes;

    /**
     * @var array List of file types to be considered as images.
     */
    protected $imageFileTypes;

    /**
     * @var array List of dangerous file types to be rejected.
     */
    protected $forbiddenFileTypes;

    /**
     * @var array List of allowed file sizes per field.
     */
    protected $allowedFileSizes;

    /**
     * Constructor initialising the supported object types.
     */
    public function __construct()
    {
        $this->allowedObjectTypes = array('file');
        $this->imageFileTypes = array('gif', 'jpeg', 'jpg', 'png', 'swf');
        $this->forbiddenFileTypes = array('cgi', 'pl', 'asp', 'phtml', 'php', 'php3', 'php4', 'php5', 'exe', 'com', 'bat', 'jsp', 'cfm', 'shtml');
        $this->allowedFileSizes = array('file' => array('uploadFile' => 102400));
    }

    /**
     * Process a file upload.
     *
     * @param string $objectType Currently treated entity type.
     * @param string $fileData   Form data array.
     * @param string $fieldName  Name of upload field.
     *
     * @return array Resulting file name and collected meta data.
     */
    public function performFileUpload($objectType, $fileData, $fieldName)
    {
        $dom = ZLanguage::getModuleDomain('MUFiles');
    
        $result = array('fileName' => '',
                        'metaData' => array());
    
        // check whether uploads are allowed for the given object type
        if (!in_array($objectType, $this->allowedObjectTypes)) {
            return $result;
        }
    
        // perform validation
        if (!$this->validateFileUpload($objectType, $fileData[$fieldName], $fieldName)) {
            // skip this upload field
            return $result;
        }
    
        // retrieve the final file name
        $fileName = $fileData[$fieldName]['name'];
        $fileNameParts = explode('.', $fileName);
        $extension = strtolower($fileNameParts[count($fileNameParts) - 1]);
        $extension = str_replace('jpeg', 'jpg', $extension);
        $fileNameParts[count($fileNameParts) - 1] = $extension;
        $fileName = implode('.', $fileNameParts);
    
        $serviceManager = ServiceUtil::getManager();
        $controllerHelper = new MUFiles_Util_Controller($serviceManager);
    
        // retrieve the final file name
        try {
            $basePath = $controllerHelper->getFileBaseFolder($objectType, $fieldName);
        } catch (\Exception $e) {
            return LogUtil::registerError($e->getMessage());
        }
        $fileName = $this->determineFileName($objectType, $fieldName, $basePath, $fileName, $extension);
    
        if (!move_uploaded_file($fileData[$fieldName]['tmp_name'], $basePath . $fileName)) {
            return LogUtil::registerError(__('Error! Could not move your file to the destination folder.', $dom));
        }
    
        // collect data to return
        $result['fileName'] = $fileName;
        $result['metaData'] = $this->readMetaDataForFile($fileName, $basePath . $fileName);
    
        return $result;
    }

    /**
     * Check if an upload file meets all validation criteria.
     *
     * @param string $objectType Currently treated entity type.
     * @param array $file Reference to data of uploaded file.
     * @param string $fieldName  Name of upload field.
     *
     * @return boolean true if file is valid else false
     */
    protected function validateFileUpload($objectType, $file, $fieldName)
    {
        $dom = ZLanguage::getModuleDomain('MUFiles');
    
        // check if a file has been uploaded properly without errors
        if ((!is_array($file)) || (is_array($file) && ($file['error'] != '0'))) {
            if (is_array($file)) {
                return $this->handleError($file);
            }
            return LogUtil::registerError(__('Error! No file found.', $dom));
        }
    
        // extract file extension
        $fileName = $file['name'];
        $fileNameParts = explode('.', $fileName);
        $extension = strtolower($fileNameParts[count($fileNameParts) - 1]);
        $extension = str_replace('jpeg', 'jpg', $extension);
    
        // validate extension
        $isValidExtension = $this->isAllowedFileExtension($objectType, $fieldName, $extension);
        if ($isValidExtension === false) {
            return LogUtil::registerError(__('Error! This file type is not allowed. Please choose another file format.', $dom));
        }
    
        // validate file size
        $maxSize = $this->allowedFileSizes[$objectType][$fieldName];
        if ($maxSize > 0) {
            $fileSize = filesize($file['tmp_name']);
            if ($fileSize > $maxSize) {
                $maxSizeKB = $maxSize / 1024;
                if ($maxSizeKB < 1024) {
                    $maxSizeKB = DataUtil::formatNumber($maxSizeKB); 
                    return LogUtil::registerError(__f('Error! Your file is too big. Please keep it smaller than %s kilobytes.', array($maxSizeKB), $dom));
                }
                $maxSizeMB = $maxSizeKB / 1024;
                $maxSizeMB = DataUtil::formatNumber($maxSizeMB); 
                return LogUtil::registerError(__f('Error! Your file is too big. Please keep it smaller than %s megabytes.', array($maxSizeMB), $dom));
            }
        }
    
        // validate image file
        $isImage = in_array($extension, $this->imageFileTypes);
        if ($isImage) {
            $imgInfo = getimagesize($file['tmp_name']);
            if (!is_array($imgInfo) || !$imgInfo[0] || !$imgInfo[1]) {
                return LogUtil::registerError(__('Error! This file type seems not to be a valid image.', $dom));
            }
        }
    
        return true;
    }

    /**
     * Read meta data from a certain file.
     *
     * @param string $fileName  Name of file to be processed.
     * @param string $filePath  Path to file to be processed.
     *
     * @return array collected meta data
     */
    public function readMetaDataForFile($fileName, $filePath)
    {
        $meta = array();
        if (empty($fileName)) {
            return $meta;
        }
    
        $extensionarr = explode('.', $fileName);
        $meta = array();
        $meta['extension'] = strtolower($extensionarr[count($extensionarr) - 1]);
        $meta['size'] = filesize($filePath);
        $meta['isImage'] = (in_array($meta['extension'], $this->imageFileTypes) ? true : false);
    
        if (!$meta['isImage']) {
            return $meta;
        }
    
        if ($meta['extension'] == 'swf') {
            $meta['isImage'] = false;
        }
    
        $imgInfo = getimagesize($filePath);
        if (!is_array($imgInfo)) {
            return $meta;
        }
    
        $meta['width'] = $imgInfo[0];
        $meta['height'] = $imgInfo[1];
    
        if ($imgInfo[1] < $imgInfo[0]) {
            $meta['format'] = 'landscape';
        } elseif ($imgInfo[1] > $imgInfo[0]) {
            $meta['format'] = 'portrait';
        } else {
            $meta['format'] = 'square';
        }
    
        return $meta;
    }

    /**
     * Determines the allowed file extensions for a given object type.
     *
     * @param string $objectType Currently treated entity type.
     * @param string $fieldName  Name of upload field.
     * @param string $extension  Input file extension.
     *
     * @return array the list of allowed file extensions
     */
    protected function isAllowedFileExtension($objectType, $fieldName, $extension)
    {
        // determine the allowed extensions
        $allowedExtensions = array();
        switch ($objectType) {
            case 'file':
                $allowedExtensions = array('pdf');
                    break;
        }
    
        if (count($allowedExtensions) > 0) {
            if (!in_array($extension, $allowedExtensions)) {
                return false;
            }
        }
    
        if (in_array($extension, $this->forbiddenFileTypes)) {
            return false;
        }
    
        return true;
    }

    /**
     * Determines the final filename for a given input filename.
     *
     * It considers different strategies for computing the result.
     *
     * @param string $objectType Currently treated entity type.
     * @param string $fieldName  Name of upload field.
     * @param string $basePath   Base path for file storage.
     * @param string $fileName   Input file name.
     * @param string $extension  Input file extension.
     *
     * @return string the resulting file name
     */
    protected function determineFileName($objectType, $fieldName, $basePath, $fileName, $extension)
    {
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
            } else if ($namingScheme == 1) {
                // md5 name
                $fileName = md5(uniqid(mt_rand(), TRUE)) . '.' . $extension;
            } else if ($namingScheme == 2) {
                // prefix with random number
                $fileName = $fieldName . mt_rand(1, 999999) . '.' . $extension;
            }
        }
        while (file_exists($basePath . $fileName)); // repeat until we have a new name
    
        // return the new file name
        return $fileName;
    }

    /**
     * Error handling helper method.
     *
     * @param array $file File array from $_FILES.
     *
     * @return boolean false
     */
    private function handleError($file)
    {
        $dom = ZLanguage::getModuleDomain('MUFiles');
        $errmsg = '';
        switch ($file['error']) {
            case UPLOAD_ERR_OK: //no error; possible file attack!
                $errmsg = __('Unknown error', $dom);
                break;
            case UPLOAD_ERR_INI_SIZE: //uploaded file exceeds the upload_max_filesize directive in php.ini
                $errmsg = __('File too big', $dom);
                break;
            case UPLOAD_ERR_FORM_SIZE: //uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the html form
                $errmsg = __('File too big', $dom);
                break;
            case UPLOAD_ERR_PARTIAL: //uploaded file was only partially uploaded
                $errmsg = __('File uploaded partially', $dom);
                break;
            case UPLOAD_ERR_NO_FILE: //no file was uploaded
                $errmsg = __('No file uploaded', $dom);
                break;
            case UPLOAD_ERR_NO_TMP_DIR: //missing a temporary folder
                $errmsg = __('No tmp folder', $dom);
                break;
            default: //a default (error, just in case!  :)
                $errmsg = __('Unknown error', $dom);
                break;
        }
    
        return LogUtil::registerError(__('Error with upload: ', $dom) . $errmsg);
    }

    /**
     * Deletes an existing upload file.
     * For images the thumbnails are removed, too.
     *
     * @param string  $objectType Currently treated entity type.
     * @param string  $objectData Object data array.
     * @param string  $fieldName  Name of upload field.
     * @param integer $objectId   Primary identifier of the given object.
     *
     * @return mixed Array with updated object data on success, else false.
     */
    public function deleteUploadFile($objectType, $objectData, $fieldName, $objectId)
    {
        if (!in_array($objectType, $this->allowedObjectTypes)) {
            return false;
        }
    
        if (empty($objectData[$fieldName])) {
            return $objectData;
        }
    
        $serviceManager = ServiceUtil::getManager();
        $controllerHelper = new MUFiles_Util_Controller($serviceManager);
    
        // determine file system information
        try {
            $basePath = $controllerHelper->getFileBaseFolder($objectType, $fieldName);
        } catch (\Exception $e) {
            LogUtil::registerError($e->getMessage());
            return $objectData;
        }
        $fileName = $objectData[$fieldName];
    
        // path to original file
        $filePath = $basePath . $fileName;
    
        // check whether we have to consider thumbnails, too
        $fileExtension = FileUtil::getExtension($fileName, false);
        if (in_array($fileExtension, $this->imageFileTypes) && $fileExtension != 'swf') {
            // remove thumbnail images as well
            $manager = ServiceUtil::getManager()->getService('systemplugin.imagine.manager');
            $manager->setModule('MUFiles');
            $fullObjectId = $objectType . '-' . $objectId;
            $manager->removeImageThumbs($filePath, $fullObjectId);
        }
    
        // remove original file
        if (!unlink($filePath)) {
            return false;
        }
        $objectData[$fieldName] = '';
        $objectData[$fieldName . 'Meta'] = array();
    
        return $objectData;
    }
}
