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

namespace MU\FilesModule\Menu\Base;

use Knp\Menu\FactoryInterface;
use Knp\Menu\ItemInterface;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;
use Symfony\Component\HttpFoundation\RequestStack;
use Zikula\Common\Translator\TranslatorInterface;
use Zikula\Common\Translator\TranslatorTrait;
use Zikula\UsersModule\Constant as UsersConstant;
use MU\FilesModule\Entity\CollectionEntity;
use MU\FilesModule\Entity\FileEntity;
use MU\FilesModule\FilesEvents;
use MU\FilesModule\Event\ConfigureItemActionsMenuEvent;
use MU\FilesModule\Helper\EntityDisplayHelper;
use MU\FilesModule\Helper\PermissionHelper;
use Zikula\UsersModule\Api\ApiInterface\CurrentUserApiInterface;

/**
 * Menu builder base class.
 */
class AbstractMenuBuilder
{
    use TranslatorTrait;

    /**
     * @var FactoryInterface
     */
    protected $factory;

    /**
     * @var EventDispatcherInterface
     */
    protected $eventDispatcher;

    /**
     * @var RequestStack
     */
    protected $requestStack;

    /**
     * @var PermissionHelper
     */
    protected $permissionHelper;

    /**
     * @var EntityDisplayHelper
     */
    protected $entityDisplayHelper;

    /**
     * @var CurrentUserApiInterface
     */
    protected $currentUserApi;

    /**
     * MenuBuilder constructor.
     *
     * @param TranslatorInterface      $translator          Translator service instance
     * @param FactoryInterface         $factory             Factory service instance
     * @param EventDispatcherInterface $eventDispatcher     EventDispatcher service instance
     * @param RequestStack             $requestStack        RequestStack service instance
     * @param PermissionHelper         $permissionHelper    PermissionHelper service instance
     * @param EntityDisplayHelper      $entityDisplayHelper EntityDisplayHelper service instance
     * @param CurrentUserApiInterface  $currentUserApi      CurrentUserApi service instance
     */
    public function __construct(
        TranslatorInterface $translator,
        FactoryInterface $factory,
        EventDispatcherInterface $eventDispatcher,
        RequestStack $requestStack,
        PermissionHelper $permissionHelper,
        EntityDisplayHelper $entityDisplayHelper,
        CurrentUserApiInterface $currentUserApi)
    {
        $this->setTranslator($translator);
        $this->factory = $factory;
        $this->eventDispatcher = $eventDispatcher;
        $this->requestStack = $requestStack;
        $this->permissionHelper = $permissionHelper;
        $this->entityDisplayHelper = $entityDisplayHelper;
        $this->currentUserApi = $currentUserApi;
    }

    /**
     * Sets the translator.
     *
     * @param TranslatorInterface $translator Translator service instance
     */
    public function setTranslator(TranslatorInterface $translator)
    {
        $this->translator = $translator;
    }

