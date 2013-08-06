{* Purpose of this template: Display one certain file within an external context *}
<div id="file{$file.id}" class="mufilesexternalfile">
{if $displayMode eq 'link'}
    <p class="mufilesexternallink">
    <a href="{modurl modname='MUFiles' type='user' func='display' ot='file' id=$file.id}" title="{$file.title|replace:"\"":""}">
    {$file.title|notifyfilters:'mufiles.filter_hooks.files.filter'}
    </a>
    </p>
{/if}
{checkpermissionblock component='MUFiles::' instance='::' level='ACCESS_EDIT'}
    {if $displayMode eq 'embed'}
        <p class="mufilesexternaltitle">
            <strong>{$file.title|notifyfilters:'mufiles.filter_hooks.files.filter'}</strong>
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
            {if $file.description ne ''}{$file.description}<br />{/if}
        </p>
    *}
{/if}
</div>
