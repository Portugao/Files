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

namespace MU\FilesModule\Form\Type;

use MU\FilesModule\Form\Type\Base\AbstractFileType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\HttpFoundation\File\File;
use Zikula\Common\Translator\TranslatorInterface;
use MU\FilesModule\Entity\Factory\EntityFactory;
use MU\FilesModule\Form\Type\Field\UploadType;
use MU\FilesModule\Helper\CollectionFilterHelper;
use MU\FilesModule\Helper\EntityDisplayHelper;
use MU\FilesModule\Helper\FeatureActivationHelper;
use MU\FilesModule\Helper\ListEntriesHelper;
use Zikula\ExtensionsModule\Api\ApiInterface\VariableApiInterface;

/**
 * File editing form type implementation class.
 */
class FileType extends AbstractFileType
{
	/**
	 * FileType constructor.
	 *
	 * @param TranslatorInterface $translator    Translator service instance
	 * @param EntityFactory $entityFactory EntityFactory service instance
	 * @param CollectionFilterHelper $collectionFilterHelper CollectionFilterHelper service instance
	 * @param EntityDisplayHelper $entityDisplayHelper EntityDisplayHelper service instance
	 * @param ListEntriesHelper $listHelper ListEntriesHelper service instance
	 * @param FeatureActivationHelper $featureActivationHelper FeatureActivationHelper service instance
	 * @param VariableApiInterface $variableApi VariableApiInterface
	 */
	public function __construct(
			TranslatorInterface $translator,
			EntityFactory $entityFactory,
			CollectionFilterHelper $collectionFilterHelper,
			EntityDisplayHelper $entityDisplayHelper,
			ListEntriesHelper $listHelper,
			FeatureActivationHelper $featureActivationHelper,
			VariableApiInterface $variableApi
			) {
				$this->setTranslator($translator);
				$this->entityFactory = $entityFactory;
				$this->collectionFilterHelper = $collectionFilterHelper;
				$this->entityDisplayHelper = $entityDisplayHelper;
				$this->listHelper = $listHelper;
				$this->featureActivationHelper = $featureActivationHelper;
				$this->variableApi = $variableApi;
	}
	
    /**
     * Adds basic entity fields.
     *
     * @param FormBuilderInterface $builder The form builder
     * @param array                $options The options
     */
    public function addEntityFields(FormBuilderInterface $builder, array $options)
    {
        parent::addEntityFields($builder, $options);
        
        $builder->add('uploadFile', UploadType::class, [
            'label' => $this->__('Upload file') . ':',
            'attr' => [
                'class' => ' validate-upload',
                'title' => $this->__('Enter the upload file of the file')
            ],
            'required' => true && $options['mode'] == 'create',
            'entity' => $options['entity'],
            'allowed_extensions' => $this->variableApi->get('MUFilesModule', 'allowedExtensions'),
            'allowed_size' => $this->variableApi->get('MUFilesModule', 'maxSize')
        ]);
    }
}
