{* Purpose of this template: Edit block for generic item list *}
<div class="z-formrow">
    <label for="mUFilesObjectType">{gt text='Object type'}:</label>
        <select id="mUFilesObjectType" name="objecttype" size="1">
            <option value="collection"{if $objectType eq 'collection'} selected="selected"{/if}>{gt text='Collections'}</option>
            <option value="file"{if $objectType eq 'file'} selected="selected"{/if}>{gt text='Files'}</option>
        </select>
        <span class="z-sub z-formnote">{gt text='If you change this please save the block once to reload the parameters below.'}</span>
</div>

{if $catIds ne null && is_array($catIds)}
    {gt text='All' assign='lblDefault'}
    {nocache}
    {foreach key='propertyName' item='propertyId' from=$catIds}
        <div class="z-formrow">
            {modapifunc modname='MUFiles' type='category' func='hasMultipleSelection' ot=$objectType registry=$propertyName assign='hasMultiSelection'}
            {gt text='Category' assign='categoryLabel'}
            {assign var='categorySelectorId' value='catid'}
            {assign var='categorySelectorName' value='catid'}
            {assign var='categorySelectorSize' value='1'}
            {if $hasMultiSelection eq true}
                {gt text='Categories' assign='categoryLabel'}
                {assign var='categorySelectorName' value='catids'}
                {assign var='categorySelectorId' value='catids__'}
                {assign var='categorySelectorSize' value='8'}
            {/if}
            <label for="{$categorySelectorId}{$propertyName}">{$categoryLabel}</label>
            &nbsp;
                {selector_category name="`$categorySelectorName``$propertyName`" field='id' selectedValue=$catIds.$propertyName categoryRegistryModule='MUFiles' categoryRegistryTable=$objectType categoryRegistryProperty=$propertyName defaultText=$lblDefault editLink=false multipleSize=$categorySelectorSize}
                <span class="z-sub z-formnote">{gt text='This is an optional filter.'}</span>
        </div>
    {/foreach}
    {/nocache}
{/if}

<div class="z-formrow">
    <label for="mUFilesSorting">{gt text='Sorting'}:</label>
        <select id="mUFilesSorting" name="sorting">
            <option value="random"{if $sorting eq 'random'} selected="selected"{/if}>{gt text='Random'}</option>
            <option value="newest"{if $sorting eq 'newest'} selected="selected"{/if}>{gt text='Newest'}</option>
            <option value="alpha"{if $sorting eq 'default' || ($sorting != 'random' && $sorting != 'newest')} selected="selected"{/if}>{gt text='Default'}</option>
        </select>
</div>

<div class="z-formrow">
    <label for="mUFilesAmount">{gt text='Amount'}:</label>
        <input type="text" id="mUFilesAmount" name="amount" maxlength="2" size="10" value="{$amount|default:"5"}" />
</div>

<div class="z-formrow">
    <label for="mUFilesTemplate">{gt text='Template'}:</label>
        <select id="mUFilesTemplate" name="template">
            <option value="itemlist_display.tpl"{if $template eq 'itemlist_display.tpl'} selected="selected"{/if}>{gt text='Only item titles'}</option>
            <option value="itemlist_display_description.tpl"{if $template eq 'itemlist_display_description.tpl'} selected="selected"{/if}>{gt text='With description'}</option>
            <option value="custom"{if $template eq 'custom'} selected="selected"{/if}>{gt text='Custom template'}</option>
        </select>
</div>

<div id="customTemplateArea" class="z-formrow z-hide">
    <label for="mUFilesCustomTemplate">{gt text='Custom template'}:</label>
        <input type="text" id="mUFilesCustomTemplate" name="customtemplate" size="40" maxlength="80" value="{$customTemplate|default:''}" />
        <span class="z-sub z-formnote">{gt text='Example'}: <em>itemlist_[objectType]_display.tpl</em></span>
</div>

<div class="z-formrow z-hide">
    <label for="mUFilesFilter">{gt text='Filter (expert option)'}:</label>
        <input type="text" id="mUFilesFilter" name="filter" size="40" value="{$filterValue|default:''}" />
        <span class="z-sub z-formnote">
            ({gt text='Syntax examples'}: <kbd>name:like:foobar</kbd> {gt text='or'} <kbd>status:ne:3</kbd>)
        </span>
</div>

{pageaddvar name='javascript' value='prototype'}
<script type="text/javascript">
/* <![CDATA[ */
    function mufilesToggleCustomTemplate() {
        if ($F('mUFilesTemplate') == 'custom') {
            $('customTemplateArea').removeClassName('z-hide');
        } else {
            $('customTemplateArea').addClassName('z-hide');
        }
    }

    document.observe('dom:loaded', function() {
        mufilesToggleCustomTemplate();
        $('mUFilesTemplate').observe('change', function(e) {
            mufilesToggleCustomTemplate();
        });
    });
/* ]]> */
</script>
