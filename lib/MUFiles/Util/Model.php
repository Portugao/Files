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
 * @version Generated by ModuleStudio 0.6.0 (http://modulestudio.de) at Mon Aug 05 18:31:04 CEST 2013.
 */

/**
 * Utility implementation class for model helper methods.
 */
class MUFiles_Util_Model extends MUFiles_Util_Base_Model
{
	/**
	 *
	 * This method is for getting a repository for file
	 *
	 */

	public static function getFilesRepository() {

		$serviceManager = ServiceUtil::getManager();
		$entityManager = $serviceManager->getService('doctrine.entitymanager');
		$repository = $entityManager->getRepository('MUFiles_Entity_File');

		return $repository;
	}
	
	/**
	 * This method is for getting the allowed file extensions
	 */
	public static function getAllowedExtensions()
	{
	    $extensions = ModUtil::getVar('MUFiles', 'allowedExtensions');
	    //$extensions = explode(',', $extensions);
	    return $extensions;
	}
	
	/**
	 * This method is for getting the allowed max size for files
	 */
	public static function getMaxSize()
	{
	    $maxSize = ModUtil::getVar('MUFiles', 'maxSize');
	    return $maxSize;
	}
}
