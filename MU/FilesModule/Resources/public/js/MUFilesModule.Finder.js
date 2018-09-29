'use strict';

var currentMUFilesModuleEditor = null;
var currentMUFilesModuleInput = null;

/**
 * Returns the attributes used for the popup window. 
 * @return {String}
 */
function getMUFilesModulePopupAttributes() {
    var pWidth, pHeight;

    pWidth = screen.width * 0.75;
    pHeight = screen.height * 0.66;

    return 'width=' + pWidth + ',height=' + pHeight + ',location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,resizable=yes,scrollbars=yes';
}

/**
 * Open a popup window with the finder triggered by an editor button.
 */
function MUFilesModuleFinderOpenPopup(editor, editorName) {
    var popupUrl;

    // Save editor for access in selector window
    currentMUFilesModuleEditor = editor;

    popupUrl = Routing.generate('mufilesmodule_external_finder', { objectType: 'collection', editor: editorName });

    if (editorName == 'ckeditor') {
        editor.popup(popupUrl, /*width*/ '80%', /*height*/ '70%', getMUFilesModulePopupAttributes());
    } else {
        window.open(popupUrl, '_blank', getMUFilesModulePopupAttributes());
    }
}


var mUFilesModule = {};

mUFilesModule.finder = {};

mUFilesModule.finder.onLoad = function (baseId, selectedId) {
    if (jQuery('#mUFilesModuleSelectorForm').length < 1) {
        return;
    }
    jQuery('select').not("[id$='pasteAs']").change(mUFilesModule.finder.onParamChanged);
    
    jQuery('.btn-default').click(mUFilesModule.finder.handleCancel);

    var selectedItems = jQuery('#mufilesmoduleItemContainer a');
    selectedItems.bind('click keypress', function (event) {
        event.preventDefault();
        mUFilesModule.finder.selectItem(jQuery(this).data('itemid'));
    });
};

mUFilesModule.finder.onParamChanged = function () {
    jQuery('#mUFilesModuleSelectorForm').submit();
};

mUFilesModule.finder.handleCancel = function (event) {
    var editor;

    event.preventDefault();
    editor = jQuery("[id$='editor']").first().val();
    if ('ckeditor' === editor) {
        mUFilesClosePopup();
    } else if ('quill' === editor) {
        mUFilesClosePopup();
    } else if ('summernote' === editor) {
        mUFilesClosePopup();
    } else if ('tinymce' === editor) {
        mUFilesClosePopup();
    } else {
        alert('Close Editor: ' + editor);
    }
};


function mUFilesGetPasteSnippet(mode, itemId) {
    var quoteFinder;
    var itemPath;
    var itemUrl;
    var itemTitle;
    var itemDescription;
    var pasteMode;

    quoteFinder = new RegExp('"', 'g');
    itemPath = jQuery('#path' + itemId).val().replace(quoteFinder, '');
    itemUrl = jQuery('#url' + itemId).val().replace(quoteFinder, '');
    itemTitle = jQuery('#title' + itemId).val().replace(quoteFinder, '').trim();
    itemDescription = jQuery('#desc' + itemId).val().replace(quoteFinder, '').trim();
    pasteMode = jQuery("[id$='pasteAs']").first().val();

    // item ID
    if (pasteMode === '3') {
        return '' + itemId;
    }

    // relative link to detail page
    if (pasteMode === '1') {
        return mode === 'url' ? itemPath : '<a href="' + itemPath + '" title="' + itemDescription + '">' + itemTitle + '</a>';
    }
    // absolute url to detail page
    if (pasteMode === '2') {
        return mode === 'url' ? itemUrl : '<a href="' + itemUrl + '" title="' + itemDescription + '">' + itemTitle + '</a>';
    }

    return '';
}


// User clicks on "select item" button
mUFilesModule.finder.selectItem = function (itemId) {
    var editor, html;

    html = mUFilesGetPasteSnippet('html', itemId);
    editor = jQuery("[id$='editor']").first().val();
    if ('ckeditor' === editor) {
        if (null !== window.opener.currentMUFilesModuleEditor) {
            window.opener.currentMUFilesModuleEditor.insertHtml(html);
        }
    } else if ('quill' === editor) {
        if (null !== window.opener.currentMUFilesModuleEditor) {
            window.opener.currentMUFilesModuleEditor.clipboard.dangerouslyPasteHTML(window.opener.currentMUFilesModuleEditor.getLength(), html);
        }
    } else if ('summernote' === editor) {
        if (null !== window.opener.currentMUFilesModuleEditor) {
            html = jQuery(html).get(0);
            window.opener.currentMUFilesModuleEditor.invoke('insertNode', html);
        }
    } else if ('tinymce' === editor) {
        window.opener.currentMUFilesModuleEditor.insertContent(html);
    } else {
        alert('Insert into Editor: ' + editor);
    }
    mUFilesClosePopup();
};

function mUFilesClosePopup() {
    window.opener.focus();
    window.close();
}

jQuery(document).ready(function () {
    mUFilesModule.finder.onLoad();
});
