{* purpose of this template: files xml inclusion template in admin area *}
<file id="{$item.id}" createdon="{$item.createdDate|dateformat}" updatedon="{$item.updatedDate|dateformat}">
    <id>{$item.id}</id>
    <title><![CDATA[{$item.title}]]></title>
    <description><![CDATA[{$item.description}]]></description>
    <uploadFile{if $item.uploadFile ne ''} extension="{$item.uploadFileMeta.extension}" size="{$item.uploadFileMeta.size}" isImage="{if $item.uploadFileMeta.isImage}true{else}false{/if}"{if $item.uploadFileMeta.isImage} width="{$item.uploadFileMeta.width}" height="{$item.uploadFileMeta.height}" format="{$item.uploadFileMeta.format}"{/if}{/if}>{$item.uploadFile}</uploadFile>
    <workflowState>{$item.workflowState|mufilesObjectState:false|lower}</workflowState>
    <aliascollection>{if isset($item.Aliascollection) && $item.Aliascollection ne null}{$item.Aliascollection->getTitleFromDisplayPattern()|default:''}{/if}</aliascollection>
</file>
