{* purpose of this template: collections view view in user area *}
{include file='user/header.tpl'}
<div class="mufiles-collection mufiles-view">
{gt text='Collection list' assign='templateTitle'}
{pagesetvar name='title' value=$templateTitle}
<div class="z-frontendcontainer">
    <h2>{$templateTitle}</h2>

{checkpermissionblock component='MUFiles:Collection:' instance='::' level='ACCESS_EDIT'}
    {gt text='Create collection' assign='createTitle'}
    <a href="{modurl modname='MUFiles' type='user' func='edit' ot='collection'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
{/checkpermissionblock}
{assign var='own' value=0}
{if isset($showOwnEntries) && $showOwnEntries eq 1}
    {assign var='own' value=1}
{/if}
{assign var='all' value=0}
{if isset($showAllEntries) && $showAllEntries eq 1}
    {gt text='Back to paginated view' assign='linkTitle'}
    <a href="{modurl modname='MUFiles' type='user' func='view' ot='collection'}" title="{$linkTitle}" class="z-icon-es-view">
        {$linkTitle}
    </a>
    {assign var='all' value=1}
{else}
    {gt text='Show all entries' assign='linkTitle'}
    <a href="{modurl modname='MUFiles' type='user' func='view' ot='collection' all=1}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
{/if}

{include file='user/collection/view_quickNav.tpl'}{* see template file for available options *}

<table class="z-datatable">
    <colgroup>
        <col id="cworkflowstate" />
        <col id="cname" />
        <col id="cdescription" />
        <col id="cparentid" />
        <col id="cparent" />
        <col id="citemactions" />
    </colgroup>
    <thead>
    <tr>
        {assign var='catIdListMainString' value=','|implode:$catIdList.Main}
        <th id="hworkflowstate" scope="col" class="z-left">
            {sortlink __linktext='State' currentsort=$sort modname='MUFiles' type='user' func='view' ot='collection' sort='workflowState' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
        </th>
        <th id="hname" scope="col" class="z-left">
            {sortlink __linktext='Name' currentsort=$sort modname='MUFiles' type='user' func='view' ot='collection' sort='name' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
        </th>
        <th id="hdescription" scope="col" class="z-left">
            {sortlink __linktext='Description' currentsort=$sort modname='MUFiles' type='user' func='view' ot='collection' sort='description' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
        </th>
        <th id="hparentid" scope="col" class="z-right">
            {sortlink __linktext='Parentid' currentsort=$sort modname='MUFiles' type='user' func='view' ot='collection' sort='parentid' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
        </th>
        <th id="hparent" scope="col" class="z-left">
            {sortlink __linktext='Parent' currentsort=$sort modname='MUFiles' type='user' func='view' ot='collection' sort='parent' sortdir=$sdir all=$all own=$own catidMain=$catIdListMainString parent=$parent workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
        </th>
        <th id="hitemactions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
    </tr>
    </thead>
    <tbody>

{foreach item='collection' from=$items}
    <tr class="{cycle values='z-odd, z-even'}">
        <td headers="hworkflowstate" class="z-left z-nowrap">
            {$collection.workflowState|mufilesObjectState}
        </td>
        <td headers="hname" class="z-left">
            <a href="{modurl modname='MUFiles' type='user' func='display' ot='collection' id=$collection.id}" title="{gt text='View detail page'}">{$collection.name|notifyfilters:'mufiles.filterhook.collections'}</a>
        </td>
        <td headers="hdescription" class="z-left">
            {$collection.description}
        </td>
        <td headers="hparentid" class="z-right">
            {$collection.parentid}
        </td>
        <td headers="hparent" class="z-left">
            {if isset($collection.Parent) && $collection.Parent ne null}
                <a href="{modurl modname='MUFiles' type='user' func='display' ot='collection' id=$collection.Parent.id}">{strip}
                  {$collection.Parent.name|default:""}
                {/strip}</a>
                <a id="collectionItem{$collection.id}_rel_{$collection.Parent.id}Display" href="{modurl modname='MUFiles' type='user' func='display' ot='collection' id=$collection.Parent.id theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
                <script type="text/javascript">
                /* <![CDATA[ */
                    document.observe('dom:loaded', function() {
                        mufilesInitInlineWindow($('collectionItem{{$collection.id}}_rel_{{$collection.Parent.id}}Display'), '{{$collection.Parent.name|replace:"'":""}}');
                    });
                /* ]]> */
                </script>
            {else}
                {gt text='Not set.'}
            {/if}
        </td>
        <td id="itemactions{$collection.id}" headers="hitemactions" class="z-right z-nowrap z-w02">
            {if count($collection._actions) gt 0}
                {foreach item='option' from=$collection._actions}
                    <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}"{if $option.icon eq 'preview'} target="_blank"{/if}>{icon type=$option.icon size='extrasmall' alt=$option.linkText|safetext}</a>
                {/foreach}
                {icon id="itemactions`$collection.id`trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
                <script type="text/javascript">
                /* <![CDATA[ */
                    document.observe('dom:loaded', function() {
                        mufilesInitItemActions('collection', 'view', 'itemactions{{$collection.id}}');
                    });
                /* ]]> */
                </script>
            {/if}
        </td>
    </tr>
{foreachelse}
    <tr class="z-datatableempty">
      <td class="z-left" colspan="6">
    {gt text='No collections found.'}
      </td>
    </tr>
{/foreach}

    </tbody>
</table>

{if !isset($showAllEntries) || $showAllEntries ne 1}
    {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page'}
{/if}


{notifydisplayhooks eventname='mufiles.ui_hooks.collections.display_view' urlobject=$currentUrlObject assign='hooks'}
{foreach key='providerArea' item='hook' from=$hooks}
    {$hook}
{/foreach}
</div>
</div>
{include file='user/footer.tpl'}

