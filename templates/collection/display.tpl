{* purpose of this template: collections display view *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
<div class="mufiles-collection mufiles-display with-rightbox">
    {gt text='Collection' assign='templateTitle'}
    {assign var='templateTitle' value=$collection->getTitleFromDisplayPattern()|default:$templateTitle}
    {pagesetvar name='title' value=$templateTitle|@html_entity_decode}
    {if $lct eq 'admin'}
        <div class="z-admin-content-pagetitle">
            {icon type='display' size='small' __alt='Details'}
            <h3>{$templateTitle|notifyfilters:'mufiles.filter_hooks.collections.filter'} <small>({$collection.workflowState|mufilesObjectState:false|lower})</small>{icon id='itemActionsTrigger' type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}</h3>
        </div>
    {else}
        <h2>{$templateTitle|notifyfilters:'mufiles.filter_hooks.collections.filter'} <small>({$collection.workflowState|mufilesObjectState:false|lower})</small>{icon id='itemActionsTrigger' type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}</h2>
    {/if}

    {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
        <div class="mufiles-rightbox">
            {if $lct eq 'admin'}
                <h4>{gt text='Files'}</h4>
            {else}
                <h3>{gt text='Files'}</h3>
            {/if}
            
            {if isset($collection.alilasfile) && $collection.alilasfile ne null}
                {include file='file/include_displayItemListMany.tpl' items=$collection.alilasfile}
            {/if}
            
            {assign var='permLevel' value='ACCESS_COMMENT'}
            {if $lct eq 'admin'}
                {assign var='permLevel' value='ACCESS_ADMIN'}
            {/if}
            {checkpermission component='MUFiles:Collection:' instance="`$collection.id`::" level=$permLevel assign='mayManage'}
            {if $mayManage || (isset($uid) && isset($collection.createdUserId) && $collection.createdUserId eq $uid)}
            <p class="managelink">
                {gt text='Create file' assign='createTitle'}
                <a href="{modurl modname='MUFiles' type=$lct func='edit' ot='file' aliascollection="`$collection.id`" returnTo="`$lct`DisplayCollection"'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
            </p>
            {/if}
            {if $lct eq 'admin'}
                <h4>{gt text='Collection'}</h4>
            {else}
                <h3>{gt text='Collection'}</h3>
            {/if}
            
            {if isset($collection.parent) && $collection.parent ne null}
                {include file='collection/include_displayItemListOne.tpl' item=$collection.parent}
            {/if}
            
            {if !isset($collection.parent) || $collection.parent eq null}
            {assign var='permLevel' value='ACCESS_COMMENT'}
            {if $lct eq 'admin'}
                {assign var='permLevel' value='ACCESS_ADMIN'}
            {/if}
            {checkpermission component='MUFiles:Collection:' instance="`$collection.id`::" level=$permLevel assign='mayManage'}
            {if $mayManage || (isset($uid) && isset($collection.createdUserId) && $collection.createdUserId eq $uid)}
            <p class="managelink">
                {gt text='Create collection' assign='createTitle'}
                <a href="{modurl modname='MUFiles' type=$lct func='edit' ot='collection' children="`$collection.id`" returnTo="`$lct`DisplayCollection"'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
            </p>
            {/if}
            {/if}
            {if $lct eq 'admin'}
                <h4>{gt text='Hookobjects'}</h4>
            {else}
                <h3>{gt text='Hookobjects'}</h3>
            {/if}
            
            {if isset($collection.hookcollection) && $collection.hookcollection ne null}
                {include file='hookobject/include_displayItemListMany.tpl' items=$collection.hookcollection}
            {/if}
            
            {assign var='permLevel' value='ACCESS_COMMENT'}
            {if $lct eq 'admin'}
                {assign var='permLevel' value='ACCESS_ADMIN'}
            {/if}
            {checkpermission component='MUFiles:Collection:' instance="`$collection.id`::" level=$permLevel assign='mayManage'}
            {if $mayManage || (isset($uid) && isset($collection.createdUserId) && $collection.createdUserId eq $uid)}
            <p class="managelink">
                {gt text='Create hookobject' assign='createTitle'}
                <a href="{modurl modname='MUFiles' type=$lct func='edit' ot='hookobject' collectionhook="`$collection.id`" returnTo="`$lct`DisplayCollection"'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
            </p>
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
        <dt>{gt text='In frontend'}</dt>
        <dd>{$collection.inFrontend|yesno:true}</dd>
        <dt>{gt text='Parent'}</dt>
        <dd>
        {if isset($collection.Parent) && $collection.Parent ne null}
          {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
          <a href="{modurl modname='MUFiles' type=$lct func='display' id=$collection.Parent.id ot='collection'}">{strip}
            {$collection.Parent->getTitleFromDisplayPattern()|default:""}
          {/strip}</a>
          <a id="collectionItem{$collection.Parent.id}Display" href="{modurl modname='MUFiles' type=$lct func='display' id=$collection.Parent.id ot='collection' theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
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
    {include file='helper/include_categories_display.tpl' obj=$collection}
    {include file='helper/include_standardfields_display.tpl' obj=$collection}

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
{include file="`$lct`/footer.tpl"}
