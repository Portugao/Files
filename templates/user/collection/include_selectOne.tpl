{* purpose of this template: inclusion template for managing related collection in user area *}
{if !isset($displayMode)}
    {assign var='displayMode' value='dropdown'}
{/if}
{if !isset($allowEditing)}
    {assign var='allowEditing' value=false}
{/if}
{if isset($panel) && $panel eq true}
    <h3 class="collection z-panel-header z-panel-indicator z-pointer">{gt text='Collection'}</h3>
    <fieldset class="collection z-panel-content" style="display: none">
{else}
    <fieldset class="collection">
{/if}
    <legend>{gt text='Collection'}</legend>
    <div class="z-formrow">
    {if $displayMode eq 'dropdown'}
        {formlabel for=$alias __text='Choose collection'}
            {mufilesRelationSelectorList group=$group id=$alias aliasReverse=$aliasReverse mandatory=$mandatory __title='Choose the collection' selectionMode='single' objectType='collection' linkingItem=$linkingItem}
    {elseif $displayMode eq 'autocomplete'}
        {assign var='createLink' value=''}
        {if $allowEditing eq true}
            {modurl modname='MUFiles' type='user' func='edit' ot='collection' forcelongurl=true assign='createLink'}
        {/if}
        {mufilesRelationSelectorAutoComplete group=$group id=$alias aliasReverse=$aliasReverse mandatory=$mandatory __title='Choose the collection' selectionMode='single' objectType='collection' linkingItem=$linkingItem idPrefix=$idPrefix createLink=$createLink withImage=false}
        <div class="mufiles-relation-leftside">
            {if isset($linkingItem.$alias)}
                {include file='user/collection/include_selectItemListOne.tpl'  item=$linkingItem.$alias}
            {else}
                {include file='user/collection/include_selectItemListOne.tpl' }
            {/if}
        </div>
        <br class="z-clearer" />
    {/if}
    </div>
</fieldset>
