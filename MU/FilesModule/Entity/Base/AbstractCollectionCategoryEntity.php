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

namespace MU\FilesModule\Entity\Base;

use Doctrine\ORM\Mapping as ORM;
use Zikula\CategoriesModule\Entity\AbstractCategoryAssignment;

/**
 * Entity extension domain class storing collection categories.
 *
 * This is the base category class for collection entities.
 */
abstract class AbstractCollectionCategoryEntity extends AbstractCategoryAssignment
{
    /**
     * @ORM\ManyToOne(targetEntity="\MU\FilesModule\Entity\CollectionEntity", inversedBy="categories")
     * @ORM\JoinColumn(name="entityId", referencedColumnName="id")
     * @var \MU\FilesModule\Entity\CollectionEntity
     */
    protected $entity;
    
    /**
     * Get reference to owning entity.
     *
     * @return \MU\FilesModule\Entity\CollectionEntity
     */
    public function getEntity()
    {
        return $this->entity;
    }
    
    /**
     * Set reference to owning entity.
     *
     * @param \MU\FilesModule\Entity\CollectionEntity $entity
     */
    public function setEntity(/*\MU\FilesModule\Entity\CollectionEntity */$entity)
    {
        $this->entity = $entity;
    }
}
