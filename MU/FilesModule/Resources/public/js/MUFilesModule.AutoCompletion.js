'use strict';

/**
 * Toggles the fields of an auto completion field.
 */
function mUFilesToggleRelatedItemForm(idPrefix)
{
    // if we don't have a toggle link do nothing
    if (jQuery('#' + idPrefix + 'AddLink').length < 1) {
        return;
    }

    // show/hide the toggle link
    jQuery('#' + idPrefix + 'AddLink').toggleClass('hidden');

    // hide/show the fields
    jQuery('#' + idPrefix + 'AddFields').toggleClass('hidden');
}

/**
 * Resets an auto completion field.
 */
function mUFilesResetRelatedItemForm(idPrefix)
{
    // hide the sub form
    mUFilesToggleRelatedItemForm(idPrefix);

    // reset value of the auto completion field
    jQuery('#' + idPrefix + 'Selector').val('');
}

/**
 * Helper function to create new modal form dialog instances.
 */
function mUFilesCreateRelationWindowInstance(containerElem, useIframe)
{
    var newWindowId;

    // define the new window instance
    newWindowId = containerElem.attr('id') + 'Dialog';
    jQuery('<div id="' + newWindowId + '"></div>')
        .append(
            jQuery('<iframe />')
                .attr('src', containerElem.attr('href'))
                .css({ width: '100%', height: '440px' })
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
            //title: containerElem.title,
            width: 600,
            height: 500,
            modal: false
        })
        .dialog('open');

    // return the instance
    return newWindowId;
}

/**
 * Observe a link for opening an inline window.
 */
function mUFilesInitInlineRelationWindow(objectType, containerID)
{
    var found, newItem;

    // whether the handler has been found
    found = false;

    // search for the handler
    jQuery.each(relationHandler, function (key, singleRelationHandler) {
        // is this the right one
        if (singleRelationHandler.prefix === containerID) {
            // yes, it is
            found = true;
            // look whether there is already a window instance
            if (null !== singleRelationHandler.windowInstanceId) {
                // unset it
                jQuery(containerID + 'Dialog').dialog('destroy');
            }
            // create and assign the new window instance
            singleRelationHandler.windowInstanceId = mUFilesCreateRelationWindowInstance(jQuery('#' + containerID), true);
        }
    });

    if (false !== found) {
        return;
    }

    // if no handler was found create a new one
    newItem = {
        ot: objectType,
        prefix: containerID,
        moduleName: 'MUFilesModule',
        acInstance: null,
        windowInstanceId: mUFilesCreateRelationWindowInstance(jQuery('#' + containerID), true)
    };

    // add it to the list of handlers
    relationHandler.push(newItem);
}

/**
 * Removes a related item from the list of selected ones.
 */
function mUFilesRemoveRelatedItem(idPrefix, removeId)
{
    var itemIds, itemIdsArr;

    itemIds = jQuery('#' + idPrefix).val();
    itemIdsArr = itemIds.split(',');

    itemIdsArr = jQuery.grep(itemIdsArr, function(value) {
        return value != removeId;
    });

    itemIds = itemIdsArr.join(',');

    jQuery('#' + idPrefix).val(itemIds);
    jQuery('#' + idPrefix + 'Reference_' + removeId).remove();
}

/**
 * Adds a related item to selection which has been chosen by auto completion.
 */
