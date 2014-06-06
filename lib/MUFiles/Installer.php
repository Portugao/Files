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
 * Installer implementation class.
 */
class MUFiles_Installer extends MUFiles_Base_Installer
{
     /**
* Install the MUFiles application.
*
* @return boolean True on success, or false.
*/
    public function install()
    {
        parent::install();
        
        // Set up module hooks
        HookUtil::registerProviderBundles($this->version->getHookProviderBundles()); //TODO next version
        
        return true;
    }
    
    public function uninstall()
    {
        parent::uninstall();
        
        // unregister hook providers
        HookUtil::unregisterProviderBundles($this->version->getHookProviderBundles()); //TODO next version
        return true;
    }
}
