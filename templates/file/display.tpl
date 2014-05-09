{* purpose of this template: files display view *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
<div class="mufiles-file mufiles-display">
    {gt text='File' assign='templateTitle'}
    {assign var='templateTitle' value=$file->getTitleFromDisplayPattern()|default:$templateTitle}
    {pagesetvar name='title' value=$templateTitle|@html_entity_decode}
    {if $lct eq 'admin'}
        <div class="z-admin-content-pagetitle">
            {icon type='display' size='small' __alt='Details'}
            <h3>{$templateTitle|notifyfilters:'mufiles.filter_hooks.files.filter'} <small>({$file.workflowState|mufilesObjectState:false|lower})</small>{icon id='itemActionsTrigger' type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}</h3>
        </div>
    {else}
        <h2>{$templateTitle|notifyfilters:'mufiles.filter_hooks.files.filter'} <small>({$file.workflowState|mufilesObjectState:false|lower})</small>{icon id='itemActionsTrigger' type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}</h2>
    {/if}

    <dl>
        <dt>{gt text='State'}</dt>
        <dd>{$file.workflowState|mufilesGetListEntry:'file':'workflowState'|safetext}</dd>
        <dt>{gt text='Title'}</dt>
        <dd>{$file.title}</dd>
        <dt>{gt text='Description'}</dt>
        <dd>{$file.description}</dd>
        <dt>{gt text='Upload file'}</dt>
        <dd>  <a href="{$file.uploadFileFullPathURL}" title="{$file->getTitleFromDisplayPattern()|replace:"\"":""}"{if $file.uploadFileMeta.isImage} rel="imageviewer[file]"{/if}>
          {if $file.uploadFileMeta.isImage}
              {thumb image=$file.uploadFileFullPath objectid="file-`$file.id`" preset=$fileThumbPresetUploadFile tag=true img_alt=$file->getTitleFromDisplayPattern()}
          {else}
              {gt text='Download'} ({$file.uploadFileMeta.size|mufilesGetFileSize:$file.uploadFileFullPath:false:false})
          {/if}
          </a>
        </dd>
        <dt>{gt text='Aliascollection'}</dt>
        <dd>
        {if isset($file.Aliascollection) && $file.Aliascollection ne null}
          {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
          <a href="{modurl modname='MUFiles' type=$lct func='display' id=$file.Aliascollection.id ot='collection'}">{strip}
            {$file.Aliascollection->getTitleFromDisplayPattern()|default:""}
          {/strip}</a>
          <a id="collectionItem{$file.Aliascollection.id}Display" href="{modurl modname='MUFiles' type=$lct func='display' id=$file.Aliascollection.id ot='collection' theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
          <script type="text/javascript">
          /* <![CDATA[ */
              document.observe('dom:loaded', function() {
                  mufilesInitInlineWindow($('collectionItem{{$file.Aliascollection.id}}Display'), '{{$file.Aliascollection->getTitleFromDisplayPattern()|replace:"'":""}}');
              });
          /* ]]> */
          </script>
          {else}
            {$file.Aliascollection->getTitleFromDisplayPattern()|default:""}
          {/if}
        {else}
            {gt text='Not set.'}
        {/if}
        </dd>
        
    </dl>
    {include file='helper/include_standardfields_display.tpl' obj=$file}

    {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
        {* include display hooks *}
        {notifydisplayhooks eventname='mufiles.ui_hooks.files.display_view' id=$file.id urlobject=$currentUrlObject assign='hooks'}
        {foreach key='providerArea' item='hook' from=$hooks}
            {$hook}
        {/foreach}
        {if count($file._actions) gt 0}
            <p id="itemActions">
            {foreach item='option' from=$file._actions}
                <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}" class="z-icon-es-{$option.icon}">{$option.linkText|safetext}</a>
            {/foreach}
            </p>
            <script type="text/javascript">
            /* <![CDATA[ */
                document.observe('dom:loaded', function() {
                    mufilesInitItemActions('file', 'display', 'itemActions');
                });
            /* ]]> */
            </script>
        {/if}
    {/if}
</div>
{include file="`$lct`/footer.tpl"}