'use strict';

function mUFilesCapitaliseFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.substring(1);
}

/**
 * Initialise the quick navigation form in list views.
 */
function mUFilesInitQuickNavigation() {
    var quickNavForm;
    var objectType;

    if (jQuery('.mufilesmodule-quicknav').length < 1) {
        return;
    }

    quickNavForm = jQuery('.mufilesmodule-quicknav').first();
    objectType = quickNavForm.attr('id').replace('mUFilesModule', '').replace('QuickNavForm', '');

    quickNavForm.find('select').change(function (event) {
        quickNavForm.submit();
    });

    var fieldPrefix = 'mufilesmodule_' + objectType.toLowerCase() + 'quicknav_';
    // we can hide the submit button if we have no visible quick search field
    if (jQuery('#' + fieldPrefix + 'q').length < 1 || jQuery('#' + fieldPrefix + 'q').parent().parent().hasClass('hidden')) {
        jQuery('#' + fieldPrefix + 'updateview').addClass('hidden');
    }
}

/**
 * Toggles a certain flag for a given item.
 */
function mUFilesToggleFlag(objectType, fieldName, itemId) {
    jQuery.ajax({
        method: 'POST',
        url: Routing.generate('mufilesmodule_ajax_toggleflag'),
        data: {
            ot: objectType,
            field: fieldName,
            id: itemId
        },
        success: function (data) {
            var idSuffix;
            var toggleLink;

            idSuffix = mUFilesCapitaliseFirstLetter(fieldName) + itemId;
            toggleLink = jQuery('#toggle' + idSuffix);

            /*if (data.message) {
                mUFilesSimpleAlert(toggleLink, Translator.__('Success'), data.message, 'toggle' + idSuffix + 'DoneAlert', 'success');
            }*/

            toggleLink.find('.fa-check').toggleClass('hidden', true !== data.state);
            toggleLink.find('.fa-times').toggleClass('hidden', true === data.state);
        }
    });
}

/**
 * Initialise ajax-based toggle for all affected boolean fields on the current page.
 */
function mUFilesInitAjaxToggles() {
    jQuery('.mufiles-ajax-toggle').click(function (event) {
        var objectType;
        var fieldName;
        var itemId;

        event.preventDefault();
        objectType = jQuery(this).data('object-type');
        fieldName = jQuery(this).data('field-name');
        itemId = jQuery(this).data('item-id');

        mUFilesToggleFlag(objectType, fieldName, itemId);
    }).removeClass('hidden');
}

/**
 * Simulates a simple alert using bootstrap.
 */
function mUFilesSimpleAlert(anchorElement, title, content, alertId, cssClass) {
    var alertBox;

    alertBox = ' \
        <div id="' + alertId + '" class="alert alert-' + cssClass + ' fade"> \
          <button type="button" class="close" data-dismiss="alert">&times;</button> \
          <h4>' + title + '</h4> \
          <p>' + content + '</p> \
        </div>';

    // insert alert before the given anchor element
    anchorElement.before(alertBox);

    jQuery('#' + alertId).delay(200).addClass('in').fadeOut(4000, function () {
        jQuery(this).remove();
    });
}

/**
 * Initialises the mass toggle functionality for admin view pages.
 */
function mUFilesInitMassToggle() {
    if (jQuery('.mufiles-mass-toggle').length > 0) {
        jQuery('.mufiles-mass-toggle').unbind('click').click(function (event) {
            jQuery('.mufiles-toggle-checkbox').prop('checked', jQuery(this).prop('checked'));
        });
    }
}

/**
 * Creates a dropdown menu for the item actions.
 */
function mUFilesInitItemActions(context) {
    var containerSelector;
    var containers;
    
    containerSelector = '';
    if (context == 'view') {
        containerSelector = '.mufilesmodule-view';
    } else if (context == 'display') {
        containerSelector = 'h2, h3';
    }
    
    if (containerSelector == '') {
        return;
    }
    
    containers = jQuery(containerSelector);
    if (containers.length < 1) {
        return;
    }
    
    containers.find('.dropdown > ul').removeClass('list-inline').addClass('list-unstyled dropdown-menu');
    containers.find('.dropdown > ul a i').addClass('fa-fw');
    if (containers.find('.dropdown-toggle').length > 0) {
        containers.find('.dropdown-toggle').removeClass('hidden').dropdown();
    }
}

/**
 * Helper function to create new dialog window instances.
 * Note we use jQuery UI dialogs instead of Bootstrap modals here
 * because we want to be able to open multiple windows simultaneously.
 */
function mUFilesInitInlineWindow(containerElem) {
    var newWindowId;
    var modalTitle;

    // show the container (hidden for users without JavaScript)
    containerElem.removeClass('hidden');

    // define name of window
    newWindowId = containerElem.attr('id') + 'Dialog';

    containerElem.unbind('click').click(function (event) {
        event.preventDefault();

        // check if window exists already
        if (jQuery('#' + newWindowId).length < 1) {
            // create new window instance
            jQuery('<div />', { id: newWindowId })
                .append(
                    jQuery('<iframe width="100%" height="100%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="auto" />')
                        .attr('src', containerElem.attr('href'))
                )
                .dialog({
                    autoOpen: false,
                    show: {
                        effect: 'blind',
                        duration: 1000
                    },
                    hide: {
                        effect: 'explode',
                        duration: 1000
                    },
                    title: containerElem.data('modal-title'),
                    width: 600,
                    height: 400,
                    modal: false
                });
        }

        // open the window
        jQuery('#' + newWindowId).dialog('open');
    });

    // return the dialog selector id;
    return newWindowId;
}

/**
 * Initialises modals for inline display of related items.
 */
function mUFilesInitQuickViewModals() {
    jQuery('.mufiles-inline-window').each(function (index) {
        mUFilesInitInlineWindow(jQuery(this));
    });
}

jQuery(document).ready(function () {
    var isViewPage;
    var isDisplayPage;

    isViewPage = jQuery('.mufilesmodule-view').length > 0;
    isDisplayPage = jQuery('.mufilesmodule-display').length > 0;

    if (isViewPage) {
        mUFilesInitQuickNavigation();
        mUFilesInitMassToggle();
        mUFilesInitItemActions('view');
        mUFilesInitAjaxToggles();
    } else if (isDisplayPage) {
        mUFilesInitItemActions('display');
        mUFilesInitAjaxToggles();
    }

    mUFilesInitQuickViewModals();
});
