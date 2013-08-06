{* Purpose of this template: Display item information for previewing from other modules *}
<dl id="file{$file.id}">
<dt>{$file.title|notifyfilters:'mufiles.filter_hooks.files.filter'|htmlentities}</dt>
{if $file.description ne ''}<dd>{$file.description}</dd>{/if}
</dl>
