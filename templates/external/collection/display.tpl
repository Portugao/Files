{* Purpose of this template: Display one certain collection within an external context *}
<div id="collection{$collection.id}" class="mufiles-external-collection">
{if $displayMode eq 'link'}
    <p class="mufiles-external-link">
    <a href="{modurl modname='MUFiles' type='user' ot='collection' func='display' id=$collection.id}" title="{$collection->getTitleFromDisplayPattern()|replace:"\"":""}">
    {$collection->getTitleFromDisplayPattern()|notifyfilters:'mufiles.filter_hooks.collections.filter'}
    </a>
    </p>
{/if}
{checkpermissionblock component='MUFiles::' instance='::' level='ACCESS_EDIT'}
    {if $displayMode eq 'embed'}
        <p class="mufiles-external-title">
            <strong>{$collection->getTitleFromDisplayPattern()|notifyfilters:'mufiles.filter_hooks.collections.filter'}</strong>
        </p>
    {/if}
{/checkpermissionblock}

{if $displayMode eq 'link'}
{elseif $displayMode eq 'embed'}
    <div class="mufiles-external-snippet">
        &nbsp;
    </div>

    {* you can distinguish the context like this: *}
    {*if $source eq 'contentType'}
        ...
    {elseif $source eq 'scribite'}
        ...
    {/if*}

    {* you can enable more details about the item: *}
    {*
        <p class="mufiles-external-description">
            {if $collection.description ne ''}{$collection.description}<br />{/if}
            {assignedcategorieslist categories=$collection.categories doctrine2=true}
        </p>
    *}
{/if}
</div>
