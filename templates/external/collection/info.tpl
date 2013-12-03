{* Purpose of this template: Display item information for previewing from other modules *}
<dl id="collection{$collection.id}">
<dt>{$collection->getTitleFromDisplayPattern()|notifyfilters:'mufiles.filter_hooks.collections.filter'|htmlentities}</dt>
{if $collection.description ne ''}<dd>{$collection.description}</dd>{/if}
<dd>{assignedcategorieslist categories=$collection.categories doctrine2=true}</dd>
</dl>
