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
            <h3>{$templateTitle|notifyfilters:'mufiles.filter_hooks.collections.filter'} <small>({$collection.workflowState|mufilesObjectState:false|lower})</small>{icon id="itemActions`$collection.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
            </h3>
        </div>
    {else}
        <h2>{$templateTitle|notifyfilters:'mufiles.filter_hooks.collections.filter'} <small>({$collection.workflowState|mufilesObjectState:false|lower})</small>{icon id="itemActions`$collection.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
        </h2>
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
                <h4>{gt text='Collections'}</h4>
            {else}
                <h3>{gt text='Collections'}</h3>
            {/if}
            
            {if isset($collection.children) && $collection.children ne null}
                {include file='collection/include_displayItemListMany.tpl' items=$collection.children}
            {/if}
            
            {assign var='permLevel' value='ACCESS_COMMENT'}
            {if $lct eq 'admin'}
                {assign var='permLevel' value='ACCESS_ADMIN'}
            {/if}
            {checkpermission component='MUFiles:Collection:' instance="`$collection.id`::" level=$permLevel assign='mayManage'}
            {if $mayManage || (isset($uid) && isset($collection.createdUserId) && $collection.createdUserId eq $uid)}
            <p class="managelink">
                {gt text='Create collection' assign='createTitle'}
                <a href="{modurl modname='MUFiles' type=$lct func='edit' ot='collection' parent="`$collection.id`" returnTo="`$lct`DisplayCollection"'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
            </p>
            {/if}
            {* {if $lct eq 'admin'}
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
            {/if} *}
        </div>
    {/if}

    <dl>
       {* <dt>{gt text='State'}</dt>
        <dd>{$collection.workflowState|mufilesGetListEntry:'collection':'workflowState'|safetext}</dd>
        <dt>{gt text='Name'}</dt>
        <dd>{$collection.name}</dd> *}
        <dt>{gt text='Description'}</dt>
        <dd>{$collection.description}</dd>
       {* <dt>{gt text='Parentid'}</dt>
        <dd>{$collection.parentid}</dd>
        <dt>{gt text='In frontend'}</dt>
        <dd>{assign var='itemid' value=$collection.id}
        <a id="toggleInFrontend{$itemid}" href="javascript:void(0);" class="z-hide">
        {if $collection.inFrontend}
            {icon type='ok' size='extrasmall' __alt='Yes' id="yesinfrontend_`$itemid`" __title='This setting is enabled. Click here to disable it.'}
            {icon type='cancel' size='extrasmall' __alt='No' id="noinfrontend_`$itemid`" __title='This setting is disabled. Click here to enable it.' class='z-hide'}
        {else}
            {icon type='ok' size='extrasmall' __alt='Yes' id="yesinfrontend_`$itemid`" __title='This setting is enabled. Click here to disable it.' class='z-hide'}
            {icon type='cancel' size='extrasmall' __alt='No' id="noinfrontend_`$itemid`" __title='This setting is disabled. Click here to enable it.'}
        {/if}
        </a>
        <noscript><div id="noscriptInFrontend{$itemid}">
            {$collection.inFrontend|yesno:true}
        </div></noscript>
        </dd> *}
        <dt>{gt text='Parent'}</dt>
        <dd>
        {if isset($collection.Parent) && $collection.Parent ne null}
          {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
          <a href="{modurl modname='MUFiles' type=$lct func='display' ot='collection'  id=$collection.Parent.id}">{strip}
            {$collection.Parent->getTitleFromDisplayPattern()|default:""}
          {/strip}</a>
          <a id="collectionItem{$collection.Parent.id}Display" href="{modurl modname='MUFiles' type=$lct func='display' ot='collection'  id=$collection.Parent.id' theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
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
        {foreach name='hookLoop' key='providerArea' item='hook' from=$hooks}
            {$hook}
        {/foreach}
        {if count($collection._actions) gt 0}
            <p id="itemActions{$collection.id}">
                {foreach item='option' from=$collection._actions}
                    <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}" class="z-icon-es-{$option.icon}">{$option.linkText|safetext}</a>
                {/foreach}
            </p>
        
            <script type="text/javascript">
            /* <![CDATA[ */
                document.observe('dom:loaded', function() {
                    mUMUFilesInitItemActions('collection', 'display', 'itemActions{{$collection.id}}');
                });
            /* ]]> */
            </script>
        {/if}
        <br style="clear: right" />
    {/if}
</div>
{include file="`$lct`/footer.tpl"}

{if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
    <script type="text/javascript">
    /* <![CDATA[ */
        document.observe('dom:loaded', function() {
            {{assign var='itemid' value=$collection.id}}
            mUMUFilesInitToggle('collection', 'inFrontend', '{{$itemid}}');
        });
    /* ]]> */
    </script>
{/if}
