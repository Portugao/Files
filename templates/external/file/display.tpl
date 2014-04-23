{* Purpose of this template: Display one certain file within an external context *}
<div id="file{$file.id}" class="mufiles-external-file">
{if $displayMode eq 'link'}
    <p class="mufiles-external-link">
    <a href="{modurl modname='MUFiles' type='user' func='display' ot='file' id=$file.id}" title="{$file->getTitleFromDisplayPattern()|replace:"\"":""}">
    {$file->getTitleFromDisplayPattern()|notifyfilters:'mufiles.filter_hooks.files.filter'}
    </a>
    </p>
{/if}
{checkpermissionblock component='MUFiles::' instance='::' level='ACCESS_COMMENT'}
    {if $displayMode eq 'embed'}
        <p class="mufiles-external-title">
            <strong>{$file->getTitleFromDisplayPattern()|notifyfilters:'mufiles.filter_hooks.files.filter'}</strong>
        </p>
    {/if}
{/checkpermissionblock}

{if $displayMode eq 'link'}
{elseif $displayMode eq 'embed'}
    <div class="mufiles-external-snippet">
        &nbsp;
    </div>

    {* you can distinguish the context like this: *}
    {if $source eq 'contentType'}
        <a href="{modurl modname='MUFiles' type='user' func='giveFile' id=$file.id}">{gt text='Download'}</a> ({$file.uploadFileMeta.extension})
    {elseif $source eq 'scribite'}
        ...
    {/if}

    {* you can enable more details about the item: *}
    {*
        <p class="mufiles-external-description">
            {if $file.description ne ''}{$file.description}<br />{/if}
        </p>
    *}
{/if}
</div>
