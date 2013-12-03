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
 * The mufilesObjectTypeSelector plugin provides items for a dropdown selector.
 *
 * Available parameters:
 *   - assign: If set, the results are assigned to the corresponding variable instead of printed out.
 *
 * @param  array            $params All attributes passed to this function from the template.
 * @param  Zikula_Form_View $view   Reference to the view object.
 *
 * @return string The output of the plugin.
 */
function smarty_function_mufilesObjectTypeSelector($params, $view)
{
    $dom = ZLanguage::getModuleDomain('MUFiles');
    $result = array();

    $result[] = array('text' => __('Collections', $dom), 'value' => 'collection');
    $result[] = array('text' => __('Files', $dom), 'value' => 'file');

    if (array_key_exists('assign', $params)) {
        $view->assign($params['assign'], $result);

        return;
    }

    return $result;
}
