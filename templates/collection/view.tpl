{* purpose of this template: collections list view *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
<div class="mufiles-collection mufiles-view">
    {gt text='Collection list' assign='templateTitle'}
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
        {checkpermissionblock component='MUFiles:Collection:' instance='::' level='ACCESS_COMMENT'}
            {gt text='Create collection' assign='createTitle'}
            <a href="{modurl modname='MUFiles' type=$lct func='edit' ot='collection'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
        {/checkpermissionblock}
    {/if}
    {assign var='own' value=0}
    {if isset($showOwnEntries) && $showOwnEntries eq 1}
        {assign var='own' value=1}
    {/if}
    {assign var='all' value=0}
    {if isset($showAllEntries) && $showAllEntries eq 1}
        {gt text='Back to paginated view' assign='linkTitle'}
        <a href="{modurl modname='MUFiles' type=$lct func='view' ot='collection'}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
        {assign var='all' value=1}
    {else}
        {gt text='Show all entries' assign='linkTitle'}
        <a href="{modurl modname='MUFiles' type=$lct func='view' ot='collection' all=1}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
    {/if}

    {include file='collection/view_quickNav.tpl' all=$all own=$own}{* see template file for available options *}

    {if $lct eq 'admin'}
    <form action="{modurl modname='MUFiles' type='collection' func='handleSelectedEntries' lct=$lct}" method="post" id="collectionsViewForm" class="z-form">
        <div>
            <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    {/if}
        <table class="z-datatable">
            <colgroup>
                {if $lct eq 'admin'}
                    <col id="cSelect" />              
                    <col id="cWorkflowState" />
                    <col id="cInFrontend" />
                {/if}
                <col id="cName" />
                <col id="cDescription" />
                {*
                <col id="cParentid" />
                <col id="cInFrontend" /> *}
                <col id="cParent" />           
                <col id="cItemActions" />
            </colgroup>
            <thead>
            <tr>
                {assign var='catIdListMainString' value=','|implode:$catIdList.Main}
                {if $lct eq 'admin'}
                    <th id="hSelect" scope="col" align="center" valign="middle">
                        <input type="checkbox" id="toggleCollections" />
                    </th>
                
                <th id="hWorkflowState" scope="col" class="z-left">
                    {sortlink __linktext='State' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='workflowState' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize inFrontend=$inFrontend ot='collection'}
                </th>
                <th id="hInFrontend" scope="col" align="center" valign="middle">
                    {gt text='In frontend?'}
                </th>
                {/if}
                <th id="hName" scope="col" class="z-left">
                    {sortlink __linktext='Name' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='name' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize inFrontend=$inFrontend ot='collection'}
                </th>
                <th id="hDescription" scope="col" class="z-left">
                    {sortlink __linktext='Description' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='description' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize inFrontend=$inFrontend ot='collection'}
                </th>
                {*
                <th id="hParentid" scope="col" class="z-right">
                    {sortlink __linktext='Parentid' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='parentid' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize inFrontend=$inFrontend ot='collection'}
                </th>
                <th id="hInFrontend" scope="col" class="z-center">
                    {sortlink __linktext='In frontend' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='inFrontend' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize inFrontend=$inFrontend ot='collection'}
                </th> *}
                <th id="hParent" scope="col" class="z-left">
                    {sortlink __linktext='Parent' currentsort=$sort modname='MUFiles' type=$lct func='view' sort='parent' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize inFrontend=$inFrontend ot='collection'}
                </th>
                
                <th id="hItemActions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
            </tr>
            </thead>
            <tbody>
        
        {foreach item='collection' from=$items}
            <tr class="{cycle values='z-odd, z-even'}">
                {if $lct eq 'admin'}
                    <td headers="hselect" align="center" valign="top">
                        <input type="checkbox" name="items[]" value="{$collection.id}" class="collections-checkbox" />
                    </td>                
                    <td headers="hWorkflowState" class="z-left z-nowrap">
                        {$collection.workflowState|mufilesObjectState}
                    </td>
                    <td headers="hInFrontend" align="center" valign="top">
                        {$collection.inFrontend|yesno:true}
                    </td>                     
                {/if}
                <td headers="hName" class="z-left">
                    <a href="{modurl modname='MUFiles' type=$lct func='display' ot='collection'  id=$collection.id}" title="{gt text='View detail page'}">{$collection.name|notifyfilters:'mufiles.filterhook.collections'}</a>
                </td>
                <td headers="hDescription" class="z-left">
                    {$collection.description}
                </td>
                {*
                <td headers="hParentid" class="z-right">
                    {$collection.parentid}
                </td>
                <td headers="hInFrontend" class="z-center">
                    {assign var='itemid' value=$collection.id}
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
                </td> *}
                <td headers="hParent" class="z-left">
                    {if isset($collection.Parent) && $collection.Parent ne null}
                        <a href="{modurl modname='MUFiles' type=$lct func='display' ot='collection'  id=$collection.Parent.id}">{strip}
                          {$collection.Parent->getTitleFromDisplayPattern()|default:""}
                        {/strip}</a>
                        <a id="collectionItem{$collection.id}_rel_{$collection.Parent.id}Display" href="{modurl modname='MUFiles' type=$lct func='display' ot='collection'  id=$collection.Parent.id theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
                        <script type="text/javascript">
                        /* <![CDATA[ */
                            document.observe('dom:loaded', function() {
                                mufilesInitInlineWindow($('collectionItem{{$collection.id}}_rel_{{$collection.Parent.id}}Display'), '{{$collection.Parent->getTitleFromDisplayPattern()|replace:"'":""}}');
                            });
                        /* ]]> */
                        </script>
                    {else}
                        {gt text='Not set.'}
                    {/if}
                </td>
                
                <td id="itemActions{$collection.id}" headers="hItemActions" class="z-right z-nowrap z-w02">
                    {if count($collection._actions) gt 0}
                        {icon id="itemActions`$collection.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
                        {foreach item='option' from=$collection._actions}
                            <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}"{if $option.icon eq 'preview'} target="_blank"{/if}>{icon type=$option.icon size='extrasmall' alt=$option.linkText|safetext}</a>
                        {/foreach}
                    
                        <script type="text/javascript">
                        /* <![CDATA[ */
                            document.observe('dom:loaded', function() {
                                mufilesInitItemActions('collection', 'view', 'itemActions{{$collection.id}}');
                            });
                        /* ]]> */
                        </script>
                    {/if}
                </td>
            </tr>
        {foreachelse}
            <tr class="z-{if $lct eq 'admin'}admin{else}data{/if}tableempty">
              <td class="z-left" colspan="{if $lct eq 'admin'}7{else}4{/if}">
            {gt text='No collections found.'}
              </td>
            </tr>
        {/foreach}
        
            </tbody>
        </table>
        
        {if !isset($showAllEntries) || $showAllEntries ne 1}
            {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page' modname='MUFiles' type='collection' func='view' lct=$lct}
        {/if}
    {if $lct eq 'admin'}
            <fieldset>
                <label for="mUFilesAction">{gt text='With selected collections'}</label>
                <select id="mUFilesAction" name="action">
                    <option value="">{gt text='Choose action'}</option>
                <option value="approve" title="{gt text='Update content and approve for immediate publishing.'}">{gt text='Approve'}</option>
                    <option value="delete" title="{gt text='Delete content permanently.'}">{gt text='Delete'}</option>
                </select>
                <input type="submit" value="{gt text='Submit'}" />
            </fieldset>
        </div>
    </form>
    {/if}

    
    {if $lct ne 'admin'}
        {notifydisplayhooks eventname='mufiles.ui_hooks.collections.display_view' urlobject=$currentUrlObject assign='hooks'}
        {foreach key='providerArea' item='hook' from=$hooks}
            {$hook}
        {/foreach}
    {/if}
</div>
{include file="`$lct`/footer.tpl"}

<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        {{foreach item='collection' from=$items}}
            {{assign var='itemid' value=$collection.id}}
            mufilesInitToggle('collection', 'inFrontend', '{{$itemid}}');
        {{/foreach}}
        {{if $lct eq 'admin'}}
            {{* init the "toggle all" functionality *}}
            if ($('toggleCollections') != undefined) {
                $('toggleCollections').observe('click', function (e) {
                    Zikula.toggleInput('collectionsViewForm');
                    e.stop()
                });
            }
        {{/if}}
    });
/* ]]> */
</script>
