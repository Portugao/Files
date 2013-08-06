'use strict';

var currentMUFilesEditor = null;
var currentMUFilesInput = null;

/**
 * Returns the attributes used for the popup window. 
 * @return {String}
 */
function getPopupAttributes() {
    var pWidth, pHeight;

    pWidth = screen.width * 0.75;
    pHeight = screen.height * 0.66;
    return 'width=' + pWidth + ',height=' + pHeight + ',scrollbars,resizable';
}

/**
 * Open a popup window with the finder triggered by a Xinha button.
 */
function MUFilesFinderXinha(editor, mufilesURL) {
    var popupAttributes;

    // Save editor for access in selector window
    currentMUFilesEditor = editor;

    popupAttributes = getPopupAttributes();
    window.open(mufilesURL, '', popupAttributes);
}

/**
 * Open a popup window with the finder triggered by a CKEditor button.
 */
function MUFilesFinderCKEditor(editor, mufilesURL) {
    // Save editor for access in selector window
    currentMUFilesEditor = editor;

    editor.popup(
        Zikula.Config.baseURL + Zikula.Config.entrypoint + '?module=MUFiles&type=external&func=finder&editor=ckeditor',
        /*width*/ '80%', /*height*/ '70%',
        'location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,resizable=yes,scrollbars=yes'
    );
}



var mufiles = {};

mufiles.finder = {};

mufiles.finder.onLoad = function (baseId, selectedId) {
    $('MUFiles_sort').observe('change', mufiles.finder.onParamChanged);
    $('MUFiles_sortdir').observe('change', mufiles.finder.onParamChanged);
    $('MUFiles_pagesize').observe('change', mufiles.finder.onParamChanged);
    $('MUFiles_gosearch').observe('click', mufiles.finder.onParamChanged)
                           .observe('keypress', mufiles.finder.onParamChanged);
    $('MUFiles_submit').addClassName('z-hide');
    $('MUFiles_cancel').observe('click', mufiles.finder.handleCancel);
};

mufiles.finder.onParamChanged = function () {
    $('selectorForm').submit();
};

mufiles.finder.handleCancel = function () {
    var editor, w;

    editor = $F('editorName');
    if (editor === 'xinha') {
        w = parent.window;
        window.close();
        w.focus();
    } else if (editor === 'tinymce') {
        mufilesClosePopup();
    } else if (editor === 'ckeditor') {
        mufilesClosePopup();
    } else {
        alert('Close Editor: ' + editor);
    }
};


function getPasteSnippet(mode, itemId) {
    var itemUrl, itemTitle, itemDescription, pasteMode;

    itemUrl = $F('url' + itemId);
    itemTitle = $F('title' + itemId);
    itemDescription = $F('desc' + itemId);
    pasteMode = $F('MUFiles_pasteas');

    if (pasteMode === '2' || pasteMode !== '1') {
        return itemId;
    }

    // return link to item
    if (mode === 'url') {
        // plugin mode
        return itemUrl;
    } else {
        // editor mode
        return '<a href="' + itemUrl + '" title="' + itemDescription + '">' + itemTitle + '</a>';
    }
}


// User clicks on "select item" button
mufiles.finder.selectItem = function (itemId) {
    var editor, html;

    editor = $F('editorName');
    if (editor === 'xinha') {
        if (window.opener.currentMUFilesEditor !== null) {
            html = getPasteSnippet('html', itemId);

            window.opener.currentMUFilesEditor.focusEditor();
            window.opener.currentMUFilesEditor.insertHTML(html);
        } else {
            html = getPasteSnippet('url', itemId);
            var currentInput = window.opener.currentMUFilesInput;

            if (currentInput.tagName === 'INPUT') {
                // Simply overwrite value of input elements
                currentInput.value = html;
            } else if (currentInput.tagName === 'TEXTAREA') {
                // Try to paste into textarea - technique depends on environment
                if (typeof document.selection !== 'undefined') {
                    // IE: Move focus to textarea (which fortunately keeps its current selection) and overwrite selection
                    currentInput.focus();
                    window.opener.document.selection.createRange().text = html;
                } else if (typeof currentInput.selectionStart !== 'undefined') {
                    // Firefox: Get start and end points of selection and create new value based on old value
                    var startPos = currentInput.selectionStart;
                    var endPos = currentInput.selectionEnd;
                    currentInput.value = currentInput.value.substring(0, startPos)
                                        + html
                                        + currentInput.value.substring(endPos, currentInput.value.length);
                } else {
                    // Others: just append to the current value
                    currentInput.value += html;
                }
            }
        }
    } else if (editor === 'tinymce') {
        html = getPasteSnippet('html', itemId);
        window.opener.tinyMCE.activeEditor.execCommand('mceInsertContent', false, html);
        // other tinymce commands: mceImage, mceInsertLink, mceReplaceContent, see http://www.tinymce.com/wiki.php/Command_identifiers
    } else if (editor === 'ckeditor') {
        /** to be done*/
    } else {
        alert('Insert into Editor: ' + editor);
    }
    mufilesClosePopup();
};


