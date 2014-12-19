{* Purpose of this template: Display collections within an external context *}
<dl>
    {foreach item='collection' from=$items}
        <dt>{$collection->getTitleFromDisplayPattern()}</dt>
        {if $collection.description}
            <dd>{$collection.description|strip_tags|truncate:200:'&hellip;'}</dd>
        {/if}
        <dd><a href="{modurl modname='MUFiles' type='user' ot='collection' func='display'  id=$collection.id}">{gt text='Read more'}</a>
        </dd>
    {foreachelse}
        <dt>{gt text='No entries found.'}</dt>
    {/foreach}
</dl>
