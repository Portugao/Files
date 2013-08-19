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
 * @version Generated by ModuleStudio 0.6.0 (http://modulestudio.de) at Mon Aug 05 18:31:03 CEST 2013.
 */



/**
 * This is the User controller class providing navigation and interaction functionality.
 */
class MUFiles_Controller_User extends MUFiles_Controller_Base_User
{
    /**
     * Post initialise.
     *
     * Run after construction.
     *
     * @return void
     */
    protected function postInitialize()
    {
        // Set caching to true by default.
        $this->view->setCaching(Zikula_View::CACHE_DISABLED);
    }
    
    /**
     * This method provides a generic item list overview.
     *
     * @param array $args List of arguments.
     * @param string  $ot           Treated object type.
     * @param string  $sort         Sorting field.
     * @param string  $sortdir      Sorting direction.
     * @param int     $pos          Current pager position.
     * @param int     $num          Amount of entries to display.
     * @param string  $tpl          Name of alternative template (for alternative display options, feeds and xml output)
     * @param boolean $raw          Optional way to display a template instead of fetching it (needed for standalone output)
     *
     * @return mixed Output.
     */
   /* public function view(array $args = array())
    {
        parent::view();
    }*/
    
    public function giveFile()
    {
        // for guests no access
        if (UserUtil::isLoggedIn() == false) {
            return LogUtil::registerPermissionError();
        }

        // we get the id of the relevant file
        $id = $this->request->query->filter('id' , 0, FILTER_SANITIZE_NUMBER_INT);

        // get file repository and get file
        $repository = MUFiles_Util_Model::getFilesRepository();
        $file = $repository->selectById($id);

        // return error if no permissions for the file or the collection of the file
        if (!SecurityUtil::checkPermission($this->name . ':' . 'File' . ':', $id . '::', ACCESS_COMMENT) || !SecurityUtil::checkPermission($this->name. ':' . 'Collection' . ':', $file['aliascollection']['id'] . '::', ACCESS_COMMENT)) {
            $url = ModUtil::url($this->name, 'user', 'view');
            return LogUtil::registerPermissionError($url);
        } else {
            
            $extension = $file['uploadFileMeta']['extension'];
            $mime = MUFiles_Util_View::getMimeTyp($extension);
             
            // we build the header
            header('Content-Description: File Transfer');
            header('Content-Type: ' . $mime);
            header('Content-Disposition: attachment; filename=' . $file['uploadFile']);
            header('Content-Transfer-Encoding: binary');
            header('Expires: 0');
            header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
            header('Pragma: public');
            header('Content-Length: ' . filesize("userdata/MUFiles/files/uploadfile/" . $file['uploadFile']));
            // we clean the output buffer
            ob_clean();
            flush();
            // we read the file if give it out
            readfile('userdata/MUFiles/files/uploadfile/' . $file['uploadFile']);
            exit();
        }


    }
}
