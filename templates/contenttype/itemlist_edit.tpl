{* Purpose of this template: edit view of generic item list content type *}

<div class="z-formrow">
    {gt text='Object type' domain='module_mufiles' assign='objectTypeSelectorLabel'}
    {formlabel for='MUFiles_objecttype' text=$objectTypeSelectorLabel}
    {mufilesObjectTypeSelector assign='allObjectTypes'}
    {formdropdownlist id='MUFiles_objecttype' dataField='objectType' group='data' mandatory=true items=$allObjectTypes}
    <div class="z-sub z-formnote">{gt text='If you change this please save the element once to reload the parameters below.' domain='module_mufiles'}</div>
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
            {formlabel for="MUFiles_catids`$propertyName`" text=$categorySelectorLabel}
            {formdropdownlist id="MUFiles_catids`$propName`" items=$categories.$propName dataField="catids`$propName`" group='data' selectionMode=$selectionMode}
            <div class="z-sub z-formnote">{gt text='This is an optional filter.' domain='module_mufiles'}</div>
        </div>
    {/foreach}
    {/nocache}
{/if}
{/formvolatile}

<div class="z-formrow">
    {gt text='Sorting' domain='module_mufiles' assign='sortingLabel'}
    {formlabel text=$sortingLabel}
    <div>
        {formradiobutton id='MUFiles_srandom' value='random' dataField='sorting' group='data' mandatory=true}
        {gt text='Random' domain='module_mufiles' assign='sortingRandomLabel'}
        {formlabel for='MUFiles_srandom' text=$sortingRandomLabel}
        {formradiobutton id='MUFiles_snewest' value='newest' dataField='sorting' group='data' mandatory=true}
        {gt text='Newest' domain='module_mufiles' assign='sortingNewestLabel'}
        {formlabel for='MUFiles_snewest' text=$sortingNewestLabel}
        {formradiobutton id='MUFiles_sdefault' value='default' dataField='sorting' group='data' mandatory=true}
        {gt text='Default' domain='module_mufiles' assign='sortingDefaultLabel'}
        {formlabel for='MUFiles_sdefault' text=$sortingDefaultLabel}
    </div>
</div>

<div class="z-formrow">
    {gt text='Amount' domain='module_mufiles' assign='amountLabel'}
    {formlabel for='MUFiles_amount' text=$amountLabel}
    {formintinput id='MUFiles_amount' dataField='amount' group='data' mandatory=true maxLength=2}
</div>

<div class="z-formrow">
    {gt text='Template' domain='module_mufiles' assign='templateLabel'}
    {formlabel for='MUFiles_template' text=$templateLabel}
    {mufilesTemplateSelector assign='allTemplates'}
    {formdropdownlist id='MUFiles_template' dataField='template' group='data' mandatory=true items=$allTemplates}
</div>

<div id="customtemplatearea" class="z-formrow z-hide">
    {gt text='Custom template' domain='module_mufiles' assign='customTemplateLabel'}
    {formlabel for='MUFiles_customtemplate' text=$customTemplateLabel}
    {formtextinput id='MUFiles_customtemplate' dataField='customTemplate' group='data' mandatory=false maxLength=80}
    <div class="z-sub z-formnote">{gt text='Example' domain='module_mufiles'}: <em>itemlist_[objecttype]_display.tpl</em></div>
</div>

<div class="z-formrow z-hide">
    {gt text='Filter (expert option)' domain='module_mufiles' assign='filterLabel'}
    {formlabel for='MUFiles_filter' text=$filterLabel}
    {formtextinput id='MUFiles_filter' dataField='filter' group='data' mandatory=false maxLength=255}
    <div class="z-sub z-formnote">({gt text='Syntax examples' domain='module_mufiles'}: <kbd>name:like:foobar</kbd> {gt text='or' domain='module_mufiles'} <kbd>status:ne:3</kbd>)</div>
</div>

{pageaddvar name='javascript' value='prototype'}
<script type="text/javascript">
/* <![CDATA[ */
    function mufilesToggleCustomTemplate() {
        if ($F('MUFiles_template') == 'custom') {
            $('customtemplatearea').removeClassName('z-hide');
        } else {
            $('customtemplatearea').addClassName('z-hide');
        }
    }

    document.observe('dom:loaded', function() {
        mufilesToggleCustomTemplate();
        $('MUFiles_template').observe('change', function(e) {
            mufilesToggleCustomTemplate();
        });
    });
/* ]]> */
</script>
