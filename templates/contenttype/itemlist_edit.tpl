{* Purpose of this template: edit view of generic item list content type *}
<div class="z-formrow">
    {gt text='Object type' domain='module_mufiles' assign='objectTypeSelectorLabel'}
    {formlabel for='mUFilesObjectType' text=$objectTypeSelectorLabel}
        {mufilesObjectTypeSelector assign='allObjectTypes'}
        {formdropdownlist id='mUFilesOjectType' dataField='objectType' group='data' mandatory=true items=$allObjectTypes}
        <span class="z-sub z-formnote">{gt text='If you change this please save the element once to reload the parameters below.' domain='module_mufiles'}</span>
</div>

{formvolatile}
{if $properties ne null && is_array($properties)}
    {nocache}
    {foreach key='registryId' item='registryCid' from=$registries}
        {assign var='propName' value=''}
        {foreach key='propertyName' item='propertyId' from=$properties}
            {if $propertyId eq $registryId}
                {assign var='propName' value=$propertyName}
            {/if}
        {/foreach}
        <div class="z-formrow">
            {modapifunc modname='MUFiles' type='category' func='hasMultipleSelection' ot=$objectType registry=$propertyName assign='hasMultiSelection'}
            {gt text='Category' domain='module_mufiles' assign='categorySelectorLabel'}
            {assign var='selectionMode' value='single'}
            {if $hasMultiSelection eq true}
                {gt text='Categories' domain='module_mufiles' assign='categorySelectorLabel'}
                {assign var='selectionMode' value='multiple'}
            {/if}
            {formlabel for="mUFilesCatIds`$propertyName`" text=$categorySelectorLabel}
                {formdropdownlist id="mUFilesCatIds`$propName`" items=$categories.$propName dataField="catids`$propName`" group='data' selectionMode=$selectionMode}
                <span class="z-sub z-formnote">{gt text='This is an optional filter.' domain='module_mufiles'}</span>
        </div>
    {/foreach}
    {/nocache}
{/if}
{/formvolatile}

<div class="z-formrow">
    {gt text='Sorting' domain='module_mufiles' assign='sortingLabel'}
    {formlabel text=$sortingLabel}
    <div>
        {formradiobutton id='mUFilesSortRandom' value='random' dataField='sorting' group='data' mandatory=true}
        {gt text='Random' domain='module_mufiles' assign='sortingRandomLabel'}
        {formlabel for='mUFilesSortRandom' text=$sortingRandomLabel}
        {formradiobutton id='mUFilesSortNewest' value='newest' dataField='sorting' group='data' mandatory=true}
        {gt text='Newest' domain='module_mufiles' assign='sortingNewestLabel'}
        {formlabel for='mUFilesSortNewest' text=$sortingNewestLabel}
        {formradiobutton id='mUFilesSortDefault' value='default' dataField='sorting' group='data' mandatory=true}
        {gt text='Default' domain='module_mufiles' assign='sortingDefaultLabel'}
        {formlabel for='mUFilesSortDefault' text=$sortingDefaultLabel}
    </div>
</div>

<div class="z-formrow">
    {gt text='Amount' domain='module_mufiles' assign='amountLabel'}
    {formlabel for='mUFilesAmount' text=$amountLabel}
        {formintinput id='mUFilesAmount' dataField='amount' group='data' mandatory=true maxLength=2}
</div>

<div class="z-formrow">
    {gt text='Template' domain='module_mufiles' assign='templateLabel'}
    {formlabel for='mUFilesTemplate' text=$templateLabel}
        {mufilesTemplateSelector assign='allTemplates'}
        {formdropdownlist id='mUFilesTemplate' dataField='template' group='data' mandatory=true items=$allTemplates}
</div>

<div id="customTemplateArea" class="z-formrow z-hide">
    {gt text='Custom template' domain='module_mufiles' assign='customTemplateLabel'}
    {formlabel for='mUFilesCustomTemplate' text=$customTemplateLabel}
        {formtextinput id='mUFilesCustomTemplate' dataField='customTemplate' group='data' mandatory=false maxLength=80}
        <span class="z-sub z-formnote">{gt text='Example' domain='module_mufiles'}: <em>itemlist_[objectType]_display.tpl</em></span>
</div>

<div class="z-formrow z-hide">
    {gt text='Filter (expert option)' domain='module_mufiles' assign='filterLabel'}
    {formlabel for='mUFilesFilter' text=$filterLabel}
        {formtextinput id='mUFilesFilter' dataField='filter' group='data' mandatory=false maxLength=255}
        <span class="z-sub z-formnote">
            ({gt text='Syntax examples'}: <kbd>name:like:foobar</kbd> {gt text='or'} <kbd>status:ne:3</kbd>)
        </span>
</div>

{pageaddvar name='javascript' value='prototype'}
<script type="text/javascript">
/* <![CDATA[ */
    function mUMUFilesToggleCustomTemplate() {
        if ($F('mUFilesTemplate') == 'custom') {
            $('customTemplateArea').removeClassName('z-hide');
        } else {
            $('customTemplateArea').addClassName('z-hide');
        }
    }

    document.observe('dom:loaded', function() {
        mUMUFilesToggleCustomTemplate();
        $('mUFilesTemplate').observe('change', function(e) {
            mUMUFilesToggleCustomTemplate();
        });
    });
/* ]]> */
</script>
