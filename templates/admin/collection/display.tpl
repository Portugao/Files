{* purpose of this template: collections display view in admin area *}
{include file='admin/header.tpl'}
<div class="mufiles-collection mufiles-display with-rightbox">
    {gt text='Collection' assign='templateTitle'}
    {assign var='templateTitle' value=$collection->getTitleFromDisplayPattern()|default:$templateTitle}
    {pagesetvar name='title' value=$templateTitle|@html_entity_decode}
    <div class="z-admin-content-pagetitle">
        {icon type='display' size='small' __alt='Details'}
        <h3>{$templateTitle|notifyfilters:'mufiles.filter_hooks.collections.filter'} <small>{$collection.workflowState|mufilesObjectState:false|lower})</small>{icon id='itemActionsTrigger' type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}</h3>
    </div>

    {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
        <div class="mufiles-rightbox">
            <h4>{gt text='Files'}</h4>
            
            {if isset($collection.alilasfile) && $collection.alilasfile ne null}
                {include file='admin/file/include_displayItemListMany.tpl' items=$collection.alilasfile}
            {/if}
            
            {checkpermission component='MUFiles:Collection:' instance="`$collection.id`::" level='ACCESS_ADMIN' assign='authAdmin'}
            {if $authAdmin || (isset($uid) && isset($collection.createdUserId) && $collection.createdUserId eq $uid)}
            <p class="managelink">
                {gt text='Create file' assign='createTitle'}
                <a href="{modurl modname='MUFiles' type='admin' func='edit' ot='file' aliascollection="`$collection.id`" returnTo='adminDisplayCollection'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
            </p>
            {/if}
            <h4>{gt text='Collection'}</h4>
            
            {if isset($collection.parent) && $collection.parent ne null}
                {include file='admin/collection/include_displayItemListOne.tpl' item=$collection.parent}
            {/if}
            
            {if !isset($collection.parent) || $collection.parent eq null}
            {checkpermission component='MUFiles:Collection:' instance="`$collection.id`::" level='ACCESS_ADMIN' assign='authAdmin'}
            {if $authAdmin || (isset($uid) && isset($collection.createdUserId) && $collection.createdUserId eq $uid)}
            <p class="managelink">
                {gt text='Create collection' assign='createTitle'}
                <a href="{modurl modname='MUFiles' type='admin' func='edit' ot='collection' children="`$collection.id`" returnTo='adminDisplayCollection'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
            </p>
            {/if}
            {/if}
        </div>
    {/if}

    <dl>
        <dt>{gt text='State'}</dt>
        <dd>{$collection.workflowState|mufilesGetListEntry:'collection':'workflowState'|safetext}</dd>
        <dt>{gt text='Name'}</dt>
        <dd>{$collection.name}</dd>
        <dt>{gt text='Description'}</dt>
        <dd>{$collection.description}</dd>
        <dt>{gt text='Parentid'}</dt>
        <dd>{$collection.parentid}</dd>
        <dt>{gt text='Parent'}</dt>
        <dd>
        {if isset($collection.Parent) && $collection.Parent ne null}
          {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
          <a href="{modurl modname='MUFiles' type='admin' func='display' ot='collection' id=$collection.Parent.id}">{strip}
            {$collection.Parent->getTitleFromDisplayPattern()|default:""}
          {/strip}</a>
          <a id="collectionItem{$collection.Parent.id}Display" href="{modurl modname='MUFiles' type='admin' func='display' ot='collection' id=$collection.Parent.id theme='Printer'}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
          <script type="text/javascript">
          /* <![CDATA[ */
              document.observe('dom:loaded', function() {
                  mufilesInitInlineWindow($('collectionItem{{$collection.Parent.id}}Display'), '{{$collection.Parent->getTitleFromDisplayPattern()|replace:"'":""}}');
              });
          /* ]]> */
          </script>
          {else}
            {$collection.Parent->getTitleFromDisplayPattern()|default:""}
          {/if}
        {else}
            {gt text='Not set.'}
        {/if}
        </dd>
        
    </dl>
    {include file='admin/include_categories_display.tpl' obj=$collection}
    {include file='admin/include_standardfields_display.tpl' obj=$collection}

    {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
        {* include display hooks *}
        {notifydisplayhooks eventname='mufiles.ui_hooks.collections.display_view' id=$collection.id urlobject=$currentUrlObject assign='hooks'}
        {foreach key='providerArea' item='hook' from=$hooks}
            {$hook}
        {/foreach}
        {if count($collection._actions) gt 0}
            <p id="itemActions">
            {foreach item='option' from=$collection._actions}
                <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}" class="z-icon-es-{$option.icon}">{$option.linkText|safetext}</a>
            {/foreach}
            </p>
            <script type="text/javascript">
            /* <![CDATA[ */
                document.observe('dom:loaded', function() {
                    mufilesInitItemActions('collection', 'display', 'itemActions');
                });
            /* ]]> */
            </script>
        {/if}
        <br style="clear: right" />
    {/if}
</div>
{include file='admin/footer.tpl'}
