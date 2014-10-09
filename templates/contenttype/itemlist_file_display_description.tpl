{* Purpose of this template: Display files within an external context *}
<dl>
    {foreach item='file' from=$items}
        <dt>{$file->getTitleFromDisplayPattern()}</dt>
        {if $file.description}
            <dd>{$file.description|strip_tags|truncate:200:'&hellip;'}</dd>
        {/if}
        <dd><a href="{modurl modname='MUFiles' type='user' ot='file' func='display'  id=$$objectType.id}">{gt text='Read more'}</a>
        </dd>
    {foreachelse}
        <dt>{gt text='No entries found.'}</dt>
    {/foreach}
</dl>
