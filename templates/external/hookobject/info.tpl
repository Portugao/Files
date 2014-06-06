{* Purpose of this template: Display item information for previewing from other modules *}
<dl id="hookobject{$hookobject.id}">
<dt>{$hookobject->getTitleFromDisplayPattern()|notifyfilters:'mufiles.filter_hooks.hookobjects.filter'|htmlentities}</dt>
{if $hookobject.hookedModule ne ''}<dd>{$hookobject.hookedModule}</dd>{/if}
</dl>