function mUFilesSelectRelatedItem(objectType, idPrefix, selectedListItem)
{
    var newItemId, newTitle, includeEditing, editLink, removeLink, elemPrefix, itemPreview, li, editHref, fldPreview, itemIds;

    itemIds = jQuery('#' + idPrefix).val();
    if (itemIds !== '') {
        if (jQuery('#' + idPrefix + 'Multiple').val() === '0') {
            jQuery('#' + idPrefix + 'ReferenceList').text('');
            itemIds = '';
        } else {
            itemIds += ',';
        }
    }

    newItemId = selectedListItem.id;
    newTitle = selectedListItem.title;
    includeEditing = !!((jQuery('#' + idPrefix + 'Mode').val() == '1'));
    elemPrefix = idPrefix + 'Reference_' + newItemId;
    itemPreview = '';

    if (selectedListItem.image != '') {
        itemPreview = selectedListItem.image;
    }

    li = jQuery('<li />', { id: elemPrefix, text: newTitle });
    if (true === includeEditing) {
        var editHref = jQuery('#' + idPrefix + 'SelectorDoNew').attr('href') + '&id=' + newItemId;
        editLink = jQuery('<a />', { id: elemPrefix + 'Edit', href: editHref, text: 'edit' });
        li.append(editLink);
        editLink.html(' ' + editImage);
    }

    removeLink = jQuery('<a />', { id: elemPrefix + 'Remove', href: 'javascript:mUFilesRemoveRelatedItem(\'' + idPrefix + '\', ' + newItemId + ');', text: 'remove' });
    li.append(removeLink);
    removeLink.html(' ' + removeImage);

    if (itemPreview !== '') {
        fldPreview = jQuery('<div>', { id: elemPrefix + 'preview', name: idPrefix + 'preview' });
        fldPreview.html(itemPreview);
        li.append(fldPreview);
        itemPreview = '';
    }

    jQuery('#' + idPrefix + 'ReferenceList').append(li);

    if (true === includeEditing) {
        jQuery('#' + elemPrefix + 'Edit').click(function (event) {
            event.preventDefault();
            mUFilesInitInlineRelationWindow(objectType, idPrefix + 'Reference_' + newItemId + 'Edit');
        });
    }

    itemIds += newItemId;
    jQuery('#' + idPrefix).val(itemIds);

    mUFilesResetRelatedItemForm(idPrefix);
}

/**
 * Adds a hook assignment item to selection which has been chosen by auto completion.
 */
function mUFilesSelectHookItem(objectType, idPrefix, selectedListItem)
{
    mUFilesResetRelatedItemForm(idPrefix);
    mUFilesAttachHookObject(jQuery(idPrefix + 'AddLink'), selectedListItem.id);
}

/**
 * Initialises a relation field section with autocompletion and optional edit capabilities.
 */
