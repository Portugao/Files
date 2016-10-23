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
 * This handler class handles the page events of editing forms.
 * It collects common functionality required by different object types.
 */
class MUFiles_Form_Handler_Common_Edit extends MUFiles_Form_Handler_Common_Base_Edit
{
   /**
     * Input data processing called by handleCommand method.
     *
     * @param Zikula_Form_View $view The form view instance.
     * @param array            $args Additional arguments.
     *
     * @return array form data after processing.
     */
    public function fetchInputData(Zikula_Form_View $view, &$args)
    {
        // fetch posted data input values as an associative array
        $formData = $this->view->getValues();

        if ($this->getVar('specialCollectionMenue') == 1) {
        	$collectionRepository = MUFiles_Util_Model::getCollectionsRepository();
        	if ($this->objectTypeCapital == 'Collection') {

                $parent = $this->request->request->filter('parent', 0);
                if ($parent > 0) {
                	$collectionObject = $collectionRepository->selectById($parent);
                	$formData[$this->objectTypeLower]['parent'] = $collectionObject;             	
                } else {
                	$formData[$this->objectTypeLower]['parent'] = NULL;
                }
                
        	} else {
        		$collectionOfFile = $this->request->request->filter('aliascollection', 0);
        		if ($collectionOfFile > 0) {
        			$collectionObject = $collectionRepository->selectById($collectionOfFile);
            	    $formData[$this->objectTypeLower]['aliascollection'] = $collectionObject;
        		} else {
        			$formData[$this->objectTypeLower]['aliascollection'] = NULL;
        		}
        	}
        }

        // we want the array with our field values
        $entityData = $formData[$this->objectTypeLower];
        unset($formData[$this->objectTypeLower]);
    
        // get treated entity reference from persisted member var
        $entity = $this->entityRef;
    
    
        if ($args['commandName'] != 'cancel') {
            if (count($this->uploadFields) > 0) {
                $entityData = $this->handleUploads($entityData, $entity);
                if ($entityData == false) {
                    return false;
                }
            }
    
            if (count($this->listFields) > 0) {
                foreach ($this->listFields as $listField => $multiple) {
                    if (!$multiple) {
                        continue;
                    }
                    if (is_array($entityData[$listField])) { 
                        $values = $entityData[$listField];
                        $entityData[$listField] = '';
                        if (count($values) > 0) {
                            $entityData[$listField] = '###' . implode('###', $values) . '###';
                        }
                    }
                }
            }
        } else {
            // remove fields for form options to prevent them being merged into the entity object
            if (count($this->uploadFields) > 0) {
                foreach ($this->uploadFields as $uploadField => $isMandatory) {
                    if (isset($entityData[$uploadField . 'DeleteFile'])) {
                        unset($entityData[$uploadField . 'DeleteFile']);
                    }
                }
            }
        }
    
        if (isset($entityData['repeatCreation'])) {
            if ($this->mode == 'create') {
                $this->repeatCreateAction = $entityData['repeatCreation'];
            }
            unset($entityData['repeatCreation']);
        }
        if (isset($entityData['additionalNotificationRemarks'])) {
            SessionUtil::setVar($this->name . 'AdditionalNotificationRemarks', $entityData['additionalNotificationRemarks']);
            unset($entityData['additionalNotificationRemarks']);
        }
    
        // search for relationship plugins to update the corresponding data
        $entityData = $this->writeRelationDataToEntity($view, $entity, $entityData);
    
        // assign fetched data
        $entity->merge($entityData);
    
        // we must persist related items now (after the merge) to avoid validation errors
        // if cascades cause the main entity becoming persisted automatically, too
        $this->persistRelationData($view);
    
        // save updated entity
        $this->entityRef = $entity;
    
        // return remaining form data
        return $formData;
    }
}
