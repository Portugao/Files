{* Purpose of this template: Display files within an external context *}
<dl>
    {foreach item='file' from=$items}
        <dt>{$file.title}</dt>
        {if $file.description}
            <dd>{$file.description|truncate:200:"..."}</dd>
        {/if}
        <dd><a href="{modurl modname='MUFiles' type='user' func='display' ot=$objectType id=$item.id}">{gt text='Read more'}</a>
        </dd>
    {foreachelse}
        <dt>{gt text='No entries found.'}</dt>
    {/foreach}
</dl>
