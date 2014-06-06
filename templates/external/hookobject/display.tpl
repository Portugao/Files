{* Purpose of this template: Display one certain hookobject within an external context *}
<div id="hookobject{$hookobject.id}" class="mufiles-external-hookobject">
{if $displayMode eq 'link'}
    <p class="mufiles-external-link">
    <a href="{modurl modname='MUFiles' type='user' ot='hookobject' func='display' id=$hookobject.id}" title="{$hookobject->getTitleFromDisplayPattern()|replace:"\"":""}">
    {$hookobject->getTitleFromDisplayPattern()|notifyfilters:'mufiles.filter_hooks.hookobjects.filter'}
    </a>
    </p>
{/if}
{checkpermissionblock component='MUFiles::' instance='::' level='ACCESS_EDIT'}
    {if $displayMode eq 'embed'}
        <p class="mufiles-external-title">
            <strong>{$hookobject->getTitleFromDisplayPattern()|notifyfilters:'mufiles.filter_hooks.hookobjects.filter'}</strong>
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
            {if $hookobject.hookedModule ne ''}{$hookobject.hookedModule}<br />{/if}
        </p>
    *}
{/if}
</div>