function mUFilesInitRelationItemsForm(objectType, idPrefix, includeEditing)
{
    var acOptions, acDataSet, itemIds, itemIdsArr, acUrl, isHookAttacher;

    // update identifier of hidden field for easier usage in JS
    jQuery('#' + idPrefix + 'Multiple').prev().attr('id', idPrefix);

    // add handling for the toggle link if existing
    jQuery('#' + idPrefix + 'AddLink').click(function (event) {
        mUFilesToggleRelatedItemForm(idPrefix);
    });

    // add handling for the cancel button
    jQuery('#' + idPrefix + 'SelectorDoCancel').click(function (event) {
        mUFilesResetRelatedItemForm(idPrefix);
    });

    // clear values and ensure starting state
    mUFilesResetRelatedItemForm(idPrefix);


    isHookAttacher = idPrefix.startsWith('hookAssignment');
    jQuery.each(relationHandler, function (key, singleRelationHandler) {
        if (singleRelationHandler.prefix !== (idPrefix + 'SelectorDoNew') || null !== singleRelationHandler.acInstance) {
            return;
        }

        singleRelationHandler.acInstance = 'yes';

        jQuery('#' + idPrefix + 'Selector').autocomplete({
            minLength: 1,
            open: function(event, ui) {
                jQuery(this).autocomplete('widget').css({
                    width: (jQuery(this).outerWidth() + 'px')
                });
            },
            source: function (request, response) {
                var acUrlArgs;

                acUrlArgs = {
                    ot: objectType,
                    fragment: request.term
                };
                if (jQuery('#' + idPrefix).length > 0) {
                    if (true === isHookAttacher) {
                        acUrlArgs.exclude = jQuery('#' + idPrefix + 'ExcludedIds').val();
                    } else {
                        acUrlArgs.exclude = jQuery('#' + idPrefix).val();
                    }
                }

                jQuery.getJSON(Routing.generate(singleRelationHandler.moduleName.toLowerCase() + '_ajax_getitemlistautocompletion', acUrlArgs), function(data) {
                    response(data);
                });
            },
            response: function(event, ui) {
                jQuery('#' + idPrefix + 'LiveSearch .empty-message').remove();
                if (ui.content.length === 0) {
                    jQuery('#' + idPrefix + 'LiveSearch').append('<div class="empty-message">' + Translator.__('No results found!') + '</div>');
                }
            },
            focus: function(event, ui) {
                jQuery('#' + idPrefix + 'Selector').val(ui.item.title);

                return false;
            },
            select: function(event, ui) {
                if (true === isHookAttacher) {
                    mUFilesSelectHookItem(objectType, idPrefix, ui.item);
                } else {
                    mUFilesSelectRelatedItem(objectType, idPrefix, ui.item);
                }

                return false;
            }
        })
        .autocomplete('instance')._renderItem = function(ul, item) {
            return jQuery('<div class="suggestion">')
                .append('<div class="media"><div class="media-left"><a href="javascript:void(0)">' + item.image + '</a></div><div class="media-body"><p class="media-heading">' + item.title + '</p>' + item.description + '</div></div>')
                .appendTo(ul);
        };
    });

    if (!includeEditing || jQuery('#' + idPrefix + 'SelectorDoNew').length < 1) {
        return;
    }

    // from here inline editing will be handled
    jQuery('#' + idPrefix + 'SelectorDoNew').attr('href', jQuery('#' + idPrefix + 'SelectorDoNew').attr('href') + '?raw=1&idp=' + idPrefix + 'SelectorDoNew');
    jQuery('#' + idPrefix + 'SelectorDoNew').click(function (event) {
        event.preventDefault();
        mUFilesInitInlineRelationWindow(objectType, idPrefix + 'SelectorDoNew');
    });

    itemIds = jQuery('#' + idPrefix).val();
    itemIdsArr = itemIds.split(',');
    jQuery.each(itemIdsArr, function (key, existingId) {
        var elemPrefix;

        if (existingId) {
            elemPrefix = idPrefix + 'Reference_' + existingId + 'Edit';
            jQuery('#' + elemPrefix).attr('href', jQuery('#' + elemPrefix).attr('href') + '?raw=1&idp=' + elemPrefix);
            jQuery('#' + elemPrefix).click(function (event) {
                event.preventDefault();
                mUFilesInitInlineRelationWindow(objectType, elemPrefix);
            });
        }
    });
}

/**
 * Closes an iframe from the document displayed in it.
 */
function mUFilesCloseWindowFromInside(idPrefix, itemId, searchTerm)
{
    // if there is no parent window do nothing
    if (window.parent === '') {
        return;
    }

    // search for the handler of the current window
    jQuery.each(window.parent.relationHandler, function (key, singleRelationHandler) {
        var selector;

        // look if this handler is the right one
        if (singleRelationHandler.prefix === idPrefix) {
            // look whether there is an auto completion instance
            if (null !== singleRelationHandler.acInstance) {
                selector = window.parent.jQuery('#' + idPrefix.replace('DoNew', '')).first();

                // show a message
                window.parent.mUFilesSimpleAlert(selector, window.parent.Translator.__('Information'), window.parent.Translator.__('Action has been completed.'), 'actionDoneAlert', 'success');

                // check if a new item has been created
                if (itemId > 0) {
                    // activate auto completion
                    if (searchTerm == '') {
                        searchTerm = selector.val();
                    }
                    if (searchTerm != '') {
                        selector.autocomplete('option', 'autoFocus', true);
                        selector.autocomplete('search', searchTerm);
                        window.setTimeout(function() {
                            var suggestions = selector.autocomplete('widget')[0].children;
                            if (suggestions.length === 1) {
                                window.parent.jQuery(suggestions[0]).click();
                            }
                            selector.autocomplete('option', 'autoFocus', false);
                        }, 1000);
                    }
                }
            }

            // look whether there is a window instance
            if (null !== singleRelationHandler.windowInstanceId) {
                // close it
                window.parent.jQuery('#' + singleRelationHandler.windowInstanceId).dialog('close');
            }
        }
    });
}

