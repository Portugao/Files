{* Purpose of this template: Display collections within an external context *}
<dl>
    {foreach item='collection' from=$items}
        <dt>{$collection->getTitleFromDisplayPattern()}</dt>
        {if $collection.description}
            <dd>{$collection.description|truncate:200:"..."}</dd>
        {/if}
        <dd><a href="{modurl modname='MUFiles' type='user' func='display' ot=$objectType id=$collection.id}">{gt text='Read more'}</a>
        </dd>
    {foreachelse}
        <dt>{gt text='No entries found.'}</dt>
    {/foreach}
</dl>
