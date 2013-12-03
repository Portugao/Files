{* Purpose of this template: Display files within an external context *}
{foreach item='file' from=$items}
    <h3>{$file->getTitleFromDisplayPattern()}</h3>
    <p><a href="{modurl modname='MUFiles' type='user' func='display' ot=$objectType id=$file.id}">{gt text='Read more'}</a>
    </p>
{/foreach}
