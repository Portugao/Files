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

namespace MU\FilesModule\Helper\Base;

/**
 * Helper base class for dynamic feature enablement methods.
 */
abstract class AbstractFeatureActivationHelper
{
    /**
     * Categorisation feature
     */
    const CATEGORIES = 'categories';
    
    /**
     * This method checks whether a certain feature is enabled for a given entity type or not.
     *
     * @param string $feature     Name of requested feature
     * @param string $objectType  Currently treated entity type
     *
     * @return boolean True if the feature is enabled, false otherwise
     */
    public function isEnabled($feature, $objectType)
    {
        if (self::CATEGORIES == $feature) {
            $method = 'hasCategories';
            if (method_exists($this, $method)) {
                return $this->$method($objectType);
            }
    
            return in_array($objectType, ['collection']);
        }
    
        return false;
    }
}
