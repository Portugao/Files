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
 * Moderation block base class.
 */
class MUFiles_Block_Base_Moderation extends Zikula_Controller_AbstractBlock
{
    /**
     * Initialise the block.
     */
    public function init()
    {
        SecurityUtil::registerPermissionSchema('MUFiles:ModerationBlock:', 'Block title::');
    }
    
    /**
     * Get information on the block.
     *
     * @return array The block information
     */
    public function info()
    {
        $requirementMessage = '';
        // check if the module is available at all
        if (!ModUtil::available('MUFiles')) {
            $requirementMessage .= $this->__('Notice: This block will not be displayed until you activate the MUFiles module.');
        }
    
        return array('module'          => 'MUFiles',
                     'text_type'       => $this->__('Moderation'),
                     'text_type_long'  => $this->__('Show a list of pending tasks to moderators.'),
                     'allow_multiple'  => true,
                     'form_content'    => false,
                     'form_refresh'    => false,
                     'show_preview'    => false,
                     'admin_tableless' => true,
                     'requirement'     => $requirementMessage);
    }
    
    /**
     * Display the block.
     *
     * @param array $blockinfo the blockinfo structure
     *
     * @return string output of the rendered block
     */
    public function display($blockinfo)
    {
        // only show block content if the user has the required permissions
        if (!SecurityUtil::checkPermission('MUFiles:ModerationBlock:', "$blockinfo[title]::", ACCESS_OVERVIEW)) {
            return false;
        }
    
        // check if the module is available at all
        if (!ModUtil::available('MUFiles')) {
            return false;
        }
    
        if (!UserUtil::isLoggedIn()) {
            return false;
        }
    
        ModUtil::initOOModule('MUFiles');
    
        $this->view->setCaching(Zikula_View::CACHE_DISABLED);
        $template = $this->getDisplayTemplate($vars);
    
        $workflowHelper = new MUFiles_Util_Workflow($this->serviceManager);
        $amounts = $workflowHelper->collectAmountOfModerationItems();
    
        // assign block vars and fetched data
        $this->view->assign('moderationObjects', $amounts);
    
        // set a block title
        if (empty($blockinfo['title'])) {
            $blockinfo['title'] = $this->__('Moderation');
        }
    
        $blockinfo['content'] = $this->view->fetch($template);
    
        // return the block to the theme
        return BlockUtil::themeBlock($blockinfo);
    }
    
    /**
     * Returns the template used for output.
     *
     * @param array $vars List of block variables.
     *
     * @return string the template path.
     */
    protected function getDisplayTemplate($vars)
    {
        $template = 'block/moderation.tpl';
    
        return $template;
    }
}
