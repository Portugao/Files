{* purpose of this template: inclusion template for display of related hookobjects *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{if $lct ne 'admin'}
    {checkpermission component='MUFiles:Hookobject:' instance='::' level='ACCESS_EDIT' assign='hasAdminPermission'}
    {checkpermission component='MUFiles:Hookobject:' instance='::' level='ACCESS_EDIT' assign='hasEditPermission'}
{/if}
{if !isset($nolink)}
    {assign var='nolink' value=false}
{/if}
<h4>
{strip}
{if !$nolink}
    <a href="{modurl modname='MUFiles' type=$lct func='display' id=$item.id ot='hookobject'}" title="{$item->getTitleFromDisplayPattern()|replace:"\"":""}">
{/if}
    {$item->getTitleFromDisplayPattern()}
{if !$nolink}
    </a>
    <a id="hookobjectItem{$item.id}Display" href="{modurl modname='MUFiles' type=$lct func='display' id=$item.id ot='hookobject' theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
{/if}
{/strip}
</h4>
{if !$nolink}
<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        mufilesInitInlineWindow($('hookobjectItem{{$item.id}}Display'), '{{$item->getTitleFromDisplayPattern()|replace:"'":""}}');
    });
/* ]]> */
</script>
{/if}
