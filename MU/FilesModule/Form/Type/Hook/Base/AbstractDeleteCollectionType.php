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

namespace MU\FilesModule\Form\Type\Hook\Base;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Zikula\Common\Translator\IdentityTranslator;

/**
 * Delete collection form type base class.
 */
abstract class AbstractDeleteCollectionType extends AbstractType
{
    /**
     * @inheritDoc
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $translator = $options['translator'];
        $builder
            ->add('dummyName', TextType::class, [
                'label' => $translator->__('Dummy collection text'),
                'required' => true
            ])
            ->add('dummmyChoice', ChoiceType::class, [
                'label' => $translator->__('Dummy collection choice'),
                'choices' => [
                    $translator->__('Option A') => 'A',
                    $translator->__('Option A') => 'B',
                    $translator->__('Option A') => 'C'
                ],
                'required' => true,
                'multiple' => true,
                'expanded' => true
            ])
        ;
    }

    /**
     * @inheritDoc
     */
    public function getBlockPrefix()
    {
        return 'mufilesmodule_hook_deletecollection';
    }

    /**
     * @inheritDoc
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'translator' => new IdentityTranslator()
        ]);
    }
}
