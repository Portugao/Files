{* Purpose of this template: Display files in html mailings *}
{*
<ul>
{foreach item='file' from=$items}
    <li>
        <a href="{modurl modname='MUFiles' type='user' func='display' ot=$objectType id=$file.id fqurl=true}">{$file.title}
        </a>
    </li>
{foreachelse}
    <li>{gt text='No files found.'}</li>
{/foreach}
</ul>
*}

{include file='contenttype/itemlist_file_display_description.tpl'}
