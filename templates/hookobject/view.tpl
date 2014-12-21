{* purpose of this template: hookobjects list view *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
<div class="mufiles-hookobject mufiles-view">
    {gt text='Hookobject list' assign='templateTitle'}
    {pagesetvar name='title' value=$templateTitle}
    {if $lct eq 'admin'}
        <div class="z-admin-content-pagetitle">
            {icon type='view' size='small' alt=$templateTitle}
            <h3>{$templateTitle}</h3>
        </div>
    {else}
        <h2>{$templateTitle}</h2>
    {/if}

    {if $canBeCreated}
        {checkpermissionblock component='MUFiles:Hookobject:' instance='::' level='ACCESS_EDIT'}
            {gt text='Create hookobject' assign='createTitle'}
            <a href="{modurl modname='MUFiles' type=$lct func='edit' ot='hookobject'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
        {/checkpermissionblock}
    {/if}
    {assign var='own' value=0}
    {if isset($showOwnEntries) && $showOwnEntries eq 1}
        {assign var='own' value=1}
    {/if}
    {assign var='all' value=0}
    {if isset($showAllEntries) && $showAllEntries eq 1}
        {gt text='Back to paginated view' assign='linkTitle'}
        <a href="{modurl modname='MUFiles' type=$lct func='view' ot='hookobject'}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
        {assign var='all' value=1}
    {else}
        {gt text='Show all entries' assign='linkTitle'}
        <a href="{modurl modname='MUFiles' type=$lct func='view' ot='hookobject' all=1}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
    {/if}

    {include file='hookobject/view_quickNav.tpl' all=$all own=$own workflowStateFilter=false}{* see template file for available options *}

    {if $lct eq 'admin'}
    <form action="{modurl modname='MUFiles' type='hookobject' func='handleSelectedEntries' lct=$lct}" method="post" id="hookobjectsViewForm" class="z-form">
        <div>
            <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    {/if}
        <table class="z-datatable">
            <colgroup>
                {if $lct eq 'admin'}
                    <col id="cSelect" />
                {/if}
                <col id="cHookedModule" />
                <col id="cHookedObject" />
                <col id="cAreaId" />
                <col id="cUrl" />
                <col id="cObjectId" />
                <col id="cItemActions" />
            </colgroup>
            <thead>
            <tr>
                {if $lct eq 'admin'}
                    <th id="hSelect" scope="col" align="center" valign="middle">
                        <input type="checkbox" id="toggleHookobjects" />
                    </th>
                {/if}
                <th id="hHookedModule" scope="col" class="z-left">
                    {sortlink __linktext='Hooked module' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='hookedModule' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='hookobject'}
                </th>
                <th id="hHookedObject" scope="col" class="z-left">
                    {sortlink __linktext='Hooked object' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='hookedObject' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='hookobject'}
                </th>
                <th id="hAreaId" scope="col" class="z-right">
                    {sortlink __linktext='Area id' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='areaId' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='hookobject'}
                </th>
                <th id="hUrl" scope="col" class="z-left">
                    {sortlink __linktext='Url' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='url' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='hookobject'}
                </th>
                <th id="hObjectId" scope="col" class="z-right">
                    {sortlink __linktext='Object id' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='objectId' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='hookobject'}
                </th>
                <th id="hItemActions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
            </tr>
            </thead>
            <tbody>
        
        {foreach item='hookobject' from=$items}
            <tr class="{cycle values='z-odd, z-even'}">
                {if $lct eq 'admin'}
                    <td headers="hselect" align="center" valign="top">
                        <input type="checkbox" name="items[]" value="{$hookobject.id}" class="hookobjects-checkbox" />
                    </td>
                {/if}
                <td headers="hHookedModule" class="z-left">
                    {$hookobject.hookedModule}
                </td>
                <td headers="hHookedObject" class="z-left">
                    {$hookobject.hookedObject}
                </td>
                <td headers="hAreaId" class="z-right">
                    {$hookobject.areaId}
                </td>
                <td headers="hUrl" class="z-left">
                    {$hookobject.url}
                </td>
                <td headers="hObjectId" class="z-right">
                    {$hookobject.objectId}
                </td>
                <td id="itemActions{$hookobject.id}" headers="hItemActions" class="z-right z-nowrap z-w02">
                    {if count($hookobject._actions) gt 0}
                        {icon id="itemActions`$hookobject.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
                        {foreach item='option' from=$hookobject._actions}
                            <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}"{if $option.icon eq 'preview'} target="_blank"{/if}>{icon type=$option.icon size='extrasmall' alt=$option.linkText|safetext}</a>
                        {/foreach}
                    
                        <script type="text/javascript">
                        /* <![CDATA[ */
                            document.observe('dom:loaded', function() {
                                mufilesInitItemActions('hookobject', 'view', 'itemActions{{$hookobject.id}}');
                            });
                        /* ]]> */
                        </script>
                    {/if}
                </td>
            </tr>
        {foreachelse}
            <tr class="z-{if $lct eq 'admin'}admin{else}data{/if}tableempty">
              <td class="z-left" colspan="{if $lct eq 'admin'}7{else}6{/if}">
            {gt text='No hookobjects found.'}
              </td>
            </tr>
        {/foreach}
        
            </tbody>
        </table>
        
        {if !isset($showAllEntries) || $showAllEntries ne 1}
            {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page' modname='MUFiles' type=$lct func='view' ot='hookobject'}
        {/if}
    {if $lct eq 'admin'}
            <fieldset>
                <label for="mUFilesAction">{gt text='With selected hookobjects'}</label>
                <select id="mUFilesAction" name="action">
                    <option value="">{gt text='Choose action'}</option>
                    <option value="delete" title="{gt text='Delete content permanently.'}">{gt text='Delete'}</option>
                </select>
                <input type="submit" value="{gt text='Submit'}" />
            </fieldset>
        </div>
    </form>
    {/if}

    
    {* here you can activate calling display hooks for the view page if you need it *}
    {*if $lct ne 'admin'}
        {notifydisplayhooks eventname='mufiles.ui_hooks.hookobjects.display_view' urlobject=$currentUrlObject assign='hooks'}
        {foreach key='providerArea' item='hook' from=$hooks}
            {$hook}
        {/foreach}
    {/if*}
</div>
{include file="`$lct`/footer.tpl"}

<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        {{if $lct eq 'admin'}}
            {{* init the "toggle all" functionality *}}
            if ($('toggleHookobjects') != undefined) {
                $('toggleHookobjects').observe('click', function (e) {
                    Zikula.toggleInput('hookobjectsViewForm');
                    e.stop()
                });
            }
        {{/if}}
    });
/* ]]> */
</script>
