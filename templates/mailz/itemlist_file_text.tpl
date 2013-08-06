{* Purpose of this template: Display files in text mailings *}
{foreach item='file' from=$items}
{$file.title}
{modurl modname='MUFiles' type='user' func='display' ot=$objectType id=$file.id fqurl=true}
-----
{foreachelse}
{gt text='No files found.'}
{/foreach}
