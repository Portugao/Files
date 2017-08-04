<?php
/**
 * Files.
 *
 * @copyright Michael Ueberschaer (MU)
 * @license http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
 * @author Michael Ueberschaer <info@homepages-mit-zikula.de>.
 * @link https://homepages-mit-zikula.de
 * @link http://zikula.org
 * @version Generated by ModuleStudio (https://modulestudio.de).
 */

namespace MU\FilesModule\Entity;

use MU\FilesModule\Entity\Base\AbstractCollectionCategoryEntity as BaseEntity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Entity extension domain class storing collection categories.
 *
 * This is the concrete category class for collection entities.
 * @ORM\Entity(repositoryClass="\MU\FilesModule\Entity\Repository\CollectionCategoryRepository")
 * @ORM\Table(name="mu_files_collection_category",
 *     uniqueConstraints={
 *         @ORM\UniqueConstraint(name="cat_unq", columns={"registryId", "categoryId", "entityId"})
 *     }
 * )
 */
class CollectionCategoryEntity extends BaseEntity
{
    // feel free to add your own methods here
}