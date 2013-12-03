{* purpose of this template: collections view csv view in user area *}
{mufilesTemplateHeaders contentType='text/comma-separated-values; charset=iso-8859-15' asAttachment=true filename='Collections.csv'}
{strip}"{gt text='Name'}";"{gt text='Description'}";"{gt text='Parentid'}";"{gt text='Workflow state'}"
;"{gt text='Parent'}"
;"{gt text='Alilasfile'}";"{gt text='Children'}"
{/strip}
{foreach item='collection' from=$items}
{strip}
    "{$collection.name}";"{$collection.description}";"{$collection.parentid}";"{$item.workflowState|mufilesObjectState:false|lower}"
    ;"{if isset($collection.Parent) && $collection.Parent ne null}{$collection.Parent->getTitleFromDisplayPattern()|default:''}{/if}"
    ;"
        {if isset($collection.Alilasfile) && $collection.Alilasfile ne null}
            {foreach name='relationLoop' item='relatedItem' from=$collection.Alilasfile}
            {$relatedItem->getTitleFromDisplayPattern()|default:''}{if !$smarty.foreach.relationLoop.last}, {/if}
            {/foreach}
        {/if}
    ";"
        {if isset($collection.Children) && $collection.Children ne null}
            {foreach name='relationLoop' item='relatedItem' from=$collection.Children}
            {$relatedItem->getTitleFromDisplayPattern()|default:''}{if !$smarty.foreach.relationLoop.last}, {/if}
            {/foreach}
        {/if}
    "
{/strip}
{/foreach}
