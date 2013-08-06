{* Purpose of this template: Display one certain collection within an external context *}
<div id="collection{$collection.id}" class="mufilesexternalcollection">
{if $displayMode eq 'link'}
    <p class="mufilesexternallink">
    <a href="{modurl modname='MUFiles' type='user' func='display' ot='collection' id=$collection.id}" title="{$collection.name|replace:"\"":""}">
    {$collection.name|notifyfilters:'mufiles.filter_hooks.collections.filter'}
    </a>
    </p>
{/if}
{checkpermissionblock component='MUFiles::' instance='::' level='ACCESS_EDIT'}
    {if $displayMode eq 'embed'}
        <p class="mufilesexternaltitle">
            <strong>{$collection.name|notifyfilters:'mufiles.filter_hooks.collections.filter'}</strong>
        </p>
    {/if}
{/checkpermissionblock}

{if $displayMode eq 'link'}
{elseif $displayMode eq 'embed'}
    <div class="mufilesexternalsnippet">
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
        <p class="mufilesexternaldesc">
            {if $collection.description ne ''}{$collection.description}<br />{/if}
            {assignedcategorieslist categories=$collection.categories doctrine2=true}
        </p>
    *}
{/if}
</div>
