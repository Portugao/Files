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

namespace MU\FilesModule\Entity\Base;

use Doctrine\ORM\Mapping as ORM;
use Gedmo\Mapping\Annotation as Gedmo;
use Symfony\Component\HttpFoundation\File\File;
use Symfony\Component\Validator\Constraints as Assert;
use Zikula\Core\Doctrine\EntityAccess;
use MU\FilesModule\Traits\StandardFieldsTrait;
use MU\FilesModule\Validator\Constraints as FilesAssert;
use MU\FilesModule\Validator\Constraints as SizeAssert;

/**
 * Entity class that defines the entity structure and behaviours.
 *
 * This is the base entity class for file entities.
 * The following annotation marks it as a mapped superclass so subclasses
 * inherit orm properties.
 *
 * @ORM\MappedSuperclass
 */
abstract class AbstractFileEntity extends EntityAccess
{
    /**
     * Hook standard fields behaviour embedding createdBy, updatedBy, createdDate, updatedDate fields.
     */
    use StandardFieldsTrait;

    /**
     * @var string The tablename this object maps to
     */
    protected $_objectType = 'file';
    
    /**
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     * @ORM\Column(type="integer", unique=true)
     * @var integer $id
     */
    protected $id = 0;
    
    /**
     * the current workflow state
     * @ORM\Column(length=20)
     * @Assert\NotBlank()
     * @FilesAssert\ListEntry(entityName="file", propertyName="workflowState", multiple=false)
     * @var string $workflowState
     */
    protected $workflowState = 'initial';
    
    /**
     * @ORM\Column(length=255)
     * @Assert\NotBlank()
     * @Assert\Length(min="0", max="255")
     * @var string $title
     */
    protected $title = '';
    
    /**
     * @ORM\Column(type="text", length=2000)
     * @Assert\NotNull()
     * @Assert\Length(min="0", max="2000")
     * @var text $description
     */
    protected $description = '';
    
    /**
     * Upload file meta data array.
     *
     * @ORM\Column(type="array")
     * @Assert\Type(type="array")
     * @var array $uploadFileMeta
     */
    protected $uploadFileMeta = [];
    
    /**
     * @ORM\Column(length=255)
     * @Assert\NotBlank()
     * @Assert\Length(min="0", max="255")
     * @Assert\File(
     *    mimeTypes = {"application/*"}
     * )
     * @SizeAssert\FileSize(entityName="file", fileSize="")
     * @var string $uploadFile
     */
    protected $uploadFile = null;
    
    /**
     * Full upload file path as url.
     *
     * @Assert\Type(type="string")
     * @var string $uploadFileUrl
     */
    protected $uploadFileUrl = '';
    
    
    /**
     * Bidirectional - Many alilasfiles [files] are linked by one aliascollection [collection] (OWNING SIDE).
     *
     * @ORM\ManyToOne(targetEntity="MU\FilesModule\Entity\CollectionEntity", inversedBy="alilasfiles")
     * @ORM\JoinTable(name="mu_files_collection")
     * @Assert\Type(type="MU\FilesModule\Entity\CollectionEntity")
     * @var \MU\FilesModule\Entity\CollectionEntity $aliascollection
     */
    protected $aliascollection;
    
    
    /**
     * FileEntity constructor.
     *
     * Will not be called by Doctrine and can therefore be used
     * for own implementation purposes. It is also possible to add
     * arbitrary arguments as with every other class method.
     */
    public function __construct()
    {
    }
    
    /**
     * Returns the _object type.
     *
     * @return string
     */
    public function get_objectType()
    {
        return $this->_objectType;
    }
    
    /**
     * Sets the _object type.
     *
     * @param string $_objectType
     *
     * @return void
     */
    public function set_objectType($_objectType)
    {
        if ($this->_objectType != $_objectType) {
            $this->_objectType = $_objectType;
        }
    }
    
    
    /**
     * Returns the id.
     *
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }
    
    /**
     * Sets the id.
     *
     * @param integer $id
     *
     * @return void
     */
    public function setId($id)
    {
        if (intval($this->id) !== intval($id)) {
            $this->id = intval($id);
        }
    }
    
    /**
     * Returns the workflow state.
     *
     * @return string
     */
    public function getWorkflowState()
    {
        return $this->workflowState;
    }
    
    /**
     * Sets the workflow state.
     *
     * @param string $workflowState
     *
     * @return void
     */
    public function setWorkflowState($workflowState)
    {
        if ($this->workflowState !== $workflowState) {
            $this->workflowState = isset($workflowState) ? $workflowState : '';
        }
    }
    
    /**
     * Returns the title.
     *
     * @return string
     */
    public function getTitle()
    {
        return $this->title;
    }
    
    /**
     * Sets the title.
     *
     * @param string $title
     *
     * @return void
     */
    public function setTitle($title)
    {
        if ($this->title !== $title) {
            $this->title = isset($title) ? $title : '';
        }
    }
    
