<?php
/**
 * Files.
 *
 * @copyright Michael Ueberschaer (MU)
 * @license http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
 * @author Michael Ueberschaer <info@homepages-mit-zikula.de>.
 * @link https://homepages-mit-zikula.de
 * @link https://ziku.la
 * @version Generated by ModuleStudio (https://modulestudio.de).
 */

namespace MU\FilesModule\Block\Base;

use Symfony\Component\HttpKernel\Controller\ControllerReference;
use Zikula\BlocksModule\AbstractBlockHandler;
use MU\FilesModule\Block\Form\Type\ItemBlockType;

/**
 * Generic item detail block base class.
 */
abstract class AbstractItemBlock extends AbstractBlockHandler
{
    /**
     * @inheritDoc
     */
    public function getType()
    {
        return $this->__('Files detail', 'mufilesmodule');
    }
    
    /**
     * @inheritDoc
     */
    public function display(array $properties = [])
    {
        // only show block content if the user has the required permissions
        if (!$this->hasPermission('MUFilesModule:ItemBlock:', "$properties[title]::", ACCESS_OVERVIEW)) {
            return '';
        }
    
        // set default values for all params which are not properly set
        $defaults = $this->getDefaults();
        $properties = array_merge($defaults, $properties);
    
        if (null === $properties['id'] || empty($properties['id'])) {
            return '';
        }
    
        $controllerHelper = $this->get('mu_files_module.controller_helper');
        $contextArgs = ['name' => 'detail'];
        if (!isset($properties['objectType']) || !in_array($properties['objectType'], $controllerHelper->getObjectTypes('block', $contextArgs))) {
            $properties['objectType'] = $controllerHelper->getDefaultObjectType('block', $contextArgs);
        }
    
        $controllerReference = new ControllerReference('MUFilesModule:External:display', $this->getDisplayArguments($properties), ['template' => $properties['customTemplate']]);
    
        return $this->get('fragment.handler')->render($controllerReference, 'inline', []);
    }
    
    /**
     * Returns common arguments for displaying the selected object using the external controller.
     *
     * @param array $properties The block properties
     *
     * @return array Display arguments
     */
    protected function getDisplayArguments(array $properties = [])
    {
        return [
            'objectType' => $properties['objectType'],
            'id' => $properties['id'],
            'source' => 'block',
            'displayMode' => 'embed'
        ];
    }
    
    /**
     * @inheritDoc
     */
    public function getFormClassName()
    {
        return ItemBlockType::class;
    }
    
    /**
     * @inheritDoc
     */
    public function getFormOptions()
    {
        $objectType = 'collection';
    
        $request = $this->get('request_stack')->getCurrentRequest();
        if ($request->attributes->has('blockEntity')) {
            $blockEntity = $request->attributes->get('blockEntity');
            if (is_object($blockEntity) && method_exists($blockEntity, 'getProperties')) {
                $blockProperties = $blockEntity->getProperties();
                if (isset($blockProperties['objectType'])) {
                    $objectType = $blockProperties['objectType'];
                } else {
                    // set default options for new block creation
                    $blockEntity->setProperties($this->getDefaults());
                }
            }
        }
    
        return [
            'object_type' => $objectType
        ];
    }
    
    /**
     * @inheritDoc
     */
    public function getFormTemplate()
    {
        return '@MUFilesModule/Block/item_modify.html.twig';
    }
    
    /**
     * Returns default settings for this block.
     *
     * @return array The default settings
     */
    protected function getDefaults()
    {
        return [
            'objectType' => 'collection',
            'id' => null,
            'template' => 'item_display.html.twig',
            'customTemplate' => null
        ];
    }
}
