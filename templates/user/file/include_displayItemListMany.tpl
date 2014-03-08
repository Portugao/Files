{* purpose of this template: inclusion template for display of related files in user area *}
{checkpermission component='MUFiles:File:' instance='::' level='ACCESS_COMMENT' assign='hasAdminPermission'}
{checkpermission component='MUFiles:File:' instance='::' level='ACCESS_COMMENT' assign='hasEditPermission'}
{if !isset($nolink)}
    {assign var='nolink' value=false}
{/if}
{if isset($items) && $items ne null && count($items) gt 0}
<ul class="mufiles-related-item-list file">
{foreach name='relLoop' item='item' from=$items}
{if $hasAdminPermission || $item.workflowState eq 'approved'}
    <li>
{strip}
{if !$nolink}
    <a href="{modurl modname='MUFiles' type='user' func='display' ot='file' id=$item.id}" title="{$item->getTitleFromDisplayPattern()|replace:"\"":""}">
{/if}
    {$item->getTitleFromDisplayPattern()}
{if !$nolink}
    </a>
    <a id="fileItem{$item.id}Display" href="{modurl modname='MUFiles' type='user' func='display' ot='file' id=$item.id theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
{/if}
{/strip}
{if !$nolink}
<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        mufilesInitInlineWindow($('fileItem{{$item.id}}Display'), '{{$item->getTitleFromDisplayPattern()|replace:"'":""}}');
    });
/* ]]> */
</script>
{/if}
    </li>
{/if}
{/foreach}
</ul>
{/if}
