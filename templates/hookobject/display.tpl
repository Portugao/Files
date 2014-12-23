{* purpose of this template: hookobjects display view *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
<div class="mufiles-hookobject mufiles-display with-rightbox">
    {gt text='Hookobject' assign='templateTitle'}
    {assign var='templateTitle' value=$hookobject->getTitleFromDisplayPattern()|default:$templateTitle}
    {pagesetvar name='title' value=$templateTitle|@html_entity_decode}
    {if $lct eq 'admin'}
        <div class="z-admin-content-pagetitle">
            {icon type='display' size='small' __alt='Details'}
            <h3>{$templateTitle|notifyfilters:'mufiles.filter_hooks.hookobjects.filter'}{icon id="itemActions`$hookobject.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
            </h3>
        </div>
    {else}
        <h2>{$templateTitle|notifyfilters:'mufiles.filter_hooks.hookobjects.filter'}{icon id="itemActions`$hookobject.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
        </h2>
    {/if}

    {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
        <div class="mufiles-rightbox">
            {if $lct eq 'admin'}
                <h4>{gt text='Collections'}</h4>
            {else}
                <h3>{gt text='Collections'}</h3>
            {/if}
            
            {if isset($hookobject.collectionhook) && $hookobject.collectionhook ne null}
                {include file='collection/include_displayItemListMany.tpl' items=$hookobject.collectionhook}
            {/if}
            
            {assign var='permLevel' value='ACCESS_EDIT'}
            {if $lct eq 'admin'}
                {assign var='permLevel' value='ACCESS_ADMIN'}
            {/if}
            {checkpermission component='MUFiles:Hookobject:' instance="`$hookobject.id`::" level=$permLevel assign='mayManage'}
            {if $mayManage || (isset($uid) && isset($hookobject.createdUserId) && $hookobject.createdUserId eq $uid)}
            <p class="managelink">
                {gt text='Create collection' assign='createTitle'}
                <a href="{modurl modname='MUFiles' type=$lct func='edit' ot='collection' hookcollection="`$hookobject.id`" returnTo="`$lct`DisplayHookobject"'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
            </p>
            {/if}
            {if $lct eq 'admin'}
                <h4>{gt text='Files'}</h4>
            {else}
                <h3>{gt text='Files'}</h3>
            {/if}
            
            {if isset($hookobject.filehook) && $hookobject.filehook ne null}
                {include file='file/include_displayItemListMany.tpl' items=$hookobject.filehook}
            {/if}
            
            {assign var='permLevel' value='ACCESS_EDIT'}
            {if $lct eq 'admin'}
                {assign var='permLevel' value='ACCESS_ADMIN'}
            {/if}
            {checkpermission component='MUFiles:Hookobject:' instance="`$hookobject.id`::" level=$permLevel assign='mayManage'}
            {if $mayManage || (isset($uid) && isset($hookobject.createdUserId) && $hookobject.createdUserId eq $uid)}
            <p class="managelink">
                {gt text='Create file' assign='createTitle'}
                <a href="{modurl modname='MUFiles' type=$lct func='edit' ot='file' hookfile="`$hookobject.id`" returnTo="`$lct`DisplayHookobject"'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
            </p>
            {/if}
        </div>
    {/if}

    <dl>
        <dt>{gt text='Hooked module'}</dt>
        <dd>{$hookobject.hookedModule}</dd>
        <dt>{gt text='Hooked object'}</dt>
        <dd>{$hookobject.hookedObject}</dd>
        <dt>{gt text='Area id'}</dt>
        <dd>{$hookobject.areaId}</dd>
        <dt>{gt text='Url'}</dt>
        <dd>{$hookobject.url}</dd>
        <dt>{gt text='Object id'}</dt>
        <dd>{$hookobject.objectId}</dd>
        <dt>{gt text='Url object'}</dt>
        <dd>{$hookobject.urlObject}</dd>
        
    </dl>
    {include file='helper/include_standardfields_display.tpl' obj=$hookobject}

    {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
        {* include display hooks *}
        {notifydisplayhooks eventname='mufiles.ui_hooks.hookobjects.display_view' id=$hookobject.id urlobject=$currentUrlObject assign='hooks'}
        {foreach name='hookLoop' key='providerArea' item='hook' from=$hooks}
            {$hook}
        {/foreach}
        {if count($hookobject._actions) gt 0}
            <p id="itemActions{$hookobject.id}">
                {foreach item='option' from=$hookobject._actions}
                    <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}" class="z-icon-es-{$option.icon}">{$option.linkText|safetext}</a>
                {/foreach}
            </p>
        
            <script type="text/javascript">
            /* <![CDATA[ */
                document.observe('dom:loaded', function() {
                    mUMUFilesInitItemActions('hookobject', 'display', 'itemActions{{$hookobject.id}}');
                });
            /* ]]> */
            </script>
        {/if}
        <br style="clear: right" />
    {/if}
</div>
{include file="`$lct`/footer.tpl"}
