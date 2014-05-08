{* purpose of this template: inclusion template for display of related collections *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{if $lct ne 'admin'}
    {checkpermission component='MUFiles:Collection:' instance='::' level='ACCESS_COMMENT' assign='hasAdminPermission'}
    {checkpermission component='MUFiles:Collection:' instance='::' level='ACCESS_COMMENT' assign='hasEditPermission'}
{/if}
{if !isset($nolink)}
    {assign var='nolink' value=false}
{/if}
{if isset($items) && $items ne null && count($items) gt 0}
<ul class="mufiles-related-item-list collection">
{foreach name='relLoop' item='item' from=$items}
    {if $hasAdminPermission || $item.workflowState eq 'approved'}
    <li>
{strip}
{if !$nolink}
    <a href="{modurl modname='MUFiles' type=$lct func='display' id=$item.id ot='collection'}" title="{$item->getTitleFromDisplayPattern()|replace:"\"":""}">
{/if}
    {$item->getTitleFromDisplayPattern()}
{if !$nolink}
    </a>
    <a id="collectionItem{$item.id}Display" href="{modurl modname='MUFiles' type=$lct func='display' id=$item.id ot='collection' theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
{/if}
{/strip}
{if !$nolink}
<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        mufilesInitInlineWindow($('collectionItem{{$item.id}}Display'), '{{$item->getTitleFromDisplayPattern()|replace:"'":""}}');
    });
/* ]]> */
</script>
{/if}
    </li>
    {/if}
{/foreach}
</ul>
{/if}
