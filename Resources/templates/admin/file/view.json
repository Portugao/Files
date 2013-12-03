{* purpose of this template: files view json view in admin area *}
{mufilesTemplateHeaders contentType='application/json'}
[
{foreach item='item' from=$items name='files'}
    {if not $smarty.foreach.files.first},{/if}
    {$item->toJson()}
{/foreach}
]
