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

namespace MU\FilesModule\HookProvider\Base;

use Symfony\Component\Form\FormFactoryInterface;
use Symfony\Component\HttpFoundation\Session\SessionInterface;
use Zikula\Bundle\HookBundle\Category\FormAwareCategory;
use Zikula\Bundle\HookBundle\FormAwareHook\FormAwareHook;
use Zikula\Bundle\HookBundle\FormAwareHook\FormAwareResponse;
use Zikula\Bundle\HookBundle\HookProviderInterface;
use Zikula\Bundle\HookBundle\ServiceIdTrait;
use Zikula\Common\Translator\TranslatorInterface;
use MU\FilesModule\Form\Type\Hook\DeleteFileType;
use MU\FilesModule\Form\Type\Hook\EditFileType;

/**
 * Base class for form aware hook provider.
 */
abstract class AbstractFileFormAwareHookProvider implements HookProviderInterface
{
    use ServiceIdTrait;

    /**
     * @var TranslatorInterface
     */
    protected $translator;

    /**
     * @var SessionInterface
     */
    protected $session;

    /**
     * @var FormFactoryInterface
     */
    protected $formFactory;

    /**
     * FileFormAwareHookProvider constructor.
     *
     * @param TranslatorInterface  $translator
     * @param SessionInterface     $session
     * @param FormFactoryInterface $formFactory
     */
    public function __construct(
        TranslatorInterface $translator,
        SessionInterface $session,
        FormFactoryInterface $formFactory
    ) {
        $this->translator = $translator;
        $this->session = $session;
        $this->formFactory = $formFactory;
    }

    /**
     * @inheritDoc
     */
    public function getOwner()
    {
        return 'MUFilesModule';
    }
    
    /**
     * @inheritDoc
     */
    public function getCategory()
    {
        return FormAwareCategory::NAME;
    }
    
    /**
     * @inheritDoc
     */
    public function getTitle()
    {
        return $this->translator->__('File form aware provider');
    }

    /**
     * @inheritDoc
     */
    public function getProviderTypes()
    {
        return [
            FormAwareCategory::TYPE_EDIT => 'edit',
            FormAwareCategory::TYPE_PROCESS_EDIT => 'processEdit',
            FormAwareCategory::TYPE_DELETE => 'delete',
            FormAwareCategory::TYPE_PROCESS_DELETE => 'processDelete'
        ];
    }

    /**
     * Provide the inner editing form.
     *
     * @param FormAwareHook $hook
     */
    public function edit(FormAwareHook $hook)
    {
        $innerForm = $this->formFactory->create(EditFileType::class, null, [
            'auto_initialize' => false,
            'mapped' => false
        ]);
        $hook
            ->formAdd($innerForm)
            ->addTemplate('@MUFilesModule/Hook/editFileForm.html.twig')
        ;
    }

    /**
     * Process the inner editing form.
     *
     * @param FormAwareResponse $hook
     */
    public function processEdit(FormAwareResponse $hook)
    {
        $innerForm = $hook->getFormData('mufilesmodule_hook_editfileform');
        $dummyOutput = $innerForm['dummyName'] . ' (Option ' . $innerForm['dummyChoice'] . ')';
        $this->session->getFlashBag()->add('success', sprintf('The FileFormAwareHookProvider edit form was processed and the answer was %s', $dummyOutput));
    }

    /**
     * Provide the inner deletion form.
     *
     * @param FormAwareHook $hook
     */
    public function delete(FormAwareHook $hook)
    {
        $innerForm = $this->formFactory->create(DeleteFileType::class, null, [
            'auto_initialize' => false,
            'mapped' => false
        ]);
        $hook
            ->formAdd($innerForm)
            ->addTemplate('@MUFilesModule/Hook/deleteFileForm.html.twig')
        ;
    }

    /**
     * Process the inner deletion form.
     *
     * @param FormAwareResponse $hook
     */
    public function processDelete(FormAwareResponse $hook)
    {
        $innerForm = $hook->getFormData('mufilesmodule_hook_deletefileform');
        $dummyOutput = $innerForm['dummyName'] . ' (Option ' . $innerForm['dummyChoice'] . ')';
        $this->session->getFlashBag()->add('success', sprintf('The FileFormAwareHookProvider delete form was processed and the answer was %s', $dummyOutput));
    }
}
