{* purpose of this template: files display view in user area *}
{include file='user/header.tpl'}
<div class="mufiles-file mufiles-display">
{gt text='File' assign='templateTitle'}
{assign var='templateTitle' value=$file.title|default:$templateTitle}
{pagesetvar name='title' value=$templateTitle|@html_entity_decode}
<div class="z-frontendcontainer">
    <h2>{$templateTitle|notifyfilters:'mufiles.filter_hooks.files.filter'} ({$file.workflowState|mufilesObjectState:false|lower}){icon id='itemactionstrigger' type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}</h2>


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
   <dd>
         <a href="{modurl modname='MUFiles' type='user' func='giveFile' id=$file.id}">{gt text='Download'} ({$file.uploadFileMeta.size|mufilesGetFileSize:$file.uploadFileFullPath:false:false})</a>
   </dd>
    <dt>{gt text='Collection'}</dt>
    <dd>
    {if isset($file.Aliascolletion) && $file.Aliascolletion ne null}
      {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
      <a href="{modurl modname='MUFiles' type='user' func='display' ot='collection' id=$file.Aliascolletion.id}">{strip}
        {$file.Aliascolletion.name|default:""}
      {/strip}</a>
      <a id="collectionItem{$file.Aliascolletion.id}Display" href="{modurl modname='MUFiles' type='user' func='display' ot='collection' id=$file.Aliascolletion.id theme='Printer' forcelongurl=true}" title="{gt text='Open quick view window'}" class="z-hide">{icon type='view' size='extrasmall' __alt='Quick view'}</a>
      <script type="text/javascript">
      /* <![CDATA[ */
          document.observe('dom:loaded', function() {
              mufilesInitInlineWindow($('collectionItem{{$file.Aliascolletion.id}}Display'), '{{$file.Aliascolletion.name|replace:"'":""}}');
          });
      /* ]]> */
      </script>
      {else}
    {$file.Aliascolletion.name|default:""}
      {/if}
    {else}
        {gt text='Not set.'}
    {/if}
    </dd>
    
</dl>
{include file='user/include_standardfields_display.tpl' obj=$file}

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
</div>
{include file='user/footer.tpl'}

