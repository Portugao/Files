{* purpose of this template: inclusion template for managing related collections *}
{if !isset($displayMode)}
    {assign var='displayMode' value='dropdown'}
{/if}
{if !isset($allowEditing)}
    {assign var='allowEditing' value=false}
{/if}
{if isset($panel) && $panel eq true}
    <h3 class="collections z-panel-header z-panel-indicator z-pointer">{gt text='Collections'}</h3>
    <fieldset class="collections z-panel-content" style="display: none">
{else}
    <fieldset class="collections">
{/if}
    <legend>{gt text='Collections'}</legend>
    <div class="z-formrow">
    {if $displayMode eq 'dropdown'}
        {formlabel for=$alias __text='Choose collections'}
            {mufilesRelationSelectorList group=$group id=$alias aliasReverse=$aliasReverse mandatory=$mandatory __title='Choose the collections' selectionMode='multiple' objectType='collection' linkingItem=$linkingItem}
    {elseif $displayMode eq 'autocomplete'}
        {assign var='createLink' value=''}
        {if $allowEditing eq true}
            {modurl modname='MUFiles' type=$lct func='edit' ot='collection' forcelongurl=true assign='createLink'}
        {/if}
        {mufilesRelationSelectorAutoComplete group=$group id=$alias aliasReverse=$aliasReverse mandatory=$mandatory __title='Choose the collections' selectionMode='multiple' objectType='collection' linkingItem=$linkingItem idPrefix=$idPrefix createLink=$createLink withImage=false}
        <div class="mufiles-relation-leftside">
            {if isset($linkingItem.$alias)}
                {include file='collection/include_selectEditItemListMany.tpl'  items=$linkingItem.$alias}
            {else}
                {include file='collection/include_selectEditItemListMany.tpl' }
            {/if}
        </div>
        <br class="z-clearer" />
    {/if}
    </div>
{if isset($panel) && $panel eq true}
    </fieldset>
{else}
    </fieldset>
{/if}
