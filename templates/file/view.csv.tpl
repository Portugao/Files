{* purpose of this template: files view csv view *}
{mufilesTemplateHeaders contentType='text/comma-separated-values; charset=iso-8859-15' asAttachment=true filename='Files.csv'}
{strip}"{gt text='Title'}";"{gt text='Description'}";"{gt text='Upload file'}";"{gt text='Workflow state'}"
;"{gt text='Aliascollection'}"
;"{gt text='Hookfile'}"
{/strip}
{foreach item='file' from=$items}
{strip}
    "{$file.title}";"{$file.description}";"{$file.uploadFile}";"{$item.workflowState|mufilesObjectState:false|lower}"
    ;"{if isset($file.Aliascollection) && $file.Aliascollection ne null}{$file.Aliascollection->getTitleFromDisplayPattern()|default:''}{/if}"
    ;"
        {if isset($file.Hookfile) && $file.Hookfile ne null}
            {foreach name='relationLoop' item='relatedItem' from=$file.Hookfile}
            {$relatedItem->getTitleFromDisplayPattern()|default:''}{if !$smarty.foreach.relationLoop.last}, {/if}
            {/foreach}
        {/if}
    "
{/strip}
{/foreach}
