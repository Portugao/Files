{* purpose of this template: files list view *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
<div class="mufiles-file mufiles-view">
    {gt text='File list' assign='templateTitle'}
    {pagesetvar name='title' value=$templateTitle}
    <h2>{$templateTitle}</h2>

    {if $canBeCreated}
        {checkpermissionblock component='MUFiles:File:' instance='::' level='ACCESS_EDIT'}
            {gt text='Create file' assign='createTitle'}
            <a href="{modurl modname='MUFiles' type='user' func='edit' ot='file'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
        {/checkpermissionblock}
    {/if}
    {assign var='own' value=0}
    {if isset($showOwnEntries) && $showOwnEntries eq 1}
        {assign var='own' value=1}
    {/if}
    {assign var='all' value=0}
    {if isset($showAllEntries) && $showAllEntries eq 1}
        {gt text='Back to paginated view' assign='linkTitle'}
        <a href="{modurl modname='MUFiles' type='user' func='view' ot='file'}" title="{$linkTitle}" class="z-icon-es-view">
            {$linkTitle}
        </a>
        {assign var='all' value=1}
    {else}
        {gt text='Show all entries' assign='linkTitle'}
        <a href="{modurl modname='MUFiles' type='user' func='view' ot='file' all=1}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
    {/if}

    {include file='file/view_quickNav.tpl' all=$all own=$own}{* see template file for available options *}

    <table class="z-datatable">
        <colgroup>
           {* <col id="cWorkflowState" /> *}
            <col id="cTitle" />
           {* <col id="cDescription" />
            <col id="cUploadFile" /> *}
            <col id="cAliascollection" />
            <col id="cItemActions" />
        </colgroup>
        <thead>
        <tr>
           {* <th id="hWorkflowState" scope="col" class="z-left">
                {sortlink __linktext='State' currentsort=$sort modname='MUFiles' type='user' func='view' ot='file' sort='workflowState' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
            </th> *}
            <th id="hTitle" scope="col" class="z-left">
                {sortlink __linktext='Title' currentsort=$sort modname='MUFiles' type='user' func='view' ot='file' sort='title' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
            </th>
           {* <th id="hDescription" scope="col" class="z-left">
                {sortlink __linktext='Description' currentsort=$sort modname='MUFiles' type='user' func='view' ot='file' sort='description' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
            </th>
            <th id="hUploadFile" scope="col" class="z-left">
                {sortlink __linktext='Upload file' currentsort=$sort modname='MUFiles' type='user' func='view' ot='file' sort='uploadFile' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
            </th> *}
            <th id="hAliascollection" scope="col" class="z-left">
                {sortlink __linktext='Aliascollection' currentsort=$sort modname='MUFiles' type='user' func='view' ot='file' sort='aliascollection' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
            </th>
            <th id="hItemActions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
        </tr>
        </thead>
        <tbody>
    
    {foreach item='file' from=$items}
        <tr class="{cycle values='z-odd, z-even'}">
          {*  <td headers="hWorkflowState" class="z-left z-nowrap">
                {$file.workflowState|mufilesObjectState}
            </td> *}
            <td headers="hTitle" class="z-left">
                <a href="{modurl modname='MUFiles' type='user' func='display' ot='file' id=$file.id}" title="{gt text='View detail page'}">{$file.title|notifyfilters:'mufiles.filterhook.files'}</a>
            </td>
          {*  <td headers="hDescription" class="z-left">
                {$file.description}
            </td>
            <td headers="hUploadFile" class="z-left">
                  <a href="{$file.uploadFileFullPathURL}" title="{$file->getTitleFromDisplayPattern()|replace:"\"":""}"{if $file.uploadFileMeta.isImage} rel="imageviewer[file]"{/if}>
                  {if $file.uploadFileMeta.isImage}
                      {thumb image=$file.uploadFileFullPath objectid="file-`$file.id`" preset=$fileThumbPresetUploadFile tag=true img_alt=$file->getTitleFromDisplayPattern()}
                  {else}
                      {gt text='Download'} ({$file.uploadFileMeta.size|mufilesGetFileSize:$file.uploadFileFullPath:false:false})
                  {/if}
                  </a>
            </td> *}
            <td headers="hAliascollection" class="z-left">
                {if isset($file.Aliascollection) && $file.Aliascollection ne null}
                    <a href="{modurl modname='MUFiles' type='user' func='display' ot='collection' id=$file.Aliascollection.id}">{strip}
                      {$file.Aliascollection->getTitleFromDisplayPattern()|default:""}
                    {/strip}</a>
                    <a id="collectionItem{$file.id}_rel_{$file.Aliascollection.id}Display" href="{modurl modname='MUFiles' type='user' func='display' ot='collection' id=$file.Aliascollection.id theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
                    <script type="text/javascript">
                    /* <![CDATA[ */
                        document.observe('dom:loaded', function() {
                            mufilesInitInlineWindow($('collectionItem{{$file.id}}_rel_{{$file.Aliascollection.id}}Display'), '{{$file.Aliascollection->getTitleFromDisplayPattern()|replace:"'":""}}');
                        });
                    /* ]]> */
                    </script>
                {else}
                    {gt text='Not set.'}
                {/if}
            </td>
            <td id="itemActions{$file.id}" headers="hItemActions" class="z-right z-nowrap z-w02">
                {if count($file._actions) gt 0}
                    {foreach item='option' from=$file._actions}
                        <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}"{if $option.icon eq 'preview'} target="_blank"{/if}>{icon type=$option.icon size='extrasmall' alt=$option.linkText|safetext}</a>
                    {/foreach}
                    {icon id="itemActions`$file.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
                    <script type="text/javascript">
                    /* <![CDATA[ */
                        document.observe('dom:loaded', function() {
                            mufilesInitItemActions('file', 'view', 'itemActions{{$file.id}}');
                        });
                    /* ]]> */
                    </script>
                {/if}
            </td>
        </tr>
    {foreachelse}
        <tr class="z-datatableempty">
          <td class="z-left" colspan="6">
        {gt text='No files found.'}
          </td>
        </tr>
    {/foreach}
    
        </tbody>
    </table>
    
    {if !isset($showAllEntries) || $showAllEntries ne 1}
        {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page' modname='MUFiles' type='user' func='view' ot='file'}
    {/if}

    
    {notifydisplayhooks eventname='mufiles.ui_hooks.files.display_view' urlobject=$currentUrlObject assign='hooks'}
    {foreach key='providerArea' item='hook' from=$hooks}
        {$hook}
    {/foreach}
</div>
{include file='user/footer.tpl'}
