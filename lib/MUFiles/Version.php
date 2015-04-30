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
 * @version Generated by ModuleStudio 0.6.1 (http://modulestudio.de) at Tue Dec 03 15:01:29 CET 2013.
 */

/**
 * Version information implementation class.
 */
class MUFiles_Version extends MUFiles_Base_Version
{
    /**
     * Retrieves meta data information for this application.
     *
     * @return array List of meta data.
     */
    public function getMetaData()
    {
        $meta = array();
        // the current module version
        $meta['version']              = '1.1.0';
        // the displayed name of the module
        $meta['displayname']          = $this->__('MUFiles');
        // the module description
        $meta['description']          = $this->__('MUFiles module to handle files');
        //! url version of name, should be in lowercase without space
        $meta['url']                  = $this->__('mufiles');
        // core requirement
        $meta['core_min']             = '1.3.5'; // requires minimum 1.3.5
        $meta['core_max']             = '1.3.99'; // not ready for 1.4.0 yet

        // define special capabilities of this module
        $meta['capabilities'] = array(
                HookUtil::SUBSCRIBER_CAPABLE => array('enabled' => true)
                ,
                 HookUtil::PROVIDER_CAPABLE => array('enabled' => true)/*, // TODO: see #15
        'authentication' => array('version' => '1.0'),
        'profile'        => array('version' => '1.0', 'anotherkey' => 'anothervalue'),
        'message'        => array('version' => '1.0', 'anotherkey' => 'anothervalue')
        */
        );

        // permission schema
        $meta['securityschema'] = array(
                'MUFiles::' => '::',
                'MUFiles::Ajax' => '::',
                'MUFiles:ItemListBlock:' => 'Block title::',
                'MUFiles:ModerationBlock:' => 'Block title::',
                'MUFiles:Collection:' => 'Collection ID::',
                'MUFiles:Collection:Collection' => 'Collection ID:Collection ID:',
                'MUFiles:File:' => 'File ID::',
                'MUFiles:Collection:File' => 'Collection ID:File ID:',
        );
        // DEBUG: permission schema aspect ends


        return $meta;
    }
    
    /**
     * Define hook provider bundles.
     */
    protected function setupHookBundles()
    {        
        $bundle = new Zikula_HookManager_ProviderBundle($this->name, 'provider.mufiles.ui_hooks.service', 'ui_hooks', $this->__('MUFiles - Embed collection or file'));
        // form_edit hook is used to add smiley selector and other code to new object form (validate and process hooks unneeded)
        $bundle->addServiceHandler('display_view', 'MUFiles_HookHandlers', 'uiView', 'mufiles.file');
        $bundle->addServiceHandler('form_edit', 'MUFiles_HookHandlers', 'uiEdit', 'mufiles.file');
        $bundle->addServiceHandler('validate_edit', 'MUFiles_HookHandlers', 'validateEdit', 'mufiles.file');
        $bundle->addServiceHandler('process_edit', 'MUFiles_HookHandlers', 'processEdit', 'mufiles.file');
        $bundle->addServiceHandler('process_delete', 'MUFiles_HookHandlers', 'processDelete', 'mufiles.file');
        
        $this->registerHookProviderBundle($bundle);
         
        parent::setupHookBundles();
    }
}
