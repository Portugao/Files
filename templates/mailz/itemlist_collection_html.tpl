{* Purpose of this template: Display collections in html mailings *}
{*
<ul>
{foreach item='collection' from=$items}
    <li>
        <a href="{modurl modname='MUFiles' type='user' func='display' ot=$objectType id=$collection.id fqurl=true}">{$collection.name}
        </a>
    </li>
{foreachelse}
    <li>{gt text='No collections found.'}</li>
{/foreach}
</ul>
*}

{include file='contenttype/itemlist_collection_display_description.tpl'}
