{* purpose of this template: files view view in admin area *}
{include file='admin/header.tpl'}
<div class="mufiles-file mufiles-view">
{gt text='File list' assign='templateTitle'}
{pagesetvar name='title' value=$templateTitle}
<div class="z-admin-content-pagetitle">
    {icon type='view' size='small' alt=$templateTitle}
    <h3>{$templateTitle}</h3>
</div>

{checkpermissionblock component='MUFiles:File:' instance='::' level='ACCESS_EDIT'}
    {gt text='Create file' assign='createTitle'}
    <a href="{modurl modname='MUFiles' type='admin' func='edit' ot='file'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
{/checkpermissionblock}
{assign var='own' value=0}
{if isset($showOwnEntries) && $showOwnEntries eq 1}
    {assign var='own' value=1}
{/if}
{assign var='all' value=0}
{if isset($showAllEntries) && $showAllEntries eq 1}
    {gt text='Back to paginated view' assign='linkTitle'}
    <a href="{modurl modname='MUFiles' type='admin' func='view' ot='file'}" title="{$linkTitle}" class="z-icon-es-view">
        {$linkTitle}
    </a>
    {assign var='all' value=1}
{else}
    {gt text='Show all entries' assign='linkTitle'}
    <a href="{modurl modname='MUFiles' type='admin' func='view' ot='file' all=1}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
{/if}

{include file='admin/file/view_quickNav.tpl'}{* see template file for available options *}

<form class="z-form" id="files_view" action="{modurl modname='MUFiles' type='admin' func='handleselectedentries'}" method="post">
    <div>
        <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
        <input type="hidden" name="ot" value="file" />
        <table class="z-datatable">
            <colgroup>
                <col id="cselect" />
                <col id="cworkflowstate" />
                <col id="ctitle" />
                <col id="cdescription" />
                <col id="cuploadfile" />
                <col id="caliascollection" />
                <col id="citemactions" />
            </colgroup>
            <thead>
            <tr>
                <th id="hselect" scope="col" align="center" valign="middle">
                    <input type="checkbox" id="toggle_files" />
                </th>
                <th id="hworkflowstate" scope="col" class="z-left">
                    {sortlink __linktext='State' currentsort=$sort modname='MUFiles' type='admin' func='view' ot='file' sort='workflowState' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
                </th>
                <th id="htitle" scope="col" class="z-left">
                    {sortlink __linktext='Title' currentsort=$sort modname='MUFiles' type='admin' func='view' ot='file' sort='title' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
                </th>
                <th id="hdescription" scope="col" class="z-left">
                    {sortlink __linktext='Description' currentsort=$sort modname='MUFiles' type='admin' func='view' ot='file' sort='description' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
                </th>
                <th id="huploadfile" scope="col" class="z-left">
                    {sortlink __linktext='Upload file' currentsort=$sort modname='MUFiles' type='admin' func='view' ot='file' sort='uploadFile' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
                </th>
                <th id="haliascollection" scope="col" class="z-left">
                    {sortlink __linktext='Aliascollection' currentsort=$sort modname='MUFiles' type='admin' func='view' ot='file' sort='aliascollection' sortdir=$sdir all=$all own=$own aliascollection=$aliascollection workflowState=$workflowState searchterm=$searchterm pageSize=$pageSize}
                </th>
                <th id="hitemactions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
            </tr>
            </thead>
            <tbody>
        
        {foreach item='file' from=$items}
            <tr class="{cycle values='z-odd, z-even'}">
                <td headers="hselect" align="center" valign="top">
                    <input type="checkbox" name="items[]" value="{$file.id}" class="files_checkbox" />
                </td>
                <td headers="hworkflowstate" class="z-left z-nowrap">
                    {$file.workflowState|mufilesObjectState}
                </td>
                <td headers="htitle" class="z-left">
                    <a href="{modurl modname='MUFiles' type='admin' func='display' ot='file' id=$file.id}" title="{gt text='View detail page'}">{$file.title|notifyfilters:'mufiles.filterhook.files'}</a>
                </td>
                <td headers="hdescription" class="z-left">
                    {$file.description}
                </td>
                <td headers="huploadfile" class="z-left">
                      <a href="{$file.uploadFileFullPathURL}" title="{$file.title|replace:"\"":""}"{if $file.uploadFileMeta.isImage} rel="imageviewer[file]"{/if}>
                      {if $file.uploadFileMeta.isImage}
                          {thumb image=$file.uploadFileFullPath objectid="file-`$file.id`" manager=$fileThumbManagerUploadFile tag=true img_alt=$file.title}
                      {else}
                          {gt text='Download'} ({$file.uploadFileMeta.size|mufilesGetFileSize:$file.uploadFileFullPath:false:false})
                      {/if}
                      </a>
                </td>
                <td headers="haliascollection" class="z-left">
                    {if isset($file.Aliascollection) && $file.Aliascollection ne null}
                        <a href="{modurl modname='MUFiles' type='admin' func='display' ot='collection' id=$file.Aliascollection.id}">{strip}
                          {$file.Aliascollection.name|default:""}
                        {/strip}</a>
                        <a id="collectionItem{$file.id}_rel_{$file.Aliascollection.id}Display" href="{modurl modname='MUFiles' type='admin' func='display' ot='collection' id=$file.Aliascollection.id theme='Printer'}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
                        <script type="text/javascript">
                        /* <![CDATA[ */
                            document.observe('dom:loaded', function() {
                                mufilesInitInlineWindow($('collectionItem{{$file.id}}_rel_{{$file.Aliascollection.id}}Display'), '{{$file.Aliascollection.name|replace:"'":""}}');
                            });
                        /* ]]> */
                        </script>
                    {else}
                        {gt text='Not set.'}
                    {/if}
                </td>
                <td id="itemactions{$file.id}" headers="hitemactions" class="z-right z-nowrap z-w02">
                    {if count($file._actions) gt 0}
                        {foreach item='option' from=$file._actions}
                            <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}"{if $option.icon eq 'preview'} target="_blank"{/if}>{icon type=$option.icon size='extrasmall' alt=$option.linkText|safetext}</a>
                        {/foreach}
                        {icon id="itemactions`$file.id`trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
                        <script type="text/javascript">
                        /* <![CDATA[ */
                            document.observe('dom:loaded', function() {
                                mufilesInitItemActions('file', 'view', 'itemactions{{$file.id}}');
                            });
                        /* ]]> */
                        </script>
                    {/if}
                </td>
            </tr>
        {foreachelse}
            <tr class="z-admintableempty">
              <td class="z-left" colspan="7">
            {gt text='No files found.'}
              </td>
            </tr>
        {/foreach}
        
            </tbody>
        </table>
        
        {if !isset($showAllEntries) || $showAllEntries ne 1}
            {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page'}
        {/if}
        <fieldset>
            <label for="mufiles_action">{gt text='With selected files'}</label>
            <select id="mufiles_action" name="action">
                <option value="">{gt text='Choose action'}</option>
                <option value="delete">{gt text='Delete'}</option>
            </select>
            <input type="submit" value="{gt text='Submit'}" />
        </fieldset>
    </div>
</form>

</div>
{include file='admin/footer.tpl'}

<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
    {{* init the "toggle all" functionality *}}
    if ($('toggle_files') != undefined) {
        $('toggle_files').observe('click', function (e) {
            Zikula.toggleInput('files_view');
            e.stop()
        });
    }
    });
/* ]]> */
</script>