function mufilesClosePopup() {
    window.opener.focus();
    window.close();
}




//=============================================================================
// MUFiles item selector for Forms
//=============================================================================

mufiles.itemSelector = {};
mufiles.itemSelector.items = {};
mufiles.itemSelector.baseId = 0;
mufiles.itemSelector.selectedId = 0;

mufiles.itemSelector.onLoad = function (baseId, selectedId) {
    mufiles.itemSelector.baseId = baseId;
    mufiles.itemSelector.selectedId = selectedId;

    // required as a changed object type requires a new instance of the item selector plugin
    $(baseId + '_objecttype').observe('change', mufiles.itemSelector.onParamChanged);

    if ($(baseId + '_catid') !== undefined) {
        $(baseId + '_catid').observe('change', mufiles.itemSelector.onParamChanged);
    }
    $(baseId + '_id').observe('change', mufiles.itemSelector.onItemChanged);
    $(baseId + '_sort').observe('change', mufiles.itemSelector.onParamChanged);
    $(baseId + '_sortdir').observe('change', mufiles.itemSelector.onParamChanged);
    $('MUFiles_gosearch').observe('click', mufiles.itemSelector.onParamChanged)
                           .observe('keypress', mufiles.itemSelector.onParamChanged);

    mufiles.itemSelector.getItemList();
};

mufiles.itemSelector.onParamChanged = function () {
    $('ajax_indicator').removeClassName('z-hide');

    mufiles.itemSelector.getItemList();
};

mufiles.itemSelector.getItemList = function () {
    var baseId, pars, request;

    baseId = mufiles.itemSelector.baseId;
    pars = 'objectType=' + baseId + '&';
    if ($(baseId + '_catid') !== undefined) {
        pars += 'catid=' + $F(baseId + '_catid') + '&';
    }
    pars += 'sort=' + $F(baseId + '_sort') + '&' +
            'sortdir=' + $F(baseId + '_sortdir') + '&' +
            'searchterm=' + $F(baseId + '_searchterm');

    request = new Zikula.Ajax.Request('ajax.php?module=MUFiles&func=getItemListFinder', {
        method: 'post',
        parameters: pars,
        onFailure: function(req) {
            Zikula.showajaxerror(req.getMessage());
        },
        onSuccess: function(req) {
            var baseId;
            baseId = mufiles.itemSelector.baseId;
            mufiles.itemSelector.items[baseId] = req.getData();
            $('ajax_indicator').addClassName('z-hide');
            mufiles.itemSelector.updateItemDropdownEntries();
            mufiles.itemSelector.updatePreview();
        }
    });
};

mufiles.itemSelector.updateItemDropdownEntries = function () {
    var baseId, itemSelector, items, i, item;

    baseId = mufiles.itemSelector.baseId;
    itemSelector = $(baseId + '_id');
    itemSelector.length = 0;

    items = mufiles.itemSelector.items[baseId];
    for (i = 0; i < items.length; ++i) {
        item = items[i];
        itemSelector.options[i] = new Option(item.title, item.id, false);
    }

    if (mufiles.itemSelector.selectedId > 0) {
        $(baseId + '_id').value = mufiles.itemSelector.selectedId;
    }
};

mufiles.itemSelector.updatePreview = function () {
    var baseId, items, selectedElement, i;

    baseId = mufiles.itemSelector.baseId;
    items = mufiles.itemSelector.items[baseId];

    $(baseId + '_previewcontainer').addClassName('z-hide');

    if (items.length === 0) {
        return;
    }

    selectedElement = items[0];
    if (mufiles.itemSelector.selectedId > 0) {
        for (var i = 0; i < items.length; ++i) {
            if (items[i].id === mufiles.itemSelector.selectedId) {
                selectedElement = items[i];
                break;
            }
        }
    }

    if (selectedElement !== null) {
        $(baseId + '_previewcontainer').update(window.atob(selectedElement.previewInfo))
                                       .removeClassName('z-hide');
    }
};

mufiles.itemSelector.onItemChanged = function () {
    var baseId, itemSelector, preview;

    baseId = mufiles.itemSelector.baseId;
    itemSelector = $(baseId + '_id');
    preview = window.atob(mufiles.itemSelector.items[baseId][itemSelector.selectedIndex].previewInfo);

    $(baseId + '_previewcontainer').update(preview);
    mufiles.itemSelector.selectedId = $F(baseId + '_id');
};
