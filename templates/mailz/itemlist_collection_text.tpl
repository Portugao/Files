{* Purpose of this template: Display collections in text mailings *}
{foreach item='collection' from=$items}
{$collection->getTitleFromDisplayPattern()}
{modurl modname='MUFiles' type='user' func='display' ot=$objectType id=$collection.id fqurl=true}
-----
{foreachelse}
{gt text='No collections found.'}
{/foreach}
