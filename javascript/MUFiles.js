'use strict';

var mufilesContextMenu;

mufilesContextMenu = Class.create(Zikula.UI.ContextMenu, {
    selectMenuItem: function ($super, event, item, item_container) {
        // open in new tab / window when right-clicked
        if (event.isRightClick()) {
            item.callback(this.clicked, true);
            event.stop(); // close the menu
            return;
        }
        // open in current window when left-clicked
        return $super(event, item, item_container);
    }
});

/**
 * Initialises the context menu for item actions.
 */
function mufilesInitItemActions(objectType, func, containerId)
{
    var triggerId, contextMenu, icon;

    triggerId = containerId + 'Trigger';

    // attach context menu
    contextMenu = new mufilesContextMenu(triggerId, { leftClick: true, animation: false });

    // process normal links
    $$('#' + containerId + ' a').each(function (elem) {
        // hide it
        elem.addClassName('z-hide');
        // determine the link text
        var linkText = '';
        if (func === 'display') {
            linkText = elem.innerHTML;
        } else if (func === 'view') {
            elem.select('img').each(function (imgElem) {
                linkText = imgElem.readAttribute('alt');
            });
        }

        // determine the icon
        icon = '';
        if (func === 'display') {
            if (elem.hasClassName('z-icon-es-preview')) {
                icon = 'xeyes.png';
            } else if (elem.hasClassName('z-icon-es-display')) {
                icon = 'kview.png';
            } else if (elem.hasClassName('z-icon-es-edit')) {
                icon = 'edit';
            } else if (elem.hasClassName('z-icon-es-saveas')) {
                icon = 'filesaveas';
            } else if (elem.hasClassName('z-icon-es-delete')) {
                icon = '14_layer_deletelayer';
            } else if (elem.hasClassName('z-icon-es-back')) {
                icon = 'agt_back';
            }
            if (icon !== '') {
                icon = Zikula.Config.baseURL + 'images/icons/extrasmall/' + icon + '.png';
            }
        } else if (func === 'view') {
            elem.select('img').each(function (imgElem) {
                icon = imgElem.readAttribute('src');
            });
        }
        if (icon !== '') {
            icon = '<img src="' + icon + '" width="16" height="16" alt="' + linkText + '" /> ';
        }

        contextMenu.addItem({
            label: icon + linkText,
            callback: function (selectedMenuItem, isRightClick) {
                var url;

                url = elem.readAttribute('href');
                if (isRightClick) {
                    window.open(url);
                } else {
                    window.location = url;
                }
            }
        });
    });
    $(triggerId).removeClassName('z-hide');
}

function mufilesCapitaliseFirstLetter(string)
{
    return string.charAt(0).toUpperCase() + string.slice(1);
}

/**
 * Submits a quick navigation form.
 */
function mufilesSubmitQuickNavForm(objectType)
{
    $('mufiles' + mufilesCapitaliseFirstLetter(objectType) + 'QuickNavForm').submit();
}

/**
 * Initialise the quick navigation panel in list views.
 */
function mufilesInitQuickNavigation(objectType)
{
    if ($('mufiles' + mufilesCapitaliseFirstLetter(objectType) + 'QuickNavForm') == undefined) {
        return;
    }

    if ($('catid') != undefined) {
        $('catid').observe('change', function () { mufilesSubmitQuickNavForm(objectType); });
    }
    if ($('sortby') != undefined) {
        $('sortby').observe('change', function () { mufilesSubmitQuickNavForm(objectType); });
    }
    if ($('sortdir') != undefined) {
        $('sortdir').observe('change', function () { mufilesSubmitQuickNavForm(objectType); });
    }
    if ($('num') != undefined) {
        $('num').observe('change', function () { mufilesSubmitQuickNavForm(objectType); });
    }

    switch (objectType) {
    case 'collection':
        if ($('parent') != undefined) {
            $('parent').observe('change', function () { mufilesSubmitQuickNavForm(objectType); });
        }
        if ($('workflowState') != undefined) {
            $('workflowState').observe('change', function () { mufilesSubmitQuickNavForm(objectType); });
        }
        if ($('inFrontend') != undefined) {
            $('inFrontend').observe('change', function () { mufilesSubmitQuickNavForm(objectType); });
        }
        break;
    case 'file':
        if ($('aliascollection') != undefined) {
            $('aliascollection').observe('change', function () { mufilesSubmitQuickNavForm(objectType); });
        }
        if ($('workflowState') != undefined) {
            $('workflowState').observe('change', function () { mufilesSubmitQuickNavForm(objectType); });
        }
        break;
    default:
        break;
    }
}

/**
 * Helper function to create new Zikula.UI.Window instances.
 * For edit forms we use "iframe: true" to ensure file uploads work without problems.
 * For all other windows we use "iframe: false" because we want the escape key working.
 */
function mufilesInitInlineWindow(containerElem, title)
{
    var newWindow;

    // show the container (hidden for users without JavaScript)
    containerElem.removeClassName('z-hide');

    // define the new window instance
    newWindow = new Zikula.UI.Window(
        containerElem,
        {
            minmax: true,
            resizable: true,
            title: title,
            width: 600,
            initMaxHeight: 400,
            modal: false,
            iframe: false
        }
    );

    // return the instance
    return newWindow;
}

