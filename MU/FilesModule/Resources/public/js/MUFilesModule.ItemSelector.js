'use strict';

var mUFilesModule = {};

mUFilesModule.itemSelector = {};
mUFilesModule.itemSelector.items = {};
mUFilesModule.itemSelector.baseId = 0;
mUFilesModule.itemSelector.selectedId = 0;

mUFilesModule.itemSelector.onLoad = function (baseId, selectedId)
{
    mUFilesModule.itemSelector.baseId = baseId;
    mUFilesModule.itemSelector.selectedId = selectedId;

    // required as a changed object type requires a new instance of the item selector plugin
    jQuery('#mUFilesModuleObjectType').change(mUFilesModule.itemSelector.onParamChanged);

    jQuery('#' + baseId + '_catidMain').change(mUFilesModule.itemSelector.onParamChanged);
    jQuery('#' + baseId + '_catidsMain').change(mUFilesModule.itemSelector.onParamChanged);
    jQuery('#' + baseId + 'Id').change(mUFilesModule.itemSelector.onItemChanged);
    jQuery('#' + baseId + 'Sort').change(mUFilesModule.itemSelector.onParamChanged);
    jQuery('#' + baseId + 'SortDir').change(mUFilesModule.itemSelector.onParamChanged);
    jQuery('#mUFilesModuleSearchGo').click(mUFilesModule.itemSelector.onParamChanged);
    jQuery('#mUFilesModuleSearchGo').keypress(mUFilesModule.itemSelector.onParamChanged);

    mUFilesModule.itemSelector.getItemList();
};

mUFilesModule.itemSelector.onParamChanged = function ()
{
    jQuery('#ajaxIndicator').removeClass('hidden');

    mUFilesModule.itemSelector.getItemList();
};

mUFilesModule.itemSelector.getItemList = function ()
{
    var baseId;
    var params;

    baseId = mUFilesModule.itemSelector.baseId;
    params = {
        ot: baseId,
        sort: jQuery('#' + baseId + 'Sort').val(),
        sortdir: jQuery('#' + baseId + 'SortDir').val(),
        q: jQuery('#' + baseId + 'SearchTerm').val()
    }
    if (jQuery('#' + baseId + '_catidMain').length > 0) {
        params[catidMain] = jQuery('#' + baseId + '_catidMain').val();
    } else if (jQuery('#' + baseId + '_catidsMain').length > 0) {
        params[catidsMain] = jQuery('#' + baseId + '_catidsMain').val();
    }

    jQuery.getJSON(Routing.generate('mufilesmodule_ajax_getitemlistfinder'), params, function( data ) {
        var baseId;

        baseId = mUFilesModule.itemSelector.baseId;
        mUFilesModule.itemSelector.items[baseId] = data;
        jQuery('#ajaxIndicator').addClass('hidden');
        mUFilesModule.itemSelector.updateItemDropdownEntries();
        mUFilesModule.itemSelector.updatePreview();
    });
};

mUFilesModule.itemSelector.updateItemDropdownEntries = function ()
{
    var baseId, itemSelector, items, i, item;

    baseId = mUFilesModule.itemSelector.baseId;
    itemSelector = jQuery('#' + baseId + 'Id');
    itemSelector.length = 0;

    items = mUFilesModule.itemSelector.items[baseId];
    for (i = 0; i < items.length; ++i) {
        item = items[i];
        itemSelector.get(0).options[i] = new Option(item.title, item.id, false);
    }

    if (mUFilesModule.itemSelector.selectedId > 0) {
        jQuery('#' + baseId + 'Id').val(mUFilesModule.itemSelector.selectedId);
    }
};

mUFilesModule.itemSelector.updatePreview = function ()
{
    var baseId, items, selectedElement, i;

    baseId = mUFilesModule.itemSelector.baseId;
    items = mUFilesModule.itemSelector.items[baseId];

    jQuery('#' + baseId + 'PreviewContainer').addClass('hidden');

    if (items.length === 0) {
        return;
    }

    selectedElement = items[0];
    if (mUFilesModule.itemSelector.selectedId > 0) {
        for (var i = 0; i < items.length; ++i) {
            if (items[i].id == mUFilesModule.itemSelector.selectedId) {
                selectedElement = items[i];
                break;
            }
        }
    }

    if (null !== selectedElement) {
        jQuery('#' + baseId + 'PreviewContainer')
            .html(window.atob(selectedElement.previewInfo))
            .removeClass('hidden');
    }
};

mUFilesModule.itemSelector.onItemChanged = function ()
{
    var baseId, itemSelector, preview;

    baseId = mUFilesModule.itemSelector.baseId;
    itemSelector = jQuery('#' + baseId + 'Id').get(0);
    preview = window.atob(mUFilesModule.itemSelector.items[baseId][itemSelector.selectedIndex].previewInfo);

    jQuery('#' + baseId + 'PreviewContainer').html(preview);
    mUFilesModule.itemSelector.selectedId = jQuery('#' + baseId + 'Id').val();
};

jQuery(document).ready(function() {
    var infoElem;

    infoElem = jQuery('#itemSelectorInfo');
    if (infoElem.length == 0) {
        return;
    }

    mUFilesModule.itemSelector.onLoad(infoElem.data('base-id'), infoElem.data('selected-id'));
});