    /**
     * Returns the description.
     *
     * @return text
     */
    public function getDescription()
    {
        return $this->description;
    }
    
    /**
     * Sets the description.
     *
     * @param text $description
     *
     * @return void
     */
    public function setDescription($description)
    {
        if ($this->description !== $description) {
            $this->description = isset($description) ? $description : '';
        }
    }
    
    /**
     * Returns the upload file.
     *
     * @return string
     */
    public function getUploadFile()
    {
        return $this->uploadFile;
    }
    
    /**
     * Sets the upload file.
     *
     * @param string $uploadFile
     *
     * @return void
     */
    public function setUploadFile($uploadFile)
    {
        if ($this->uploadFile !== $uploadFile) {
            $this->uploadFile = isset($uploadFile) ? $uploadFile : '';
        }
    }
    
    /**
     * Returns the upload file url.
     *
     * @return string
     */
    public function getUploadFileUrl()
    {
        return $this->uploadFileUrl;
    }
    
    /**
     * Sets the upload file url.
     *
     * @param string $uploadFileUrl
     *
     * @return void
     */
    public function setUploadFileUrl($uploadFileUrl)
    {
        if ($this->uploadFileUrl !== $uploadFileUrl) {
            $this->uploadFileUrl = isset($uploadFileUrl) ? $uploadFileUrl : '';
        }
    }
    
    /**
     * Returns the upload file meta.
     *
     * @return array
     */
    public function getUploadFileMeta()
    {
        return $this->uploadFileMeta;
    }
    
    /**
     * Sets the upload file meta.
     *
     * @param array $uploadFileMeta
     *
     * @return void
     */
    public function setUploadFileMeta($uploadFileMeta = [])
    {
        if ($this->uploadFileMeta !== $uploadFileMeta) {
            $this->uploadFileMeta = isset($uploadFileMeta) ? $uploadFileMeta : '';
        }
    }
    
    
    /**
     * Returns the aliascollection.
     *
     * @return \MU\FilesModule\Entity\CollectionEntity
     */
    public function getAliascollection()
    {
        return $this->aliascollection;
    }
    
    /**
     * Sets the aliascollection.
     *
     * @param \MU\FilesModule\Entity\CollectionEntity $aliascollection
     *
     * @return void
     */
    public function setAliascollection($aliascollection = null)
    {
        $this->aliascollection = $aliascollection;
    }
    
    
    
    /**
     * Creates url arguments array for easy creation of display urls.
     *
     * @return array The resulting arguments list
     */
    public function createUrlArgs()
    {
        return [
            'id' => $this->getId()
        ];
    }
    
    /**
     * Returns the primary key.
     *
     * @return integer The identifier
     */
    public function getKey()
    {
        return $this->getId();
    }
    
    /**
     * Determines whether this entity supports hook subscribers or not.
     *
     * @return boolean
     */
    public function supportsHookSubscribers()
    {
        return true;
    }
    
    /**
     * Return lower case name of multiple items needed for hook areas.
     *
     * @return string
     */
    public function getHookAreaPrefix()
    {
        return 'mufilesmodule.ui_hooks.files';
    }
    
    /**
     * Returns an array of all related objects that need to be persisted after clone.
     * 
     * @param array $objects The objects are added to this array. Default: []
     * 
     * @return array of entity objects
     */
    public function getRelatedObjectsToPersist(&$objects = []) 
    {
        return [];
    }
    
    /**
     * ToString interceptor implementation.
     * This method is useful for debugging purposes.
     *
     * @return string The output string for this entity
     */
    public function __toString()
    {
        return 'File ' . $this->getKey() . ': ' . $this->getTitle();
    }
    
    /**
     * Clone interceptor implementation.
     * This method is for example called by the reuse functionality.
     * Performs a quite simple shallow copy.
     *
     * See also:
     * (1) http://docs.doctrine-project.org/en/latest/cookbook/implementing-wakeup-or-clone.html
     * (2) http://www.php.net/manual/en/language.oop5.cloning.php
     * (3) http://stackoverflow.com/questions/185934/how-do-i-create-a-copy-of-an-object-in-php
     */
    public function __clone()
    {
        // if the entity has no identity do nothing, do NOT throw an exception
        if (!$this->id) {
            return;
        }
    
        // otherwise proceed
    
        // unset identifier
        $this->setId(0);
    
        // reset workflow
        $this->setWorkflowState('initial');
    
        // reset upload fields
        $this->setUploadFile(null);
        $this->setUploadFileMeta([]);
        $this->setUploadFileUrl('');
    
        $this->setCreatedBy(null);
        $this->setCreatedDate(null);
        $this->setUpdatedBy(null);
        $this->setUpdatedDate(null);
    
    }
}
