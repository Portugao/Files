{* purpose of this template: inclusion template for managing related files *}
{if !isset($displayMode)}
    {assign var='displayMode' value='dropdown'}
{/if}
{if !isset($allowEditing)}
    {assign var='allowEditing' value=false}
{/if}
{if isset($panel) && $panel eq true}
    <h3 class="files z-panel-header z-panel-indicator z-pointer">{gt text='Files'}</h3>
    <fieldset class="files z-panel-content" style="display: none">
{else}
    <fieldset class="files">
{/if}
    <legend>{gt text='Files'}</legend>
    <div class="z-formrow">
    {if $displayMode eq 'dropdown'}
        {formlabel for=$alias __text='Choose files'}
            {mufilesRelationSelectorList group=$group id=$alias aliasReverse=$aliasReverse mandatory=$mandatory __title='Choose the files' selectionMode='multiple' objectType='file' linkingItem=$linkingItem}
    {elseif $displayMode eq 'autocomplete'}
        {assign var='createLink' value=''}
        {if $allowEditing eq true}
            {modurl modname='MUFiles' type=$lct func='edit' ot='file' forcelongurl=true assign='createLink'}
        {/if}
        {mufilesRelationSelectorAutoComplete group=$group id=$alias aliasReverse=$aliasReverse mandatory=$mandatory __title='Choose the files' selectionMode='multiple' objectType='file' linkingItem=$linkingItem idPrefix=$idPrefix createLink=$createLink withImage=false}
        <div class="mufiles-relation-leftside">
            {if isset($linkingItem.$alias)}
                {include file='file/include_selectEditItemListMany.tpl'  items=$linkingItem.$alias}
            {else}
                {include file='file/include_selectEditItemListMany.tpl' }
            {/if}
        </div>
        <br class="z-clearer" />
    {/if}
    </div>
</fieldset>
