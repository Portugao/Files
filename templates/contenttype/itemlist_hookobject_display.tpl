{* Purpose of this template: Display hookobjects within an external context *}
{foreach item='hookobject' from=$items}
    <h3>{$hookobject->getTitleFromDisplayPattern()}</h3>
    <p><a href="{modurl modname='MUFiles' type='user' ot='hookobject' func='display'  id=$$objectType.id}">{gt text='Read more'}</a>
    </p>
{/foreach}
