{* purpose of this template: files display view in admin area *}
{include file='admin/header.tpl'}
<div class="mufiles-file mufiles-display">
{gt text='File' assign='templateTitle'}
{assign var='templateTitle' value=$file.title|default:$templateTitle}
{pagesetvar name='title' value=$templateTitle|@html_entity_decode}
<div class="z-admin-content-pagetitle">
    {icon type='display' size='small' __alt='Details'}
    <h3>{$templateTitle|notifyfilters:'mufiles.filter_hooks.files.filter'} ({$file.workflowState|mufilesObjectState:false|lower}){icon id='itemactionstrigger' type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}</h3>
</div>


<dl>
    <dt>{gt text='Description'}</dt>
    <dd>{$file.description}</dd>
    <dt>{gt text='Upload file'}</dt>
    <dd>  <a href="{$file.uploadFileFullPathURL}" title="{$file.title|replace:"\"":""}"{if $file.uploadFileMeta.isImage} rel="imageviewer[file]"{/if}>
      {if $file.uploadFileMeta.isImage}
          {thumb image=$file.uploadFileFullPath objectid="file-`$file.id`" manager=$fileThumbManagerUploadFile tag=true img_alt=$file.title}
      {else}
          {gt text='Download'} ({$file.uploadFileMeta.size|mufilesGetFileSize:$file.uploadFileFullPath:false:false})
      {/if}
      </a>
    </dd>
    <dt>{gt text='Collection'}</dt>
    <dd>
    {if isset($file.Aliascollection) && $file.Aliascollection ne null}
      {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
      <a href="{modurl modname='MUFiles' type='admin' func='display' ot='collection' id=$file.Aliascollection.id}">{strip}
        {$file.Aliascollection.name|default:""}
      {/strip}</a>
      <a id="collectionItem{$file.Aliascollection.id}Display" href="{modurl modname='MUFiles' type='admin' func='display' ot='collection' id=$file.Aliascollection.id theme='Printer'}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
      <script type="text/javascript">
      /* <![CDATA[ */
          document.observe('dom:loaded', function() {
              mufilesInitInlineWindow($('collectionItem{{$file.Aliascollection.id}}Display'), '{{$file.Aliascollection.name|replace:"'":""}}');
          });
      /* ]]> */
      </script>
      {else}
    {$file.Aliascollection.name|default:""}
      {/if}
    {else}
        {gt text='Not set.'}
    {/if}
    </dd>
    
</dl>
{include file='admin/include_standardfields_display.tpl' obj=$file}

{if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
    {* include display hooks *}
    {notifydisplayhooks eventname='mufiles.ui_hooks.files.display_view' id=$file.id urlobject=$currentUrlObject assign='hooks'}
    {foreach key='providerArea' item='hook' from=$hooks}
        {$hook}
    {/foreach}
    {if count($file._actions) gt 0}
        <p id="itemactions">
        {foreach item='option' from=$file._actions}
            <a href="{$option.url.type|mufilesActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}" class="z-icon-es-{$option.icon}">{$option.linkText|safetext}</a>
        {/foreach}
        </p>
        <script type="text/javascript">
        /* <![CDATA[ */
            document.observe('dom:loaded', function() {
                mufilesInitItemActions('file', 'display', 'itemactions');
            });
        /* ]]> */
        </script>
    {/if}
{/if}

</div>
{include file='admin/footer.tpl'}

