{* Purpose of this template: Display hookobjects within an external context *}
<dl>
    {foreach item='hookobject' from=$items}
        <dt>{$hookobject->getTitleFromDisplayPattern()}</dt>
        {if $hookobject.hookedModule}
            <dd>{$hookobject.hookedModule|strip_tags|truncate:200:'&hellip;'}</dd>
        {/if}
        <dd><a href="{modurl modname='MUFiles' type='user' ot='hookobject' func='display'  id=$hookobject.id}">{gt text='Read more'}</a>
        </dd>
    {foreachelse}
        <dt>{gt text='No entries found.'}</dt>
    {/foreach}
</dl>