    /**
     * Builds the item actions menu.
     *
     * @param array $options List of additional options
     *
     * @return ItemInterface The assembled menu
     */
    public function createItemActionsMenu(array $options = [])
    {
        $menu = $this->factory->createItem('itemActions');
        if (!isset($options['entity']) || !isset($options['area']) || !isset($options['context'])) {
            return $menu;
        }

        $entity = $options['entity'];
        $routeArea = $options['area'];
        $context = $options['context'];
        $menu->setChildrenAttribute('class', 'list-inline item-actions');

        $this->eventDispatcher->dispatch(FilesEvents::MENU_ITEMACTIONS_PRE_CONFIGURE, new ConfigureItemActionsMenuEvent($this->factory, $menu, $options));

        $currentUserId = $this->currentUserApi->isLoggedIn() ? $this->currentUserApi->get('uid') : UsersConstant::USER_ID_ANONYMOUS;
        if ($entity instanceof CollectionEntity) {
            $routePrefix = 'mufilesmodule_collection_';
            $isOwner = $currentUserId > 0 && null !== $entity->getCreatedBy() && $currentUserId == $entity->getCreatedBy()->getUid();
        
            if ($routeArea == 'admin') {
                $title = $this->__('Preview', 'mufilesmodule');
                $previewRouteParameters = $entity->createUrlArgs();
                $previewRouteParameters['preview'] = 1;
                $menu->addChild($title, [
                    'route' => $routePrefix . 'display',
                    'routeParameters' => $previewRouteParameters
                ]);
                $menu[$title]->setLinkAttribute('target', '_blank');
                $menu[$title]->setLinkAttribute('title', $this->__('Open preview page', 'mufilesmodule'));
                $menu[$title]->setAttribute('icon', 'fa fa-search-plus');
            }
            if ($context != 'display') {
                $title = $this->__('Details', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'display',
                    'routeParameters' => $entity->createUrlArgs()
                ]);
                $menu[$title]->setLinkAttribute('title', str_replace('"', '', $this->entityDisplayHelper->getFormattedTitle($entity)));
                $menu[$title]->setAttribute('icon', 'fa fa-eye');
            }
            if ($this->permissionHelper->mayEdit($entity)) {
                $title = $this->__('Edit', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'edit',
                    'routeParameters' => $entity->createUrlArgs()
                ]);
                $menu[$title]->setLinkAttribute('title', $this->__('Edit this collection', 'mufilesmodule'));
                $menu[$title]->setAttribute('icon', 'fa fa-pencil-square-o');
                $title = $this->__('Reuse', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'edit',
                    'routeParameters' => ['astemplate' => $entity->getKey()]
                ]);
                $menu[$title]->setLinkAttribute('title', $this->__('Reuse for new collection', 'mufilesmodule'));
                $menu[$title]->setAttribute('icon', 'fa fa-files-o');
            }
            if ($this->permissionHelper->mayDelete($entity)) {
                $title = $this->__('Delete', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'delete',
                    'routeParameters' => $entity->createUrlArgs()
                ]);
                $menu[$title]->setLinkAttribute('title', $this->__('Delete this collection', 'mufilesmodule'));
                $menu[$title]->setAttribute('icon', 'fa fa-trash-o');
            }
            if ($context == 'display') {
                $title = $this->__('Collections list', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'view'
                ]);
                $menu[$title]->setLinkAttribute('title', $title);
                $menu[$title]->setAttribute('icon', 'fa fa-reply');
            }
            
            // more actions for adding new related items
            
            if ($isOwner || $this->permissionHelper->hasComponentPermission('collection', ACCESS_COMMENT)) {
                $title = $this->__('Create collections', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => 'mufilesmodule_collection_' . $routeArea . 'edit',
                    'routeParameters' => ['collection' => $entity->getKey()]
                ]);
                $menu[$title]->setLinkAttribute('title', $title);
                $menu[$title]->setAttribute('icon', 'fa fa-plus');
            }
            
            if ($isOwner || $this->permissionHelper->hasComponentPermission('file', ACCESS_COMMENT)) {
                $title = $this->__('Create alilasfiles', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => 'mufilesmodule_file_' . $routeArea . 'edit',
                    'routeParameters' => ['aliascollection' => $entity->getKey()]
                ]);
                $menu[$title]->setLinkAttribute('title', $title);
                $menu[$title]->setAttribute('icon', 'fa fa-plus');
            }
        }
        if ($entity instanceof FileEntity) {
            $routePrefix = 'mufilesmodule_file_';
            $isOwner = $currentUserId > 0 && null !== $entity->getCreatedBy() && $currentUserId == $entity->getCreatedBy()->getUid();
        
            if ($routeArea == 'admin') {
                $title = $this->__('Preview', 'mufilesmodule');
                $previewRouteParameters = $entity->createUrlArgs();
                $previewRouteParameters['preview'] = 1;
                $menu->addChild($title, [
                    'route' => $routePrefix . 'display',
                    'routeParameters' => $previewRouteParameters
                ]);
                $menu[$title]->setLinkAttribute('target', '_blank');
                $menu[$title]->setLinkAttribute('title', $this->__('Open preview page', 'mufilesmodule'));
                $menu[$title]->setAttribute('icon', 'fa fa-search-plus');
            }
            if ($context != 'display') {
                $title = $this->__('Details', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'display',
                    'routeParameters' => $entity->createUrlArgs()
                ]);
                $menu[$title]->setLinkAttribute('title', str_replace('"', '', $this->entityDisplayHelper->getFormattedTitle($entity)));
                $menu[$title]->setAttribute('icon', 'fa fa-eye');
            }
            if ($this->permissionHelper->mayEdit($entity)) {
                $title = $this->__('Edit', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'edit',
                    'routeParameters' => $entity->createUrlArgs()
                ]);
                $menu[$title]->setLinkAttribute('title', $this->__('Edit this file', 'mufilesmodule'));
                $menu[$title]->setAttribute('icon', 'fa fa-pencil-square-o');
                $title = $this->__('Reuse', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'edit',
                    'routeParameters' => ['astemplate' => $entity->getKey()]
                ]);
                $menu[$title]->setLinkAttribute('title', $this->__('Reuse for new file', 'mufilesmodule'));
                $menu[$title]->setAttribute('icon', 'fa fa-files-o');
            }
            if ($this->permissionHelper->mayDelete($entity)) {
                $title = $this->__('Delete', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'delete',
                    'routeParameters' => $entity->createUrlArgs()
                ]);
                $menu[$title]->setLinkAttribute('title', $this->__('Delete this file', 'mufilesmodule'));
                $menu[$title]->setAttribute('icon', 'fa fa-trash-o');
            }
            if ($context == 'display') {
                $title = $this->__('Files list', 'mufilesmodule');
                $menu->addChild($title, [
                    'route' => $routePrefix . $routeArea . 'view'
                ]);
                $menu[$title]->setLinkAttribute('title', $title);
                $menu[$title]->setAttribute('icon', 'fa fa-reply');
            }
        }

        $this->eventDispatcher->dispatch(FilesEvents::MENU_ITEMACTIONS_POST_CONFIGURE, new ConfigureItemActionsMenuEvent($this->factory, $menu, $options));

        return $menu;
    }
}
