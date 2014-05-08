{* purpose of this template: files view csv view *}
{mufilesTemplateHeaders contentType='text/comma-separated-values; charset=iso-8859-15' asAttachment=true filename='Files.csv'}
{strip}"{gt text='Title'}";"{gt text='Description'}";"{gt text='Upload file'}";"{gt text='Workflow state'}"
;"{gt text='Aliascollection'}"
{/strip}
{foreach item='file' from=$items}
{strip}
    "{$file.title}";"{$file.description}";"{$file.uploadFile}";"{$item.workflowState|mufilesObjectState:false|lower}"
    ;"{if isset($file.Aliascollection) && $file.Aliascollection ne null}{$file.Aliascollection->getTitleFromDisplayPattern()|default:''}{/if}"
{/strip}
{/foreach}
