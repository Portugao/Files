{* purpose of this template: hookobjects view csv view *}
{mufilesTemplateHeaders contentType='text/comma-separated-values; charset=iso-8859-15' asAttachment=true filename='Hookobjects.csv'}
{strip}"{gt text='Hooked module'}";"{gt text='Area id'}";"{gt text='Url'}";"{gt text='Object id'}";"{gt text='Url object'}";"{gt text='Workflow state'}"
;"{gt text='Collectionhook'}";"{gt text='Filehook'}"{/strip}
{foreach item='hookobject' from=$items}
{strip}
    "{$hookobject.hookedModule}";"{$hookobject.areaId}";"{$hookobject.url}";"{$hookobject.objectId}";"{$hookobject.urlObject}";"{$item.workflowState|mufilesObjectState:false|lower}"
    ;"
        {if isset($hookobject.Collectionhook) && $hookobject.Collectionhook ne null}
            {foreach name='relationLoop' item='relatedItem' from=$hookobject.Collectionhook}
            {$relatedItem->getTitleFromDisplayPattern()|default:''}{if !$smarty.foreach.relationLoop.last}, {/if}
            {/foreach}
        {/if}
    ";"
        {if isset($hookobject.Filehook) && $hookobject.Filehook ne null}
            {foreach name='relationLoop' item='relatedItem' from=$hookobject.Filehook}
            {$relatedItem->getTitleFromDisplayPattern()|default:''}{if !$smarty.foreach.relationLoop.last}, {/if}
            {/foreach}
        {/if}
    "
{/strip}
{/foreach}
