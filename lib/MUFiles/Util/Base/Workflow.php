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
 * Utility base class for workflow helper methods.
 */
class MUFiles_Util_Base_Workflow extends Zikula_AbstractBase
{
    /**
      * This method returns a list of possible object states.
      *
      * @return array List of collected state information.
      */
     public function getObjectStates()
     {
         $states = array();
         $states[] = array('value' => 'initial',
                           'text' => $this->__('Initial'),
                           'ui' => 'red');
         $states[] = array('value' => 'waiting',
                           'text' => $this->__('Waiting'),
                           'ui' => 'yellow');
         $states[] = array('value' => 'approved',
                           'text' => $this->__('Approved'),
                           'ui' => 'green');
         $states[] = array('value' => 'deleted',
                           'text' => $this->__('Deleted'),
                           'ui' => 'red');
    
         return $states;
     }
    
    /**
     * This method returns information about a certain state.
     *
     * @param string $state The given state value.
     *
     * @return array|null The corresponding state information.
     */
    public function getStateInfo($state = 'initial')
    {
        $result = null;
        $stateList = $this->getObjectStates();
        foreach ($stateList as $singleState) {
            if ($singleState['value'] != $state) {
                continue;
            }
            $result = $singleState;
            break;
        }
    
        return $result;
    }
    
    /**
     * This method returns the workflow name for a certain object type.
     *
     * @param string $objectType Name of treated object type.
     *
     * @return string Name of the corresponding workflow.
     */
    public function getWorkflowName($objectType = '')
    {
        $result = '';
        switch ($objectType) {
            case 'collection':
                $result = 'standard';
                break;
            case 'file':
                $result = 'standard';
                break;
        }
    
        return $result;
    }
    
    /**
     * This method returns the workflow schema for a certain object type.
     *
     * @param string $objectType Name of treated object type.
     *
     * @return array|null The resulting workflow schema
     */
    public function getWorkflowSchema($objectType = '')
    {
        $schema = null;
        $schemaName = $this->getWorkflowName($objectType);
        if ($schemaName != '') {
            $schema = Zikula_Workflow_Util::loadSchema($schemaName, $this->name);
        }
    
        return $schema;
    }
    
    /**
     * Retrieve the available actions for a given entity object.
     *
     * @param \Zikula_EntityAccess $entity The given entity instance.
     *
     * @return array List of available workflow actions.
     */
    public function getActionsForObject($entity)
    {
        // get possible actions for this object in it's current workflow state
        $objectType = $entity['_objectType'];
    
        $idcolumn = $entity['__WORKFLOW__']['obj_idcolumn'];
        $wfActions = Zikula_Workflow_Util::getActionsForObject($entity, $objectType, $idcolumn, $this->name);
    
        // as we use the workflows for multiple object types we must maybe filter out some actions
        $listHelper = new MUFiles_Util_ListEntries($this->serviceManager);
        $states = $listHelper->getEntries($objectType, 'workflowState');
        $allowedStates = array();
        foreach ($states as $state) {
            $allowedStates[] = $state['value'];
        }
    
        $actions = array();
        foreach ($wfActions as $actionId => $action) {
            $nextState = (isset($action['nextState']) ? $action['nextState'] : '');
            if ($nextState != '' && !in_array($nextState, $allowedStates)) {
                continue;
            }
    
            $actions[$actionId] = $action;
            $actions[$actionId]['buttonClass'] = $this->getButtonClassForAction($actionId);
        }
    
        return $actions;
    }
    
    /**
     * Returns a button class for a certain action.
     *
     * @param string $actionId Id of the treated action.
     */
    protected function getButtonClassForAction($actionId)
    {
        $buttonClass = '';
        switch ($actionId) {
            case 'submit':
                $buttonClass = 'ok';
                break;
            case 'update':
                $buttonClass = 'ok';
                break;
            case 'approve':
                $buttonClass = 'ok';
                break;
            case 'delete':
                $buttonClass = 'delete z-btred';
                break;
        }
    
        if (!empty($buttonClass)) {
            $buttonClass = 'z-bt-' . $buttonClass;
        }
    
        return $buttonClass;
    }
    
    /**
     * Executes a certain workflow action for a given entity object.
     *
     * @param \Zikula_EntityAccess $entity   The given entity instance.
     * @param string               $actionId Name of action to be executed.
     * @param bool                 $recursive true if the function called itself.  
     *
     * @return bool False on error or true if everything worked well.
     */
    public function executeAction($entity, $actionId = '', $recursive = false)
    {
        $objectType = $entity['_objectType'];
        $schemaName = $this->getWorkflowName($objectType);
    
        $entity->initWorkflow(true);
        $idcolumn = $entity['__WORKFLOW__']['obj_idcolumn'];
    
        $result = Zikula_Workflow_Util::executeAction($schemaName, $entity, $actionId, $objectType, $this->name, $idcolumn);
    
        if ($result !== false && !$recursive) {
            $entities = $entity->getRelatedObjectsToPersist();
            foreach ($entities as $rel) {
                if ($rel->getWorkflowState() == 'initial') {
                    $this->executeAction($rel, $actionId, true);
                }
            }
        }
    
        return ($result !== false);
    }
    /**
     * Collects amount of moderation items foreach object type.
     *
     * @return array List of collected amounts.
     */
    public function collectAmountOfModerationItems()
    {
        $amounts = array();
        $modname = 'MUFiles';
    
    
        // check if objects are waiting for approval
        $state = 'waiting';
        $objectType = 'collection';
        if (SecurityUtil::checkPermission($modname . ':' . ucwords($objectType) . ':', '::', ACCESS_ADD)) {
            $amount = $this->getAmountOfModerationItems($objectType, $state);
            if ($amount > 0) {
                $amounts[] = array(
                    'aggregateType' => 'collectionsApproval',
                    'description' => $this->__('Collections pending approval'),
                    'amount' => $amount,
                    'objectType' => $objectType,
                    'state' => $state,
                    'message' => $this->_fn('One collection is waiting for approval.', '%s collections are waiting for approval.', $amount, array($amount))
                );
            }
        }
        $objectType = 'file';
        if (SecurityUtil::checkPermission($modname . ':' . ucwords($objectType) . ':', '::', ACCESS_ADD)) {
            $amount = $this->getAmountOfModerationItems($objectType, $state);
            if ($amount > 0) {
                $amounts[] = array(
                    'aggregateType' => 'filesApproval',
                    'description' => $this->__('Files pending approval'),
                    'amount' => $amount,
                    'objectType' => $objectType,
                    'state' => $state,
                    'message' => $this->_fn('One file is waiting for approval.', '%s files are waiting for approval.', $amount, array($amount))
                );
            }
        }
    
        return $amounts;
    }
    
    /**
     * Retrieves the amount of moderation items for a given object type
     * and a certain workflow state.
     *
     * @param string $objectType Name of treated object type.
     * @param string $state The given state value.
     *
     * @return integer The affected amount of objects.
     */
    public function getAmountOfModerationItems($objectType, $state)
    {
        $entityClass = $this->name . '_Entity_' . ucwords($objectType);
        $entityManager = $this->serviceManager->getService('doctrine.entitymanager');
    
        $repository = $entityManager->getRepository($entityClass);
    
        $where = 'tbl.workflowState = \'' . $state . '\'';
        $parameters = array('workflowState' => $state);
        $useJoins = false;
        $amount = $repository->selectCount($where, $useJoins, $parameters);
    
        return $amount;
    }
}
